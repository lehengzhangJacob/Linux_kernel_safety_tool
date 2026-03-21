#!/bin/bash
set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# 项目根目录
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# 工具目录
TOOLS_DIR="$PROJECT_ROOT/tools"

# 查找JDK
JAVA_DIR=$(ls -d "$TOOLS_DIR/jdk-"* 2>/dev/null | head -1)
if [ -n "$JAVA_DIR" ]; then
    export JAVA_HOME="$JAVA_DIR"
    export PATH="$JAVA_HOME/bin:$PATH"
fi

# 查找Neo4j
NEO4J_DIR=$(ls -d "$TOOLS_DIR/neo4j-community-"* 2>/dev/null | head -1)

# 1. Stop Neo4j
if [ -n "$NEO4J_DIR" ]; then
    "$NEO4J_DIR/bin/neo4j" stop || true
fi

# 2. Clean Build (Force Re-analysis)
if [ -d "$PROJECT_ROOT/build_analysis_linux-6.6.1" ]; then
    make -C "$PROJECT_ROOT/linux-6.6.1" O=../build_analysis_linux-6.6.1 clean 2>/dev/null || true
fi

# 3. Remove build artifacts
echo "[*] Removing build artifacts..."
rm -rf "$PROJECT_ROOT"/build_analysis_*

# 3.5 Remove neo4j_data directories (created during failed analysis)
echo "[*] Removing neo4j_data directories..."
rm -rf "$PROJECT_ROOT"/neo4j_data_*

# 4. Remove uploaded temporary directories (created during analysis)
echo "[*] Removing uploaded temporary directories..."
rm -rf "$PROJECT_ROOT"/build_analysis_uploaded_*
rm -rf "$PROJECT_ROOT"/neo4j_data_uploaded_*
rm -rf "$PROJECT_ROOT"/analysis_data/uploaded_*
# Remove old symlinks in project root (legacy cleanup)
find "$PROJECT_ROOT" -maxdepth 1 -type l -name "uploaded_*" -exec rm -f {} \; 2>/dev/null || true
# Remove symlinks in the new unified location
if [ -d "$PROJECT_ROOT/analysis_data/uploaded_links" ]; then
    rm -rf "$PROJECT_ROOT/analysis_data/uploaded_links"
fi

# 5. Remove analysis data
echo "[*] Removing analysis data..."
rm -rf "$PROJECT_ROOT"/logs/analysis_*.log "$PROJECT_ROOT"/logs/ast_*.log "$PROJECT_ROOT"/logs/race_warnings_*.txt

# 6. Remove analysis JSON directory
rm -rf "$PROJECT_ROOT/analysis_data"

# 7. Remove Neo4j data (already handled in step 3.5)
# Note: neo4j_data_* directories are cleaned in step 3.5

echo "[*] Clean complete."
