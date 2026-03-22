#!/bin/bash
# 一键启动脚本 - 启动前端和后端服务

set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# 项目根目录
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 确保日志目录存在
mkdir -p "$PROJECT_ROOT/logs"

# 清理旧进程
echo "[*] 清理旧进程..."
pkill -9 -f "python app.py" 2>/dev/null || true
pkill -9 -f "vite" 2>/dev/null || true
pkill -9 -f "npm run dev" 2>/dev/null || true
sleep 2

# 检查端口是否被占用
echo "[*] 检查端口占用情况..."
if ss -tlnp | grep -q ":5000"; then
    echo "[WARNING] 端口 5000 被占用，尝试释放..."
    fuser -k 5000/tcp 2>/dev/null || true
    sleep 1
fi

if ss -tlnp | grep -q ":5173"; then
    echo "[WARNING] 端口 5173 被占用，尝试释放..."
    fuser -k 5173/tcp 2>/dev/null || true
    sleep 1
fi

# 启动后端服务
echo "[*] 启动后端服务..."
cd "$PROJECT_ROOT/web_dashboard/backend"
. venv/bin/activate
nohup python app.py > "$PROJECT_ROOT/logs/backend.log" 2>&1 &
BACKEND_PID=$!

echo $BACKEND_PID > "$PROJECT_ROOT/logs/backend.pid"

# 启动前端服务
echo "[*] 启动前端服务..."
cd "$PROJECT_ROOT/web_dashboard/frontend"
nohup npm run dev -- --host 0.0.0.0 --port 5173 > "$PROJECT_ROOT/logs/frontend.log" 2>&1 &
FRONTEND_PID=$!

echo $FRONTEND_PID > "$PROJECT_ROOT/logs/frontend.pid"

# 等待服务启动
echo "[*] 等待服务启动..."
sleep 3

# 检查后端服务状态
echo "[*] 检查后端服务状态..."
for i in {1..20}; do
    if curl -s http://localhost:5000/api/status > /dev/null 2>&1; then
        echo "[✓] 后端服务启动成功！"
        echo "[✓] 访问地址: http://localhost:5000"
        echo "[✓] API 地址: http://localhost:5000/api"
        echo "[✓] 日志文件: $PROJECT_ROOT/logs/backend.log"
        break
    fi
    sleep 1
done

# 检查前端服务状态
echo "[*] 检查前端服务状态..."
for i in {1..20}; do
    if curl -s http://localhost:5173 > /dev/null 2>&1; then
        echo "[✓] 前端服务启动成功！"
        echo "[✓] 访问地址: http://localhost:5173"
        echo "[✓] 日志文件: $PROJECT_ROOT/logs/frontend.log"
        break
    fi
    sleep 1
done

echo ""
echo "[✓] 一键启动完成！"
echo ""
echo "服务状态："
echo "  前端: http://localhost:5173"
echo "  后端: http://localhost:5000"
echo ""
echo "停止服务命令："
echo "  pkill -9 -f 'python app.py' && pkill -9 -f 'vite'"
echo ""
echo "查看日志："
echo "  后端: tail -f $PROJECT_ROOT/logs/backend.log"
echo "  前端: tail -f $PROJECT_ROOT/logs/frontend.log"
