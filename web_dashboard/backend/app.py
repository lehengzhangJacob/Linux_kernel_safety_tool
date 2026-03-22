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
import sqlite3
import uuid
import re
import glob
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

# 统一日志目录（项目根目录下的 logs）
LOGS_DIR = os.path.join(PROJECT_ROOT, 'logs')
os.makedirs(LOGS_DIR, exist_ok=True)

# 用户上传源码专用目录
UPLOADS_ROOT_DIR = os.path.join(DATA_DIR, 'uploads')
os.makedirs(UPLOADS_ROOT_DIR, exist_ok=True)

# 上传任务分析产物专用目录（按 target/run_id 隔离）
ANALYSIS_RESULTS_ROOT_DIR = os.path.join(DATA_DIR, 'analysis_results')
os.makedirs(ANALYSIS_RESULTS_ROOT_DIR, exist_ok=True)

# 分析数据目录（项目根目录下的 analysis_data）
UPLOAD_DIR = os.path.join(PROJECT_ROOT, 'analysis_data')
os.makedirs(UPLOAD_DIR, exist_ok=True)

# SQLite 持久化目录（使用 backend 目录下的 data）
BACKEND_DATA_DIR = os.path.join(BASE_DIR, 'data')
os.makedirs(BACKEND_DATA_DIR, exist_ok=True)
SQLITE_DB_PATH = os.path.join(BACKEND_DATA_DIR, 'analysis.db')


def get_db_connection():
    conn = sqlite3.connect(SQLITE_DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def get_upload_target_root(target):
    return os.path.join(UPLOADS_ROOT_DIR, sanitize_target_dir(target))


def get_upload_source_dir(target):
    return os.path.join(get_upload_target_root(target), 'source')


def get_upload_archive_dir(target):
    return os.path.join(get_upload_target_root(target), 'archive')


def get_upload_meta_path(target):
    return os.path.join(get_upload_target_root(target), 'upload_meta.json')


def get_run_result_dir(target, run_id):
    safe_target = sanitize_target_dir(target)
    return os.path.join(ANALYSIS_RESULTS_ROOT_DIR, safe_target, f'run_{run_id}')


def init_sqlite_db():
    conn = get_db_connection()
    try:
        conn.execute('PRAGMA journal_mode=WAL;')
        conn.execute('PRAGMA synchronous=NORMAL;')

        conn.execute(
            '''
            CREATE TABLE IF NOT EXISTS analysis_runs (
                run_id TEXT PRIMARY KEY,
                target_name TEXT NOT NULL,
                target_type TEXT NOT NULL,
                status TEXT NOT NULL,
                started_at INTEGER NOT NULL,
                finished_at INTEGER,
                error_message TEXT,
                is_uploaded INTEGER NOT NULL DEFAULT 0
            )
            '''
        )

        conn.execute(
            '''
            CREATE TABLE IF NOT EXISTS warnings (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                run_id TEXT NOT NULL,
                target_name TEXT NOT NULL,
                warn_type TEXT NOT NULL,
                severity TEXT NOT NULL,
                variable_name TEXT,
                function_name TEXT,
                raw_text TEXT,
                created_at INTEGER NOT NULL,
                FOREIGN KEY (run_id) REFERENCES analysis_runs(run_id)
            )
            '''
        )

        conn.execute(
            '''
            CREATE TABLE IF NOT EXISTS summary_stats (
                run_id TEXT PRIMARY KEY,
                kernel_version TEXT,
                analysis_files INTEGER,
                total_functions INTEGER,
                total_variables INTEGER,
                total_edges INTEGER,
                total_calls INTEGER,
                total_reads INTEGER,
                total_writes INTEGER,
                total_warnings INTEGER,
                warning_reads INTEGER,
                warning_writes INTEGER,
                top_variables_json TEXT,
                top_functions_json TEXT,
                FOREIGN KEY (run_id) REFERENCES analysis_runs(run_id)
            )
            '''
        )

        conn.execute('CREATE INDEX IF NOT EXISTS idx_warnings_run_id ON warnings(run_id)')
        conn.execute('CREATE INDEX IF NOT EXISTS idx_warnings_severity ON warnings(severity)')
        conn.execute('CREATE INDEX IF NOT EXISTS idx_warnings_var_func ON warnings(variable_name, function_name)')
        conn.commit()
    finally:
        conn.close()


def normalize_warning_type(value):
    return 'Write' if str(value).lower() == 'write' else 'Read'


def warning_severity_from_type(warn_type):
    return 'HIGH' if warn_type == 'Write' else 'MEDIUM'


def create_run_record(run_id, target_name, is_uploaded):
    conn = get_db_connection()
    try:
        conn.execute(
            '''
            INSERT INTO analysis_runs(run_id, target_name, target_type, status, started_at, is_uploaded)
            VALUES (?, ?, ?, 'running', ?, ?)
            ''',
            (run_id, target_name, 'uploaded' if is_uploaded else 'builtin', int(time.time()), 1 if is_uploaded else 0)
        )
        conn.commit()
    finally:
        conn.close()


def update_run_status(run_id, status, error_message=None):
    conn = get_db_connection()
    try:
        conn.execute(
            '''
            UPDATE analysis_runs
            SET status = ?, finished_at = ?, error_message = ?
            WHERE run_id = ?
            ''',
            (status, int(time.time()), error_message, run_id)
        )
        conn.commit()
    finally:
        conn.close()


def persist_warnings(run_id, target_name, warnings, raw_lines=None):
    conn = get_db_connection()
    try:
        conn.execute('DELETE FROM warnings WHERE run_id = ?', (run_id,))
        now_ts = int(time.time())
        rows = []

        for idx, warn in enumerate(warnings):
            warn_type = normalize_warning_type(warn.get('type'))
            rows.append(
                (
                    run_id,
                    target_name,
                    warn_type,
                    warning_severity_from_type(warn_type),
                    warn.get('variable') or '',
                    warn.get('function') or '',
                    (raw_lines[idx] if raw_lines and idx < len(raw_lines) else ''),
                    now_ts,
                )
            )

        if rows:
            conn.executemany(
                '''
                INSERT INTO warnings(run_id, target_name, warn_type, severity, variable_name, function_name, raw_text, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                ''',
                rows
            )
        conn.commit()
    finally:
        conn.close()


def persist_summary(run_id, data):
    summary = data.get('summary', {})
    race_warnings = data.get('race_warnings', {})
    analysis_files = int(summary.get('analysis_files', 0))
    print(f"[DEBUG] Persisting summary for run_id {run_id}: analysis_files={analysis_files}")
    conn = get_db_connection()
    try:
        conn.execute(
            '''
            INSERT OR REPLACE INTO summary_stats(
                run_id, kernel_version, analysis_files, total_functions, total_variables,
                total_edges, total_calls, total_reads, total_writes, total_warnings,
                warning_reads, warning_writes, top_variables_json, top_functions_json
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ''',
            (
                run_id,
                data.get('kernel_version') or data.get('target') or 'unknown',
                int(summary.get('analysis_files', 0)),
                int(summary.get('total_functions', 0)),
                int(summary.get('total_variables', 0)),
                int(summary.get('total_edges', 0)),
                int(summary.get('total_calls', 0)),
                int(summary.get('total_reads', 0)),
                int(summary.get('total_writes', 0)),
                int(summary.get('total_warnings', 0)),
                int(summary.get('warning_reads', 0)),
                int(summary.get('warning_writes', 0)),
                json.dumps(race_warnings.get('top_variables', []), ensure_ascii=False),
                json.dumps(race_warnings.get('top_functions', []), ensure_ascii=False),
            )
        )
        conn.commit()
    finally:
        conn.close()


def latest_run_id(target_name=None):
    conn = get_db_connection()
    try:
        if target_name:
            row = conn.execute(
                '''
                SELECT run_id FROM analysis_runs
                WHERE target_name = ?
                ORDER BY started_at DESC
                LIMIT 1
                ''',
                (target_name,)
            ).fetchone()
        else:
            row = conn.execute(
                'SELECT run_id FROM analysis_runs ORDER BY started_at DESC LIMIT 1'
            ).fetchone()
        return row['run_id'] if row else None
    finally:
        conn.close()


def get_latest_run(target_name=None, is_uploaded=None, statuses=None):
    conn = get_db_connection()
    try:
        clauses = []
        params = []

        if target_name:
            clauses.append('target_name = ?')
            params.append(target_name)

        if is_uploaded is not None:
            clauses.append('is_uploaded = ?')
            params.append(1 if is_uploaded else 0)

        if statuses:
            placeholders = ','.join(['?'] * len(statuses))
            clauses.append(f'status IN ({placeholders})')
            params.extend(statuses)

        where_sql = f"WHERE {' AND '.join(clauses)}" if clauses else ''
        row = conn.execute(
            f'''
            SELECT run_id, target_name, status, started_at, finished_at, error_message, is_uploaded
            FROM analysis_runs
            {where_sql}
            ORDER BY started_at DESC
            LIMIT 1
            ''',
            params,
        ).fetchone()
        return row
    finally:
        conn.close()


def has_reusable_uploaded_result(target, run_id):
    if not target or not run_id:
        return False

    result_dir = get_run_result_dir(target, run_id)
    race_file, nodes_file, edges_file = resolve_prebuilt_paths(
        target,
        result_base=result_dir,
        prefer_result=True,
        prefer_display=False,
    )
    return bool(race_file and nodes_file and edges_file)


def format_timestamp(ts):
    if not ts:
        return None
    return time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(int(ts)))


def get_dir_size_bytes(path):
    if not path or not os.path.exists(path):
        return 0
    if os.path.isfile(path):
        return os.path.getsize(path)

    total_size = 0
    for root, _, files in os.walk(path):
        for name in files:
            file_path = os.path.join(root, name)
            try:
                total_size += os.path.getsize(file_path)
            except OSError:
                continue
    return total_size


def bool_from_query(value, default=False):
    if value is None:
        return default
    return str(value).strip().lower() in ('1', 'true', 'yes', 'on')


def remove_uploaded_target_payload(target_name):
    safe_target = sanitize_target_dir(target_name)
    removed_paths = []

    upload_target_root = get_upload_target_root(safe_target)
    if os.path.exists(upload_target_root):
        shutil.rmtree(upload_target_root)
        removed_paths.append(upload_target_root)

    analysis_target_root = os.path.join(ANALYSIS_RESULTS_ROOT_DIR, safe_target)
    if os.path.exists(analysis_target_root):
        shutil.rmtree(analysis_target_root)
        removed_paths.append(analysis_target_root)

    return removed_paths


def delete_run_records(run_ids):
    if not run_ids:
        return

    conn = get_db_connection()
    try:
        placeholders = ','.join(['?'] * len(run_ids))
        conn.execute(f'DELETE FROM warnings WHERE run_id IN ({placeholders})', run_ids)
        conn.execute(f'DELETE FROM summary_stats WHERE run_id IN ({placeholders})', run_ids)
        conn.execute(f'DELETE FROM analysis_runs WHERE run_id IN ({placeholders})', run_ids)
        conn.commit()
    finally:
        conn.close()


def purge_uploaded_reports(target_name):
    safe_target = sanitize_target_dir(target_name)
    conn = get_db_connection()
    try:
        rows = conn.execute(
            '''
            SELECT run_id, status
            FROM analysis_runs
            WHERE target_name = ? AND is_uploaded = 1
            ''',
            (safe_target,),
        ).fetchall()
    finally:
        conn.close()

    running = [r['run_id'] for r in rows if (r['status'] or '').lower() == 'running']
    if running:
        return {
            'ok': False,
            'reason': 'running',
            'running_run_ids': running,
            'deleted_run_ids': [],
        }

    run_ids = [r['run_id'] for r in rows]
    removed_result_dirs = []
    for rid in run_ids:
        result_dir = get_run_result_dir(safe_target, rid)
        if os.path.isdir(result_dir):
            shutil.rmtree(result_dir)
            removed_result_dirs.append(result_dir)

    delete_run_records(run_ids)
    return {
        'ok': True,
        'reason': '',
        'running_run_ids': [],
        'deleted_run_ids': run_ids,
        'removed_result_dirs': removed_result_dirs,
    }


def pick_first_existing(paths):
    for path in paths:
        if path and os.path.exists(path):
            return path
    return None


def resolve_prebuilt_paths(target, result_base=None, prefer_display=False, prefer_result=False):
    result_base = result_base or os.path.join(DATA_DIR, f'{target}_result')

    # logs 目录（新位置，优先）
    race_logs_default = os.path.join(LOGS_DIR, f'race_warnings_{target}.txt')
    race_logs_display = os.path.join(LOGS_DIR, f'race_warnings_{target}_display.txt')
    nodes_logs_default = os.path.join(LOGS_DIR, f'neo4j_data_{target}', 'nodes.csv')
    edges_logs_default = os.path.join(LOGS_DIR, f'neo4j_data_{target}', 'edges.csv')
    nodes_logs_display = os.path.join(LOGS_DIR, f'neo4j_data_{target}_display', 'nodes.csv')
    edges_logs_display = os.path.join(LOGS_DIR, f'neo4j_data_{target}_display', 'edges.csv')
    
    # 根目录（旧位置，兼容）
    race_root_default = os.path.join(PROJECT_ROOT, f'race_warnings_{target}.txt')
    race_root_display = os.path.join(PROJECT_ROOT, f'race_warnings_{target}_display.txt')
    nodes_root_default = os.path.join(PROJECT_ROOT, f'neo4j_data_{target}', 'nodes.csv')
    edges_root_default = os.path.join(PROJECT_ROOT, f'neo4j_data_{target}', 'edges.csv')
    nodes_root_display = os.path.join(PROJECT_ROOT, f'neo4j_data_{target}_display', 'nodes.csv')
    edges_root_display = os.path.join(PROJECT_ROOT, f'neo4j_data_{target}_display', 'edges.csv')
    
    # result 目录
    race_result_default = os.path.join(result_base, f'race_warnings_{target}.txt')
    race_result_display = os.path.join(result_base, f'race_warnings_{target}_display.txt')
    nodes_result_default = os.path.join(result_base, f'neo4j_data_{target}', 'nodes.csv')
    edges_result_default = os.path.join(result_base, f'neo4j_data_{target}', 'edges.csv')
    nodes_result_display = os.path.join(result_base, f'neo4j_data_{target}_display', 'nodes.csv')
    edges_result_display = os.path.join(result_base, f'neo4j_data_{target}_display', 'edges.csv')

    race_candidates = []
    graph_candidates = []

    if prefer_result:
        if prefer_display:
            race_candidates.extend([race_result_display, race_result_default, race_logs_display, race_logs_default, race_root_display, race_root_default])
            graph_candidates.extend([
                (nodes_result_display, edges_result_display),
                (nodes_result_default, edges_result_default),
                (nodes_logs_display, edges_logs_display),
                (nodes_logs_default, edges_logs_default),
                (nodes_root_display, edges_root_display),
                (nodes_root_default, edges_root_default),
            ])
        else:
            race_candidates.extend([race_result_default, race_result_display, race_logs_default, race_logs_display, race_root_default, race_root_display])
            graph_candidates.extend([
                (nodes_result_default, edges_result_default),
                (nodes_result_display, edges_result_display),
                (nodes_logs_default, edges_logs_default),
                (nodes_logs_display, edges_logs_display),
                (nodes_root_default, edges_root_default),
                (nodes_root_display, edges_root_display),
            ])
    else:
        if prefer_display:
            race_candidates.extend([race_logs_display, race_logs_default, race_root_display, race_root_default, race_result_display, race_result_default])
            graph_candidates.extend([
                (nodes_logs_display, edges_logs_display),
                (nodes_logs_default, edges_logs_default),
                (nodes_root_display, edges_root_display),
                (nodes_root_default, edges_root_default),
                (nodes_result_display, edges_result_display),
                (nodes_result_default, edges_result_default),
            ])
        else:
            race_candidates.extend([race_logs_default, race_logs_display, race_root_default, race_root_display, race_result_default, race_result_display])
            graph_candidates.extend([
                (nodes_logs_default, edges_logs_default),
                (nodes_logs_display, edges_logs_display),
                (nodes_root_default, edges_root_default),
                (nodes_root_display, edges_root_display),
                (nodes_result_default, edges_result_default),
                (nodes_result_display, edges_result_display),
            ])

    race_file = pick_first_existing(race_candidates)
    nodes_file = None
    edges_file = None
    for nfile, efile in graph_candidates:
        if os.path.exists(nfile) and os.path.exists(efile):
            nodes_file = nfile
            edges_file = efile
            break

    return race_file, nodes_file, edges_file


def resolve_analysis_log_path(target, result_base=None, prefer_display=False, prefer_result=False):
    result_base = result_base or os.path.join(DATA_DIR, f'{target}_result')

    # 优先使用 logs 目录下的日志文件
    logs_default = os.path.join(LOGS_DIR, f'analysis_{target}.log')
    logs_display = os.path.join(LOGS_DIR, f'analysis_{target}_display.log')
    result_default = os.path.join(result_base, f'analysis_{target}.log')
    result_display = os.path.join(result_base, f'analysis_{target}_display.log')

    candidates = []
    if prefer_result:
        if prefer_display:
            candidates = [result_display, result_default, logs_display, logs_default]
        else:
            candidates = [result_default, result_display, logs_default, logs_display]
    else:
        if prefer_display:
            candidates = [logs_display, logs_default, result_display, result_default]
        else:
            candidates = [logs_default, logs_display, result_default, result_display]

    return pick_first_existing(candidates)


def count_analysis_files_from_log(log_path):
    if not log_path or not os.path.exists(log_path):
        return 0

    compiled_objects = set()
    pattern = re.compile(r'^\s*CC\s+(.+)$')
    with open(log_path, 'r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            match = pattern.match(line)
            if not match:
                continue
            obj = match.group(1).strip()
            if obj.endswith('.o'):
                compiled_objects.add(obj)

    return len(compiled_objects)


def get_run_row(run_id):
    if not run_id:
        return None
    conn = get_db_connection()
    try:
        row = conn.execute(
            '''
            SELECT run_id, target_name, is_uploaded, started_at, finished_at
            FROM analysis_runs
            WHERE run_id = ?
            ''',
            (run_id,),
        ).fetchone()
        return row
    finally:
        conn.close()


def resolve_analysis_log_path_for_run(run_id, target_name=None):
    row = get_run_row(run_id)
    if row:
        target_name = row['target_name']
        is_uploaded = bool(row['is_uploaded'])
        started_at = int(row['started_at'] or 0)
    else:
        is_uploaded = False
        started_at = 0

    if not target_name:
        return None

    if not is_uploaded:
        return resolve_analysis_log_path(target_name, prefer_display=False, prefer_result=False)

    # 上传任务日志命名：analysis_uploaded_<target>_<ts>.log
    pattern = os.path.join(LOGS_DIR, f'analysis_uploaded_{target_name}_*.log')
    candidates = glob.glob(pattern)
    if not candidates:
        return resolve_analysis_log_path(target_name, prefer_display=False, prefer_result=False)

    def _score(path):
        name = os.path.basename(path)
        m = re.search(r'_(\d+)\.log$', name)
        if m and started_at > 0:
            ts = int(m.group(1))
            return abs(ts - started_at)
        return 10**18

    # 优先按上传时间戳接近 run 的 started_at；兜底按最近修改时间
    candidates.sort(key=lambda p: (_score(p), -os.path.getmtime(p)))
    return candidates[0]


def parse_detector_summary_from_log(log_path):
    summary = {
        'buffer_overflow': 0,
        'null_pointer': 0,
        'use_after_free': 0,
        'memory_safety': 0,
        'info_leak': 0,
        'privilege_escalation': 0,
        'toctou': 0,
    }

    if not log_path or not os.path.exists(log_path):
        return summary

    patterns = {
        'buffer_overflow': re.compile(r'\[BufferOverflowDetector\]\s+Found\s+(\d+)\s+buffer overflow issues'),
        'null_pointer': re.compile(r'\[NullPointerDetector\]\s+Found\s+(\d+)\s+null pointer issues'),
        'use_after_free': re.compile(r'\[UseAfterFreeDetector\]\s+Found\s+(\d+)\s+use-after-free issues'),
        'info_leak': re.compile(r'\[InfoLeakDetector\]\s+Found\s+(\d+)\s+information leakage issues'),
        'privilege_escalation': re.compile(r'\[PrivilegeEscalationDetector\]\s+Found\s+(\d+)\s+privilege escalation issues'),
        'toctou': re.compile(r'\[TOCTOUDetector\]\s+Found\s+(\d+)\s+TOCTOU issues'),
        'memory_safety_total': re.compile(r'^MemorySafety:\s+(\d+)\s+findings\s*$'),
    }

    with open(log_path, 'r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            line = line.strip()
            for key, pat in patterns.items():
                m = pat.search(line)
                if not m:
                    continue
                value = int(m.group(1))
                if key == 'memory_safety_total':
                    summary['memory_safety'] = value
                else:
                    summary[key] = value

    if summary['memory_safety'] == 0:
        summary['memory_safety'] = summary['buffer_overflow'] + summary['null_pointer'] + summary['use_after_free']

    return summary


def resolve_detection_json_dirs_for_run(run_id, target_name=None):
    row = get_run_row(run_id)
    if row:
        target_name = row['target_name']

    if not target_name:
        return []

    candidates = [
        get_run_result_dir(target_name, run_id),
        os.path.join(UPLOAD_DIR, target_name),
        os.path.join(UPLOAD_DIR, 'uploaded_links', target_name),
    ]

    # Uploaded analyses are often stored under analysis_data/uploaded_<target>_<ts>
    candidates.extend(glob.glob(os.path.join(UPLOAD_DIR, f'uploaded_{target_name}_*')))

    seen = set()
    result = []
    for d in candidates:
        if not d:
            continue
        real = os.path.realpath(d)
        if real in seen:
            continue
        seen.add(real)
        if os.path.isdir(real):
            result.append(real)
    return result


def parse_detector_summary_from_json_dirs(json_dirs):
    summary = {
        'buffer_overflow': 0,
        'null_pointer': 0,
        'use_after_free': 0,
        'memory_safety': 0,
        'info_leak': 0,
        'privilege_escalation': 0,
        'toctou': 0,
    }

    type_map = {
        'BufferOverflow': 'buffer_overflow',
        'NullPointer': 'null_pointer',
        'UseAfterFree': 'use_after_free',
        'InfoLeak': 'info_leak',
        'PrivilegeEscalation': 'privilege_escalation',
        'TOCTOU': 'toctou',
    }

    found_files = 0
    for d in json_dirs:
        for path in glob.glob(os.path.join(d, 'detections_*.json')):
            found_files += 1
            try:
                with open(path, 'r', encoding='utf-8', errors='ignore') as f:
                    items = json.load(f)
                if not isinstance(items, list):
                    continue
                for item in items:
                    if not isinstance(item, dict):
                        continue
                    mapped = type_map.get(item.get('type'))
                    if mapped:
                        summary[mapped] += 1
            except Exception:
                continue

    summary['memory_safety'] = (
        summary['buffer_overflow'] + summary['null_pointer'] + summary['use_after_free']
    )
    return summary, found_files


def get_detector_summary_for_run(run_id, target_name=None):
    json_dirs = resolve_detection_json_dirs_for_run(run_id, target_name)
    json_summary, found_files = parse_detector_summary_from_json_dirs(json_dirs)
    if found_files > 0:
        return json_summary

    log_path = resolve_analysis_log_path_for_run(run_id, target_name)
    return parse_detector_summary_from_log(log_path)


def has_prebuilt_result(target):
    print(f"[DEBUG] Checking prebuilt result for target: {target}")
    # 检查是否有race_warnings文件
    race_file, nodes_file, edges_file = resolve_prebuilt_paths(target, prefer_display=True)
    print(f"[DEBUG] Resolved paths - race_file: {race_file}, nodes_file: {nodes_file}, edges_file: {edges_file}")
    
    if race_file and os.path.exists(race_file):
        print(f"[DEBUG] Race file exists: {race_file}, size: {os.path.getsize(race_file)}")
        if os.path.getsize(race_file) > 0:
            print(f"[DEBUG] Race file has content, returning True")
            return True
    
    # 检查是否有上传的分析结果JSON文件
    uploaded_dirs = glob.glob(os.path.join(UPLOAD_DIR, f"uploaded_{target}_*"))
    print(f"[DEBUG] Uploaded dirs: {uploaded_dirs}")
    if uploaded_dirs:
        for uploaded_dir in uploaded_dirs:
            json_files = glob.glob(os.path.join(uploaded_dir, "*.json"))
            print(f"[DEBUG] JSON files in {uploaded_dir}: {json_files}")
            if json_files:
                print(f"[DEBUG] Found JSON files, returning True")
                return True
    
    # 检查是否有neo4j数据文件
    if nodes_file and edges_file:
        print(f"[DEBUG] Checking neo4j files - nodes: {os.path.exists(nodes_file)}, edges: {os.path.exists(edges_file)}")
        if os.path.exists(nodes_file) and os.path.exists(edges_file):
            print(f"[DEBUG] Neo4j files exist, returning True")
            return True
    
    print(f"[DEBUG] No prebuilt result found for {target}")
    return False

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
    "run_id": None,
    "target": None,
    "logs": deque(maxlen=300) # 只保留最后300行日志，防止内存溢出
}

# In-memory data storage（按 run_id 存储，避免并发任务串数据）
analysis_data = {}
current_run_id = None

init_sqlite_db()


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


def detect_archive_suffix(filename):
    lower = (filename or '').lower()
    for suffix in ('.tar.gz', '.tgz', '.tar.xz', '.txz', '.tar.bz2', '.tbz2', '.tar', '.zip'):
        if lower.endswith(suffix):
            return suffix
    return os.path.splitext(filename)[1] or '.bin'


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


def ensure_uploaded_source_ready(target):
    source_dir = get_upload_source_dir(target)
    meta_path = get_upload_meta_path(target)

    if os.path.isdir(source_dir) and os.listdir(source_dir):
        return source_dir, None

    if not os.path.exists(meta_path):
        return None, '未找到上传元数据，请重新上传源码'

    try:
        with open(meta_path, 'r', encoding='utf-8') as f:
            meta = json.load(f)
    except Exception as exc:
        return None, f'上传元数据损坏: {str(exc)}'

    mode = meta.get('mode')
    if mode != 'archive':
        return None, '上传源目录为空，请重新上传源码'

    archive_path = meta.get('archive_file')
    if not archive_path or not os.path.exists(archive_path):
        return None, '上传压缩包不存在，请重新上传'

    if os.path.exists(source_dir):
        shutil.rmtree(source_dir)
    os.makedirs(source_dir, exist_ok=True)

    archive_name = meta.get('archive_name') or os.path.basename(archive_path)
    lower_name = archive_name.lower().strip()
    try:
        if lower_name.endswith('.zip'):
            safe_extract_zip(archive_path, source_dir)
        elif (
            lower_name.endswith('.tar.gz')
            or lower_name.endswith('.tgz')
            or lower_name.endswith('.tar.xz')
            or lower_name.endswith('.txz')
            or lower_name.endswith('.tar.bz2')
            or lower_name.endswith('.tbz2')
            or lower_name.endswith('.tar')
        ):
            safe_extract_tar(archive_path, source_dir)
        else:
            return None, '不支持的压缩包格式'
    except Exception as exc:
        return None, f'解压失败: {str(exc)}'

    if not os.listdir(source_dir):
        return None, '压缩包解压后为空目录'

    # Check if the source looks like a valid kernel source
    kernel_root = resolve_kernel_source_dir(source_dir)
    if not kernel_root:
        return None, '上传的源码不是有效的Linux内核源码（缺少Makefile或Kconfig）'

    # Check for critical kernel directories
    critical_dirs = ['include', 'kernel', 'fs', 'drivers', 'mm']
    missing_dirs = []
    for d in critical_dirs:
        if not os.path.isdir(os.path.join(kernel_root, d)):
            missing_dirs.append(d)

    if missing_dirs:
        return None, f'内核源码不完整，缺少关键目录: {", ".join(missing_dirs)}'

    # Check for critical include subdirectories
    include_dir = os.path.join(kernel_root, 'include')
    if os.path.isdir(include_dir):
        # Count include subdirectories
        include_subdirs = [d for d in os.listdir(include_dir) if os.path.isdir(os.path.join(include_dir, d))]
        if len(include_subdirs) < 10:
            return None, f'内核源码不完整，include目录内容过少（只有{len(include_subdirs)}个子目录）'

    # Check source size (a full kernel should be at least 100MB)
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(source_dir):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            if os.path.exists(fp):
                total_size += os.path.getsize(fp)

    if total_size < 100 * 1024 * 1024:  # 100MB
        return None, f'内核源码不完整，总大小只有 {total_size / (1024*1024):.1f}MB（完整内核应大于100MB）'

    return source_dir, None


def list_uploaded_archive_targets():
    items = []
    if not os.path.isdir(UPLOADS_ROOT_DIR):
        return items

    for entry in os.listdir(UPLOADS_ROOT_DIR):
        target = sanitize_target_dir(entry)
        target_root = get_upload_target_root(target)
        if not os.path.isdir(target_root):
            continue

        meta_path = get_upload_meta_path(target)
        if not os.path.isfile(meta_path):
            continue

        try:
            with open(meta_path, 'r', encoding='utf-8') as f:
                meta = json.load(f)
        except Exception:
            continue

        if meta.get('mode') != 'archive':
            continue

        archive_file = meta.get('archive_file')
        archive_exists = bool(archive_file and os.path.isfile(archive_file))
        archive_size_bytes = 0
        archive_updated_at = 0
        if archive_exists:
            try:
                archive_size_bytes = os.path.getsize(archive_file)
                archive_updated_at = int(os.path.getmtime(archive_file))
            except OSError:
                archive_size_bytes = 0
                archive_updated_at = 0

        source_dir = get_upload_source_dir(target)
        source_ready = bool(os.path.isdir(source_dir) and os.listdir(source_dir))

        meta_updated_at = 0
        try:
            meta_updated_at = int(os.path.getmtime(meta_path))
        except OSError:
            meta_updated_at = 0

        updated_at = max(meta_updated_at, archive_updated_at)

        items.append({
            'target': target,
            'archive_name': meta.get('archive_name') or (os.path.basename(archive_file) if archive_file else ''),
            'archive_exists': archive_exists,
            'archive_size_bytes': archive_size_bytes,
            'source_ready': source_ready,
            'updated_at': updated_at,
        })

    items.sort(key=lambda x: x.get('updated_at', 0), reverse=True)
    return items


def resolve_kernel_source_dir(upload_base_dir):
    if os.path.isfile(os.path.join(upload_base_dir, 'Makefile')) and os.path.isfile(os.path.join(upload_base_dir, 'Kconfig')):
        return upload_base_dir

    subdirs = [
        os.path.join(upload_base_dir, name)
        for name in os.listdir(upload_base_dir)
        if os.path.isdir(os.path.join(upload_base_dir, name))
    ]

    if len(subdirs) == 1:
        only_dir = subdirs[0]
        if os.path.isfile(os.path.join(only_dir, 'Makefile')) and os.path.isfile(os.path.join(only_dir, 'Kconfig')):
            return only_dir

    # Fallback: search nested folders (depth <= 3) for kernel root markers.
    base_depth = upload_base_dir.rstrip(os.sep).count(os.sep)
    for root, dirs, _ in os.walk(upload_base_dir):
        current_depth = root.rstrip(os.sep).count(os.sep) - base_depth
        if current_depth > 3:
            dirs[:] = []
            continue

        if os.path.isfile(os.path.join(root, 'Makefile')) and os.path.isfile(os.path.join(root, 'Kconfig')):
            return root

    return upload_base_dir


def stream_command_to_log(cmd, cwd, env, log_path, progress_hook=None):
    with open(log_path, 'a', encoding='utf-8') as log_file:
        process = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            cwd=cwd,
            env=env,
        )
        for line in iter(process.stdout.readline, ''):
            line = line.rstrip('\n')
            log_file.write(line + '\n')
            if line:
                scan_status['logs'].append(line)
                if progress_hook:
                    progress_hook(line)
        process.wait()
        return process.returncode


def update_uploaded_progress_from_line(line):
    text = (line or '').strip()
    if not text:
        return

    milestones = [
        ('Target Kernel:', 12),
        ('[*] Building GCC Plugin...', 18),
        ('[*] Configuring Kernel', 24),
        ('[*] Starting Kernel Analysis', 35),
        ('[*] Extracting Unprotected Global Variable Access List...', 72),
        ('[*] Generating Neo4j Import Data...', 82),
        ('Processing complete. Found', 88),
        ('[+] Neo4j data generation completed successfully', 92),
        ('[*] 已归档', 96),
    ]

    for marker, progress in milestones:
        if marker in text and scan_status['progress'] < progress:
            scan_status['progress'] = progress
            return


def run_uploaded_real_analysis(target, source_path, result_path):
    kernel_source_dir = resolve_kernel_source_dir(source_path)

    if not os.path.isfile(os.path.join(kernel_source_dir, 'Makefile')) or not os.path.isfile(os.path.join(kernel_source_dir, 'Kconfig')):
        scan_status['logs'].append(f'[-] 上传目录不是可构建的 Linux 内核源码: {kernel_source_dir}')
        return False

    os.makedirs(result_path, exist_ok=True)
    analysis_log_file = os.path.join(result_path, f'analysis_{target}.log')
    if os.path.exists(analysis_log_file):
        os.remove(analysis_log_file)

    env = os.environ.copy()
    env['ANALYSIS_JOBS'] = env.get('ANALYSIS_JOBS', '2')

    alias_target = f"uploaded_{sanitize_target_dir(target)}_{int(time.time())}"
    # Create a short alias under analysis_data to avoid polluting project root
    alias_dir = os.path.join(PROJECT_ROOT, 'analysis_data', 'uploaded_links')
    os.makedirs(alias_dir, exist_ok=True)
    alias_source_link = os.path.join(alias_dir, alias_target)

    # Create a short alias so run_analysis.sh can use standard relative paths.
    if os.path.lexists(alias_source_link):
        if os.path.islink(alias_source_link) or os.path.isfile(alias_source_link):
            os.unlink(alias_source_link)
        else:
            shutil.rmtree(alias_source_link)
    os.symlink(kernel_source_dir, alias_source_link)

    alias_analysis_data_dir = os.path.join(PROJECT_ROOT, 'analysis_data', alias_target)

    try:
        scan_status['progress'] = 10
        scan_status['logs'].append('[*] 调用 run_analysis.sh 执行上传内核分析流程...')
        analysis_rc = stream_command_to_log(
            ['bash', './scripts/run_analysis.sh', alias_target],
            PROJECT_ROOT,
            env,
            analysis_log_file,
            progress_hook=update_uploaded_progress_from_line,
        )
        if analysis_rc != 0:
            scan_status['logs'].append(f'[WARNING] run_analysis.sh 退出码: {analysis_rc}（部分文件可能编译失败，但继续处理）')
            # Don't return False here - analysis may have partial results

        scan_status['progress'] = 92
        scan_status['logs'].append('[*] 归档分析结果到上传结果目录...')

        # 从 logs 目录读取日志文件
        logs_analysis_log = os.path.join(LOGS_DIR, f'analysis_{alias_target}.log')
        logs_ast_log = os.path.join(LOGS_DIR, f'ast_{alias_target}.log')
        logs_race_file = os.path.join(LOGS_DIR, f'race_warnings_{alias_target}.txt')
        logs_neo4j_dir = os.path.join(LOGS_DIR, f'neo4j_data_{alias_target}')

        result_analysis_log = os.path.join(result_path, f'analysis_{target}.log')
        result_ast_log = os.path.join(result_path, f'ast_{target}.log')
        result_race_file = os.path.join(result_path, f'race_warnings_{target}.txt')
        result_neo4j_dir = os.path.join(result_path, f'neo4j_data_{target}')

        if os.path.exists(logs_analysis_log):
            shutil.copy2(logs_analysis_log, result_analysis_log)
        if os.path.exists(logs_ast_log):
            shutil.copy2(logs_ast_log, result_ast_log)
        if os.path.exists(logs_race_file):
            shutil.copy2(logs_race_file, result_race_file)

        if os.path.exists(result_neo4j_dir):
            shutil.rmtree(result_neo4j_dir)
        if os.path.isdir(logs_neo4j_dir):
            shutil.copytree(logs_neo4j_dir, result_neo4j_dir)

        # 保留探测器细粒度结果，避免上传任务退化为仅 race_warnings 推断。
        if os.path.isdir(alias_analysis_data_dir):
            copied_detection_files = 0
            for filename in os.listdir(alias_analysis_data_dir):
                if filename.startswith('detections_') and filename.endswith('.json'):
                    src_path = os.path.join(alias_analysis_data_dir, filename)
                    dst_path = os.path.join(result_path, filename)
                    shutil.copy2(src_path, dst_path)
                    copied_detection_files += 1
            if copied_detection_files > 0:
                scan_status['logs'].append(f'[*] 已归档 {copied_detection_files} 个检测结果文件到上传任务目录')
            else:
                scan_status['logs'].append('[WARNING] 未发现 detections_*.json，检测模块详情可能不完整')

        # Check if we have any race warnings - if not, analysis might have failed completely
        if not os.path.exists(result_race_file) or os.path.getsize(result_race_file) == 0:
            # Check if analysis log has any plugin output
            if os.path.exists(result_analysis_log):
                with open(result_analysis_log, 'r') as f:
                    content = f.read()
                    if 'Analyzer Plugin Loaded' not in content:
                        scan_status['logs'].append('[-] 分析插件未加载，分析可能失败')
                        return False
            scan_status['logs'].append('[WARNING] 未找到竞态告警，但分析已完成')

        return True
    finally:
        # 清理临时符号链接
        if os.path.lexists(alias_source_link):
            if os.path.islink(alias_source_link) or os.path.isfile(alias_source_link):
                os.unlink(alias_source_link)
            else:
                shutil.rmtree(alias_source_link)
        
        # 清理临时构建目录（新位置在 analysis_data 下）
        build_dir = os.path.join(PROJECT_ROOT, 'analysis_data', f'build_{alias_target}')
        if os.path.isdir(build_dir):
            shutil.rmtree(build_dir)
        # 兼容旧位置（根目录下的 build_analysis_*）
        old_build_dir = os.path.join(PROJECT_ROOT, f'build_analysis_{alias_target}')
        if os.path.isdir(old_build_dir):
            shutil.rmtree(old_build_dir)
        
        # 清理临时 Neo4j 数据目录
        neo4j_dir = os.path.join(PROJECT_ROOT, f'neo4j_data_{alias_target}')
        if os.path.isdir(neo4j_dir):
            shutil.rmtree(neo4j_dir)
        
        # 清理临时分析数据目录
        if os.path.isdir(alias_analysis_data_dir):
            shutil.rmtree(alias_analysis_data_dir)

def run_real_scan(target, is_uploaded=False, run_id=None):
    global scan_status
    global current_run_id

    run_id = run_id or str(uuid.uuid4())
    current_run_id = run_id
    create_run_record(run_id, target, is_uploaded)

    scan_status["status"] = "running"
    scan_status["progress"] = 5
    scan_status["run_id"] = run_id
    scan_status["target"] = target
    scan_status["logs"].clear()
    scan_status["logs"].append(f"[*] 开始真实分析任务，目标: {target}")
    scan_status["logs"].append(f"[*] run_id: {run_id}")

    try:
        if is_uploaded:
            source_path, source_err = ensure_uploaded_source_ready(target)
            result_path = get_run_result_dir(target, run_id)

            if source_err:
                scan_status["status"] = "error"
                scan_status["logs"].append(f"[-] 错误: {source_err}")
                update_run_status(run_id, 'error', source_err)
                return

            if not os.path.exists(source_path):
                scan_status["status"] = "error"
                scan_status["logs"].append(f"[-] 错误: 找不到上传的代码目录: {source_path}")
                update_run_status(run_id, 'error', 'uploaded source not found')
                return

            os.makedirs(result_path, exist_ok=True)
            scan_status["logs"].append(f"[*] 分析上传的代码: {source_path}")
            scan_status["logs"].append(f"[*] 结果将保存到: {result_path}")

            real_ok = run_uploaded_real_analysis(target, source_path, result_path)
            if not real_ok:
                scan_status["status"] = "error"
                scan_status["logs"].append("[-] 上传代码真实分析失败")
                update_run_status(run_id, 'error', 'uploaded real analysis failed')
                return

            # Upload and built-in share the same stats/graph schema; only data source differs.
            generate_analysis_data(target, run_id, result_path, prefer_result=True, prefer_display=False)
            scan_status["progress"] = 100
            scan_status["status"] = "completed"
            scan_status["logs"].append("[+] 上传代码分析完成！")
            update_run_status(run_id, 'completed')
            return

        env = os.environ.copy()
        env['ANALYSIS_JOBS'] = '2'

        process = subprocess.Popen(
            [os.path.join(PROJECT_ROOT, 'scripts', 'run_analysis.sh'), target],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            cwd=PROJECT_ROOT,
            env=env
        )

        try:
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
        except Exception as e:
            scan_status["logs"].append(f"[-] 读取分析输出时出错: {str(e)}")
        finally:
            # Ensure process is terminated
            if process.poll() is None:
                process.terminate()
                try:
                    process.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    process.kill()
                    process.wait()

        if process.returncode == 0:
            scan_status["progress"] = 100
            scan_status["status"] = "completed"
            scan_status["logs"].append("[+] 分析完成！数据已就绪。")
            generate_analysis_data(target, run_id, prefer_display=True)
            update_run_status(run_id, 'completed')
        else:
            scan_status["status"] = "error"
            scan_status["logs"].append(f"[-] 分析结束，退出码: {process.returncode}")
            update_run_status(run_id, 'error', f'run_analysis exit code {process.returncode}')
    except Exception as exc:
        scan_status["status"] = "error"
        scan_status["logs"].append(f"[-] 后端异常: {str(exc)}")
        update_run_status(run_id, 'error', str(exc))


def generate_analysis_data(target, run_id, result_dir_override=None, prefer_result=False, prefer_display=False, is_prebuilt=False):
    """生成分析数据并存储在内存中
    
    Args:
        target: 目标内核名称
        run_id: 运行ID
        result_dir_override: 结果目录覆盖
        prefer_result: 优先使用结果目录
        prefer_display: 优先使用display版本
        is_prebuilt: 是否为预置结果（不是实时分析的）
    """
    global analysis_data
    
    result_base = result_dir_override or os.path.join(DATA_DIR, f"{target}_result")
    race_file, nodes_file, edges_file = resolve_prebuilt_paths(
        target,
        result_base=result_base,
        prefer_display=prefer_display,
        prefer_result=prefer_result,
    )

    if not race_file:
        race_file = os.path.join(PROJECT_ROOT, f"race_warnings_{target}.txt")

    race_data = parse_race_warnings(race_file)

    if not nodes_file or not edges_file:
        # 优先从 logs 目录读取（新位置）
        logs_nodes_file = os.path.join(LOGS_DIR, f"neo4j_data_{target}", 'nodes.csv')
        logs_edges_file = os.path.join(LOGS_DIR, f"neo4j_data_{target}", 'edges.csv')
        # 兼容旧位置（根目录）
        root_nodes_file = os.path.join(PROJECT_ROOT, f"neo4j_data_{target}", 'nodes.csv')
        root_edges_file = os.path.join(PROJECT_ROOT, f"neo4j_data_{target}", 'edges.csv')
        result_nodes_file = os.path.join(result_base, f"neo4j_data_{target}", 'nodes.csv')
        result_edges_file = os.path.join(result_base, f"neo4j_data_{target}", 'edges.csv')
        
        # 按优先级选择：logs > root > result_base
        if os.path.exists(logs_nodes_file):
            nodes_file = logs_nodes_file
            edges_file = logs_edges_file
        elif os.path.exists(root_nodes_file):
            nodes_file = root_nodes_file
            edges_file = root_edges_file
        else:
            nodes_file = result_nodes_file
            edges_file = result_edges_file

    nodes_data = parse_nodes_csv(nodes_file)
    edges_data = parse_edges_csv(edges_file)
    analysis_log_path = resolve_analysis_log_path(
        target,
        result_base=result_base,
        prefer_display=prefer_display,
        prefer_result=prefer_result,
    )
    analysis_files_count = count_analysis_files_from_log(analysis_log_path)

    # For prebuilt data, prefer the default analysis log's file count to avoid
    # stale display-log statistics.
    if is_prebuilt:
        default_log_path = resolve_analysis_log_path(
            target,
            result_base=result_base,
            prefer_display=False,
            prefer_result=prefer_result,
        )
        default_count = count_analysis_files_from_log(default_log_path)
        if default_count > 0:
            analysis_files_count = default_count
    
    # 构建图数据
    graph_data = build_sample_graph(edges_file, nodes_file)
    
    # 判断数据类型
    is_demo_data = False
    data_source = "真实分析结果"
    
    # 如果没有真实数据，生成演示数据
    if race_data["total"] == 0 and nodes_data["total"] == 0:
        print(f"[INFO] No real data found for {target}, generating demo data...")
        race_data = generate_demo_race_data()
        nodes_data = generate_demo_nodes_data()
        edges_data = generate_demo_edges_data()
        graph_data = generate_demo_graph_data()
        is_demo_data = True
        data_source = "演示数据"
        # 演示数据不覆盖 analysis_files，保持日志统计值（无日志时为 0）
    elif is_prebuilt:
        # 预置结果（不是实时分析的）
        data_source = "预置分析数据"
    
    # 存储分析数据
    built_data = {
        "run_id": run_id,
        "target": target,
        "kernel_version": target,
        "scan_time": time.strftime("%Y-%m-%d"),
        "is_demo_data": is_demo_data,
        "is_prebuilt": is_prebuilt,
        "data_source": data_source,
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
            "analysis_files": analysis_files_count
        },
        "race_warnings": race_data,
        "edges_stats": edges_data,
        "graph": graph_data
    }

    analysis_data[run_id] = built_data
    persist_summary(run_id, built_data)
    persist_warnings(run_id, target, race_data.get('warnings_sample', []), race_data.get('raw_lines', []))

def generate_demo_race_data():
    """生成演示竞态数据"""
    warnings = [
        {"type": "Read", "variable": "global_counter", "function": "read_data"},
        {"type": "Write", "variable": "global_counter", "function": "write_data"},
        {"type": "Read", "variable": "shared_buffer", "function": "process_buffer"},
        {"type": "Write", "variable": "shared_buffer", "function": "update_buffer"},
        {"type": "Read", "variable": "status_flag", "function": "check_status"},
        {"type": "Write", "variable": "status_flag", "function": "set_status"},
    ]
    return {
        "total": 6,
        "reads": 3,
        "writes": 3,
        "top_variables": [
            {"name": "global_counter", "count": 2},
            {"name": "shared_buffer", "count": 2},
            {"name": "status_flag", "count": 2},
        ],
        "top_functions": [
            {"name": "read_data", "count": 1},
            {"name": "write_data", "count": 1},
            {"name": "process_buffer", "count": 1},
        ],
        "warnings_sample": warnings,
        "raw_lines": []
    }


def generate_demo_nodes_data():
    """生成演示节点数据"""
    return {
        "functions": 150,
        "variables": 30,
        "total": 180
    }


def generate_demo_edges_data():
    """生成演示边数据"""
    return {
        "calls": 200,
        "reads": 50,
        "writes": 30,
        "total": 280
    }


def generate_demo_graph_data():
    """生成演示图数据"""
    nodes = [
        {"id": "func_1", "name": "main", "category": 0, "symbolSize": 20, "value": 10},
        {"id": "func_2", "name": "process_data", "category": 0, "symbolSize": 15, "value": 8},
        {"id": "func_3", "name": "read_data", "category": 0, "symbolSize": 12, "value": 6},
        {"id": "func_4", "name": "write_data", "category": 0, "symbolSize": 12, "value": 6},
        {"id": "var_1", "name": "global_counter", "category": 1, "symbolSize": 15, "value": 8},
        {"id": "var_2", "name": "shared_buffer", "category": 1, "symbolSize": 12, "value": 5},
    ]
    edges = [
        {"source": "func_1", "target": "func_2", "type": "CALLS"},
        {"source": "func_2", "target": "func_3", "type": "CALLS"},
        {"source": "func_2", "target": "func_4", "type": "CALLS"},
        {"source": "func_3", "target": "var_1", "type": "READS"},
        {"source": "func_4", "target": "var_1", "type": "WRITES"},
    ]
    return {"nodes": nodes, "edges": edges}


def parse_race_warnings(filepath):
    """解析竞态警告文件"""
    import re
    from collections import Counter
    
    warnings = []
    raw_lines = []
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
            "warnings_sample": [],
            "raw_lines": []
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
                    raw_lines.append(line.strip())
    
    return {
        "total": read_count + write_count,
        "reads": read_count,
        "writes": write_count,
        "top_variables": [{"name": k, "count": v} for k, v in var_counter.most_common(30)],
        "top_functions": [{"name": k, "count": v} for k, v in func_counter.most_common(30)],
        "warnings_sample": warnings,
        "raw_lines": raw_lines
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

    target_root = get_upload_target_root(target_dir)
    source_dir = get_upload_source_dir(target_dir)
    archive_dir = get_upload_archive_dir(target_dir)
    result_root = os.path.join(ANALYSIS_RESULTS_ROOT_DIR, target_dir)
    os.makedirs(target_root, exist_ok=True)
    os.makedirs(source_dir, exist_ok=True)
    os.makedirs(archive_dir, exist_ok=True)
    os.makedirs(result_root, exist_ok=True)
    
    if files:
        for file in files:
            if file.filename:
                # Use the full relative path from webkitRelativePath
                relative_path = file.filename
                
                # Handle paths that may include the root folder name
                # e.g., "linux-6.6.1/include/linux/module.h" -> "include/linux/module.h"
                path_parts = relative_path.split('/')
                if len(path_parts) > 1:
                    # Check if first part looks like a root folder (contains version number or common kernel names)
                    first_part = path_parts[0].lower()
                    if any(keyword in first_part for keyword in ['linux', 'kernel', 'src', 'source']):
                        relative_path = '/'.join(path_parts[1:])

                file_path = os.path.join(source_dir, relative_path)
                if not is_within_directory(source_dir, file_path):
                    return jsonify({"error": "Invalid file path in upload"}), 400
                os.makedirs(os.path.dirname(file_path), exist_ok=True)
                file.save(file_path)

        with open(get_upload_meta_path(target_dir), 'w', encoding='utf-8') as f:
            json.dump({"mode": "folder", "target": target_dir, "source_dir": source_dir}, f, ensure_ascii=False)

    if archive and archive.filename:
        archive_name = os.path.basename(archive.filename)
        ext = detect_archive_suffix(archive_name)
        archive_path = os.path.join(archive_dir, f'package_{int(time.time())}{ext}')
        archive.save(archive_path)

        lower_name = archive_name.lower().strip()
        if not (
            lower_name.endswith('.zip')
            or lower_name.endswith('.tar.gz')
            or lower_name.endswith('.tgz')
            or lower_name.endswith('.tar.xz')
            or lower_name.endswith('.txz')
            or lower_name.endswith('.tar.bz2')
            or lower_name.endswith('.tbz2')
            or lower_name.endswith('.tar')
        ):
            return jsonify({"error": "Unsupported archive format. Use zip/tar/tar.gz/tgz/tar.xz/tar.bz2"}), 400

        if os.path.exists(source_dir):
            shutil.rmtree(source_dir)
        os.makedirs(source_dir, exist_ok=True)

        with open(get_upload_meta_path(target_dir), 'w', encoding='utf-8') as f:
            json.dump(
                {
                    "mode": "archive",
                    "target": target_dir,
                    "archive_file": archive_path,
                    "archive_name": archive_name,
                },
                f,
                ensure_ascii=False,
            )
            
    return jsonify({
        "message": "Upload complete", 
        "target": target_dir,
        "upload_path": target_root,
        "source_path": source_dir,
        "result_root": result_root,
        "extract_deferred": True if archive and archive.filename else False
    })


@app.route('/api/uploaded-archives', methods=['GET'])
def get_uploaded_archives():
    items = list_uploaded_archive_targets()
    return jsonify({
        'items': items,
        'total': len(items),
    })

@app.route('/api/scan', methods=['POST'])
def start_scan():
    global current_run_id
    data = request.json or {}
    target = data.get('target', 'linux-6.6.1')
    is_uploaded = data.get('is_uploaded', False)
    force_reanalyze = bool(data.get('force_reanalyze', False))
    overwrite_existing = bool(data.get('overwrite_existing', False))
    run_id = str(uuid.uuid4())

    if is_uploaded:
        target = sanitize_target_dir(target)

    # 上传内核强制重跑并覆盖：删除该 target 的历史报告记录与产物，保留上传包本身。
    if is_uploaded and force_reanalyze and overwrite_existing:
        purge_result = purge_uploaded_reports(target)
        if not purge_result.get('ok'):
            return jsonify({
                "error": "该目标仍有运行中的任务，无法覆盖历史报告",
                "target": target,
                "running_run_ids": purge_result.get('running_run_ids', []),
            }), 409
    
    # 内置内核快速路径：若已有预置结果则直接返回，不重跑分析
    if not is_uploaded and not force_reanalyze and has_prebuilt_result(target):
        create_run_record(run_id, target, False)
        generate_analysis_data(target, run_id, prefer_display=True, is_prebuilt=True)
        update_run_status(run_id, 'completed')
        current_run_id = run_id

        scan_status["status"] = "completed"
        scan_status["progress"] = 100
        scan_status["run_id"] = run_id
        scan_status["target"] = target
        scan_status["logs"].clear()
        scan_status["logs"].append(f"[*] run_id: {run_id}")
        scan_status["logs"].append("[*] 命中内置结果，跳过重分析")
        scan_status["logs"].append("[+] 已加载预置分析数据（非实时分析）")

        return jsonify({
            "message": "Scan loaded from prebuilt data",
            "target": target,
            "is_uploaded": is_uploaded,
            "run_id": run_id,
            "quick_mode": True,
        })

    # 上传源码复用路径：命中最近一次已完成任务则直接加载历史结果，避免重复长时间审计
    if is_uploaded and not force_reanalyze:
        latest_completed = get_latest_run(target_name=target, is_uploaded=True, statuses=['completed'])
        if latest_completed and has_reusable_uploaded_result(target, latest_completed['run_id']):
            reused_run_id = latest_completed['run_id']
            result_dir = get_run_result_dir(target, reused_run_id)
            generate_analysis_data(
                target,
                reused_run_id,
                result_dir_override=result_dir,
                prefer_result=True,
                prefer_display=False,
                is_prebuilt=True,
            )
            current_run_id = reused_run_id

            scan_status["status"] = "completed"
            scan_status["progress"] = 100
            scan_status["run_id"] = reused_run_id
            scan_status["target"] = target
            scan_status["logs"].clear()
            scan_status["logs"].append(f"[*] run_id: {reused_run_id}")
            scan_status["logs"].append("[*] 命中上传历史结果，跳过重复审计")
            scan_status["logs"].append("[+] 已恢复最近一次完成的分析数据")

            return jsonify({
                "message": "Scan loaded from previous uploaded result",
                "target": target,
                "is_uploaded": is_uploaded,
                "run_id": reused_run_id,
                "quick_mode": True,
                "reused": True,
            })
    
    # 启动真实的后台分析线程
    thread = threading.Thread(target=run_real_scan, args=(target, is_uploaded, run_id))
    thread.start()
    current_run_id = run_id
    
    return jsonify({
        "message": "Scan started successfully",
        "target": target,
        "is_uploaded": is_uploaded,
        "run_id": run_id,
        "overwrite_existing": overwrite_existing,
        "quick_mode": False,
    })


@app.route('/api/scan/recover', methods=['GET'])
def recover_scan():
    global current_run_id

    target = request.args.get('target', default=None, type=str)
    is_uploaded_raw = request.args.get('is_uploaded', default=None, type=str)
    is_uploaded = None
    if is_uploaded_raw is not None:
        is_uploaded = str(is_uploaded_raw).strip().lower() in ('1', 'true', 'yes', 'on')

    # 优先返回内存中的实时任务状态（服务未重启时）
    active_run_id = scan_status.get('run_id')
    active_target = scan_status.get('target')
    active_status = scan_status.get('status')

    if active_run_id and active_status in ('running', 'completed'):
        if (not target or active_target == target):
            if is_uploaded is None:
                return jsonify({
                    "recoverable": True,
                    "source": "memory",
                    "status": active_status,
                    "progress": scan_status.get('progress', 0),
                    "run_id": active_run_id,
                    "target": active_target,
                    "logs": list(scan_status.get('logs', [])),
                })

            row = get_latest_run(target_name=active_target, statuses=None)
            if row and bool(row['is_uploaded']) == is_uploaded:
                return jsonify({
                    "recoverable": True,
                    "source": "memory",
                    "status": active_status,
                    "progress": scan_status.get('progress', 0),
                    "run_id": active_run_id,
                    "target": active_target,
                    "logs": list(scan_status.get('logs', [])),
                })

    # 兜底：从数据库恢复最近完成的任务
    latest_completed = get_latest_run(target_name=target, is_uploaded=is_uploaded, statuses=['completed'])
    if latest_completed:
        recovered_run_id = latest_completed['run_id']
        recovered_target = latest_completed['target_name']

        if bool(latest_completed['is_uploaded']):
            result_dir = get_run_result_dir(recovered_target, recovered_run_id)
            if os.path.isdir(result_dir):
                generate_analysis_data(
                    recovered_target,
                    recovered_run_id,
                    result_dir_override=result_dir,
                    prefer_result=True,
                    prefer_display=False,
                )
        else:
            generate_analysis_data(recovered_target, recovered_run_id, prefer_display=True)

        current_run_id = recovered_run_id
        return jsonify({
            "recoverable": True,
            "source": "sqlite",
            "status": "completed",
            "progress": 100,
            "run_id": recovered_run_id,
            "target": recovered_target,
            "logs": [
                f"[*] run_id: {recovered_run_id}",
                "[*] 已恢复最近一次完成的分析结果",
                "[+] 可直接进入可视化报告",
            ],
        })

    return jsonify({
        "recoverable": False,
        "status": "idle",
        "progress": 0,
        "run_id": None,
        "target": target,
        "logs": [],
        "message": "没有可恢复的历史任务，请发起新的审计。",
    })

@app.route('/api/scan/status', methods=['GET'])
def get_scan_status():
    return jsonify({
        "status": scan_status["status"],
        "progress": scan_status["progress"],
        "run_id": scan_status.get("run_id"),
        "target": scan_status.get("target"),
        "logs": list(scan_status["logs"])
    })


@app.route('/api/history', methods=['GET'])
def get_history():
    target_type = (request.args.get('target_type', default='all', type=str) or 'all').strip().lower()
    status = (request.args.get('status', default='all', type=str) or 'all').strip().lower()
    target_keyword = (request.args.get('target', default='', type=str) or '').strip()
    page = max(1, request.args.get('page', default=1, type=int))
    page_size = request.args.get('page_size', default=20, type=int)
    page_size = 20 if page_size is None else max(1, min(page_size, 100))
    offset = (page - 1) * page_size

    where = []
    params = []

    if target_type in ('uploaded', 'builtin'):
        where.append('r.target_type = ?')
        params.append(target_type)

    if status in ('running', 'completed', 'error'):
        where.append('r.status = ?')
        params.append(status)

    if target_keyword:
        where.append('r.target_name LIKE ?')
        params.append(f'%{target_keyword}%')

    where_sql = f"WHERE {' AND '.join(where)}" if where else ''

    conn = get_db_connection()
    try:
        total = conn.execute(
            f'''
            SELECT COUNT(1) AS c
            FROM analysis_runs r
            {where_sql}
            ''',
            params,
        ).fetchone()['c']

        rows = conn.execute(
            f'''
            SELECT
                r.run_id,
                r.target_name,
                r.target_type,
                r.status,
                r.started_at,
                r.finished_at,
                r.error_message,
                r.is_uploaded,
                COALESCE(s.analysis_files, 0) AS analysis_files,
                COALESCE(s.total_warnings, 0) AS total_warnings
            FROM analysis_runs r
            LEFT JOIN summary_stats s ON s.run_id = r.run_id
            {where_sql}
            ORDER BY r.started_at DESC
            LIMIT ? OFFSET ?
            ''',
            params + [page_size, offset],
        ).fetchall()

        items = []
        for row in rows:
            is_uploaded = bool(row['is_uploaded'])
            run_id = row['run_id']
            target_name = row['target_name']

            result_dir = get_run_result_dir(target_name, run_id) if is_uploaded else None
            result_exists = bool(result_dir and os.path.isdir(result_dir))
            result_size_bytes = get_dir_size_bytes(result_dir) if result_exists else 0

            upload_root = get_upload_target_root(target_name) if is_uploaded else None
            upload_exists = bool(upload_root and os.path.isdir(upload_root))
            upload_size_bytes = get_dir_size_bytes(upload_root) if upload_exists else 0

            items.append(
                {
                    'run_id': run_id,
                    'target_name': target_name,
                    'target_type': row['target_type'],
                    'is_uploaded': is_uploaded,
                    'status': row['status'],
                    'started_at': int(row['started_at'] or 0),
                    'started_at_text': format_timestamp(row['started_at']),
                    'finished_at': int(row['finished_at'] or 0) if row['finished_at'] else None,
                    'finished_at_text': format_timestamp(row['finished_at']),
                    'error_message': row['error_message'] or '',
                    'analysis_files': int(row['analysis_files'] or 0),
                    'total_warnings': int(row['total_warnings'] or 0),
                    'result_exists': result_exists,
                    'result_size_bytes': int(result_size_bytes),
                    'upload_exists': upload_exists,
                    'upload_size_bytes': int(upload_size_bytes),
                    'can_open_report': row['status'] == 'completed',
                }
            )

        return jsonify(
            {
                'page': page,
                'page_size': page_size,
                'total': int(total),
                'items': items,
            }
        )
    finally:
        conn.close()


@app.route('/api/history/<run_id>', methods=['DELETE'])
def delete_history_run(run_id):
    purge_uploaded_payload = bool_from_query(request.args.get('purge_uploaded_payload', default='0'))

    conn = get_db_connection()
    try:
        row = conn.execute(
            '''
            SELECT run_id, target_name, status, is_uploaded
            FROM analysis_runs
            WHERE run_id = ?
            ''',
            (run_id,),
        ).fetchone()
    finally:
        conn.close()

    if not row:
        return jsonify({'error': 'history run not found'}), 404

    run_target = row['target_name']
    is_uploaded = bool(row['is_uploaded'])
    run_status = row['status']

    if run_status == 'running':
        return jsonify({'error': 'cannot delete a running task'}), 400

    removed_paths = []

    if is_uploaded:
        run_result_dir = get_run_result_dir(run_target, run_id)
        if os.path.isdir(run_result_dir):
            shutil.rmtree(run_result_dir)
            removed_paths.append(run_result_dir)

    runs_to_delete = [run_id]
    if is_uploaded and purge_uploaded_payload:
        conn = get_db_connection()
        try:
            rows = conn.execute(
                '''
                SELECT run_id FROM analysis_runs
                WHERE target_name = ? AND is_uploaded = 1
                ''',
                (run_target,),
            ).fetchall()
            runs_to_delete = [r['run_id'] for r in rows] or [run_id]
        finally:
            conn.close()

        removed_paths.extend(remove_uploaded_target_payload(run_target))

    delete_run_records(runs_to_delete)

    global current_run_id
    if current_run_id in runs_to_delete:
        current_run_id = latest_run_id()

    if scan_status.get('run_id') in runs_to_delete:
        scan_status['run_id'] = current_run_id
        if not current_run_id:
            scan_status['status'] = 'idle'
            scan_status['progress'] = 0
            scan_status['target'] = None
            scan_status['logs'].clear()

    for rid in runs_to_delete:
        analysis_data.pop(rid, None)

    return jsonify(
        {
            'message': 'history deleted',
            'deleted_run_ids': runs_to_delete,
            'removed_paths': removed_paths,
            'purge_uploaded_payload': bool(purge_uploaded_payload),
        }
    )

@app.route('/api/status', methods=['GET'])
def get_status():
    return jsonify({"status": "connected", "message": "Successfully connected to kernel analysis system"})


def get_active_run_id(requested_run_id=None, target_name=None):
    if requested_run_id:
        return requested_run_id
    if target_name:
        run_id = latest_run_id(target_name)
        if run_id:
            return run_id
    return current_run_id or latest_run_id()


def get_analysis_data_by_run(run_id):
    if run_id and run_id in analysis_data:
        return analysis_data[run_id]
    return None

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
    requested_run_id = request.args.get('run_id', default=None, type=str)
    target_name = request.args.get('target', default=None, type=str)
    limit = request.args.get('limit', default=100, type=int)
    run_id = get_active_run_id(requested_run_id, target_name)
    data = get_analysis_data_by_run(run_id) or {}
    
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
        graph_data['run_id'] = run_id
        return jsonify(graph_data)
    else:
        # 返回空图数据
        return jsonify({"nodes": [], "edges": []})

@app.route('/api/stats', methods=['GET'])
def get_stats():
    requested_run_id = request.args.get('run_id', default=None, type=str)
    target_name = request.args.get('target', default=None, type=str)
    run_id = get_active_run_id(requested_run_id, target_name)

    if run_id:
        conn = get_db_connection()
        try:
            summary_row = conn.execute(
                'SELECT * FROM summary_stats WHERE run_id = ?',
                (run_id,)
            ).fetchone()

            if summary_row:
                warning_rows = conn.execute(
                    '''
                    SELECT warn_type, variable_name, function_name, severity
                    FROM warnings
                    WHERE run_id = ?
                    ORDER BY id DESC
                    LIMIT 20
                    ''',
                    (run_id,)
                ).fetchall()

                warnings_sample = [
                    {
                        'type': row['warn_type'],
                        'variable': row['variable_name'],
                        'function': row['function_name'],
                        'severity': row['severity'],
                    }
                    for row in warning_rows
                ]

                return jsonify({
                    'run_id': run_id,
                    'kernel_version': summary_row['kernel_version'] or 'Unknown',
                    'nodes': {
                        'Function': int(summary_row['total_functions'] or 0),
                        'GlobalVariable': int(summary_row['total_variables'] or 0),
                    },
                    'edges': {
                        'CALLS': int(summary_row['total_calls'] or 0),
                        'READS': int(summary_row['total_reads'] or 0),
                        'WRITES': int(summary_row['total_writes'] or 0),
                    },
                    'top_variables': json.loads(summary_row['top_variables_json'] or '[]'),
                    'top_functions': json.loads(summary_row['top_functions_json'] or '[]'),
                    'warnings_sample': warnings_sample,
                    'analysis_files': int(summary_row['analysis_files'] or 0),
                })
        finally:
            conn.close()

    data = get_analysis_data_by_run(run_id) or {}
    
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
            "run_id": run_id,
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
            "run_id": run_id,
            "kernel_version": "Unknown",
            "nodes": {"Function": 0, "GlobalVariable": 0},
            "edges": {"CALLS": 0, "READS": 0, "WRITES": 0},
            "top_variables": [],
            "top_functions": [],
            "warnings_sample": [],
            "analysis_files": 0
        })


@app.route('/api/warnings', methods=['GET'])
def get_warnings():
    requested_run_id = request.args.get('run_id', default=None, type=str)
    target_name = request.args.get('target', default=None, type=str)
    run_id = get_active_run_id(requested_run_id, target_name)

    page = max(1, request.args.get('page', default=1, type=int))
    page_size = request.args.get('page_size', default=20, type=int)
    page_size = 20 if page_size is None else max(1, min(page_size, 200))
    severity = request.args.get('severity', default='', type=str).strip().upper()
    keyword = request.args.get('q', default='', type=str).strip()

    if not run_id:
        return jsonify({
            'run_id': None,
            'page': page,
            'page_size': page_size,
            'total': 0,
            'items': [],
        })

    where = ['run_id = ?']
    params = [run_id]

    if severity:
        where.append('severity = ?')
        params.append(severity)

    if keyword:
        where.append('(variable_name LIKE ? OR function_name LIKE ? OR raw_text LIKE ?)')
        like_expr = f'%{keyword}%'
        params.extend([like_expr, like_expr, like_expr])

    where_sql = ' AND '.join(where)
    offset = (page - 1) * page_size

    conn = get_db_connection()
    try:
        total = conn.execute(
            f'SELECT COUNT(1) AS c FROM warnings WHERE {where_sql}',
            params
        ).fetchone()['c']

        rows = conn.execute(
            f'''
            SELECT warn_type, severity, variable_name, function_name, raw_text
            FROM warnings
            WHERE {where_sql}
            ORDER BY id DESC
            LIMIT ? OFFSET ?
            ''',
            params + [page_size, offset]
        ).fetchall()

        items = [
            {
                'type': row['warn_type'],
                'severity': row['severity'],
                'variable': row['variable_name'],
                'function': row['function_name'],
                'raw_text': row['raw_text'] or '',
            }
            for row in rows
        ]

        return jsonify({
            'run_id': run_id,
            'page': page,
            'page_size': page_size,
            'total': int(total),
            'items': items,
        })
    finally:
        conn.close()


@app.route('/api/report/pdf', methods=['GET'])
def download_pdf_report():
    requested_run_id = request.args.get('run_id', default=None, type=str)
    target_name = request.args.get('target', default=None, type=str)
    run_id = get_active_run_id(requested_run_id, target_name)
    data = get_analysis_data_by_run(run_id) or {}

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


@app.route('/api/detections', methods=['GET'])
def get_detections():
    detection_type = request.args.get('type', default=None, type=str)
    requested_run_id = request.args.get('run_id', default=None, type=str)
    target_name = request.args.get('target', default=None, type=str)
    run_id = get_active_run_id(requested_run_id, target_name)

    if not run_id:
        return jsonify({
            'run_id': None,
            'type': detection_type,
            'issues': []
        })

    detector_summary = get_detector_summary_for_run(run_id, target_name)
    if detection_type == 'MemorySafety' and detector_summary.get('memory_safety', 0) == 0:
        return jsonify({'run_id': run_id, 'type': detection_type, 'issues': []})
    if detection_type == 'InfoLeak' and detector_summary.get('info_leak', 0) == 0:
        return jsonify({'run_id': run_id, 'type': detection_type, 'issues': []})
    if detection_type == 'PrivilegeEscalation' and detector_summary.get('privilege_escalation', 0) == 0:
        return jsonify({'run_id': run_id, 'type': detection_type, 'issues': []})
    if detection_type == 'TOCTOU' and detector_summary.get('toctou', 0) == 0:
        return jsonify({'run_id': run_id, 'type': detection_type, 'issues': []})

    json_backed_types = {'MemorySafety', 'InfoLeak', 'PrivilegeEscalation', 'TOCTOU'}
    if detection_type in json_backed_types:
        json_result = load_detector_issues_for_run(run_id, target_name, detection_type)
        if json_result['total_count'] > 0:
            return jsonify({
                'run_id': run_id,
                'type': detection_type,
                'issues': json_result['issues'],
                'total_count': json_result['total_count'],
                'returned_count': len(json_result['issues']),
                'truncated': json_result['total_count'] > len(json_result['issues']),
                'subtype_counts': json_result.get('subtype_counts', {}),
            })

    conn = get_db_connection()
    try:
        where = ['run_id = ?']
        params = [run_id]

        if detection_type:
            extra_where, extra_params = build_detection_where_clause(detection_type)
            where.extend(extra_where)
            params.extend(extra_params)

        where_sql = ' AND '.join(where)
        query_limit = 100
        if detection_type == 'MemorySafety' and detector_summary.get('memory_safety', 0) > 0:
            query_limit = min(500, int(detector_summary.get('memory_safety', 0)))
        elif detection_type == 'RaceCondition':
            query_limit = 500

        total_row = conn.execute(
            f'''
            SELECT COUNT(1) AS c
            FROM warnings
            WHERE {where_sql}
            ''',
            params
        ).fetchone()
        total_count = int(total_row['c'] or 0)

        rows = conn.execute(
            f'''
            SELECT warn_type, severity, variable_name, function_name, raw_text
            FROM warnings
            WHERE {where_sql}
            ORDER BY id DESC
            LIMIT ?
            ''',
            params + [query_limit]
        ).fetchall()

        issues = []
        for row in rows:
            raw_text = row['raw_text'] or ''
            function_name = row['function_name'] or 'unknown_function'
            variable_name = row['variable_name'] or 'unknown_variable'
            severity = row['severity'] or 'MEDIUM'
            lower_text = f"{raw_text} {function_name} {variable_name}".lower()

            issue = {
                'type': detection_type or 'General',
                'severity': severity.title(),
                'message': f"{row['warn_type']} warning detected",
                'variable': variable_name,
                'function': function_name,
                'file': 'kernel',
                'line': 1,
                'column': 1,
                'suggestion': 'Review the code for potential security issues',
            }

            if detection_type == 'MemorySafety':
                if 'free' in lower_text or 'kfree' in lower_text:
                    issue['type'] = 'UseAfterFree'
                    issue['message'] = f"Potential use-after-free around '{function_name}'"
                    issue['suggestion'] = 'Set pointer to NULL after free and avoid further dereference'
                elif row['warn_type'] == 'Write':
                    issue['type'] = 'BufferOverflow'
                    issue['message'] = f"Potential unsafe write to '{variable_name}'"
                    issue['suggestion'] = 'Add bounds checks and protect shared writes with synchronization'
                else:
                    issue['type'] = 'NullPointer'
                    issue['message'] = f"Potential unsafe read on '{variable_name}'"
                    issue['suggestion'] = 'Check pointer validity before dereference and synchronize reads'

            elif detection_type == 'RaceCondition':
                issue['type'] = row['warn_type'] if row['warn_type'] in ('Read', 'Write') else 'Deadlock'
                issue['message'] = f"Race condition on variable '{variable_name}'"
                issue['suggestion'] = 'Implement proper locking or use atomic operations'

            elif detection_type == 'InfoLeak':
                if any(k in lower_text for k in ['socket', 'send', 'recv', 'net', 'tcp', 'udp', 'copy_to_user']):
                    issue['type'] = 'Network'
                elif any(k in lower_text for k in ['file', 'fs', 'open', 'write', 'fwrite']):
                    issue['type'] = 'File'
                else:
                    issue['type'] = 'Log'

                if any(k in lower_text for k in ['password', 'passwd', 'pwd']):
                    issue['dataType'] = 'password'
                elif any(k in lower_text for k in ['key', 'secret', 'rsa', 'pem']):
                    issue['dataType'] = 'key'
                elif any(k in lower_text for k in ['token', 'jwt', 'oauth']):
                    issue['dataType'] = 'token'
                elif any(k in lower_text for k in ['card', 'cvv']):
                    issue['dataType'] = 'creditcard'
                else:
                    issue['dataType'] = 'personal'

                issue['message'] = f"Potential information leak in function '{function_name}'"
                issue['suggestion'] = 'Ensure sensitive data is masked or encrypted before logging/transmission/output'

            elif detection_type == 'PrivilegeEscalation':
                if any(k in lower_text for k in ['setuid', 'setgid', 'setfsuid', 'setfsgid']):
                    issue['type'] = 'PermissionBypass'
                elif any(k in lower_text for k in ['capable', 'cap_', 'cap_sys_admin']):
                    issue['type'] = 'CapabilityCheck'
                else:
                    issue['type'] = 'PrivilegedSyscall'

                issue['message'] = f"Privileged operation in function '{function_name}'"
                issue['suggestion'] = 'Verify permission/capability checks before privileged operations'

            elif detection_type == 'TOCTOU':
                if 'symlink' in lower_text:
                    issue['type'] = 'SymlinkAttack'
                elif any(k in lower_text for k in ['access', 'stat', 'lstat']) and any(k in lower_text for k in ['open', 'openat']):
                    issue['type'] = 'FileTOCTOU'
                else:
                    issue['type'] = 'RaceWindow'

                issue['checkFunction'] = 'access/stat'
                issue['useFunction'] = 'open/openat'
                issue['message'] = f"TOCTOU risk in function '{function_name}'"
                issue['suggestion'] = 'Use atomic operations and avoid check/use split paths'

            if raw_text:
                issue['raw_text'] = raw_text

            issues.append(issue)

        return jsonify({
            'run_id': run_id,
            'type': detection_type,
            'issues': issues,
            'total_count': total_count,
            'returned_count': len(issues),
            'truncated': total_count > len(issues),
        })
    finally:
        conn.close()


def build_detection_where_clause(detection_type):
    where_clauses = []
    where_params = []

    if detection_type == 'MemorySafety':
        where_clauses.append('(warn_type = ? OR warn_type = ?)')
        where_params.extend(['Read', 'Write'])

    elif detection_type == 'RaceCondition':
        where_clauses.append('(warn_type = ? OR warn_type = ?)')
        where_params.extend(['Read', 'Write'])

    elif detection_type == 'InfoLeak':
        leak_keywords = ['printk', 'pr_info', 'pr_debug', 'print', 'log', 'copy_to_user', 'copy_from_user']
        like_conditions = [f'(raw_text LIKE ? OR function_name LIKE ?)' for _ in leak_keywords]
        where_clauses.append(f"({' OR '.join(like_conditions)})")
        for keyword in leak_keywords:
            like_expr = f'%{keyword}%'
            where_params.extend([like_expr, like_expr])

    elif detection_type == 'PrivilegeEscalation':
        privilege_keywords = ['capable', 'setuid', 'setgid', 'setfsuid', 'setfsgid', 'mknod', 'chmod', 'chown']
        like_conditions = [f'(function_name LIKE ? OR raw_text LIKE ?)' for _ in privilege_keywords]
        where_clauses.append(f"({' OR '.join(like_conditions)})")
        for keyword in privilege_keywords:
            like_expr = f'%{keyword}%'
            where_params.extend([like_expr, like_expr])

    elif detection_type == 'TOCTOU':
        toctou_keywords = ['access', 'stat', 'lstat', 'open', 'openat']
        like_conditions = [f'(function_name LIKE ? OR raw_text LIKE ?)' for _ in toctou_keywords]
        where_clauses.append(f"({' OR '.join(like_conditions)})")
        for keyword in toctou_keywords:
            like_expr = f'%{keyword}%'
            where_params.extend([like_expr, like_expr])

    return where_clauses, where_params


def load_detector_issues_for_run(run_id, target_name, detection_type, limit=500):
    json_dirs = resolve_detection_json_dirs_for_run(run_id, target_name)
    detection_files = []
    for d in json_dirs:
        detection_files.extend(glob.glob(os.path.join(d, 'detections_*.json')))

    if not detection_files:
        return {'issues': [], 'total_count': 0, 'subtype_counts': {}}

    detection_files = sorted(detection_files, key=lambda p: os.path.getmtime(p), reverse=True)

    type_filters = {
        'MemorySafety': {'BufferOverflow', 'NullPointer', 'UseAfterFree'},
        'InfoLeak': {'InfoLeak'},
        'PrivilegeEscalation': {'PrivilegeEscalation'},
        'TOCTOU': {'TOCTOU'},
    }
    target_types = type_filters.get(detection_type, set())
    if not target_types:
        return {'issues': [], 'total_count': 0, 'subtype_counts': {}}

    issues = []
    total_count = 0
    subtype_counts = {}
    for path in detection_files:
        try:
            with open(path, 'r', encoding='utf-8', errors='ignore') as f:
                items = json.load(f)
        except Exception:
            continue

        if not isinstance(items, list):
            continue

        for item in items:
            if not isinstance(item, dict):
                continue

            raw_type = item.get('type')
            if raw_type not in target_types:
                continue

            message = str(item.get('message') or 'Security issue detected')
            lower_text = message.lower()

            normalized_type = raw_type
            if detection_type == 'InfoLeak':
                if any(k in lower_text for k in ['socket', 'send', 'recv', 'net', 'tcp', 'udp', 'copy_to_user']):
                    normalized_type = 'Network'
                elif any(k in lower_text for k in ['file', 'fs', 'open', 'write', 'fwrite']):
                    normalized_type = 'File'
                else:
                    normalized_type = 'Log'
            elif detection_type == 'PrivilegeEscalation':
                if any(k in lower_text for k in ['setuid', 'setgid', 'setfsuid', 'setfsgid']):
                    normalized_type = 'PermissionBypass'
                elif any(k in lower_text for k in ['capable', 'cap_', 'cap_sys_admin']):
                    normalized_type = 'CapabilityCheck'
                else:
                    normalized_type = 'PrivilegedSyscall'
            elif detection_type == 'TOCTOU':
                if 'symlink' in lower_text:
                    normalized_type = 'SymlinkAttack'
                elif any(k in lower_text for k in ['access', 'stat', 'lstat']) and any(k in lower_text for k in ['open', 'openat']):
                    normalized_type = 'FileTOCTOU'
                else:
                    normalized_type = 'RaceWindow'

            total_count += 1
            subtype_counts[normalized_type] = subtype_counts.get(normalized_type, 0) + 1

            if len(issues) >= limit:
                continue

            severity = str(item.get('severity') or 'MEDIUM').title()
            issue = {
                'type': normalized_type,
                'severity': severity,
                'message': message,
                'variable': item.get('variable') or 'unknown_variable',
                'function': item.get('function') or 'unknown_function',
                'file': item.get('file') or 'kernel',
                'line': int(item.get('line') or 1),
                'column': int(item.get('column') or 1),
                'suggestion': item.get('suggestion') or 'Review the code for potential security issues',
                'raw_text': message,
            }

            if detection_type == 'InfoLeak':
                if any(k in lower_text for k in ['password', 'passwd', 'pwd']):
                    issue['dataType'] = 'password'
                elif any(k in lower_text for k in ['key', 'secret', 'rsa', 'pem']):
                    issue['dataType'] = 'key'
                elif any(k in lower_text for k in ['token', 'jwt', 'oauth']):
                    issue['dataType'] = 'token'
                elif any(k in lower_text for k in ['card', 'cvv']):
                    issue['dataType'] = 'creditcard'
                elif any(k in lower_text for k in ['address', 'pointer', '%p']):
                    issue['dataType'] = 'address'
                else:
                    issue['dataType'] = 'personal'

            if detection_type == 'TOCTOU':
                issue['checkFunction'] = 'access/stat/permission'
                issue['useFunction'] = 'open/rename/unlink'

            issues.append(issue)

    return {
        'issues': issues,
        'total_count': total_count,
        'subtype_counts': subtype_counts,
    }


@app.route('/api/detections/summary', methods=['GET'])
def get_detection_summary():
    requested_run_id = request.args.get('run_id', default=None, type=str)
    target_name = request.args.get('target', default=None, type=str)
    run_id = get_active_run_id(requested_run_id, target_name)

    if not run_id:
        return jsonify({
            'run_id': None,
            'memory_safety': 0,
            'race_condition': 0,
            'info_leak': 0,
            'privilege_escalation': 0,
            'toctou': 0,
        })

    category_map = {
        'memory_safety': 'MemorySafety',
        'race_condition': 'RaceCondition',
        'info_leak': 'InfoLeak',
        'privilege_escalation': 'PrivilegeEscalation',
        'toctou': 'TOCTOU',
    }

    detector_summary = get_detector_summary_for_run(run_id, target_name)

    conn = get_db_connection()
    try:
        summary = {'run_id': run_id}
        for key, detection_type in category_map.items():
            where = ['run_id = ?']
            params = [run_id]

            extra_where, extra_params = build_detection_where_clause(detection_type)
            where.extend(extra_where)
            params.extend(extra_params)

            where_sql = ' AND '.join(where)
            row = conn.execute(
                f'SELECT COUNT(1) AS c FROM warnings WHERE {where_sql}',
                params,
            ).fetchone()
            summary[key] = int(row['c'] or 0)

        # 用探测器真实统计覆盖对应模块，避免模块间数据“看起来一样”。
        summary['memory_safety'] = int(detector_summary.get('memory_safety', summary['memory_safety']))
        summary['info_leak'] = int(detector_summary.get('info_leak', summary['info_leak']))
        summary['privilege_escalation'] = int(detector_summary.get('privilege_escalation', summary['privilege_escalation']))
        summary['toctou'] = int(detector_summary.get('toctou', summary['toctou']))

        return jsonify(summary)
    finally:
        conn.close()


if __name__ == '__main__':
    print("Starting Kernel Safety Analysis Backend API Server on port 5000...")
    app.run(host='0.0.0.0', port=5000, debug=False)
