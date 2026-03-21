# 使用指南

## 环境安装与配置

### 1. 安装 GCC 插件开发依赖及内核构建工具

本项目包含一个自定义的 GCC 插件（源码位于 `src/plugin/`），该插件会在运行分析脚本时**自动编译**。
因此，您不需要“安装”插件本身，但需要安装编译它所需的**开发头文件** (`gcc-*-plugin-dev`)。

此外，编译 Linux 内核也需要一系列基础工具（如 `bc`, `bison`, `flex` 等）。

**Ubuntu/Debian 安装命令：**

```bash
sudo apt update

# 1. 安装 GCC 及其插件开发包
# 注意：请确保安装的 plugin-dev 版本与您使用的 gcc 版本一致 (此处以 GCC 13 为例)
sudo apt install -y gcc-13 g++-13 gcc-13-plugin-dev

# 2. 安装 Linux 内核编译依赖
# 包含：构建工具(make, gcc), 文本处理(bison, flex), 算术工具(bc), 压缩库(libssl), ELF工具(libelf), BTF工具(dwarves), 其他(rsync, cpio)
sudo apt install -y build-essential libncurses-dev bison flex libssl-dev libelf-dev bc dwarves rsync cpio
```

### 2. 配置 Neo4j 和 JDK (便携式集成)

为了简化部署，本项目在 `tools/` 目录下内置了所需的运行时环境安装包，**无需**您手动去官网下载或配置全局环境变量。

* **JDK 17**: `tools/openjdk-17.0.2_linux-x64_bin.tar.gz`
* **Neo4j 4.4**: `tools/neo4j-community-4.4.34-unix.tar.gz`

> **注意**：如果 `tools/` 目录下的文件夹运行不正常，您可以尝试手动解压上述压缩包。

只需运行一次初始化脚本即可就绪：

```bash
./setup_tools.sh
```

该脚本会自动检测 `tools/` 目录下的环境状态：

1. **如果已安装**（目录完整）：直接跳过，无需任何操作。
2. **如果仅有压缩包**：直接解压安装，无需联网。
3. **如果缺失文件**：自动从官网下载并安装。

*注：项目脚本 (`full_run.sh` 等) 会自动引用 `tools/` 下的局部环境，不会影响您系统中已安装的 Java 版本。*

## 运行分析

### 1. 一键全流程 (推荐)

使用 `full_run.sh` 脚本可以自动完成清理、编译、分析、数据导入和数据库启动的所有步骤：

```bash
./full_run.sh
```

该脚本将执行以下操作：

1. 停止正在运行的 Neo4j 服务。
2. 清理旧的构建目录 (`build_analysis_linux-6.6.1`) 以强制重新分析。
3. 调用 `run_analysis.sh` 编译内核并运行 GCC 插件。
4. 将生成的 JSON 数据转换为 CSV 并导入 Neo4j 数据库。
5. 使用内置的 Java 环境启动 Neo4j 服务。

完成后，请访问 **http://localhost:7474** 查看可视化结果。

* **连接地址**: `bolt://localhost:7687`
* **认证方式**: 选择 **"No Authentication"** (无需用户名/密码)

### 2. 分析其他内核版本 (进阶)

本项目根目录下提供了多个版本的 Linux 内核源码包（如 `linux-5.15.145.tar.xz`, `linux-6.11.10.tar.xz` 等）。您可以按照以下步骤分析其他版本：

1. **解压源码包**：

   ```bash
   tar -xvf linux-6.11.10.tar.xz
   ```
2. **运行分析**：
   `full_run.sh` 支持传入内核目录名作为参数：

   ```bash
   ./full_run.sh linux-6.11.10
   ```

   此命令将自动创建对应的构建目录 (`build_analysis_linux-6.11.10`) 和数据目录 (`neo4j_data_linux-6.11.10`)，互不干扰。

### 3. 单独启动数据库

如果你已经运行过分析，只想启动数据库查看结果：

```bash
./start_neo4j.sh
```

服务启动后，请在浏览器中访问 **http://localhost:7474**。

* **连接地址**: `bolt://localhost:7687`
* **认证方式**: 选择 **"No Authentication"** (无需用户名/密码)

### 4. 测试工具链

要在不构建整个内核的情况下测试插件逻辑和数据生成流程：

```bash
./test_toolchain.sh
```

这将编译并分析 `test/viz_test.c`，生成独立的测试数据并验证 CSV 输出。

### 5. 环境初始化

首次配置环境时，使用 `setup_tools.sh` 自动下载并配置所需的 JDK 和 Neo4j 依赖：

```bash
./setup_tools.sh
```

### 6. 清理构建环境

如果需要强制重新分析或释放空间，使用 `clean.sh` 清理构建产物：

```bash
./clean.sh
```

### 7. 仅运行核心分析

如果不需要数据库操作，仅需运行 GCC 插件进行静态分析：

```bash
./run_analysis.sh
```

## 脚本功能速查表

| 脚本名称              | 功能描述                                                                                | 典型使用场景                                     |
| :-------------------- | :-------------------------------------------------------------------------------------- | :----------------------------------------------- |
| `full_run.sh`       | **一键启动脚本**。串行执行清理、编译分析、数据转换、数据库导入和启动服务。        | 首次运行或需要全量重新分析时使用。               |
| `run_analysis.sh`   | **核心分析脚本**。负责配置内核构建参数，加载 GCC 插件并触发内核编译过程。         | 仅需重新运行静态分析（不涉及数据库操作）时使用。 |
| `start_neo4j.sh`    | **数据库启动脚本**。配置内置 JDK 环境并启动 Neo4j 服务。                          | 分析数据已导入，仅需启动可视化界面时使用。       |
| `clean.sh`          | **清理脚本**。停止数据库服务并清理内核构建产物 (`build_analysis_linux-6.6.1`)。 | 需要释放磁盘空间或强制重构时使用。               |
| `setup_tools.sh`    | **环境初始化脚本**。自动下载并配置项目所需的 JDK 17 和 Neo4j 4.4.34 二进制包。    | 在新环境中首次部署项目时运行。                   |
| `test_toolchain.sh` | **单元测试脚本**。针对 `test/viz_test.c` 运行插件，验证分析逻辑的正确性。       | 开发插件新功能后进行快速回归测试。               |

## 可视化查询 (Neo4j)

请参考项目根目录下的 `NEO4J_QUERIES.md` 文件，其中包含了多种实用的 Cypher 查询语句，例如：

* 查看特定全局变量的调用链。
* 查找被访问次数最多的“热点”变量。
* 分析潜在的竞态条件。

## 解读输出

### 1. 竞争警告 (`race_warnings_*.txt`)

这是最重要的输出文件，包含潜在的并发错误。
格式示例：

```text
[RACE_WARNING] Function 'vulnerable_function': Unprotected Write to global variable 'shared_counter' (No locks held)
```

* **Function**: 发生访问的函数。
* **Type**: `Read` (读取) 或 `Write` (写入)。
* **Variable**: 被访问的全局变量名称。
* **Context**: `(No locks held)` 表示访问时锁集为空。

### 2. 分析日志 (`analysis.log`)

包含所有检测到的事件的流水账：

```text
[GLOBAL_WRITE] Function: update_config, Variable: system_state
[LOCK_ACQUIRE] Function: update_config, Lock: config_lock
```

### 3. AST 日志 (`ast.log`)

显示代码的内部结构（GIMPLE），用于调试插件逻辑：

```text
Function: update_config
  Basic Block 2:
    gimple_call <spin_lock, &config_lock>  // [LOCK_ACQUIRE] detected
    gimple_assign <system_state, 1>        // [GLOBAL_WRITE] detected
```
