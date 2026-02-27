from flask import Flask, jsonify, request
from flask_cors import CORS
from neo4j import GraphDatabase
import os
import json
import threading
import time
import subprocess
from collections import deque

app = Flask(__name__)
CORS(app)
app.config['MAX_CONTENT_LENGTH'] = 2 * 1024 * 1024 * 1024  # 允许最大 2GB 的上传

# Neo4j connection details
URI = "bolt://localhost:7687"
AUTH = ("neo4j", "password") # Default credentials, adjust if needed

# Global state for real scan
scan_status = {
    "status": "idle",
    "progress": 0,
    "logs": deque(maxlen=300) # 只保留最后300行日志，防止内存溢出
}

def run_real_scan(target):
    global scan_status
    scan_status["status"] = "running"
    scan_status["progress"] = 5
    scan_status["logs"].clear()
    scan_status["logs"].append(f"[*] 开始真实分析任务，目标: {target}")
    
    # 启动真实的分析脚本
    process = subprocess.Popen(
        ['./run_analysis.sh', target],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        cwd='/home/jacob/contest'
    )
    
    # run_analysis.sh 会把 make 的输出重定向到 analysis_<target>.log
    # 我们开一个子线程去 tail 这个日志文件，让前端能看到真实的编译过程
    log_file_path = f"/home/jacob/contest/analysis_{target}.log"
    
    def tail_log_file():
        # 等待日志文件创建
        for _ in range(20):
            if os.path.exists(log_file_path):
                break
            time.sleep(0.5)
        
        if os.path.exists(log_file_path):
            with open(log_file_path, 'r') as f:
                while scan_status["status"] == "running":
                    line = f.readline()
                    if line:
                        scan_status["logs"].append(line.strip())
                    else:
                        time.sleep(0.2)

    tail_thread = threading.Thread(target=tail_log_file)
    tail_thread.start()

    # 读取脚本本身的输出
    for line in iter(process.stdout.readline, ''):
        line = line.strip()
        if line:
            scan_status["logs"].append(line)
            # 根据输出关键字更新进度条
            if "Building GCC Plugin" in line:
                scan_status["progress"] = 10
            elif "Configuring Kernel" in line:
                scan_status["progress"] = 15
            elif "Starting Kernel Analysis" in line:
                scan_status["progress"] = 20
            elif "Extracting Unprotected" in line:
                scan_status["progress"] = 80
            elif "Generating Neo4j" in line:
                scan_status["progress"] = 90

    process.wait()
    
    if process.returncode == 0:
        scan_status["progress"] = 100
        scan_status["status"] = "completed"
        scan_status["logs"].append("[+] 分析完成！数据已就绪。")
    else:
        scan_status["status"] = "error"
        scan_status["logs"].append(f"[-] 分析结束，退出码: {process.returncode}")

@app.route('/api/upload', methods=['POST'])
def upload_files():
    if 'files' not in request.files:
        return jsonify({"error": "No files part"}), 400
    
    files = request.files.getlist('files')
    target_dir = request.form.get('target_dir', 'uploaded_code')
    
    base_path = os.path.join('/home/jacob/contest', target_dir)
    os.makedirs(base_path, exist_ok=True)
    
    for file in files:
        if file.filename:
            # file.filename 包含了前端传来的相对路径
            file_path = os.path.join(base_path, file.filename)
            os.makedirs(os.path.dirname(file_path), exist_ok=True)
            file.save(file_path)
            
    return jsonify({"message": "Upload complete", "target": target_dir})

@app.route('/api/scan', methods=['POST'])
def start_scan():
    data = request.json or {}
    target = data.get('target', 'linux-6.12.6')
    
    # 启动真实的后台分析线程
    thread = threading.Thread(target=run_real_scan, args=(target,))
    thread.start()
    
    return jsonify({"message": "Scan started successfully"})

@app.route('/api/scan/status', methods=['GET'])
def get_scan_status():
    return jsonify({
        "status": scan_status["status"],
        "progress": scan_status["progress"],
        "logs": list(scan_status["logs"])
    })

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
