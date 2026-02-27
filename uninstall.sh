#!/bin/bash

echo "=================================================="
echo "  Linux Kernel Safety Analyzer - Uninstaller"
echo "=================================================="

read -p "Are you sure you want to uninstall? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "[*] Stopping Neo4j if running..."
    export JAVA_HOME=$(pwd)/tools/jdk-17.0.2
    export PATH=$JAVA_HOME/bin:$PATH
    ./tools/neo4j-community-4.4.34/bin/neo4j stop 2>/dev/null || true

    echo "[*] Removing compiled files..."
    rm -f kernel_analyzer
    make -C src/plugin clean 2>/dev/null || true

    echo "[*] Removing build artifacts and logs..."
    rm -rf build_analysis_*
    rm -f analysis_*.log ast_*.log race_warnings_*.txt

    echo "[*] Removing analysis data..."
    rm -rf analysis_data/
    rm -rf neo4j_data_*/

    echo "[*] Removing tools (JDK & Neo4j)..."
    rm -rf tools/jdk-* tools/neo4j-community-*

    echo "=================================================="
    echo "  Uninstallation Complete."
    echo "  System packages (gcc, etc.) were NOT removed."
    echo "=================================================="
else
    echo "Cancelled."
fi
