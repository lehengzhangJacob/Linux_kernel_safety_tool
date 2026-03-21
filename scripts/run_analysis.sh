#!/bin/bash
set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# 项目根目录
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 统一日志目录
LOGS_DIR="$PROJECT_ROOT/logs"
mkdir -p "$LOGS_DIR"

# Configuration
# Default to linux-6.6.1 if not specified
KERNEL_SRC="${1:-linux-6.6.1}"
PLUGIN_SO="$PROJECT_ROOT/src/plugin/analyzer_plugin.so"
# Use host architecture (x86_64)
ARCH="x86"
# No cross compile needed for host
CROSS_COMPILE=""

cd "$PROJECT_ROOT"

# Determine kernel source path
# Check multiple locations: PROJECT_ROOT, analysis_data/uploaded_links, or absolute path
if [ -d "$PROJECT_ROOT/$KERNEL_SRC" ]; then
    KERNEL_SRC_PATH="$PROJECT_ROOT/$KERNEL_SRC"
elif [ -d "$PROJECT_ROOT/analysis_data/uploaded_links/$KERNEL_SRC" ]; then
    KERNEL_SRC_PATH="$PROJECT_ROOT/analysis_data/uploaded_links/$KERNEL_SRC"
elif [ -d "$KERNEL_SRC" ]; then
    KERNEL_SRC_PATH="$KERNEL_SRC"
else
    echo "[-] Error: Kernel source directory not found: $KERNEL_SRC"
    echo "[-] Checked locations:"
    echo "    - $PROJECT_ROOT/$KERNEL_SRC"
    echo "    - $PROJECT_ROOT/analysis_data/uploaded_links/$KERNEL_SRC"
    echo "    - $KERNEL_SRC (absolute path)"
    exit 1
fi

echo "[*] Kernel source path: $KERNEL_SRC_PATH"

# Build directory in analysis_data to avoid polluting root
BUILD_DIR="$PROJECT_ROOT/analysis_data/build_${KERNEL_SRC}"
mkdir -p "$PROJECT_ROOT/analysis_data"

# 1. Ensure Plugin is built
echo "[*] Building GCC Plugin..."
make -C "$PROJECT_ROOT/src/plugin"

# 2. Prepare Build Directory (Out-of-tree build)
# Clean build directory if it exists from a failed/corrupted build
if [ -d "$BUILD_DIR" ]; then
    echo "[*] Cleaning existing build directory: $BUILD_DIR"
    rm -rf "$BUILD_DIR"
fi
echo "[*] Creating build directory: $BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Fix permissions for uploaded kernel source (scripts need execute permission)
if [ -d "$KERNEL_SRC_PATH/scripts" ]; then
    echo "[*] Fixing script permissions..."
    find "$KERNEL_SRC_PATH/scripts" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    # Also fix other executable scripts that might be needed
    chmod +x "$KERNEL_SRC_PATH/scripts/pahole-flags.sh" 2>/dev/null || true
    chmod +x "$KERNEL_SRC_PATH/scripts/setlocalversion" 2>/dev/null || true
    chmod +x "$KERNEL_SRC_PATH/scripts/mkcompile_h" 2>/dev/null || true
    chmod +x "$KERNEL_SRC_PATH/scripts/remove-stale-files" 2>/dev/null || true
    chmod +x "$KERNEL_SRC_PATH/scripts/misc-check" 2>/dev/null || true
fi

# 3. Configure Kernel
# Always use allnoconfig for faster analysis (minimal config)
# This builds only essential files instead of the entire kernel
echo "[*] Configuring Kernel (allnoconfig for faster analysis)..."
if ! make -C "$KERNEL_SRC_PATH" O="$BUILD_DIR" ARCH=$ARCH allnoconfig; then
    echo "[WARNING] allnoconfig failed, trying defconfig..."
    make -C "$KERNEL_SRC_PATH" O="$BUILD_DIR" ARCH=$ARCH defconfig || true
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

# Update config
make -C "$KERNEL_SRC_PATH" O="$BUILD_DIR" ARCH=$ARCH olddefconfig > /dev/null 2>&1 || true

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
make -C "$KERNEL_SRC_PATH" O="$BUILD_DIR" ARCH=$ARCH \
    KCFLAGS="-fplugin=$PLUGIN_SO" \
    -j${JOBS} -k all > "$LOGS_DIR/analysis_${KERNEL_SRC}.log" 2>&1 || true

# Extract Race Warnings to a separate list
echo "[*] Extracting Unprotected Global Variable Access List..."
grep "\[RACE_WARNING\]" "$LOGS_DIR/analysis_${KERNEL_SRC}.log" > "$LOGS_DIR/race_warnings_${KERNEL_SRC}.txt" || true
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
NEO4J_OUTPUT_DIR="$PROJECT_ROOT/neo4j_data_${KERNEL_SRC}"
mkdir -p "$NEO4J_OUTPUT_DIR"
if python3 "$PROJECT_ROOT/tools/export_to_neo4j.py" "$ANALYSIS_JSON_DIR" "$NEO4J_OUTPUT_DIR"; then
    echo "[+] Neo4j data generation completed successfully"
    echo "    Neo4j data saved to: $NEO4J_OUTPUT_DIR"
else
    echo "[WARNING] Neo4j data generation failed, but analysis will continue"
fi
