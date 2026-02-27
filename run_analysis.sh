#!/bin/bash
set -e

# Configuration
# Default to linux-6.6.1 if not specified
KERNEL_SRC="${1:-linux-6.6.1}"
BUILD_DIR="build_analysis_${KERNEL_SRC}"
PLUGIN_SO="$(pwd)/src/plugin/analyzer_plugin.so"
# Use host architecture (x86_64)
ARCH="x86"
# No cross compile needed for host
CROSS_COMPILE=""

# 1. Ensure Plugin is built
echo "[*] Building GCC Plugin..."
make -C src/plugin

# 2. Prepare Build Directory (Out-of-tree build)
if [ ! -d "$BUILD_DIR" ]; then
    echo "[*] Creating build directory: $BUILD_DIR"
    mkdir -p $BUILD_DIR
fi

# 3. Configure Kernel (if .config doesn't exist)
if [ ! -f "$BUILD_DIR/.config" ]; then
    echo "[*] Configuring Kernel (defconfig)..."
    make -C $KERNEL_SRC O=../$BUILD_DIR ARCH=$ARCH defconfig
fi

# 4. Run Analysis (Build with Plugin)
echo "[*] Starting Kernel Analysis for $KERNEL_SRC..."
echo "    Logs will be saved to: analysis_${KERNEL_SRC}.log"
echo "    AST output will be saved to: ast_${KERNEL_SRC}.log"

# Export AST log path for the plugin
export AST_LOG_FILE="$(pwd)/ast_${KERNEL_SRC}.log"
# Clear previous AST log
rm -f "$AST_LOG_FILE"

# Prepare JSON output directory for visualization
# Use a subdirectory for each kernel to avoid conflicts
export ANALYSIS_JSON_DIR="$(pwd)/analysis_data/${KERNEL_SRC}"
mkdir -p "$ANALYSIS_JSON_DIR"
rm -f "$ANALYSIS_JSON_DIR"/*.json

# We use 'modules_prepare' or just build the kernel to trigger compilation of C files
# Using -k to keep going even if some files fail
# Allow configuring parallel job count via ANALYSIS_JOBS env var. Default to 4 to avoid OOM on small VMs.
JOBS="${ANALYSIS_JOBS:-4}"
echo "[*] Using parallel jobs: $JOBS"
make -C $KERNEL_SRC O=../$BUILD_DIR ARCH=$ARCH \
    KCFLAGS="-fplugin=$PLUGIN_SO" \
    -j${JOBS} -k > "analysis_${KERNEL_SRC}.log" 2>&1 || true

# Extract Race Warnings to a separate list
echo "[*] Extracting Unprotected Global Variable Access List..."
grep "\[RACE_WARNING\]" "analysis_${KERNEL_SRC}.log" > "race_warnings_${KERNEL_SRC}.txt" || true
echo "    Unprotected accesses saved to: race_warnings_${KERNEL_SRC}.txt"

echo "[*] Analysis finished."
echo "    Check 'analysis_${KERNEL_SRC}.log' for build logs."
echo "    Check 'ast_${KERNEL_SRC}.log' for AST and analysis results."
echo "    Check 'race_warnings_${KERNEL_SRC}.txt' for the list of unprotected global variable accesses."

# Generate Visualization
# echo "[*] Generating Visualization..."
# # Pass the data directory and output filename to the script
# python3 visualize_results.py "$ANALYSIS_JSON_DIR" "analysis_visualization_${KERNEL_SRC}.html"
# echo "    Visualization saved to: analysis_visualization_${KERNEL_SRC}.html"

# Generate Neo4j Data
echo "[*] Generating Neo4j Import Data..."
# Pass the data directory and output directory to the script
python3 tools/export_to_neo4j.py "$ANALYSIS_JSON_DIR" "neo4j_data_${KERNEL_SRC}"

