#!/bin/bash
set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# 项目根目录
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Prefer project-local unversioned cross wrappers (gcc-13 → gcc, g++-13 → g++)
# These serve apt/GCC13 paths only. Loongnix vendor GCC8 is injected later if selected.
CROSS_BIN="$PROJECT_ROOT/tools/cross-bin"
VENDOR_LOONGSON_GCC8_DIR="$PROJECT_ROOT/tools/vendor/loongson-gcc8"
VENDOR_LOONGSON_GCC8_PREFIX="$VENDOR_LOONGSON_GCC8_DIR/bin/loongarch64-linux-gnu-"
if [ -x "$SCRIPT_DIR/setup_cross_bin.sh" ]; then
    bash "$SCRIPT_DIR/setup_cross_bin.sh" >/dev/null 2>&1 || true
fi
if [ -d "$CROSS_BIN" ]; then
    export PATH="$CROSS_BIN:$PATH"
fi

# 统一日志目录
LOGS_DIR="$PROJECT_ROOT/logs"
mkdir -p "$LOGS_DIR"

# Configuration
# Default to linux-6.6.1 if not specified
# Usage: run_analysis.sh <kernel_src> [arch]
# Env overrides: KERNEL_ARCH / ARCH, CROSS_COMPILE
KERNEL_SRC="${1:-linux-6.6.1}"
PLUGIN_ROOT="$PROJECT_ROOT/src/plugin"
# PLUGIN_SO is resolved after building against the target compiler
PLUGIN_SO=""

# Architecture: prefer CLI arg, then KERNEL_ARCH, then ARCH, default x86
ARCH_INPUT="${2:-${KERNEL_ARCH:-${ARCH:-x86}}}"
ARCH_INPUT="$(echo "$ARCH_INPUT" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"
USE_VENDOR_LOONGNIX=0

case "$ARCH_INPUT" in
    x86|x86_64|amd64|i386|i686)
        ARCH="x86"
        DEFAULT_CROSS=""
        ;;
    arm64|aarch64)
        ARCH="arm64"
        DEFAULT_CROSS="aarch64-linux-gnu-"
        ;;
    arm|armv7|arm32)
        ARCH="arm"
        DEFAULT_CROSS="arm-linux-gnueabihf-"
        ;;
    loongnix)
        # Loongnix 4.x: kernel ARCH=loongarch + isolated vendor GCC 8.3
        ARCH="loongarch"
        DEFAULT_CROSS="$VENDOR_LOONGSON_GCC8_PREFIX"
        USE_VENDOR_LOONGNIX=1
        ;;
    loongarch|loongarch64|loong64)
        ARCH="loongarch"
        DEFAULT_CROSS="loongarch64-linux-gnu-"
        ;;
    *)
        echo "[-] Unsupported ARCH: $ARCH_INPUT"
        echo "[-] Supported: x86 | arm64 | arm | loongarch | loongnix"
        exit 1
        ;;
esac

# CROSS_COMPILE: unset → arch default; explicit env (even empty) kept;
# KERNEL_CROSS_COMPILE (from web backend) always wins when set.
if [ -z "${CROSS_COMPILE+x}" ]; then
    CROSS_COMPILE="$DEFAULT_CROSS"
fi
if [ -n "${KERNEL_CROSS_COMPILE+x}" ]; then
    CROSS_COMPILE="$KERNEL_CROSS_COMPILE"
fi

# Detect vendor prefix even when ARCH_INPUT was plain loongarch but CROSS_COMPILE points at vendor
case "$CROSS_COMPILE" in
    *"/tools/vendor/loongson-gcc8/"*|*"${VENDOR_LOONGSON_GCC8_DIR}"*)
        USE_VENDOR_LOONGNIX=1
        ;;
esac
if [ "$USE_VENDOR_LOONGNIX" = "1" ]; then
    if [ ! -x "${VENDOR_LOONGSON_GCC8_PREFIX}gcc" ]; then
        echo "[-] Loongnix vendor GCC8 not found: ${VENDOR_LOONGSON_GCC8_PREFIX}gcc"
        echo "[-] Install with: $SCRIPT_DIR/install_loongnix_toolchain.sh"
        echo "[-] Will NOT fall back to system gcc-13 (would break Loongnix 4.19 builds)."
        exit 1
    fi
    # Prefer vendor bin for this process only; do not rewrite tools/cross-bin or /usr
    export PATH="$VENDOR_LOONGSON_GCC8_DIR/bin:$PATH"
    # Ensure absolute prefix so make never picks apt gcc-13 from PATH by short name alone
    if [ -z "$CROSS_COMPILE" ] || [ "$CROSS_COMPILE" = "loongarch64-linux-gnu-" ]; then
        CROSS_COMPILE="$VENDOR_LOONGSON_GCC8_PREFIX"
    fi
    echo "[*] Using isolated Loongnix vendor toolchain (GCC 8.3)"
fi

cd "$PROJECT_ROOT"

echo "[*] Target ARCH=$ARCH CROSS_COMPILE='${CROSS_COMPILE}'"

# Fail early if the required cross compiler is missing
if [ -n "$CROSS_COMPILE" ]; then
    CC_BIN="${CROSS_COMPILE}gcc"
    if [ -x "$CC_BIN" ]; then
        :
    elif ! command -v "$CC_BIN" >/dev/null 2>&1; then
        echo "[-] Cross compiler not found: $CC_BIN"
        echo "[-] Install the matching toolchain, or set CROSS_COMPILE / KERNEL_CROSS_COMPILE."
        case "$ARCH_INPUT" in
            loongnix)
                echo "[-] Hint: $SCRIPT_DIR/install_loongnix_toolchain.sh"
                ;;
            arm64)
                echo "[-] Hint (Debian/Ubuntu): sudo apt install gcc-aarch64-linux-gnu"
                ;;
            arm)
                echo "[-] Hint (Debian/Ubuntu): sudo apt install gcc-arm-linux-gnueabihf"
                ;;
            loongarch)
                echo "[-] Hint: install loongarch64-linux-gnu-gcc (distro package or vendor toolchain)"
                ;;
        esac
        exit 1
    fi
    if [ -x "$CC_BIN" ]; then
        echo "[+] Cross compiler ready: $CC_BIN"
    else
        echo "[+] Cross compiler ready: $(command -v "$CC_BIN")"
    fi
fi

# Determine kernel source path
# Check multiple locations: PROJECT_ROOT, analysis_data, analysis_data/uploaded_links, or absolute path
if [ -d "$PROJECT_ROOT/$KERNEL_SRC" ]; then
    KERNEL_SRC_PATH="$PROJECT_ROOT/$KERNEL_SRC"
elif [ -d "$PROJECT_ROOT/analysis_data/$KERNEL_SRC" ]; then
    KERNEL_SRC_PATH="$PROJECT_ROOT/analysis_data/$KERNEL_SRC"
elif [ -d "$PROJECT_ROOT/analysis_data/uploaded_links/$KERNEL_SRC" ]; then
    KERNEL_SRC_PATH="$PROJECT_ROOT/analysis_data/uploaded_links/$KERNEL_SRC"
elif [ -d "$KERNEL_SRC" ]; then
    KERNEL_SRC_PATH="$KERNEL_SRC"
else
    echo "[-] Error: Kernel source directory not found: $KERNEL_SRC"
    echo "[-] Checked locations:"
    echo "    - $PROJECT_ROOT/$KERNEL_SRC"
    echo "    - $PROJECT_ROOT/analysis_data/$KERNEL_SRC"
    echo "    - $PROJECT_ROOT/analysis_data/uploaded_links/$KERNEL_SRC"
    echo "    - $KERNEL_SRC (absolute path)"
    exit 1
fi

echo "[*] Kernel source path: $KERNEL_SRC_PATH"

# Build directory in analysis_data to avoid polluting root
BUILD_DIR="$PROJECT_ROOT/analysis_data/build_${KERNEL_SRC}"
mkdir -p "$PROJECT_ROOT/analysis_data"

# 1. Ensure Plugin is built against the same GCC that will compile the kernel
# Cross gcc is a host binary; plugin .so must be host ELF (HOST_CXX=g++) but
# use that GCC's plugin headers for ABI/version match.
if [ -n "$CROSS_COMPILE" ]; then
    CC_FOR_PLUGIN="${CROSS_COMPILE}gcc"
else
    CC_FOR_PLUGIN="gcc"
fi
HOST_CXX_FOR_PLUGIN="${HOST_CXX:-g++}"

echo "[*] Building GCC Plugin for loader: $CC_FOR_PLUGIN (host CXX: $HOST_CXX_FOR_PLUGIN)"
if ! command -v "$CC_FOR_PLUGIN" >/dev/null 2>&1; then
    echo "[-] Compiler for plugin build not found: $CC_FOR_PLUGIN"
    exit 1
fi
if ! command -v "$HOST_CXX_FOR_PLUGIN" >/dev/null 2>&1; then
    echo "[-] Host C++ compiler not found: $HOST_CXX_FOR_PLUGIN"
    exit 1
fi

PLUGIN_INC_DIR="$($CC_FOR_PLUGIN -print-file-name=plugin)"
if [ ! -f "$PLUGIN_INC_DIR/include/gcc-plugin.h" ]; then
    echo "[-] GCC plugin headers missing for $CC_FOR_PLUGIN"
    echo "[-] Expected: $PLUGIN_INC_DIR/include/gcc-plugin.h"
    if [ "$USE_VENDOR_LOONGNIX" = "1" ]; then
        echo "[-] Loongnix vendor GCC8 can compile the kernel, but this analyzer plugin needs GCC plugin support."
        echo "[-] Will NOT fall back to system gcc-13 (wrong ABI for Loongnix 4.19)."
        echo "[-] Next step is a GCC8-compatible plugin build, not rewriting apt gcc-13."
    else
        case "$ARCH" in
            arm64)
                echo "[-] Hint: sudo apt install gcc-13-plugin-dev-aarch64-linux-gnu libgmp-dev"
                ;;
            arm)
                echo "[-] Hint: sudo apt install gcc-13-plugin-dev-arm-linux-gnueabihf libgmp-dev"
                ;;
            loongarch)
                echo "[-] Hint: sudo apt install gcc-13-plugin-dev-loongarch64-linux-gnu libgmp-dev"
                ;;
            *)
                echo "[-] Hint: sudo apt install gcc-13-plugin-dev libgmp-dev"
                ;;
        esac
    fi
    exit 1
fi

TRIPLET="$($CC_FOR_PLUGIN -dumpmachine)"
GCC_VER="$($CC_FOR_PLUGIN -dumpversion)"
PLUGIN_SO="$PLUGIN_ROOT/build/${TRIPLET}-${GCC_VER}/analyzer_plugin.so"
echo "[*] Plugin target: $PLUGIN_SO"
if ! make -C "$PLUGIN_ROOT" GCC="$CC_FOR_PLUGIN" HOST_CXX="$HOST_CXX_FOR_PLUGIN"; then
    echo "[-] Failed to build analyzer plugin for $TRIPLET ($GCC_VER)"
    exit 1
fi
if [ ! -f "$PLUGIN_SO" ]; then
    echo "[-] Plugin .so not found after build: $PLUGIN_SO"
    exit 1
fi

echo "[*] Smoke-testing -fplugin load with $CC_FOR_PLUGIN..."
SMOKE_OBJ="$(mktemp /tmp/plugin_smoke.XXXXXX.o)"
if ! echo 'int x;' | "$CC_FOR_PLUGIN" -fplugin="$PLUGIN_SO" -c -x c - -o "$SMOKE_OBJ" 2>/tmp/plugin_smoke_err.$$; then
    echo "[-] Plugin failed to load into $CC_FOR_PLUGIN"
    cat /tmp/plugin_smoke_err.$$ >&2 || true
    rm -f "$SMOKE_OBJ" /tmp/plugin_smoke_err.$$
    if [ "$USE_VENDOR_LOONGNIX" = "1" ]; then
        echo "[-] Vendor GCC8 plugin ABI may be incompatible with this analyzer."
        echo "[-] Will NOT fall back to system gcc-13 for Loongnix."
    fi
    exit 1
fi
rm -f "$SMOKE_OBJ" /tmp/plugin_smoke_err.$$
echo "[+] Plugin smoke test passed"

# 2. Prepare Build Directory (Out-of-tree build)
# Clean build directory if it exists from a failed/corrupted build
if [ -d "$BUILD_DIR" ]; then
    echo "[*] Cleaning existing build directory: $BUILD_DIR"
    if ! rm -rf "$BUILD_DIR"; then
        FALLBACK_BUILD_DIR="$PROJECT_ROOT/analysis_data/build_${KERNEL_SRC}_$(date +%s)"
        echo "[WARNING] Failed to clean build directory (possible permission issue)."
        echo "[WARNING] Falling back to fresh build directory: $FALLBACK_BUILD_DIR"
        BUILD_DIR="$FALLBACK_BUILD_DIR"
    fi
fi
echo "[*] Creating build directory: $BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Fix permissions for uploaded kernel source (zip often drops +x on scripts)
if [ -d "$KERNEL_SRC_PATH/scripts" ]; then
    echo "[*] Fixing script permissions..."
    # *.sh / *.pl / *.py
    find "$KERNEL_SRC_PATH/scripts" -type f \( -name '*.sh' -o -name '*.pl' -o -name '*.py' \) \
        -exec chmod +x {} \; 2>/dev/null || true
    # Shebang scripts without extension (check-local-export, setlocalversion, …)
    find "$KERNEL_SRC_PATH/scripts" -type f ! -name '*.*' -print0 2>/dev/null \
        | xargs -0 -r grep -l '^#!' 2>/dev/null \
        | xargs -r chmod +x 2>/dev/null || true
    # Named fallbacks (in case find/grep misses)
    for s in pahole-flags.sh setlocalversion mkcompile_h remove-stale-files misc-check \
             check-local-export checksyscalls.sh recordmcount as-version.sh; do
        chmod +x "$KERNEL_SRC_PATH/scripts/$s" 2>/dev/null || true
    done
fi

# 2b. Partial OSS trees: stub missing Kconfig sources (vendor secrets often gitignored)
# so allnoconfig can close the kconfig graph without proprietary source.
SANITIZE_SCRIPT="$SCRIPT_DIR/sanitize_partial_kernel_tree.py"
SANITIZE_MANIFEST="$PROJECT_ROOT/analysis_data/sanitize_manifest_${KERNEL_SRC}.json"
if [ -f "$SANITIZE_SCRIPT" ]; then
    echo "[*] Sanitizing partial OSS kernel tree (stub missing Kconfig)..."
    if ! python3 "$SANITIZE_SCRIPT" "$KERNEL_SRC_PATH" --manifest "$SANITIZE_MANIFEST"; then
        echo "[WARNING] Partial-tree sanitize failed; continuing (allnoconfig may still fail on missing Kconfig)."
    fi
else
    echo "[WARNING] sanitize_partial_kernel_tree.py not found; skipping partial-tree sanitize"
fi

# 3. Configure Kernel
# Always use allnoconfig for faster analysis (minimal config)
# This builds only essential files instead of the entire kernel
echo "[*] Configuring Kernel (allnoconfig for faster analysis)..."
if ! make -C "$KERNEL_SRC_PATH" O="$BUILD_DIR" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" allnoconfig; then
    echo "[WARNING] allnoconfig failed, trying defconfig..."
    make -C "$KERNEL_SRC_PATH" O="$BUILD_DIR" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" defconfig || true
fi

# Enable some essential options for better analysis coverage
echo "[*] Enabling essential kernel options..."
# Enable modules and some core features
cat >> "$BUILD_DIR/.config" << 'EOF'
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_SMP=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_INFO=y
EOF

# Loongnix/LoongArch vendor trees embed struct screen_info in boot_param.h
# only when CONFIG_VT is set for the include, but the struct field is unconditional.
# allnoconfig leaves CONFIG_TTY/VT=n and dies at prepare0 (asm-offsets.s).
if [ "$ARCH" = "loongarch" ]; then
    echo "[*] LoongArch: enabling CONFIG_TTY/VT (required by mach-la64/boot_param.h)"
    cat >> "$BUILD_DIR/.config" << 'EOF'
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_INPUT=y
EOF
fi

# Update config
make -C "$KERNEL_SRC_PATH" O="$BUILD_DIR" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" olddefconfig > /dev/null 2>&1 || true

# 4. Run Analysis (Build with Plugin)
echo "[*] Starting Kernel Analysis for $KERNEL_SRC..."
echo "    Logs will be saved to: logs/analysis_${KERNEL_SRC}.log"
echo "    AST output will be saved to: logs/ast_${KERNEL_SRC}.log"

# Export AST log path for the plugin
export AST_LOG_FILE="$LOGS_DIR/ast_${KERNEL_SRC}.log"
# Clear previous AST log
rm -f "$AST_LOG_FILE"

# Prepare JSON output directory for visualization
# Use a subdirectory for each kernel to avoid conflicts
export ANALYSIS_JSON_DIR="$PROJECT_ROOT/analysis_data/${KERNEL_SRC}"
mkdir -p "$ANALYSIS_JSON_DIR"
rm -f "$ANALYSIS_JSON_DIR"/*.json

# We use 'make all' to build the entire kernel for full analysis
# Using -k to keep going even if some files fail
# Allow configuring parallel job count via ANALYSIS_JOBS env var. Default to 4 to avoid OOM on small VMs.
JOBS="${ANALYSIS_JOBS:-4}"
echo "[*] Using parallel jobs: $JOBS"
echo "[*] Starting full kernel build analysis (this may take a while)..."
echo "[*] Kernel source: $KERNEL_SRC_PATH"
echo "[*] Build directory: $BUILD_DIR"

# Old LoongArch kernels pass -mabi=lp64; apt GCC 13+ wants lp64d/f/s.
# Vendor GCC8 already understands the old ABI — never wrap it with lp64d overrides.
PLUGIN_KCFLAGS="-fplugin=$PLUGIN_SO"
if [ "$ARCH" = "loongarch" ] && [ "$USE_VENDOR_LOONGNIX" != "1" ]; then
    if ! echo 'int x;' | "$CC_FOR_PLUGIN" -mabi=lp64 -c -x c - -o /tmp/loong_abi_probe.$$.o >/dev/null 2>&1; then
        echo "[*] LoongArch toolchain rejects -mabi=lp64; appending -mabi=lp64d for analysis builds"
        PLUGIN_KCFLAGS="$PLUGIN_KCFLAGS -mabi=lp64d"
    fi
    rm -f /tmp/loong_abi_probe.$$.o
fi

make -C "$KERNEL_SRC_PATH" O="$BUILD_DIR" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" \
    KCFLAGS="$PLUGIN_KCFLAGS" \
    -j${JOBS} -k all > "$LOGS_DIR/analysis_${KERNEL_SRC}.log" 2>&1 || true

# Extract Race Warnings to a separate list
echo "[*] Extracting Unprotected Global Variable Access List..."
grep "[RACE_WARNING]" "$LOGS_DIR/analysis_${KERNEL_SRC}.log" > "$LOGS_DIR/race_warnings_${KERNEL_SRC}.txt" || true
echo "    Unprotected accesses saved to: logs/race_warnings_${KERNEL_SRC}.txt"

echo "[*] Analysis finished."
echo "    Check 'logs/analysis_${KERNEL_SRC}.log' for build logs."
echo "    Check 'logs/ast_${KERNEL_SRC}.log' for AST and analysis results."
echo "    Check 'logs/race_warnings_${KERNEL_SRC}.txt' for the list of unprotected global variable accesses."

# Generate Visualization
# echo "[*] Generating Visualization..."
# # Pass the data directory and output filename to the script
# python3 visualize_results.py "$ANALYSIS_JSON_DIR" "analysis_visualization_${KERNEL_SRC}.html"
# echo "    Visualization saved to: analysis_visualization_${KERNEL_SRC}.html"

# Generate Neo4j Data
echo "[*] Generating Neo4j Import Data..."
# Pass the data directory and output directory to the script
# Output to logs directory to avoid polluting project root
NEO4J_OUTPUT_DIR="$PROJECT_ROOT/logs/neo4j_data_${KERNEL_SRC}"
mkdir -p "$NEO4J_OUTPUT_DIR"
if python3 "$PROJECT_ROOT/tools/export_to_neo4j.py" "$ANALYSIS_JSON_DIR" "$NEO4J_OUTPUT_DIR"; then
    echo "[+] Neo4j data generation completed successfully"
    echo "    Neo4j data saved to: $NEO4J_OUTPUT_DIR"
else
    echo "[WARNING] Neo4j data generation failed, but analysis will continue"
fi