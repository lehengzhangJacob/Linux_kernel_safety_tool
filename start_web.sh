#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$ROOT_DIR/web_dashboard/backend"
FRONTEND_DIR="$ROOT_DIR/web_dashboard/frontend"

BACKEND_PORT="${BACKEND_PORT:-5000}"
FRONTEND_PORT="${FRONTEND_PORT:-3001}"
HOST="${HOST:-0.0.0.0}"

BACKEND_LOG="/tmp/kernel_web_backend.log"
FRONTEND_LOG="/tmp/kernel_web_frontend.log"
BACKEND_PID_FILE="/tmp/kernel_web_backend.pid"
FRONTEND_PID_FILE="/tmp/kernel_web_frontend.pid"

echo "[*] Root: $ROOT_DIR"

if [ ! -d "$BACKEND_DIR" ] || [ ! -d "$FRONTEND_DIR" ]; then
  echo "[-] web_dashboard 目录不存在，路径检查失败。"
  exit 1
fi

if [ ! -x "$BACKEND_DIR/venv/bin/python" ]; then
  echo "[-] 后端虚拟环境不存在：$BACKEND_DIR/venv"
  echo "    请先在 $BACKEND_DIR 下创建并安装依赖。"
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "[-] npm 未安装，无法启动 Vue 前端。"
  exit 1
fi

if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
  echo "[-] 前端依赖不存在：$FRONTEND_DIR/node_modules"
  echo "    请先执行：cd $FRONTEND_DIR && npm install"
  exit 1
fi

echo "[*] 清理旧进程..."
pkill -f "python app.py" || true
pkill -f "vite --host $HOST --port $FRONTEND_PORT" || true

echo "[*] 启动后端 Flask (端口: $BACKEND_PORT)..."
(
  cd "$BACKEND_DIR"
  source venv/bin/activate
  nohup python app.py > "$BACKEND_LOG" 2>&1 &
  echo $! > "$BACKEND_PID_FILE"
)

echo "[*] 启动前端 Vue (端口: $FRONTEND_PORT)..."
(
  cd "$FRONTEND_DIR"
  nohup npm run dev -- --host "$HOST" --port "$FRONTEND_PORT" > "$FRONTEND_LOG" 2>&1 &
  echo $! > "$FRONTEND_PID_FILE"
)

sleep 2

echo "[*] 启动结果检查:"
if ss -lntp | grep -q ":$BACKEND_PORT"; then
  echo "    [+] Backend listening on :$BACKEND_PORT"
else
  echo "    [-] Backend 未监听，请查看日志: $BACKEND_LOG"
fi

if ss -lntp | grep -q ":$FRONTEND_PORT"; then
  echo "    [+] Frontend listening on :$FRONTEND_PORT"
else
  echo "    [-] Frontend 未监听，请查看日志: $FRONTEND_LOG"
fi

echo ""
echo "访问地址："
echo "  前端: http://<你的服务器IP>:$FRONTEND_PORT"
echo "  后端: http://<你的服务器IP>:$BACKEND_PORT/api/status"
echo ""
echo "日志文件："
echo "  $BACKEND_LOG"
echo "  $FRONTEND_LOG"
echo ""
echo "停止命令："
echo "  pkill -f 'python app.py' && pkill -f 'vite --host $HOST --port $FRONTEND_PORT'"
