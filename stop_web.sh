#!/bin/bash
set -euo pipefail

HOST="${HOST:-0.0.0.0}"
FRONTEND_PORT="${FRONTEND_PORT:-3001}"

echo "[*] 停止 Web 服务..."
pkill -f "python app.py" || true
pkill -f "vite --host $HOST --port $FRONTEND_PORT" || true
pkill -f "npm run dev -- --host $HOST --port $FRONTEND_PORT" || true

sleep 1

if ss -lntp | grep -q ":5000"; then
  echo "[-] 后端仍在运行，请手动检查。"
else
  echo "[+] 后端已停止"
fi

if ss -lntp | grep -q ":$FRONTEND_PORT"; then
  echo "[-] 前端仍在运行，请手动检查。"
else
  echo "[+] 前端已停止"
fi
