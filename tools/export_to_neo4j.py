import os
import json
import glob
import csv

import sys

def main():
    # Allow overriding paths via arguments
    data_dir = sys.argv[1] if len(sys.argv) > 1 else "analysis_data"
    output_dir = sys.argv[2] if len(sys.argv) > 2 else "neo4j_data"
    os.makedirs(output_dir, exist_ok=True)
    
    print(f"Scanning {data_dir} for JSON files...")
    # Only consume analyzer data files (functions list). Skip detector output like detections_*.json.
    files = [
        p for p in glob.glob(os.path.join(data_dir, "*.json"))
        if os.path.basename(p).startswith("data_")
    ]
    
    if not files:
        print("No data files found!")
        return

    # Use dictionaries to deduplicate
    # ID strategy: 
    #   Functions: "func_<name>"
    #   Variables: "var_<name>"
    nodes = {} # id -> {name, label}
    edges = set() # (start_id, end_id, type) - use set to deduplicate

    for fpath in files:
        try:
            with open(fpath, 'r') as f:
                data = json.load(f)
                for func in data:
                    fname = func['name']
                    func_id = f"func_{fname}"
                    
                    # Add Function Node
                    nodes[func_id] = {'name': fname, 'label': 'Function'}
                    
                    # Process Callees (CALLS)
                    for callee in func['callees']:
                        callee_id = f"func_{callee}"
                        # We might not have the definition of callee, but we know it exists as a node
                        if callee_id not in nodes:
                            nodes[callee_id] = {'name': callee, 'label': 'Function'}
                        
                        edges.add((func_id, callee_id, "CALLS"))

                    # Process Global Reads (READS)
                    for var in func['global_reads']:
                        var_id = f"var_{var}"
                        if var_id not in nodes:
                            nodes[var_id] = {'name': var, 'label': 'GlobalVariable'}
                        
                        edges.add((func_id, var_id, "READS"))

                    # Process Global Writes (WRITES)
                    for var in func['global_writes']:
                        var_id = f"var_{var}"
                        if var_id not in nodes:
                            nodes[var_id] = {'name': var, 'label': 'GlobalVariable'}
                        
                        edges.add((func_id, var_id, "WRITES"))

        except Exception as e:
            print(f"Error reading {fpath}: {e}")

    print(f"Processing complete. Found {len(nodes)} nodes and {len(edges)} relationships.")

    # Write nodes.csv
    nodes_file = os.path.join(output_dir, 'nodes.csv')
    with open(nodes_file, 'w', newline='') as f:
        writer = csv.writer(f)
        # Neo4j Import Header format
        writer.writerow(['id:ID', 'name', ':LABEL'])
        for nid, info in nodes.items():
            writer.writerow([nid, info['name'], info['label']])

    # Write edges.csv
    edges_file = os.path.join(output_dir, 'edges.csv')
    with open(edges_file, 'w', newline='') as f:
        writer = csv.writer(f)
        # Neo4j Import Header format
        writer.writerow([':START_ID', ':END_ID', ':TYPE'])
        for start, end, rtype in edges:
            writer.writerow([start, end, rtype])

    print(f"Generated Neo4j import files in '{output_dir}/':")
    print(f"  - {nodes_file}")
    print(f"  - {edges_file}")
    
    # Generate a helper script for easy import (using neo4j-admin import)
    # Note: This command is for the server terminal
    import_cmd = (
        "neo4j-admin database import full "
        "--nodes=import/nodes.csv "
        "--relationships=import/edges.csv "
        "--overwrite-destination neo4j"
    )
    
    readme_path = os.path.join(output_dir, "IMPORT_INSTRUCTIONS.md")
    with open(readme_path, 'w') as f:
        f.write("# How to Import into Neo4j\n\n")
        f.write("## Option 1: Neo4j Desktop (Local)\n")
        f.write("1. Create a new Project and Database.\n")
        f.write("2. Open the project folder (click '...' -> 'Open folder' -> 'Import').\n")
        f.write("3. Copy `nodes.csv` and `edges.csv` to the `import` folder.\n")
        f.write("4. Open Neo4j Browser and run the following Cypher commands (Note: LOAD CSV requires enabling file import in settings if not in import dir, but putting in import dir is easiest):\n\n")
        f.write("```cypher\n")
        f.write("// Create Constraints (Optional but recommended)\n")
        f.write("CREATE CONSTRAINT FOR (f:Function) REQUIRE f.id IS UNIQUE;\n")
        f.write("CREATE CONSTRAINT FOR (v:GlobalVariable) REQUIRE v.id IS UNIQUE;\n\n")
        f.write("// Load Nodes\n")
        f.write("LOAD CSV WITH HEADERS FROM 'file:///nodes.csv' AS row\n")
        f.write("CALL apoc.create.node([row[':LABEL']], {id: row['id:ID'], name: row['name']}) YIELD node RETURN count(*);\n\n")
        f.write("// Load Relationships\n")
        f.write("LOAD CSV WITH HEADERS FROM 'file:///edges.csv' AS row\n")
        f.write("MATCH (source {id: row[':START_ID']})\n")
        f.write("MATCH (target {id: row[':END_ID']})\n")
        f.write("CALL apoc.create.relationship(source, row[':TYPE'], {}, target) YIELD rel RETURN count(*);\n")
        f.write("```\n\n")
        f.write("*Note: The above Cypher uses APOC. If you don't have APOC, you'll need standard Cypher `MERGE` statements which are slower for large data.*\n\n")
        
        f.write("## Option 2: neo4j-admin import (Fastest, for fresh DB)\n")
        f.write("If you have access to the terminal of the Neo4j server:\n")
        f.write("```bash\n")
        f.write(f"{import_cmd}\n")
        f.write("```\n")

    print(f"Instructions saved to {readme_path}")

if __name__ == "__main__":
    main()
