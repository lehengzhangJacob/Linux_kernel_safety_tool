# 使用指南

## 环境要求
*   **操作系统**: Linux (推荐 Ubuntu/Debian)
*   **编译器**: GCC 13+ (必须支持插件开发)
*   **依赖项**:
    *   `gcc-13-plugin-dev` (或对应版本的插件头文件)
    *   `build-essential`
    *   `libgmp-dev`, `libmpc-dev`, `libmpfr-dev`
    *   `flex`, `bison`, `libssl-dev`, `libelf-dev` (内核构建依赖)

## 运行分析

### 1. 一键全流程 (推荐)
使用 `full_run.sh` 脚本可以自动完成清理、编译、分析、数据导入和数据库启动的所有步骤：

```bash
./full_run.sh
```

该脚本将执行以下操作：
1.  停止正在运行的 Neo4j 服务。
2.  清理旧的构建目录 (`build_analysis_linux-6.6.1`) 以强制重新分析。
3.  调用 `run_analysis.sh` 编译内核并运行 GCC 插件。
4.  将生成的 JSON 数据转换为 CSV 并导入 Neo4j 数据库。
5.  使用内置的 Java 环境启动 Neo4j 服务。

完成后，请访问 **http://localhost:7474** 查看可视化结果。

### 2. 单独启动数据库
如果你已经运行过分析，只想启动数据库查看结果：

```bash
./start_neo4j.sh
```

### 3. 测试工具链
要在不构建整个内核的情况下测试插件逻辑和数据生成流程：

```bash
./test_toolchain.sh
```

这将编译并分析 `test/viz_test.c`，生成独立的测试数据并验证 CSV 输出。

## 可视化查询 (Neo4j)
请参考项目根目录下的 `NEO4J_QUERIES.md` 文件，其中包含了多种实用的 Cypher 查询语句，例如：
*   查看特定全局变量的调用链。
*   查找被访问次数最多的“热点”变量。
*   分析潜在的竞态条件。

## 解读输出

### 1. 竞争警告 (`race_warnings_*.txt`)
这是最重要的输出文件，包含潜在的并发错误。
格式示例：
```text
[RACE_WARNING] Function 'vulnerable_function': Unprotected Write to global variable 'shared_counter' (No locks held)
```
*   **Function**: 发生访问的函数。
*   **Type**: `Read` (读取) 或 `Write` (写入)。
*   **Variable**: 被访问的全局变量名称。
*   **Context**: `(No locks held)` 表示访问时锁集为空。

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

---

# 开发者指南：如何编写 GCC 插件

本节简要介绍如何开发类似本项目的 GCC 插件。

## 1. 插件基础结构
GCC 插件是动态加载的共享库 (`.so`)。必须包含以下入口点：

```cpp
#include <gcc-plugin.h>
#include <plugin-version.h>

// 必须定义的标志，用于验证插件兼容性
int plugin_is_GPL_compatible;

// 插件入口函数
int plugin_init(struct plugin_name_args *plugin_info,
                struct plugin_gcc_version *version) {
    // 1. 检查 GCC 版本
    if (!plugin_default_version_check(version, &gcc_version))
        return 1;

    // 2. 注册回调或 Pass
    register_callback(plugin_info->base_name, PLUGIN_INFO, NULL, &my_plugin_info);
    
    // ... 注册自定义 Pass ...
    return 0;
}
```

## 2. 注册分析 Pass
GCC 编译过程分为多个 Pass (GIMPLE, RTL, IPA 等)。静态分析通常在 **IPA (Inter-procedural Analysis)** 或 **GIMPLE** 阶段进行。

### 定义 Pass
```cpp
const pass_data my_pass_data = {
    .type = SIMPLE_IPA_PASS, // 或 GIMPLE_PASS
    .name = "my_analyzer",
    .optinfo_flags = OPTGROUP_NONE,
    .tv_id = TV_NONE,
    .properties_required = PROP_cfg, // 需要控制流图
    .properties_provided = 0,
    .properties_destroyed = 0,
    .todo_flags_start = 0,
    .todo_flags_finish = 0,
};

class my_pass : public simple_ipa_opt_pass {
public:
    my_pass(gcc::context *ctxt) : simple_ipa_opt_pass(my_pass_data, ctxt) {}
    
    // 核心分析逻辑
    unsigned int execute(function *fun) override {
        // 遍历调用图节点
        struct cgraph_node *node;
        FOR_EACH_DEFINED_FUNCTION(node) {
            analyze_function(node);
        }
        return 0;
    }
};
```

## 3. 遍历 GIMPLE 指令
在 `execute` 函数中，你可以遍历函数的基本块 (Basic Blocks) 和语句 (Statements)：

```cpp
basic_block bb;
FOR_EACH_BB_FN(bb, fun) { // 遍历基本块
    for (gimple_stmt_iterator gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
        gimple *stmt = gsi_stmt(gsi); // 获取语句
        
        // 检查语句类型
        if (is_gimple_assign(stmt)) {
            // 处理赋值操作
        } else if (is_gimple_call(stmt)) {
            // 处理函数调用
            tree fndecl = gimple_call_fndecl(stmt);
            if (fndecl) {
                const char *name = IDENTIFIER_POINTER(DECL_NAME(fndecl));
                if (strcmp(name, "spin_lock") == 0) {
                    // 检测到锁获取
                }
            }
        }
    }
}
```

## 4. 编译插件
使用 `g++` 编译，需要指定插件头文件路径：

```bash
g++ -shared -fPIC -o my_plugin.so my_plugin.cpp \
    -I$(gcc -print-file-name=plugin)/include
```

## 5. 加载插件
在编译目标代码时使用 `-fplugin` 参数：

```bash
gcc -fplugin=./my_plugin.so -c target_code.c
```
