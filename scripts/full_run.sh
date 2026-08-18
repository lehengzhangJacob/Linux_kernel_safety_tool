#!/bin/bash
set -e

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# 项目根目录
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# 工具目录
TOOLS_DIR="$PROJECT_ROOT/tools"

# Configuration
# Default to linux-6.6.1 if not specified
KERNEL_SRC="${1:-linux-6.6.1}"
BUILD_DIR="$PROJECT_ROOT/analysis_data/build_${KERNEL_SRC}"
NEO4J_DATA_DIR="$PROJECT_ROOT/neo4j_data_${KERNEL_SRC}"

echo "Target Kernel: $KERNEL_SRC"
echo "Project Root: $PROJECT_ROOT"
echo "Tools Directory: $TOOLS_DIR"

# 查找JDK
JAVA_DIR=$(ls -d "$TOOLS_DIR/jdk-"* 2>/dev/null | head -1)
if [ -z "$JAVA_DIR" ]; then
    echo "[WARNING] JDK not found, Neo4j operations will be skipped"
else
    # Setup Java Environment for Neo4j (Required for stop/start/import)
    export JAVA_HOME="$JAVA_DIR"
    export PATH="$JAVA_HOME/bin:$PATH"
    echo "[INFO] JDK found: $JAVA_DIR"
fi

# 查找Neo4j
NEO4J_DIR=$(ls -d "$TOOLS_DIR/neo4j-community-"* 2>/dev/null | head -1)
if [ -z "$NEO4J_DIR" ]; then
    echo "[WARNING] Neo4j not found, Neo4j operations will be skipped"
else
    echo "[INFO] Neo4j found: $NEO4J_DIR"
    # Ensure Neo4j binaries are executable
    if [ -d "$NEO4J_DIR/bin" ]; then
        chmod +x "$NEO4J_DIR/bin/"* 2>/dev/null || true
    fi
    # 1. Stop Neo4j
    "$NEO4J_DIR/bin/neo4j" stop 2>/dev/null || true
fi

# 3. Run Analysis (Generates JSON & CSV)
# Optional: KERNEL_ARCH / ARCH / CROSS_COMPILE are forwarded by run_analysis.sh
echo "[INFO] Running analysis for $KERNEL_SRC (ARCH=${KERNEL_ARCH:-${ARCH:-x86}})..."
"$SCRIPT_DIR/run_analysis.sh" "$KERNEL_SRC" "${KERNEL_ARCH:-${ARCH:-}}"

# 4. Import Data to Neo4j
if [ -n "$NEO4J_DIR" ] && [ -n "$JAVA_DIR" ]; then
    # Check if CSV files exist
    if [ ! -f "$NEO4J_DATA_DIR/nodes.csv" ] || [ ! -f "$NEO4J_DATA_DIR/edges.csv" ]; then
        echo "[ERROR] CSV files not found in $NEO4J_DATA_DIR"
        echo "[WARNING] Neo4j import skipped due to missing files"
    else
        echo "[INFO] Importing data to Neo4j..."
        # Clear existing database (Neo4j 4.x specific)
        rm -rf "$NEO4J_DIR/data/databases/neo4j" 2>/dev/null || true
        rm -rf "$NEO4J_DIR/data/transactions/neo4j" 2>/dev/null || true

        "$NEO4J_DIR/bin/neo4j-admin" import --database=neo4j \
            --nodes="$NEO4J_DATA_DIR/nodes.csv" \
            --relationships="$NEO4J_DATA_DIR/edges.csv" \
            --force || true

        # 5. Start Neo4j
        echo "[INFO] Starting Neo4j..."
        "$NEO4J_DIR/bin/neo4j" start || true
    fi
else
    echo "[INFO] Neo4j not configured, skipping data import"
fi

echo "[INFO] Full run completed!"
