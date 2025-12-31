#!/bin/bash
export JAVA_HOME=$(pwd)/tools/jdk-17.0.2
export PATH=$JAVA_HOME/bin:$PATH

echo "Starting Neo4j with Java 17..."
./tools/neo4j-community-4.4.34/bin/neo4j start
