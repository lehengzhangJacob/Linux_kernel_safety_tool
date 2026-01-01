#!/bin/bash
set -e

# Set JAVA_HOME for Neo4j
export JAVA_HOME=$(pwd)/tools/jdk-17.0.2
export PATH=$JAVA_HOME/bin:$PATH

# 1. Stop Neo4j
./tools/neo4j-community-4.4.34/bin/neo4j stop || true

# 2. Clean Build (Force Re-analysis)
if [ -d "build_analysis_linux-6.6.1" ]; then
    make -C linux-6.6.1 O=../build_analysis_linux-6.6.1 clean
fi