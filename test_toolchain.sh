#!/bin/bash
set -e

# Configuration
PLUGIN_SRC="src/plugin"
PLUGIN_SO="$(pwd)/src/plugin/analyzer_plugin.so"
TEST_FILE="test/viz_test.c"
GCC="gcc"
# Use a separate directory for test data to avoid polluting the main analysis
TEST_DATA_DIR="$(pwd)/analysis_data/test_case"
TEST_NEO4J_DIR="neo4j_data_test"

echo "=== [1/4] Building GCC Plugin ==="
make -C $PLUGIN_SRC

echo "=== [2/4] Preparing Test Case ==="
# Prepare JSON output directory
mkdir -p "$TEST_DATA_DIR"
rm -f "$TEST_DATA_DIR"/*.json

# Create a simple standalone test file
mkdir -p test
cat <<TEST_EOF > $TEST_FILE
int global_var = 0;
int another_var = 1;

void func_c() {
    global_var++;
}

void func_b() {
    func_c();
    int x = another_var;
}

void func_a() {
    func_b();
    global_var = 10;
}
TEST_EOF
echo "Created $TEST_FILE"

echo "=== [3/4] Running Plugin on Test File ==="
# Set env var for plugin output
export ANALYSIS_JSON_DIR="$TEST_DATA_DIR"
# Run GCC with plugin
$GCC -fplugin=$PLUGIN_SO -c $TEST_FILE -o /dev/null

echo "=== [4/4] Generating Neo4j Data ==="
# Run the export script pointing to the test data
python3 tools/export_to_neo4j.py "$TEST_DATA_DIR" "$TEST_NEO4J_DIR"

# Verify output
if [ -f "$TEST_NEO4J_DIR/nodes.csv" ] && [ -f "$TEST_NEO4J_DIR/edges.csv" ]; then
    echo "SUCCESS: Neo4j import files generated in '$TEST_NEO4J_DIR/'"
    echo "---------------------------------------------------"
    echo "Nodes preview:"
    head -n 5 "$TEST_NEO4J_DIR/nodes.csv"
    echo "---------------------------------------------------"
    echo "Edges preview:"
    head -n 5 "$TEST_NEO4J_DIR/edges.csv"
    echo "---------------------------------------------------"
    echo "To import this test data into Neo4j, run:"
    echo "./tools/neo4j-community-4.4.34/bin/neo4j-admin import --database=neo4j --nodes=$TEST_NEO4J_DIR/nodes.csv --relationships=$TEST_NEO4J_DIR/edges.csv --force"
else
    echo "FAILURE: Neo4j files were not generated."
    exit 1
fi
