#!/bin/bash

TOOLS_DIR="tools"
mkdir -p "$TOOLS_DIR"

# JDK 17.0.2
JDK_VERSION="17.0.2"
JDK_DIR="$TOOLS_DIR/jdk-$JDK_VERSION"
JDK_TAR="$TOOLS_DIR/openjdk-${JDK_VERSION}_linux-x64_bin.tar.gz"
JDK_URL="https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz"

if [ ! -d "$JDK_DIR" ]; then
    echo "JDK $JDK_VERSION not found. Downloading..."
    if [ ! -f "$JDK_TAR" ]; then
        wget -O "$JDK_TAR" "$JDK_URL"
    fi
    echo "Extracting JDK..."
    tar -xzf "$JDK_TAR" -C "$TOOLS_DIR"
    # Rename if necessary (openjdk usually extracts to jdk-17.0.2)
else
    echo "JDK $JDK_VERSION already installed."
fi

# Neo4j 4.4.34
NEO4J_VERSION="4.4.34"
NEO4J_DIR="$TOOLS_DIR/neo4j-community-$NEO4J_VERSION"
NEO4J_TAR="$TOOLS_DIR/neo4j-community-$NEO4J_VERSION-unix.tar.gz"
NEO4J_URL="https://neo4j.com/artifact.php?name=neo4j-community-$NEO4J_VERSION-unix.tar.gz"

if [ ! -d "$NEO4J_DIR" ]; then
    echo "Neo4j $NEO4J_VERSION not found. Downloading..."
    if [ ! -f "$NEO4J_TAR" ]; then
        wget -O "$NEO4J_TAR" "$NEO4J_URL"
    fi
    echo "Extracting Neo4j..."
    tar -xzf "$NEO4J_TAR" -C "$TOOLS_DIR"
else
    echo "Neo4j $NEO4J_VERSION already installed."
fi

echo "Setup complete."
