#!/bin/bash
# Install Loongson/Loongnix vendor GCC 8.3 cross toolchain into the project tree.
# Isolated under tools/vendor/ — NEVER writes to /usr or changes apt packages.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VENDOR_ROOT="$PROJECT_ROOT/tools/vendor"
INSTALL_DIR="$VENDOR_ROOT/loongson-gcc8"
ARCHIVE_NAME="loongson-gnu-toolchain-8.3-x86_64-loongarch64-linux-gnu-rc1.6.tar.xz"
BASE_URL="https://ftp.loongnix.cn/toolchain/gcc/release/loongarch/gcc8"
ARCHIVE_PATH="$VENDOR_ROOT/$ARCHIVE_NAME"
MD5_PATH="$ARCHIVE_PATH.md5"

mkdir -p "$VENDOR_ROOT"

echo "[*] Loongnix vendor toolchain install (isolated)"
echo "    target: $INSTALL_DIR"
echo "    NOTE: will NOT modify /usr or apt gcc-13-loongarch64 packages"

if [ -x "$INSTALL_DIR/bin/loongarch64-linux-gnu-gcc" ]; then
    ver="$("$INSTALL_DIR/bin/loongarch64-linux-gnu-gcc" -dumpversion 2>/dev/null || true)"
    echo "[+] Already installed: $INSTALL_DIR/bin/loongarch64-linux-gnu-gcc (version=$ver)"
    exit 0
fi

download() {
    local url="$1" out="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -L --retry 5 --retry-delay 5 -C - -o "$out" "$url"
    else
        wget -c -O "$out" "$url"
    fi
}

if [ ! -f "$ARCHIVE_PATH" ]; then
    echo "[*] Downloading $ARCHIVE_NAME ..."
    download "$BASE_URL/$ARCHIVE_NAME" "$ARCHIVE_PATH"
fi

if [ ! -f "$MD5_PATH" ]; then
    echo "[*] Downloading checksum ..."
    download "$BASE_URL/$ARCHIVE_NAME.md5" "$MD5_PATH" || true
fi

if [ -f "$MD5_PATH" ]; then
    echo "[*] Verifying md5 ..."
    (
        cd "$VENDOR_ROOT"
        if md5sum -c "$(basename "$MD5_PATH")" 2>/dev/null; then
            echo "[+] md5 OK"
        else
            # Some mirrors store only the hash; try flexible check
            expected="$(awk '{print $1}' "$MD5_PATH" | head -1)"
            actual="$(md5sum "$ARCHIVE_PATH" | awk '{print $1}')"
            if [ -n "$expected" ] && [ "$expected" = "$actual" ]; then
                echo "[+] md5 OK (raw hash)"
            else
                echo "[WARNING] md5 mismatch or unreadable; continuing with downloaded archive"
            fi
        fi
    )
fi

echo "[*] Extracting into $INSTALL_DIR ..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
# Tarball may contain a top-level directory; normalize into INSTALL_DIR
tmpdir="$(mktemp -d "$VENDOR_ROOT/extract.XXXXXX")"
tar -xJf "$ARCHIVE_PATH" -C "$tmpdir"
# If single top dir, move its contents; else move all
entries=("$tmpdir"/*)
if [ ${#entries[@]} -eq 1 ] && [ -d "${entries[0]}" ]; then
    shopt -s dotglob
    mv "${entries[0]}"/* "$INSTALL_DIR"/
    shopt -u dotglob
else
    shopt -s dotglob
    mv "$tmpdir"/* "$INSTALL_DIR"/
    shopt -u dotglob
fi
rm -rf "$tmpdir"

GCC_BIN="$INSTALL_DIR/bin/loongarch64-linux-gnu-gcc"
if [ ! -x "$GCC_BIN" ]; then
    echo "[-] Expected compiler missing after extract: $GCC_BIN"
    ls -la "$INSTALL_DIR" || true
    ls -la "$INSTALL_DIR/bin" 2>/dev/null || true
    exit 1
fi

ver="$("$GCC_BIN" -dumpversion)"
echo "[+] Vendor toolchain ready: $GCC_BIN"
echo "    version: $ver"
echo "    CROSS_COMPILE prefix: $INSTALL_DIR/bin/loongarch64-linux-gnu-"
echo "[*] System gcc-13 left untouched."
