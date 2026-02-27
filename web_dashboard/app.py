from flask import Flask, jsonify, request
from flask_cors import CORS
from neo4j import GraphDatabase
import os
import json

app = Flask(__name__)
CORS(app)

# Neo4j connection details
URI = "bolt://localhost:7687"
AUTH = ("neo4j", "password") # Default credentials, adjust if needed

def get_db_driver():
    return GraphDatabase.driver(URI, auth=AUTH)

@app.route('/api/status', methods=['GET'])
def get_status():
    try:
        driver = get_db_driver()
        driver.verify_connectivity()
        driver.close()
        return jsonify({"status": "connected", "message": "Successfully connected to Neo4j"})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route('/api/graph', methods=['GET'])
def get_graph_data():
    limit = request.args.get('limit', default=100, type=int)
    
    query = """
    MATCH (n)-[r]->(m)
    WITH n, r, m
    LIMIT $limit
    RETURN 
        id(n) as source_id, labels(n)[0] as source_label, n.name as source_name,
        id(m) as target_id, labels(m)[0] as target_label, m.name as target_name,
        type(r) as edge_type
    """
    
    try:
        driver = get_db_driver()
        with driver.session() as session:
            result = session.run(query, limit=limit)
            
            nodes = {}
            edges = []
            
            for record in result:
                # Process source node
                src_id = f"{record['source_label']}_{record['source_name']}"
                if src_id not in nodes:
                    nodes[src_id] = {
                        "id": src_id,
                        "name": record['source_name'],
                        "category": 1 if record['source_label'] == 'GlobalVariable' else 0,
                        "symbolSize": 20,
                        "value": 1
                    }
                else:
                    nodes[src_id]["value"] += 1
                    nodes[src_id]["symbolSize"] = min(40, nodes[src_id]["symbolSize"] + 2)
                    
                # Process target node
                tgt_id = f"{record['target_label']}_{record['target_name']}"
                if tgt_id not in nodes:
                    nodes[tgt_id] = {
                        "id": tgt_id,
                        "name": record['target_name'],
                        "category": 1 if record['target_label'] == 'GlobalVariable' else 0,
                        "symbolSize": 20,
                        "value": 1
                    }
                else:
                    nodes[tgt_id]["value"] += 1
                    nodes[tgt_id]["symbolSize"] = min(40, nodes[tgt_id]["symbolSize"] + 2)
                    
                # Process edge
                edges.append({
                    "source": src_id,
                    "target": tgt_id,
                    "type": record['edge_type']
                })
                
        driver.close()
        
        return jsonify({
            "nodes": list(nodes.values()),
            "edges": edges
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/stats', methods=['GET'])
def get_stats():
    try:
        driver = get_db_driver()
        with driver.session() as session:
            # Get node counts
            node_counts = session.run("""
                MATCH (n)
                RETURN labels(n)[0] as label, count(n) as count
            """).data()
            
            # Get edge counts
            edge_counts = session.run("""
                MATCH ()-[r]->()
                RETURN type(r) as type, count(r) as count
            """).data()
            
            # Get top variables
            top_vars = session.run("""
                MATCH (f:Function)-[r:READS|WRITES]->(v:GlobalVariable)
                RETURN v.name as name, count(r) as count
                ORDER BY count DESC
                LIMIT 10
            """).data()
            
            # Get warnings sample
            warnings_sample = session.run("""
                MATCH (f:Function)-[r:READS|WRITES]->(v:GlobalVariable)
                RETURN 
                    CASE type(r) WHEN 'READS' THEN 'Read' ELSE 'Write' END as type, 
                    v.name as variable, 
                    f.name as function, 
                    'High' as risk_level
                LIMIT 50
            """).data()
            
        driver.close()
        
        # Format response
        stats = {
            "nodes": {item['label']: item['count'] for item in node_counts},
            "edges": {item['type']: item['count'] for item in edge_counts},
            "top_variables": top_vars,
            "warnings_sample": warnings_sample,
            "analysis_files": 2781
        }
        
        return jsonify(stats)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    print("Starting Neo4j Backend API Server on port 5000...")
    app.run(host='0.0.0.0', port=5000, debug=False)
