# Neo4j 配置指南

## 🔧 安装步骤

### 1. 已完成的安装

**JDK 17 已安装**:
- 版本: jdk-17.0.2
- 位置: `tools/jdk-17.0.2/`
- 状态: ✅ 已就绪

### 2. 需要下载的文件

**Neo4j 社区版** (需要手动下载):
- 推荐版本: neo4j-community-4.4.34
- 下载地址: https://neo4j.com/download-center/#community
- 或使用官方镜像: https://dist.neo4j.org/neo4j-community-4.4.34-unix.tar.gz

### 3. 解压文件

将下载的 Neo4j 文件解压到 `tools/` 目录:

```bash
# 解压 Neo4j
tar -xzf neo4j-community-4.4.34-unix.tar.gz -C tools/
```

### 4. 启动 Neo4j

```bash
# 运行启动脚本
./scripts/start_neo4j.sh
```

### 5. 首次登录

- 访问地址: http://localhost:7474
- 认证方式: 选择 **"No Authentication"** (无需用户名/密码)

**注意**: 本项目配置的 Neo4j 数据库使用无认证模式，可以直接访问。

## 📁 目录结构

```
tools/
├── jdk-17.0.2/          # Java 运行环境
└── neo4j-community-4.4.34/  # Neo4j 数据库
```

## 🔍 检查状态

```bash
# 检查 Neo4j 状态
./scripts/start_neo4j.sh status

# 停止 Neo4j
./scripts/start_neo4j.sh stop
```

## 📊 数据导入

使用项目中的导出工具将分析结果导入到 Neo4j:

```bash
# 导出分析结果到 Neo4j
python tools/export_to_neo4j.py
```

## ⚠️ 注意事项

1. **内存要求**: Neo4j 推荐至少 4GB 内存
2. **端口占用**: 确保 7474 (HTTP) 和 7687 (Bolt) 端口未被占用
3. **数据存储**: Neo4j 数据存储在 `neo4j-community-4.4.34/data/` 目录
4. **日志**: 查看 `neo4j-community-4.4.34/logs/` 目录了解运行状态

## 🛠️ 故障排除

- **启动失败**: 检查 Java 是否正确安装，端口是否被占用
- **内存不足**: 修改 `neo4j-community-4.4.34/conf/neo4j.conf` 中的内存配置
- **连接问题**: 检查防火墙设置，确保 7474 和 7687 端口开放

## 📞 支持

如果遇到问题，请参考 Neo4j 官方文档:
- https://neo4j.com/docs/
- https://neo4j.com/docs/operations-manual/current/installation/linux/