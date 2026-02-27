#!/usr/bin/env python3
"""
预处理内核分析数据，生成Web仪表盘所需的JSON文件。
用法: python3 generate_data.py [内核版本目录名]
示例: python3 generate_data.py linux-6.12.6
"""

import json
import os
import sys
import re
from collections import Counter, defaultdict

def get_project_root():
    return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def parse_race_warnings(filepath):
    """解析竞态警告文件"""
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

def parse_analysis_jsons(dirpath):
    """解析分析JSON目录，提取子系统统计"""
    subsystem_funcs = Counter()
    total_funcs = 0
    funcs_with_locks = 0
    
    if not os.path.exists(dirpath):
        return {
            "total_files": 0,
            "total_functions": 0,
            "subsystem_distribution": []
        }
    
    files = [f for f in os.listdir(dirpath) if f.endswith('.json')]
    
    for fname in files:
        fpath = os.path.join(dirpath, fname)
        try:
            with open(fpath, 'r') as f:
                data = json.load(f)
            for item in data:
                name = item.get("name", "")
                if name:
                    total_funcs += 1
        except:
            pass
    
    return {
        "total_files": len(files),
        "total_functions": total_funcs
    }

def build_sample_graph(edges_filepath, nodes_filepath, max_nodes=150):
    """构建一个采样的拓扑图数据（给ECharts用）"""
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

def main():
    kernel_version = sys.argv[1] if len(sys.argv) > 1 else "linux-6.12.6"
    project_root = get_project_root()
    
    print(f"[*] 正在处理 {kernel_version} 的分析数据...")
    
    # 文件路径
    race_file = os.path.join(project_root, f"race_warnings_{kernel_version}.txt")
    nodes_file = os.path.join(project_root, f"neo4j_data_{kernel_version}", "nodes.csv")
    edges_file = os.path.join(project_root, f"neo4j_data_{kernel_version}", "edges.csv")
    analysis_dir = os.path.join(project_root, "analysis_data", kernel_version)
    
    print(f"  [1/5] 解析竞态警告...")
    race_data = parse_race_warnings(race_file)
    print(f"    -> {race_data['total']} 条警告 (读:{race_data['reads']}, 写:{race_data['writes']})")
    
    print(f"  [2/5] 解析节点数据...")
    nodes_data = parse_nodes_csv(nodes_file)
    print(f"    -> {nodes_data['functions']} 函数, {nodes_data['variables']} 全局变量")
    
    print(f"  [3/5] 解析边数据...")
    edges_data = parse_edges_csv(edges_file)
    print(f"    -> {edges_data['calls']} 调用, {edges_data['reads']} 读, {edges_data['writes']} 写")
    
    print(f"  [4/5] 解析分析文件...")
    analysis_data = parse_analysis_jsons(analysis_dir)
    print(f"    -> {analysis_data['total_files']} 个分析文件")
    
    print(f"  [5/5] 构建拓扑图采样数据...")
    graph_data = build_sample_graph(edges_file, nodes_file, max_nodes=120)
    print(f"    -> {len(graph_data['nodes'])} 节点, {len(graph_data['edges'])} 边")
    
    # 汇总
    dashboard_data = {
        "kernel_version": kernel_version,
        "scan_time": "2025-02-27",
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
            "analysis_files": analysis_data["total_files"]
        },
        "race_warnings": race_data,
        "edges_stats": edges_data,
        "graph": graph_data
    }
    
    # 输出
    output_dir = os.path.join(project_root, "web_dashboard")
    os.makedirs(output_dir, exist_ok=True)
    output_file = os.path.join(output_dir, f"data_{kernel_version}.json")
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(dashboard_data, f, ensure_ascii=False, indent=2)
    
    print(f"\n[✓] 数据已生成: {output_file}")
    print(f"    文件大小: {os.path.getsize(output_file) / 1024:.1f} KB")

if __name__ == "__main__":
    main()
