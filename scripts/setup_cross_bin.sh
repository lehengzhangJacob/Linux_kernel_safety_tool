#!/bin/bash
# Refresh unversioned cross-compiler wrappers under tools/cross-bin
# so CROSS_COMPILE=<triplet>-gcc / g++ works with Ubuntu's *-13 binaries.
#
# NOTE: Loongnix vendor GCC 8.3 is NOT installed here.
# Use scripts/install_loongnix_toolchain.sh → tools/vendor/loongson-gcc8/
# Default loongarch wrappers must keep pointing at apt gcc-13.
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CROSS_BIN="$PROJECT_ROOT/tools/cross-bin"
mkdir -p "$CROSS_BIN"

link_tool() {
    local base="$1"
    if [ -x "/usr/bin/${base}" ]; then
        ln -sfn "/usr/bin/${base}" "$CROSS_BIN/${base}"
        return 0
    fi
    local v
    for v in 13 14 12 11; do
        if [ -x "/usr/bin/${base}-${v}" ]; then
            ln -sfn "/usr/bin/${base}-${v}" "$CROSS_BIN/${base}"
            echo "[+] $base -> ${base}-${v}"
            return 0
        fi
    done
    echo "[-] missing $base"
    return 1
}

install_loongarch_gcc_wrapper() {
    local real=""
    local v
    for v in 13 14 12; do
        if [ -x "/usr/bin/loongarch64-linux-gnu-gcc-${v}" ]; then
            real="/usr/bin/loongarch64-linux-gnu-gcc-${v}"
            break
        fi
    done
    if [ -z "$real" ] && [ -x /usr/bin/loongarch64-linux-gnu-gcc ]; then
        real=/usr/bin/loongarch64-linux-gnu-gcc
    fi
    if [ -z "$real" ]; then
        echo "[-] missing loongarch64-linux-gnu-gcc"
        return 1
    fi
    # Must remove existing symlink first; otherwise `>` truncates the real gcc binary!
    rm -f "$CROSS_BIN/loongarch64-linux-gnu-gcc"
    cat > "$CROSS_BIN/loongarch64-linux-gnu-gcc" << EOF
#!/bin/bash
# Old LoongArch kernels pass -mabi=lp64; GCC 13+ rejects it.
REAL_CC="\${LOONGARCH_REAL_GCC:-$real}"
args=()
for a in "\$@"; do
  if [ "\$a" = "-mabi=lp64" ]; then
    args+=("-mabi=lp64d")
  else
    args+=("\$a")
  fi
done
exec "\$REAL_CC" "\${args[@]}"
EOF
    chmod +x "$CROSS_BIN/loongarch64-linux-gnu-gcc"
    echo "[+] loongarch64-linux-gnu-gcc wrapper -> $real (rewrites -mabi=lp64)"
}

for t in aarch64-linux-gnu arm-linux-gnueabihf; do
    link_tool "${t}-gcc" || true
    link_tool "${t}-g++" || true
done
link_tool "loongarch64-linux-gnu-g++" || true
install_loongarch_gcc_wrapper || true

echo "[*] cross-bin ready: $CROSS_BIN"
ls -la "$CROSS_BIN"
