#!/bin/bash
# 稳定启动后端服务脚本（支持端口自动回退）

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BACKEND_DIR="$PROJECT_ROOT/web_dashboard/backend"
LOG_DIR="$PROJECT_ROOT/logs"
LOG_FILE="$LOG_DIR/backend.log"
PID_FILE="$LOG_DIR/backend.pid"
PORT_FILE="$LOG_DIR/backend.port"

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

# 如果 PID 文件存在且进程还活着，就直接复用
if [ -f "$PID_FILE" ]; then
  OLD_PID=$(cat "$PID_FILE" 2>/dev/null || true)
  if [ -n "$OLD_PID" ] && ps -p "$OLD_PID" > /dev/null 2>&1; then
    OLD_PORT=$(cat "$PORT_FILE" 2>/dev/null || echo 5000)
    echo "[INFO] 后端服务已在运行 (PID: $OLD_PID, port: $OLD_PORT)"
    echo "[INFO] API 地址: http://localhost:$OLD_PORT/api"
    exit 0
  fi
fi

# 尝试清理本用户残留进程（无法清理 root 残留时会自动换端口）
echo "[*] 清理残留后端进程(仅当前用户可清理)..."
pkill -f "$BACKEND_DIR/app.py" 2>/dev/null || true
ps -ef | grep -E "[p]ython\s+app\.py" | grep -v root >/dev/null 2>&1 && pkill -f "python app.py" 2>/dev/null || true
sleep 1

BACKEND_PORT=$(pick_free_port 5000)
if [ -z "$BACKEND_PORT" ]; then
  echo "[-] 无法找到可用后端端口(从 5000 起尝试 30 个)"
  exit 1
fi

echo "$BACKEND_PORT" > "$PORT_FILE"

echo "[*] 启动后端服务 (port: $BACKEND_PORT)..."
cd "$BACKEND_DIR"
source venv/bin/activate
BACKEND_PORT="$BACKEND_PORT" nohup python app.py > "$LOG_FILE" 2>&1 &
NEW_PID=$!

echo "$NEW_PID" > "$PID_FILE"

# 等待服务启动
for i in {1..40}; do
  if curl -s "http://127.0.0.1:${BACKEND_PORT}/api/status" > /dev/null 2>&1; then
    echo "[✓] 后端服务启动成功！"
    echo "[✓] API 地址: http://localhost:${BACKEND_PORT}/api"
    echo "[✓] 日志文件: $LOG_FILE"
    exit 0
  fi
  sleep 1
done

echo "[-] 后端服务启动超时，请检查日志: $LOG_FILE"
exit 1
