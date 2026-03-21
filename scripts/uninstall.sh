#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=================================================="
echo "  Linux Kernel Safety Analyzer - Uninstaller"
echo "=================================================="

read -p "Are you sure you want to uninstall? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "[*] Stopping Neo4j if running..."
    JAVA_DIR=$(ls -d "$PROJECT_ROOT/tools/jdk-"* 2>/dev/null | head -1)
    NEO4J_DIR=$(ls -d "$PROJECT_ROOT/tools/neo4j-community-"* 2>/dev/null | head -1)
    
    if [ -n "$JAVA_DIR" ] && [ -n "$NEO4J_DIR" ]; then
        export JAVA_HOME="$JAVA_DIR"
        export PATH="$JAVA_HOME/bin:$PATH"
        "$NEO4J_DIR/bin/neo4j" stop 2>/dev/null || true
    fi

    echo "[*] Stopping web services..."
    pkill -f "python app.py" 2>/dev/null || true
    pkill -f "npm run dev" 2>/dev/null || true
    pkill -f "vite" 2>/dev/null || true

    echo "[*] Removing compiled files..."
    rm -f "$PROJECT_ROOT/kernel_analyzer"
    make -C "$PROJECT_ROOT/src/plugin" clean 2>/dev/null || true

    echo "[*] Removing build artifacts and logs..."
    rm -rf "$PROJECT_ROOT/build_analysis_"*
    rm -rf "$PROJECT_ROOT/logs/"

    echo "[*] Removing analysis data..."
    rm -rf "$PROJECT_ROOT/analysis_data/"
    rm -rf "$PROJECT_ROOT/neo4j_data_"*

    echo "[*] Removing tools (JDK & Neo4j)..."
    rm -rf "$PROJECT_ROOT/tools/jdk-"* "$PROJECT_ROOT/tools/neo4j-community-"*

    echo "=================================================="
    echo "  Uninstallation Complete."
    echo "  System packages (gcc, etc.) were NOT removed."
    echo "=================================================="
else
    echo "Cancelled."
fi
