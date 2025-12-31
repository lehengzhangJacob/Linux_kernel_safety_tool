#!/bin/bash
set -e

# Setup Java Environment for Neo4j (Required for stop/start/import)
export JAVA_HOME=$(pwd)/tools/jdk-17.0.2
export PATH=$JAVA_HOME/bin:$PATH

# 1. Stop Neo4j
./tools/neo4j-community-4.4.34/bin/neo4j stop || true

# 2. Clean Build (Force Re-analysis)
if [ -d "build_analysis_linux-6.6.1" ]; then
    make -C linux-6.6.1 O=../build_analysis_linux-6.6.1 clean
fi

# 3. Run Analysis (Generates JSON & CSV)
./run_analysis.sh

# 4. Import Data to Neo4j
export JAVA_HOME=$(pwd)/tools/jdk-17.0.2
export PATH=$JAVA_HOME/bin:$PATH
./tools/neo4j-community-4.4.34/bin/neo4j-admin import --database=neo4j \
    --nodes=neo4j_data_linux-6.6.1/nodes.csv \
    --relationships=neo4j_data_linux-6.6.1/edges.csv \
    --force

# 5. Start Neo4j
./start_neo4j.sh
