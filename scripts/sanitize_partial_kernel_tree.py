#!/usr/bin/env python3
"""
Sanitize partially open-sourced kernel trees for analysis builds.

Vendor trees often keep `source "path/Kconfig"` while the private directory
is gitignored / not shipped. This script stubs missing Kconfig (and empty
Makefile when helpful) so allnoconfig/olddefconfig can proceed.

Does NOT restore proprietary source — stubs are analysis-only placeholders.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
from datetime import datetime, timezone

SOURCE_RE = re.compile(
    r'^\s*source\s+(?P<q>["\'])(?P<path>[^"\']+)(?P=q)',
)
STUB_MARKER = "AUTO-STUB: missing from partial OSS tree"
MAX_ROUNDS = 8
SKIP_DIR_NAMES = {
    ".git",
    "Documentation",
    "tools",
    "samples",
    "usr",
    "debian",
}


def is_under_skip(rel_path: str) -> bool:
    parts = rel_path.replace("\\", "/").split("/")
    return any(p in SKIP_DIR_NAMES for p in parts)


def collect_kconfig_files(kernel_root: str) -> list[str]:
    found: list[str] = []
    for dirpath, dirnames, filenames in os.walk(kernel_root):
        # prune heavy / irrelevant trees
        dirnames[:] = [
            d
            for d in dirnames
            if d not in SKIP_DIR_NAMES and not d.startswith(".")
        ]
        for name in filenames:
            if name == "Kconfig" or name.startswith("Kconfig."):
                found.append(os.path.join(dirpath, name))
    return found


def parse_gitignore_vendor_dirs(kernel_root: str) -> list[str]:
    """Paths like drivers/misc/hwid/ from root .gitignore (hint only)."""
    gi = os.path.join(kernel_root, ".gitignore")
    if not os.path.isfile(gi):
        return []
    out: list[str] = []
    with open(gi, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            s = line.strip()
            if not s or s.startswith("#") or s.startswith("!"):
                continue
            # drop leading slash
            if s.startswith("/"):
                s = s[1:]
            if s.endswith("/"):
                s = s[:-1]
            # likely source path fragment under drivers/arch/...
            if "/" in s and not any(ch in s for ch in "*?["):
                out.append(s)
    return out


def resolve_source_path(kernel_root: str, kconfig_file: str, ref: str) -> str | None:
    """
    Kernel kconfig resolves source paths relative to $(srctree) (kernel root).
    Also try relative to the including Kconfig's directory as a fallback.
    """
    ref = ref.strip()
    if not ref:
        return None
    candidates = [
        os.path.normpath(os.path.join(kernel_root, ref)),
        os.path.normpath(os.path.join(os.path.dirname(kconfig_file), ref)),
    ]
    # Prefer existing; else prefer root-relative (kernel convention)
    for c in candidates:
        if os.path.isfile(c):
            return c
    return candidates[0]


def extract_sources(kconfig_file: str) -> list[tuple[int, str]]:
    refs: list[tuple[int, str]] = []
    try:
        with open(kconfig_file, "r", encoding="utf-8", errors="replace") as f:
            for lineno, line in enumerate(f, 1):
                stripped = line.lstrip()
                if stripped.startswith("#"):
                    continue
                m = SOURCE_RE.match(line)
                if m:
                    refs.append((lineno, m.group("path")))
    except OSError:
        return []
    return refs


def ensure_stub_kconfig(path: str, referenced_by: str) -> bool:
    """
    Create stub Kconfig if missing. Return True if a new stub was written.
    Idempotent: existing AUTO-STUB file is left as-is (counts as already stubbed,
    not a new write).
    """
    parent = os.path.dirname(path)
    os.makedirs(parent, exist_ok=True)

    if os.path.isfile(path):
        try:
            with open(path, "r", encoding="utf-8", errors="replace") as f:
                head = f.read(200)
            if STUB_MARKER in head:
                return False
        except OSError:
            pass
        # Real file exists — do not overwrite
        return False

    content = (
        f"# {STUB_MARKER}; not vendor source\n"
        f"# Referenced by: {referenced_by}\n"
        f"# Generated for analysis-only builds of partial OSS trees.\n"
    )
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

    makefile = os.path.join(parent, "Makefile")
    if not os.path.exists(makefile):
        with open(makefile, "w", encoding="utf-8") as f:
            f.write(
                f"# {STUB_MARKER}\n"
                f"# Empty Makefile so unconditional obj-y += this dir is harmless.\n"
            )
    return True


def sanitize(kernel_root: str, manifest_path: str | None = None) -> dict:
    kernel_root = os.path.abspath(kernel_root)
    if not os.path.isdir(kernel_root):
        raise FileNotFoundError(f"kernel root not found: {kernel_root}")
    if not os.path.isfile(os.path.join(kernel_root, "Makefile")):
        raise FileNotFoundError(f"not a kernel tree (no Makefile): {kernel_root}")

    stubs: list[dict] = []
    already: list[dict] = []
    gitignore_hints = parse_gitignore_vendor_dirs(kernel_root)

    for round_idx in range(1, MAX_ROUNDS + 1):
        new_this_round = 0
        kconfigs = collect_kconfig_files(kernel_root)
        for kc in kconfigs:
            rel_kc = os.path.relpath(kc, kernel_root)
            if is_under_skip(rel_kc):
                continue
            for lineno, ref in extract_sources(kc):
                # kconfig make-vars like arch/$(SRCARCH)/Kconfig are expanded
                # at parse time — never stub the literal path.
                if "$(" in ref or "${" in ref or "$" in ref:
                    continue
                target = resolve_source_path(kernel_root, kc, ref)
                if not target:
                    continue
                rel_target = os.path.relpath(target, kernel_root)
                if is_under_skip(rel_target):
                    continue

                if os.path.isfile(target):
                    try:
                        with open(target, "r", encoding="utf-8", errors="replace") as f:
                            if STUB_MARKER in f.read(200):
                                # already a stub from prior run
                                pass
                    except OSError:
                        pass
                    continue

                referenced_by = f"{rel_kc}:{lineno}"
                hint = any(
                    rel_target.replace("\\", "/").startswith(h)
                    or h.startswith(os.path.dirname(rel_target).replace("\\", "/"))
                    for h in gitignore_hints
                )
                wrote = ensure_stub_kconfig(target, referenced_by)
                entry = {
                    "path": rel_target.replace("\\", "/"),
                    "referenced_by": referenced_by,
                    "round": round_idx,
                    "gitignore_hint": hint,
                    "source_ref": ref,
                }
                if wrote:
                    stubs.append(entry)
                    new_this_round += 1
                else:
                    # file appeared between check and write, or stub already there
                    if os.path.isfile(target):
                        already.append(entry)

        if new_this_round == 0:
            break

    result = {
        "kernel_root": kernel_root,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "stubbed_count": len(stubs),
        "rounds_used": max((s["round"] for s in stubs), default=0),
        "stubs": stubs,
        "gitignore_hints_considered": gitignore_hints[:50],
    }

    if manifest_path:
        manifest_dir = os.path.dirname(os.path.abspath(manifest_path))
        if manifest_dir:
            os.makedirs(manifest_dir, exist_ok=True)
        with open(manifest_path, "w", encoding="utf-8") as f:
            json.dump(result, f, indent=2, ensure_ascii=False)
            f.write("\n")

    return result


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Stub missing Kconfig sources in partial OSS kernel trees"
    )
    parser.add_argument("kernel_root", help="Path to kernel source root")
    parser.add_argument(
        "--manifest",
        default=None,
        help="Write JSON manifest to this path",
    )
    args = parser.parse_args()

    try:
        result = sanitize(args.kernel_root, args.manifest)
    except Exception as exc:
        print(f"[-] Partial-tree sanitize failed: {exc}", file=sys.stderr)
        return 1

    n = result["stubbed_count"]
    if n:
        print(
            f"[+] Partial-tree sanitize: stubbed {n} missing Kconfig"
            + (f" (see {args.manifest})" if args.manifest else "")
        )
        for s in result["stubs"][:20]:
            print(f"    - {s['path']}  (from {s['referenced_by']})")
        if n > 20:
            print(f"    ... and {n - 20} more")
    else:
        print("[+] Partial-tree sanitize: stubbed 0 missing Kconfig (tree already closed)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
