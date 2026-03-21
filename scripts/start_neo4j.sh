#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# 项目根目录
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# 工具目录
TOOLS_DIR="$PROJECT_ROOT/tools"

# 检查工具目录
if [ ! -d "$TOOLS_DIR" ]; then
    echo "[ERROR] 工具目录不存在: $TOOLS_DIR"
    echo "请先创建工具目录并下载 JDK 和 Neo4j"
    exit 1
fi

# 查找JDK
JAVA_DIR=$(ls -d "$TOOLS_DIR/jdk-"* 2>/dev/null | head -1)
if [ -z "$JAVA_DIR" ]; then
    echo "[ERROR] JDK 未找到，请下载 JDK 17 并解压到 $TOOLS_DIR 目录"
    echo "推荐版本: jdk-17.0.2"
    exit 1
fi

# 查找Neo4j
NEO4J_DIR=$(ls -d "$TOOLS_DIR/neo4j-community-"* 2>/dev/null | head -1)
if [ -z "$NEO4J_DIR" ]; then
    echo "[INFO] Neo4j 未找到，以下是安装步骤："
    echo "1. 访问 https://neo4j.com/download-center/#community"
    echo "2. 下载 neo4j-community-4.4.34-unix.tar.gz"
    echo "3. 解压到 $TOOLS_DIR 目录: tar -xzf neo4j-community-4.4.34-unix.tar.gz -C $TOOLS_DIR/"
    echo "4. 再次运行此脚本"
    echo ""
    echo "[INFO] 其他服务状态:"
    echo "- 前端服务: http://localhost:3001"
    echo "- 后端服务: http://localhost:5000/api/status"
    echo "- SQLite 数据库: 已就绪"
    exit 0
fi

# 设置环境变量
export JAVA_HOME="$JAVA_DIR"
export PATH="$JAVA_HOME/bin:$PATH"

echo "[INFO] 工具目录: $TOOLS_DIR"
echo "[INFO] JDK 目录: $JAVA_DIR"
echo "[INFO] Neo4j 目录: $NEO4J_DIR"
echo "[INFO] 启动 Neo4j..."

# 启动Neo4j
"$NEO4J_DIR/bin/neo4j" start

# 检查启动状态
sleep 2
if "$NEO4J_DIR/bin/neo4j" status | grep -q "is running"; then
    echo "[SUCCESS] Neo4j 服务已成功启动"
    echo "[INFO] 访问地址: http://localhost:7474"
    echo "[INFO] 认证方式: No Authentication (无需用户名/密码)"
    echo ""
    echo "[INFO] 所有服务状态:"
    echo "- 前端服务: http://localhost:3001"
    echo "- 后端服务: http://localhost:5000/api/status"
    echo "- Neo4j 服务: http://localhost:7474"
    echo "- SQLite 数据库: 已就绪"
else
    echo "[ERROR] Neo4j 启动失败，请检查日志: $NEO4J_DIR/logs/"
fi
