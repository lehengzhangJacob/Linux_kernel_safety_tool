#!/bin/bash
# 稳定启动后端服务脚本

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BACKEND_DIR="$PROJECT_ROOT/web_dashboard/backend"
LOG_FILE="$PROJECT_ROOT/logs/backend.log"
PID_FILE="$PROJECT_ROOT/logs/backend.pid"

# 确保日志目录存在
mkdir -p "$PROJECT_ROOT/logs"

# 检查是否已经在运行
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if ps -p "$OLD_PID" > /dev/null 2>&1; then
        echo "[INFO] 后端服务已在运行 (PID: $OLD_PID)"
        echo "[INFO] 访问地址: http://localhost:5000"
        exit 0
    else
        echo "[INFO] 清理旧的 PID 文件"
        rm -f "$PID_FILE"
    fi
fi

# 清理可能残留的旧进程
echo "[*] 清理残留进程..."
pkill -9 -f "python app.py" 2>/dev/null || true
sleep 2

# 检查端口是否被占用
if ss -tlnp | grep -q ":5000"; then
    echo "[WARNING] 端口 5000 被占用，尝试释放..."
    fuser -k 5000/tcp 2>/dev/null || true
    sleep 1
fi

# 启动后端服务
echo "[*] 启动后端服务..."
cd "$BACKEND_DIR"
source venv/bin/activate
nohup python app.py > "$LOG_FILE" 2>&1 &
NEW_PID=$!

# 保存 PID
echo $NEW_PID > "$PID_FILE"

# 等待服务启动
echo "[*] 等待服务启动..."
for i in {1..30}; do
    if curl -s http://localhost:5000/api/status > /dev/null 2>&1; then
        echo "[✓] 后端服务启动成功！"
        echo "[✓] 访问地址: http://localhost:5000"
        echo "[✓] API 地址: http://localhost:5000/api"
        echo "[✓] 日志文件: $LOG_FILE"
        exit 0
    fi
    sleep 1
done

echo "[-] 后端服务启动超时，请检查日志: $LOG_FILE"
exit 1
