#!/bin/bash
# 稳定启动前端服务脚本（支持端口自动回退，支持 BACKEND_URL）

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FRONTEND_DIR="$PROJECT_ROOT/web_dashboard/frontend"
LOG_DIR="$PROJECT_ROOT/logs"
PID_FILE="$LOG_DIR/frontend.pid"
PORT_FILE="$LOG_DIR/frontend.port"
BACKEND_PORT_FILE="$LOG_DIR/backend.port"

mkdir -p "$LOG_DIR"

pick_free_port() {
  local base="$1"
  local max_try=30
  local p
  for ((i=0; i<max_try; i++)); do
    p=$((base+i))
    if ! ss -ltnH | awk '{print $4}' | grep -Eq "(:|\])${p}$"; then
      echo "$p"
      return 0
    fi
  done
  return 1
}

choose_log_file() {
  local preferred="$1"
  # 若无法写入（例如文件被 root 拥有），则退化为带端口/时间戳的新文件
  if ( : > "$preferred" ) 2>/dev/null; then
    echo "$preferred"
    return 0
  fi
  local ts
  ts=$(date +%s)
  echo "$LOG_DIR/frontend_${ts}.log"
}

# 如果 PID 文件存在且进程还活着，就直接复用
if [ -f "$PID_FILE" ]; then
  OLD_PID=$(cat "$PID_FILE" 2>/dev/null || true)
  if [ -n "$OLD_PID" ] && ps -p "$OLD_PID" > /dev/null 2>&1; then
    OLD_PORT=$(cat "$PORT_FILE" 2>/dev/null || echo 5173)
    echo "[INFO] 前端服务已在运行 (PID: $OLD_PID, port: $OLD_PORT)"
    echo "[INFO] 访问地址: http://localhost:$OLD_PORT"
    exit 0
  fi
fi

# 尝试清理本用户残留进程
echo "[*] 清理残留前端进程(仅当前用户可清理)..."
pkill -f "vite" 2>/dev/null || true
pkill -f "npm run dev" 2>/dev/null || true
sleep 1

FRONTEND_PORT=$(pick_free_port 5173)
if [ -z "$FRONTEND_PORT" ]; then
  echo "[-] 无法找到可用前端端口(从 5173 起尝试 30 个)"
  exit 1
fi

echo "$FRONTEND_PORT" > "$PORT_FILE"

# 自动确定后端 URL：优先使用环境变量，其次读取 backend.port
if [ -z "$BACKEND_URL" ]; then
  if [ -f "$BACKEND_PORT_FILE" ]; then
    BP=$(cat "$BACKEND_PORT_FILE" 2>/dev/null || echo 5000)
    BACKEND_URL="http://localhost:${BP}"
  else
    BACKEND_URL="http://localhost:5000"
  fi
fi

LOG_FILE=$(choose_log_file "$LOG_DIR/frontend.log")

echo "[*] 启动前端服务 (port: $FRONTEND_PORT, backend: $BACKEND_URL)..."
cd "$FRONTEND_DIR"
BACKEND_URL="$BACKEND_URL" FRONTEND_PORT="$FRONTEND_PORT" nohup npm run dev -- --host 0.0.0.0 --port "$FRONTEND_PORT" > "$LOG_FILE" 2>&1 &
NEW_PID=$!

echo "$NEW_PID" > "$PID_FILE"

echo "$LOG_FILE" > "$LOG_DIR/frontend.log_path"

# 等待服务启动
for i in {1..40}; do
  if curl -s "http://127.0.0.1:${FRONTEND_PORT}" > /dev/null 2>&1; then
    echo "[✓] 前端服务启动成功！"
    echo "[✓] 访问地址: http://localhost:${FRONTEND_PORT}"
    echo "[✓] 日志文件: $LOG_FILE"
    exit 0
  fi
  sleep 1
done

echo "[-] 前端服务启动超时，请检查日志: $LOG_FILE"
exit 1
