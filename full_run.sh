#!/bin/bash
set -e

# Configuration
# Default to linux-6.6.1 if not specified
KERNEL_SRC="${1:-linux-6.6.1}"
BUILD_DIR="build_analysis_${KERNEL_SRC}"
NEO4J_DATA_DIR="neo4j_data_${KERNEL_SRC}"

echo "Target Kernel: $KERNEL_SRC"

# Setup Java Environment for Neo4j (Required for stop/start/import)
export JAVA_HOME=$(pwd)/tools/jdk-17.0.2
export PATH=$JAVA_HOME/bin:$PATH

# 1. Stop Neo4j
./tools/neo4j-community-4.4.34/bin/neo4j stop || true

# 2. Clean Build (Force Re-analysis)
if [ -d "$BUILD_DIR" ]; then
    echo "Cleaning build directory: $BUILD_DIR"
    rm -rf "$BUILD_DIR"
fi

# 3. Run Analysis (Generates JSON & CSV)
./run_analysis.sh "$KERNEL_SRC"

# 4. Import Data to Neo4j
export JAVA_HOME=$(pwd)/tools/jdk-17.0.2
export PATH=$JAVA_HOME/bin:$PATH

# Check if CSV files exist
if [ ! -f "$NEO4J_DATA_DIR/nodes.csv" ] || [ ! -f "$NEO4J_DATA_DIR/edges.csv" ]; then
    echo "Error: CSV files not found in $NEO4J_DATA_DIR"
    exit 1
fi

# Clear existing database (Neo4j 4.x specific)
rm -rf tools/neo4j-community-4.4.34/data/databases/neo4j
rm -rf tools/neo4j-community-4.4.34/data/transactions/neo4j

./tools/neo4j-community-4.4.34/bin/neo4j-admin import --database=neo4j \
    --nodes="$NEO4J_DATA_DIR/nodes.csv" \
    --relationships="$NEO4J_DATA_DIR/edges.csv" \
    --force

# 5. Start Neo4j
./start_neo4j.sh
