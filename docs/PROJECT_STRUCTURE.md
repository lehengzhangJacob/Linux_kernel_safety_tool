# 项目结构说明

## 目录结构

```
linux_kernel_safety_tool/
├── bin/                          # 可执行文件目录
│   └── kernel_analyzer           # 内核分析器主程序
├── data/                         # 数据目录
│   ├── input/                    # 输入数据
│   └── output/                   # 输出数据
│       ├── graphs/                # 图表文件
│       └── race_warnings_linux-6.6.1_display.txt  # 竞态警告显示文件
├── docs/                         # 文档目录
│   ├── README.md                 # 项目说明文档
│   ├── USAGE.md                 # 使用说明文档
│   ├── NEO4J_SETUP.md          # Neo4j配置文档
│   ├── NEO4J_QUERIES.md        # Neo4j查询文档
│   └── PROJECT_STRUCTURE.md      # 项目结构说明（本文件）
├── scripts/                      # 脚本目录
│   ├── install.sh               # 安装脚本
│   ├── uninstall.sh             # 卸载脚本
│   ├── setup_tools.sh          # 工具设置脚本
│   ├── run_analysis.sh         # 运行分析脚本
│   ├── full_run.sh            # 完整运行脚本
│   ├── start_web.sh           # 启动Web服务脚本
│   ├── start_neo4j.sh         # 启动Neo4j脚本
│   ├── clean.sh               # 清理脚本
│   ├── test_toolchain.sh      # 测试工具链脚本
│   └── export_to_neo4j.py     # 导出到Neo4j工具
├── src/                          # 源代码目录
│   ├── main.c                   # 主程序源代码
│   └── plugin/                  # 插件目录
│       ├── analyzer_plugin.cpp   # 分析器插件源代码
│       ├── analyzer_plugin.so   # 分析器插件编译文件
│       └── Makefile           # 插件编译配置
├── test/                         # 测试目录
│   ├── sample_kernel.c          # 示例内核代码
│   ├── test_plugin.c           # 插件测试代码
│   ├── viz_test.c              # 可视化测试代码
│   └── real_kernel/            # 真实内核测试
│       └── kernel/
│           └── panic.c
├── tools/                        # 工具目录
│   ├── jdk-17.0.2/            # Java 运行环境（自动下载）
│   └── neo4j-community-4.4.34/ # Neo4j 数据库（自动下载）
├── web_dashboard/               # Web仪表板
│   ├── backend/                # 后端服务
│   │   ├── app.py           # Flask应用
│   │   └── data/            # 后端数据目录
│   │       └── analysis.db  # SQLite数据库
│   ├── frontend/               # 前端服务
│   │   ├── src/             # Vue源代码
│   │   │   ├── components/  # Vue组件
│   │   │   │   ├── Home.vue
│   │   │   │   └── Dashboard.vue
│   │   │   ├── styles/      # 样式文件
│   │   │   │   └── main.css
│   │   │   ├── App.vue       # 根组件
│   │   │   └── main.js       # 入口文件
│   │   ├── dist/            # 构建输出
│   │   ├── index.html        # 入口文件
│   │   ├── package.json      # 依赖配置
│   │   ├── vite.config.js    # Vite配置
│   │   └── tailwind.config.js # Tailwind配置
│   └── data/                   # Web数据目录
├── Makefile                     # 编译配置
├── requirements.txt             # Python依赖配置
├── LICENSE                      # 许可证
├── .gitattributes              # Git属性配置
└── .gitignore                 # Git忽略配置
```

## 目录说明

### 核心目录

- **bin/**: 编译后的可执行文件
- **src/**: 所有源代码，包括主程序和 GCC 插件
- **scripts/**: 所有自动化脚本
- **tools/**: 外部工具（JDK 和 Neo4j），由 setup_tools.sh 自动下载
- **web_dashboard/**: Web 前后端应用

### 数据目录

- **data/**: 分析输入输出数据
  - **input/**: 输入数据
  - **output/**: 输出数据（图表、警告等）

### 文档目录

- **docs/**: 所有项目文档
  - **README.md**: 项目概述和快速开始
  - **USAGE.md**: 详细使用指南
  - **NEO4J_SETUP.md**: Neo4j 安装配置
  - **NEO4J_QUERIES.md**: Neo4j 查询示例
  - **PROJECT_STRUCTURE.md**: 本文件

### 测试目录

- **test/**: 测试代码和示例
  - **sample_kernel.c**: 简单的内核代码示例
  - **test_plugin.c**: GCC 插件测试
  - **viz_test.c**: 可视化测试
  - **real_kernel/**: 真实内核测试用例

## 构建产物（.gitignore）

以下文件和目录会被 Git 忽略：

### 编译产物
- `build_analysis_*/`: 内核构建目录
- `*.o`, `*.a`, `*.so`: 编译中间文件
- `kernel_analyzer`: 主程序可执行文件

### 工具文件
- `tools/jdk-*/`: JDK 安装目录
- `tools/neo4j-community-*/`: Neo4j 安装目录
- `tools/*.tar.gz`: 工具压缩包
- `neo4j_data_*/`: Neo4j 数据目录

### 日志文件
- `*.log`: 所有日志文件
- `*_display.log`: 显示日志

### 分析数据
- `analysis_data/`: 分析数据目录
- `analysis_*.log`: 分析日志
- `ast_*.log`: AST 日志
- `race_warnings_*.txt`: 竞态警告文件

### Web 相关
- `web_dashboard/frontend/node_modules/`: 前端依赖
- `web_dashboard/frontend/dist/`: 前端构建输出
- `web_dashboard/backend/venv/`: Python 虚拟环境
- `web_dashboard/backend/__pycache__/`: Python 缓存
- `web_dashboard/backend/data/*.db`: SQLite 数据库

### 其他
- `linux-*/`: 内核源码目录
- `*.tmp`, `*.bak`, `*.swp`: 临时文件
- `__pycache__/`, `*.pyc`: Python 缓存
- `.vscode/`, `.idea/`: IDE 配置

## 使用说明

### 首次安装

```bash
# 1. 运行安装脚本
./scripts/install.sh

# 2. 安装会自动：
#    - 安装系统依赖（gcc, nodejs, npm 等）
#    - 下载并解压 JDK 17 到 tools/jdk-17.0.2/
#    - 下载并解压 Neo4j 到 tools/neo4j-community-4.4.34/
#    - 编译 GCC 插件
#    - 编译主程序 kernel_analyzer
```

### 运行分析

```bash
# 使用主程序
./bin/kernel_analyzer analyze

# 或使用脚本
./scripts/full_run.sh
```

### 启动 Web 服务

```bash
# 使用启动脚本
./scripts/start_web.sh

# 访问
# 前端: http://localhost:3001
# 后端: http://localhost:5000/api/status
```

### 清理构建产物

```bash
# 使用清理脚本
./scripts/clean.sh

# 这会删除：
# - build_analysis_*/ 构建目录
# - analysis_data/ 分析数据
# - neo4j_data_*/ Neo4j 数据
```

## 注意事项

1. **工具目录**: JDK 和 Neo4j 会被下载到 `tools/` 目录，不要手动移动
2. **构建产物**: 所有构建产物都在 `.gitignore` 中，不会被提交到 Git
3. **数据目录**: 分析结果会保存在 `data/output/` 目录
4. **Web 数据**: Web 服务的临时数据会保存在 `web_dashboard/backend/data/` 目录
5. **路径问题**: 所有脚本都使用相对路径，可以从任何目录执行
