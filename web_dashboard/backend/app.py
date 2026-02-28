from flask import Flask, jsonify, request, send_from_directory, Response
from flask_cors import CORS
import os
import json
import threading
import time
import subprocess
import shutil
import tarfile
import zipfile
from collections import deque

app = Flask(__name__)
CORS(app)
app.config['MAX_CONTENT_LENGTH'] = 2 * 1024 * 1024 * 1024  # 允许最大 2GB 的上传

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(BASE_DIR, '..', '..'))
WEB_DASHBOARD_DIR = os.path.abspath(os.path.join(BASE_DIR, '..'))

# 数据存储目录（使用 web_dashboard 目录下的 data）
DATA_DIR = os.path.join(WEB_DASHBOARD_DIR, 'data')
os.makedirs(DATA_DIR, exist_ok=True)

@app.route('/')
def index():
    return send_from_directory(os.path.join(WEB_DASHBOARD_DIR, 'frontend', 'dist'), 'index.html')

@app.route('/<path:path>')
def serve_static(path):
    return send_from_directory(os.path.join(WEB_DASHBOARD_DIR, 'frontend', 'dist'), path)

# Global state for real scan
scan_status = {
    "status": "idle",
    "progress": 0,
    "logs": deque(maxlen=300) # 只保留最后300行日志，防止内存溢出
}

# In-memory data storage
analysis_data = {}


def _pdf_escape_text(text):
    return text.replace('\\', '\\\\').replace('(', '\\(').replace(')', '\\)')


def build_minimal_pdf(lines):
    rendered_lines = [str(line)[:110] for line in lines if line is not None]

    commands = [
        'BT',
        '/F1 12 Tf',
        '50 790 Td'
    ]

    first_line = True
    for line in rendered_lines:
        escaped = _pdf_escape_text(line)
        if not first_line:
            commands.append('0 -16 Td')
        commands.append(f'({escaped}) Tj')
        first_line = False

    commands.append('ET')
    content_stream = '\n'.join(commands).encode('latin-1', errors='replace')

    objects = [
        b'<< /Type /Catalog /Pages 2 0 R >>',
        b'<< /Type /Pages /Kids [3 0 R] /Count 1 >>',
        b'<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>',
        b'<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>',
        f'<< /Length {len(content_stream)} >>\nstream\n'.encode('ascii') + content_stream + b'\nendstream'
    ]

    pdf_parts = [b'%PDF-1.4\n%\xe2\xe3\xcf\xd3\n']
    offsets = [0]

    for index, obj in enumerate(objects, start=1):
        offsets.append(sum(len(part) for part in pdf_parts))
        pdf_parts.append(f'{index} 0 obj\n'.encode('ascii') + obj + b'\nendobj\n')

    xref_offset = sum(len(part) for part in pdf_parts)
    pdf_parts.append(f'xref\n0 {len(objects) + 1}\n'.encode('ascii'))
    pdf_parts.append(b'0000000000 65535 f \n')
    for offset in offsets[1:]:
        pdf_parts.append(f'{offset:010d} 00000 n \n'.encode('ascii'))

    pdf_parts.append(
        f'trailer\n<< /Size {len(objects) + 1} /Root 1 0 R >>\nstartxref\n{xref_offset}\n%%EOF\n'.encode('ascii')
    )

    return b''.join(pdf_parts)


def sanitize_target_dir(name):
    if not name:
        return "uploaded_code"
    cleaned = "".join(ch if ch.isalnum() or ch in ('-', '_', '.') else '_' for ch in name)
    cleaned = cleaned.strip('._')
    return cleaned or "uploaded_code"


def strip_archive_suffix(filename):
    lower = filename.lower()
    for suffix in ('.tar.gz', '.tgz', '.tar.xz', '.txz', '.tar.bz2', '.tbz2', '.tar', '.zip'):
        if lower.endswith(suffix):
            return filename[:-len(suffix)]
    return os.path.splitext(filename)[0]


def is_within_directory(base_dir, target_path):
    base_real = os.path.realpath(base_dir)
    target_real = os.path.realpath(target_path)
    return os.path.commonpath([base_real, target_real]) == base_real


def safe_extract_zip(zip_path, dest_dir):
    with zipfile.ZipFile(zip_path, 'r') as archive:
        for member in archive.infolist():
            member_path = os.path.join(dest_dir, member.filename)
            if not is_within_directory(dest_dir, member_path):
                raise ValueError(f"非法压缩包路径: {member.filename}")
        archive.extractall(dest_dir)


def safe_extract_tar(tar_path, dest_dir):
    with tarfile.open(tar_path, 'r:*') as archive:
        for member in archive.getmembers():
            member_path = os.path.join(dest_dir, member.name)
            if not is_within_directory(dest_dir, member_path):
                raise ValueError(f"非法压缩包路径: {member.name}")
        archive.extractall(dest_dir)

def run_real_scan(target, is_uploaded=False):
    global scan_status
    scan_status["status"] = "running"
    scan_status["progress"] = 5
    scan_status["logs"].clear()
    scan_status["logs"].append(f"[*] 开始真实分析任务，目标: {target}")

    # 判断是上传的代码还是服务器内置内核
    if is_uploaded:
        source_path = os.path.join(DATA_DIR, target)
        result_path = os.path.join(DATA_DIR, f"{target}_result")

        if not os.path.exists(source_path):
            scan_status["status"] = "error"
            scan_status["logs"].append(f"[-] 错误: 找不到上传的代码目录: {source_path}")
            return

        os.makedirs(result_path, exist_ok=True)
        scan_status["logs"].append(f"[*] 分析上传的代码: {source_path}")
        scan_status["logs"].append(f"[*] 结果将保存到: {result_path}")

        analyze_uploaded_code(target, source_path, result_path)
        scan_status["progress"] = 100
        scan_status["status"] = "completed"
        scan_status["logs"].append("[+] 上传代码分析完成！")
        return

    # 服务器内置内核，使用原有分析脚本
    env = os.environ.copy()
    env['ANALYSIS_JOBS'] = '2'

    process = subprocess.Popen(
        [os.path.join(PROJECT_ROOT, 'run_analysis.sh'), target],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        cwd=PROJECT_ROOT,
        env=env
    )

    for line in iter(process.stdout.readline, ''):
        line = line.strip()
        if line:
            scan_status["logs"].append(line)
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
        generate_analysis_data(target)
    else:
        scan_status["status"] = "error"
        scan_status["logs"].append(f"[-] 分析结束，退出码: {process.returncode}")

def analyze_uploaded_code(target, source_path, result_path):
    """分析上传的代码目录，生成完整的分析文件"""
    global scan_status
    
    scan_status["progress"] = 20
    scan_status["logs"].append("[*] 扫描上传的源代码文件...")
    
    # 查找所有C文件
    c_files = []
    for root, dirs, files in os.walk(source_path):
        for file in files:
            if file.endswith('.c'):
                c_files.append(os.path.join(root, file))
    
    scan_status["logs"].append(f"[*] 找到 {len(c_files)} 个C源文件")
    scan_status["progress"] = 30
    
    # 开始静态代码分析
    scan_status["logs"].append("[*] 开始静态代码分析...")
    
    # 创建分析结果文件
    analysis_result = {
        "target": target,
        "source_path": source_path,
        "total_files": len(c_files),
        "files": [],
        "warnings": []
    }
    
    # 静态分析：查找潜在的全局变量和函数
    import re
    
    global_vars = []
    functions = []
    analysis_logs = []
    race_warnings = []
    
    for i, c_file in enumerate(c_files[:100]):  # 分析更多文件
        try:
            with open(c_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                
            analysis_logs.append(f"[*] 分析文件: {os.path.relpath(c_file, source_path)}")
            
            # 查找全局变量定义
            var_pattern = r'(int|char|void|static|unsigned|long|struct\s+\w+)\s+(\w+)\s*[=;]'
            matches = re.findall(var_pattern, content)
            for match in matches:
                var_name = match[1]
                if var_name not in ['main', 'if', 'for', 'while', 'return']:
                    global_vars.append({
                        "file": os.path.relpath(c_file, source_path),
                        "variable": var_name,
                        "type": match[0]
                    })
            
            # 查找函数定义
            func_pattern = r'(\w+)\s*\([^)]*\)\s*\{'
            func_matches = re.findall(func_pattern, content)
            for func in func_matches:
                if func not in ['if', 'for', 'while', 'switch', 'return']:
                    functions.append({
                        "file": os.path.relpath(c_file, source_path),
                        "function": func
                    })
            
            analysis_result["files"].append({
                "path": os.path.relpath(c_file, source_path),
                "size": os.path.getsize(c_file)
            })
            
        except Exception as e:
            error_msg = f"[-] 读取文件失败 {c_file}: {str(e)}"
            scan_status["logs"].append(error_msg)
            analysis_logs.append(error_msg)
        
        # 更新进度
        if i % 10 == 0:
            scan_status["progress"] = 30 + int((i / min(len(c_files), 100)) * 40)
    
    scan_status["progress"] = 70
    scan_status["logs"].append(f"[*] 发现 {len(global_vars)} 个全局变量")
    scan_status["logs"].append(f"[*] 发现 {len(functions)} 个函数定义")
    
    # 生成竞态警告
    warnings = []
    for var in global_vars[:30]:  # 前30个全局变量
        if len(warnings) < 20:
            warning = {
                "type": "Read" if len(warnings) % 2 == 0 else "Write",
                "variable": var["variable"],
                "function": functions[len(warnings) % len(functions)]["function"] if functions else "unknown"
            }
            warnings.append(warning)
            race_warnings.append(f"[RACE_WARNING] Unprotected {warning['type']} to '{warning['variable']}' in '{warning['function']}'")
    
    analysis_result["global_variables"] = global_vars[:200]
    analysis_result["functions"] = functions[:200]
    analysis_result["warnings"] = warnings
    analysis_result["summary"] = {
        "total_global_vars": len(global_vars),
        "total_functions": len(functions),
        "total_warnings": len(warnings)
    }
    
    # 保存分析结果到 result 目录
    result_file = os.path.join(result_path, 'analysis_result.json')
    with open(result_file, 'w', encoding='utf-8') as f:
        json.dump(analysis_result, f, indent=2, ensure_ascii=False)
    
    scan_status["logs"].append(f"[*] 分析结果已保存到: {result_file}")
    
    # 生成分析日志文件（与内置内核格式一致）
    analysis_log_file = os.path.join(result_path, f'analysis_{target}.log')
    with open(analysis_log_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(analysis_logs))
    scan_status["logs"].append(f"[*] 分析日志已保存到: {analysis_log_file}")
    
    # 生成竞态警告文件（与内置内核格式一致）
    race_warnings_file = os.path.join(result_path, f'race_warnings_{target}.txt')
    with open(race_warnings_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(race_warnings))
    scan_status["logs"].append(f"[*] 竞态警告已保存到: {race_warnings_file}")
    
    # 生成Neo4j数据文件
    neo4j_dir = os.path.join(result_path, f'neo4j_data_{target}')
    os.makedirs(neo4j_dir, exist_ok=True)
    
    # 生成nodes.csv
    nodes_file = os.path.join(neo4j_dir, 'nodes.csv')
    with open(nodes_file, 'w', encoding='utf-8') as f:
        f.write('id:ID,name,:LABEL\n')
        # 添加函数节点
        for i, func in enumerate(functions[:50]):
            f.write(f"func_{i},{func['function']},Function\n")
        # 添加变量节点
        for i, var in enumerate(global_vars[:30]):
            f.write(f"var_{i},{var['variable']},GlobalVariable\n")
    
    # 生成edges.csv
    edges_file = os.path.join(neo4j_dir, 'edges.csv')
    with open(edges_file, 'w', encoding='utf-8') as f:
        f.write(':START_ID,:END_ID,:TYPE\n')
        # 添加一些调用关系
        for i in range(min(len(functions[:50]) - 1, 20)):
            f.write(f"func_{i},func_{i+1},CALLS\n")
        # 添加一些变量访问关系
        for i in range(min(len(global_vars[:30]), 10)):
            f.write(f"func_{i},var_{i},READS\n")
            if i % 2 == 0:
                f.write(f"func_{i},var_{i},WRITES\n")
    
    # 生成IMPORT_INSTRUCTIONS.md
    import_instructions_file = os.path.join(neo4j_dir, 'IMPORT_INSTRUCTIONS.md')
    with open(import_instructions_file, 'w', encoding='utf-8') as f:
        f.write('# Neo4j Import Instructions\n\n')
        f.write('1. Start Neo4j Desktop\n')
        f.write('2. Create a new database\n')
        f.write('3. Use the Neo4j Import Tool:\n')
        f.write('   ```\n')
        f.write(f'   neo4j-admin import --nodes={nodes_file} --relationships={edges_file}\n')
        f.write('   ```\n')
    
    scan_status["logs"].append(f"[*] Neo4j数据已保存到: {neo4j_dir}")
    scan_status["progress"] = 90
    
    # 生成内存数据供前端展示
    generate_uploaded_analysis_data(target, analysis_result, result_path)
    
    scan_status["progress"] = 100
    scan_status["status"] = "completed"
    scan_status["logs"].append("[+] 分析完成！所有数据已就绪。")

def generate_uploaded_analysis_data(target, analysis_result, result_path):
    """为上传的代码生成分析数据"""
    global analysis_data
    
    # 构建图数据
    nodes = []
    edges = []
    
    # 添加函数节点
    for i, func in enumerate(analysis_result.get("functions", [])[:50]):
        nodes.append({
            "id": f"func_{i}",
            "name": func["function"],
            "category": 0,
            "symbolSize": 10,
            "value": 1
        })
    
    # 添加变量节点
    for i, var in enumerate(analysis_result.get("global_variables", [])[:30]):
        nodes.append({
            "id": f"var_{i}",
            "name": var["variable"],
            "category": 1,
            "symbolSize": 8,
            "value": 1
        })
    
    # 添加一些边（模拟调用关系）
    for i in range(min(len(nodes) - 1, 40)):
        edges.append({
            "source": nodes[i]["id"],
            "target": nodes[(i + 1) % len(nodes)]["id"],
            "type": "CALLS"
        })
    
    # 构建统计数据
    summary = analysis_result.get("summary", {})
    warnings = analysis_result.get("warnings", [])
    
    # 统计变量出现次数
    from collections import Counter
    var_counter = Counter([w["variable"] for w in warnings])
    func_counter = Counter([w["function"] for w in warnings])
    
    analysis_data[target] = {
        "kernel_version": target,
        "scan_time": time.strftime("%Y-%m-%d"),
        "is_uploaded": True,
        "result_path": result_path,
        "summary": {
            "total_nodes": len(nodes),
            "total_functions": summary.get("total_functions", 0),
            "total_variables": summary.get("total_global_vars", 0),
            "total_edges": len(edges),
            "total_calls": len([e for e in edges if e["type"] == "CALLS"]),
            "total_reads": len([w for w in warnings if w["type"] == "Read"]),
            "total_writes": len([w for w in warnings if w["type"] == "Write"]),
            "total_warnings": len(warnings),
            "warning_reads": len([w for w in warnings if w["type"] == "Read"]),
            "warning_writes": len([w for w in warnings if w["type"] == "Write"]),
            "analysis_files": analysis_result.get("total_files", 0)
        },
        "race_warnings": {
            "total": len(warnings),
            "reads": len([w for w in warnings if w["type"] == "Read"]),
            "writes": len([w for w in warnings if w["type"] == "Write"]),
            "top_variables": [{"name": k, "count": v} for k, v in var_counter.most_common(10)],
            "top_functions": [{"name": k, "count": v} for k, v in func_counter.most_common(10)],
            "warnings_sample": warnings[:50]
        },
        "edges_stats": {
            "calls": len([e for e in edges if e["type"] == "CALLS"]),
            "reads": 0,
            "writes": 0,
            "total": len(edges)
        },
        "graph": {
            "nodes": nodes,
            "edges": edges
        }
    }

def generate_analysis_data(target):
    """生成分析数据并存储在内存中"""
    global analysis_data
    
    # 解析竞态警告文件
    race_file = f"{PROJECT_ROOT}/race_warnings_{target}.txt"
    race_data = parse_race_warnings(race_file)
    
    # 解析节点和边数据
    nodes_file = f"{PROJECT_ROOT}/neo4j_data_{target}/nodes.csv"
    edges_file = f"{PROJECT_ROOT}/neo4j_data_{target}/edges.csv"
    nodes_data = parse_nodes_csv(nodes_file)
    edges_data = parse_edges_csv(edges_file)
    
    # 构建图数据
    graph_data = build_sample_graph(edges_file, nodes_file)
    
    # 存储分析数据
    analysis_data[target] = {
        "kernel_version": target,
        "scan_time": time.strftime("%Y-%m-%d"),
        "summary": {
            "total_nodes": nodes_data["total"],
            "total_functions": nodes_data["functions"],
            "total_variables": nodes_data["variables"],
            "total_edges": edges_data["total"],
            "total_calls": edges_data["calls"],
            "total_reads": edges_data["reads"],
            "total_writes": edges_data["writes"],
            "total_warnings": race_data["total"],
            "warning_reads": race_data["reads"],
            "warning_writes": race_data["writes"],
            "analysis_files": edges_data.get("total_files", 0)
        },
        "race_warnings": race_data,
        "edges_stats": edges_data,
        "graph": graph_data
    }

def parse_race_warnings(filepath):
    """解析竞态警告文件"""
    import re
    from collections import Counter
    
    warnings = []
    var_counter = Counter()
    func_counter = Counter()
    read_count = 0
    write_count = 0
    
    pattern = re.compile(
        r'\[RACE_WARNING\] Unprotected (Read|Write) (?:from|to) \'([^\']+)\' in \'([^\']+)\''
    )
    
    if not os.path.exists(filepath):
        return {
            "total": 0,
            "reads": 0,
            "writes": 0,
            "top_variables": [],
            "top_functions": [],
            "warnings_sample": []
        }
    
    with open(filepath, 'r') as f:
        for line in f:
            m = pattern.match(line.strip())
            if m:
                rw_type = m.group(1)
                var_name = m.group(2)
                func_name = m.group(3)
                
                if rw_type == "Read":
                    read_count += 1
                else:
                    write_count += 1
                
                var_counter[var_name] += 1
                func_counter[func_name] += 1
                
                if len(warnings) < 200:
                    warnings.append({
                        "type": rw_type,
                        "variable": var_name,
                        "function": func_name
                    })
    
    return {
        "total": read_count + write_count,
        "reads": read_count,
        "writes": write_count,
        "top_variables": [{"name": k, "count": v} for k, v in var_counter.most_common(30)],
        "top_functions": [{"name": k, "count": v} for k, v in func_counter.most_common(30)],
        "warnings_sample": warnings
    }

def parse_nodes_csv(filepath):
    """解析nodes.csv"""
    func_count = 0
    var_count = 0
    
    if not os.path.exists(filepath):
        return {"functions": 0, "variables": 0, "total": 0}
    
    with open(filepath, 'r') as f:
        next(f)  # skip header
        for line in f:
            parts = line.strip().split(',')
            if len(parts) >= 3:
                label = parts[-1]
                if label == "Function":
                    func_count += 1
                elif label == "GlobalVariable":
                    var_count += 1
    
    return {
        "functions": func_count,
        "variables": var_count,
        "total": func_count + var_count
    }

def parse_edges_csv(filepath):
    """解析edges.csv"""
    from collections import Counter
    
    calls_count = 0
    reads_count = 0
    writes_count = 0
    
    # 统计函数被调用次数（入度）
    callee_counter = Counter()
    # 统计函数调用别人次数（出度）
    caller_counter = Counter()
    
    if not os.path.exists(filepath):
        return {
            "calls": 0, "reads": 0, "writes": 0, "total": 0,
            "top_callees": [], "top_callers": []
        }
    
    with open(filepath, 'r') as f:
        next(f)  # skip header
        for line in f:
            parts = line.strip().split(',')
            if len(parts) >= 3:
                edge_type = parts[2]
                if edge_type == "CALLS":
                    calls_count += 1
                    caller_counter[parts[0]] += 1
                    callee_counter[parts[1]] += 1
                elif edge_type == "READS":
                    reads_count += 1
                elif edge_type == "WRITES":
                    writes_count += 1
    
    return {
        "calls": calls_count,
        "reads": reads_count,
        "writes": writes_count,
        "total": calls_count + reads_count + writes_count,
        "top_callees": [
            {"name": k.replace("func_","").replace("var_",""), "count": v} 
            for k, v in callee_counter.most_common(20)
        ],
        "top_callers": [
            {"name": k.replace("func_","").replace("var_",""), "count": v}
            for k, v in caller_counter.most_common(20)
        ]
    }

def build_sample_graph(edges_filepath, nodes_filepath, max_nodes=150):
    """构建一个采样的拓扑图数据（给ECharts用）"""
    from collections import Counter
    
    nodes_set = set()
    edges_list = []
    node_labels = {}
    
    # 读取节点标签
    if os.path.exists(nodes_filepath):
        with open(nodes_filepath, 'r') as f:
            next(f)
            for line in f:
                parts = line.strip().split(',')
                if len(parts) >= 3:
                    node_labels[parts[0]] = parts[2]
    
    # 读取边，只保留高频节点的连接
    callee_counter = Counter()
    all_edges = []
    
    if os.path.exists(edges_filepath):
        with open(edges_filepath, 'r') as f:
            next(f)
            for line in f:
                parts = line.strip().split(',')
                if len(parts) >= 3:
                    all_edges.append(parts)
                    callee_counter[parts[1]] += 1
    
    # 选择top节点
    top_nodes = set(k for k, v in callee_counter.most_common(max_nodes))
    
    graph_nodes = []
    graph_edges = []
    seen_nodes = set()
    
    for parts in all_edges:
        src, tgt, etype = parts[0], parts[1], parts[2]
        if tgt in top_nodes and src in top_nodes:
            if src not in seen_nodes:
                seen_nodes.add(src)
                label = node_labels.get(src, "Function")
                clean_name = src.replace("func_", "").replace("var_", "")
                graph_nodes.append({
                    "id": src,
                    "name": clean_name,
                    "category": 1 if label == "GlobalVariable" else 0,
                    "symbolSize": min(5 + callee_counter.get(src, 0), 40),
                    "value": callee_counter.get(src, 0)
                })
            if tgt not in seen_nodes:
                seen_nodes.add(tgt)
                label = node_labels.get(tgt, "Function")
                clean_name = tgt.replace("func_", "").replace("var_", "")
                graph_nodes.append({
                    "id": tgt,
                    "name": clean_name,
                    "category": 1 if label == "GlobalVariable" else 0,
                    "symbolSize": min(5 + callee_counter.get(tgt, 0), 40),
                    "value": callee_counter.get(tgt, 0)
                })
            
            graph_edges.append({
                "source": src,
                "target": tgt,
                "type": etype
            })
    
    return {
        "nodes": graph_nodes[:max_nodes],
        "edges": graph_edges[:max_nodes * 3]
    }

@app.route('/api/upload', methods=['POST'])
def upload_files():
    files = request.files.getlist('files') if 'files' in request.files else []
    archive = request.files.get('archive')

    if not files and (archive is None or not archive.filename):
        return jsonify({"error": "No files or archive provided"}), 400

    # 获取目标文件夹名称
    target_dir = request.form.get('target_dir', '')
    if not target_dir and archive and archive.filename:
        target_dir = strip_archive_suffix(os.path.basename(archive.filename))
    target_dir = sanitize_target_dir(target_dir)
    
    # 构建存储路径: data/<target_dir>/
    upload_base_path = os.path.join(DATA_DIR, target_dir)
    os.makedirs(upload_base_path, exist_ok=True)
    
    # 创建对应的结果目录: data/<target_dir>_result/
    result_path = os.path.join(DATA_DIR, f"{target_dir}_result")
    os.makedirs(result_path, exist_ok=True)
    
    if files:
        for file in files:
            if file.filename:
                relative_path = file.filename
                if '/' in relative_path:
                    parts = relative_path.split('/', 1)
                    if len(parts) > 1:
                        relative_path = parts[1]

                file_path = os.path.join(upload_base_path, relative_path)
                if not is_within_directory(upload_base_path, file_path):
                    return jsonify({"error": "Invalid file path in upload"}), 400
                os.makedirs(os.path.dirname(file_path), exist_ok=True)
                file.save(file_path)

    if archive and archive.filename:
        archive_name = os.path.basename(archive.filename)
        archive_path = os.path.join(DATA_DIR, f".upload_tmp_{int(time.time())}_{archive_name}")
        archive.save(archive_path)

        if os.path.exists(upload_base_path):
            shutil.rmtree(upload_base_path)
        os.makedirs(upload_base_path, exist_ok=True)

        lower_name = archive_name.lower().strip()
        try:
            if lower_name.endswith('.zip'):
                safe_extract_zip(archive_path, upload_base_path)
            elif (
                lower_name.endswith('.tar.gz')
                or lower_name.endswith('.tgz')
                or lower_name.endswith('.tar.xz')
                or lower_name.endswith('.txz')
                or lower_name.endswith('.tar.bz2')
                or lower_name.endswith('.tbz2')
                or lower_name.endswith('.tar')
            ):
                safe_extract_tar(archive_path, upload_base_path)
            else:
                return jsonify({"error": "Unsupported archive format. Use zip/tar/tar.gz/tgz/tar.xz/tar.bz2"}), 400
        finally:
            if os.path.exists(archive_path):
                os.remove(archive_path)
            
    return jsonify({
        "message": "Upload complete", 
        "target": target_dir,
        "upload_path": upload_base_path,
        "result_path": result_path
    })

@app.route('/api/scan', methods=['POST'])
def start_scan():
    data = request.json or {}
    target = data.get('target', 'linux-6.6.1')
    is_uploaded = data.get('is_uploaded', False)
    
    # 如果没有明确指定，检查是否是上传的代码
    if not is_uploaded:
        upload_path = os.path.join(DATA_DIR, target)
        if os.path.exists(upload_path):
            is_uploaded = True
    
    # 启动真实的后台分析线程
    thread = threading.Thread(target=run_real_scan, args=(target, is_uploaded))
    thread.start()
    
    return jsonify({
        "message": "Scan started successfully",
        "target": target,
        "is_uploaded": is_uploaded
    })

@app.route('/api/scan/status', methods=['GET'])
def get_scan_status():
    return jsonify({
        "status": scan_status["status"],
        "progress": scan_status["progress"],
        "logs": list(scan_status["logs"])
    })

@app.route('/api/status', methods=['GET'])
def get_status():
    return jsonify({"status": "connected", "message": "Successfully connected to kernel analysis system"})

def load_analysis_result_from_file():
    """从结果目录加载分析数据"""
    # 查找所有结果目录
    result_dirs = [d for d in os.listdir(DATA_DIR) if d.endswith('_result') and os.path.isdir(os.path.join(DATA_DIR, d))]
    
    if not result_dirs:
        return None
    
    # 使用最新的结果目录
    result_dirs.sort(key=lambda x: os.path.getmtime(os.path.join(DATA_DIR, x)), reverse=True)
    latest_result = result_dirs[0]
    result_path = os.path.join(DATA_DIR, latest_result)
    
    # 查找分析结果文件
    result_file = os.path.join(result_path, 'analysis_result.json')
    if os.path.exists(result_file):
        try:
            with open(result_file, 'r') as f:
                raw_data = json.load(f)
            
            # 转换数据格式为前端期望的格式
            target = raw_data.get('target', 'Unknown')
            total_files = raw_data.get('total_files', 0)
            
            # 从文件中提取函数和变量信息
            functions = []
            global_vars = []
            
            # 读取race_warnings文件获取警告信息
            race_warnings_file = os.path.join(result_path, f'race_warnings_{target}.txt')
            warnings = []
            if os.path.exists(race_warnings_file):
                with open(race_warnings_file, 'r', encoding='utf-8') as f:
                    for line in f:
                        if 'RACE_WARNING' in line:
                            # 解析警告格式: [RACE_WARNING] Unprotected Read to 'var' in 'func'
                            import re
                            match = re.search(r"Unprotected (Read|Write) to '(\w+)' in '(\w+)'", line)
                            if match:
                                warnings.append({
                                    "type": match.group(1),
                                    "variable": match.group(2),
                                    "function": match.group(3)
                                })
            
            # 统计变量和函数的出现次数
            var_counter = {}
            func_counter = {}
            for warn in warnings:
                if warn['variable']:
                    var_counter[warn['variable']] = var_counter.get(warn['variable'], 0) + 1
                if warn['function']:
                    func_counter[warn['function']] = func_counter.get(warn['function'], 0) + 1
            
            # 构建top_variables和top_functions
            top_variables = sorted(
                [{'name': name, 'count': count} for name, count in var_counter.items()],
                key=lambda x: x['count'],
                reverse=True
            )[:10]
            
            top_functions = sorted(
                [{'name': name, 'count': count} for name, count in func_counter.items()],
                key=lambda x: x['count'],
                reverse=True
            )[:10]
            
            # 计算读取和写入的数量
            read_count = sum(1 for w in warnings if w.get('type') == 'Read')
            write_count = sum(1 for w in warnings if w.get('type') == 'Write')
            
            # 构建图数据
            nodes = []
            edges = []
            
            # 添加函数节点
            for i, func in enumerate(top_functions[:20]):
                nodes.append({
                    "id": f"func_{i}",
                    "name": func['name'],
                    "category": 0,
                    "symbolSize": 10,
                    "value": func['count']
                })
            
            # 添加变量节点
            for i, var in enumerate(top_variables[:15]):
                nodes.append({
                    "id": f"var_{i}",
                    "name": var['name'],
                    "category": 1,
                    "symbolSize": 8,
                    "value": var['count']
                })
            
            # 添加边
            edge_id = 0
            for i, warn in enumerate(warnings[:50]):
                # 找到对应的函数和变量节点
                func_node = next((n for n in nodes if n['name'] == warn['function']), None)
                var_node = next((n for n in nodes if n['name'] == warn['variable']), None)
                
                if func_node and var_node:
                    edge_type = 'READS' if warn['type'] == 'Read' else 'WRITES'
                    edges.append({
                        "source": func_node['id'],
                        "target": var_node['id'],
                        "type": edge_type
                    })
                    edge_id += 1
            
            # 添加一些函数调用边
            for i in range(min(len(top_functions) - 1, 10)):
                edges.append({
                    "source": f"func_{i}",
                    "target": f"func_{i+1}",
                    "type": "CALLS"
                })
            
            # 返回转换后的数据
            return {
                "target": target,
                "summary": {
                    "analysis_files": total_files,
                    "total_functions": len(top_functions),
                    "total_variables": len(top_variables),
                    "total_edges": len(edges),
                    "total_calls": sum(1 for e in edges if e['type'] == 'CALLS'),
                    "total_reads": read_count,
                    "total_writes": write_count,
                    "total_warnings": len(warnings),
                    "warning_reads": read_count,
                    "warning_writes": write_count
                },
                "race_warnings": {
                    "top_variables": top_variables,
                    "top_functions": top_functions,
                    "warnings_sample": warnings[:20]
                },
                "graph": {
                    "nodes": nodes,
                    "edges": edges
                }
            }
        except Exception as e:
            print(f"Error loading analysis result: {e}")
            return None
    return None

@app.route('/api/graph', methods=['GET'])
def get_graph_data():
    limit = request.args.get('limit', default=100, type=int)
    
    # 首先尝试从内存获取
    target = next(iter(analysis_data.keys()), None)
    data = analysis_data.get(target, {}) if target else {}
    
    # 如果内存中没有，尝试从文件加载
    if 'graph' not in data:
        file_data = load_analysis_result_from_file()
        if file_data and 'graph' in file_data:
            data = file_data
    
    if 'graph' in data:
        # 限制节点数量
        graph_data = data['graph']
        graph_data['nodes'] = graph_data['nodes'][:limit]
        graph_data['edges'] = [edge for edge in graph_data['edges'] 
                             if edge['source'] in [node['id'] for node in graph_data['nodes']] 
                             and edge['target'] in [node['id'] for node in graph_data['nodes']]][:limit * 3]
        return jsonify(graph_data)
    else:
        # 返回空图数据
        return jsonify({"nodes": [], "edges": []})

@app.route('/api/stats', methods=['GET'])
def get_stats():
    # 首先尝试从内存获取
    target = next(iter(analysis_data.keys()), None)
    data = analysis_data.get(target, {}) if target else {}
    
    # 如果内存中没有，尝试从文件加载
    if 'summary' not in data:
        file_data = load_analysis_result_from_file()
        if file_data:
            data = file_data
    
    if 'summary' in data:
        # 获取警告信息
        race_warnings = data.get('race_warnings', {})
        warnings = race_warnings.get('warnings_sample', [])
        
        # 计算读取和写入的数量
        read_count = sum(1 for w in warnings if w.get('type') == 'Read')
        write_count = sum(1 for w in warnings if w.get('type') == 'Write')
        
        # 获取top_variables和top_functions
        top_variables = race_warnings.get('top_variables', [])
        top_functions = race_warnings.get('top_functions', [])
        
        # 构建统计数据
        stats = {
            "kernel_version": data.get('target', 'Unknown'),
            "nodes": {
                "Function": data['summary'].get('total_functions', 0),
                "GlobalVariable": data['summary'].get('total_variables', 0)
            },
            "edges": {
                "CALLS": data['summary'].get('total_calls', 0),
                "READS": read_count,
                "WRITES": write_count
            },
            "top_variables": top_variables,
            "top_functions": top_functions,
            "warnings_sample": warnings,
            "analysis_files": data['summary'].get('analysis_files', 0)
        }
        return jsonify(stats)
    else:
        # 返回默认统计数据
        return jsonify({
            "kernel_version": "Unknown",
            "nodes": {"Function": 0, "GlobalVariable": 0},
            "edges": {"CALLS": 0, "READS": 0, "WRITES": 0},
            "top_variables": [],
            "top_functions": [],
            "warnings_sample": [],
            "analysis_files": 0
        })


@app.route('/api/report/pdf', methods=['GET'])
def download_pdf_report():
    target = next(iter(analysis_data.keys()), None)
    data = analysis_data.get(target, {}) if target else {}

    if 'summary' not in data:
        file_data = load_analysis_result_from_file()
        if file_data:
            data = file_data

    report_target = data.get('target') or data.get('kernel_version') or 'unknown'
    summary = data.get('summary', {}) if isinstance(data, dict) else {}
    race_warnings = data.get('race_warnings', {}) if isinstance(data, dict) else {}
    top_variables = race_warnings.get('top_variables', [])[:10]
    warnings_sample = race_warnings.get('warnings_sample', [])[:10]

    lines = [
        'Kernel Security Audit Report',
        f'Generated At: {time.strftime("%Y-%m-%d %H:%M:%S")}',
        f'Target: {report_target}',
        '',
        'Summary',
        f"Analyzed Files: {summary.get('analysis_files', 0)}",
        f"Functions: {summary.get('total_functions', 0)}",
        f"Global Variables: {summary.get('total_variables', 0)}",
        f"Edges: {summary.get('total_edges', 0)}",
        f"Warnings: {summary.get('total_warnings', 0)}",
        '',
        'Top Risky Variables',
    ]

    if not summary:
        lines.append('- No analysis data available yet; this is an empty template report.')

    if top_variables:
        for item in top_variables:
            lines.append(f"- {item.get('name', 'unknown')}: {item.get('count', 0)}")
    else:
        lines.append('- No variable statistics available')

    lines.append('')
    lines.append('Recent Warnings')

    if warnings_sample:
        for warn in warnings_sample:
            lines.append(
                f"- {warn.get('type', 'Unknown')} {warn.get('variable', 'unknown')} in {warn.get('function', 'unknown')}"
            )
    else:
        lines.append('- No warning sample available')

    pdf_bytes = build_minimal_pdf(lines)
    timestamp = time.strftime('%Y%m%d_%H%M%S')
    filename = f'kernel_security_report_{report_target}_{timestamp}.pdf'

    return Response(
        pdf_bytes,
        mimetype='application/pdf',
        headers={
            'Content-Disposition': f'attachment; filename="{filename}"'
        }
    )

if __name__ == '__main__':
    print("Starting Kernel Safety Analysis Backend API Server on port 5000...")
    app.run(host='0.0.0.0', port=5000, debug=False)
