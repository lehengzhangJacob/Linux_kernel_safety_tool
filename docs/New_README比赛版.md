## Linux 内核静态分析与可视化平台（大数据赛道作品说明书 / 技术白皮书）

> 本文档面向：**计算机设计大赛（大数据赛道）**的作品提交、答辩陈述与技术白皮书撰写。
>
> 说明：仓库中 `README.md` 为简版入口；`docs/README.md` 为项目内部技术说明。本文为**比赛版 New_README**，强调赛道契合度、数据链路、工程化与创新点。

---

## 0. 快速结论（给评委/答辩）

- **作品是什么**：一套面向 Linux 内核/大型 C 代码库的**静态分析数据生产 + 治理 + 可视化**平台。
- **为什么属于大数据赛道**：它把“编译期语义”抽取为大规模结构化数据（函数、调用、全局读写、锁上下文、漏洞事件），形成 **JSON + 日志 + 图谱 CSV + SQLite** 的多层数据资产，并提供**统一查询、统计聚合与可视化决策面板**。
- **能做什么**：上传/选择代码 → 自动生成分析数据 → 形成多运行 `run_id` 历史 → 仪表盘统计、图谱采样、告警分页、五类专项漏洞视图、PDF 报告导出；可选导入 Neo4j 做深度图查询。

---

## 1. 作品背景与问题定义（赛道语境）

### 1.1 背景
Linux 内核属于典型的“超大规模工程代码库”，具有：
- **规模大**：文件、函数、调用关系数量巨大；
- **并发复杂**：锁、共享状态、全局变量读写交织；
- **安全风险高**：竞态、TOCTOU、信息泄露、权限提升、内存安全问题具有高危后果；
- **人工审计难**：仅靠人工浏览难以覆盖全局关系与跨文件影响。

### 1.2 问题
将内核这种“复杂系统”的安全审计抽象为数据问题，本质上需要：
- **稳定地产生可复用数据**（不是一次性的日志）；
- **统一的任务与版本管理**（多次运行、多份报告）；
- **可查询、可聚合、可视化的指标体系**（给到评审/开发可决策结果）；
- **在产物缺失/旧版本布局存在时具备自愈能力**（工程交付更关键）。

### 1.3 目标
本作品目标是构建“**编译期语义数据工厂 + 安全检测与图谱化 + Web 可视化平台**”，把审计结果沉淀为可持续迭代的数据资产。

---

## 2. 作品概述（面向答辩的描述）

### 2.1 作品名称
`linux_kernel_safety_tool`：Linux 内核静态分析与可视化平台。

### 2.2 适用对象
- 内核/驱动开发与安全审计团队
- 静态分析/安全竞赛项目展示
- 需要对大型 C 工程做编译期语义抽取与图谱化的人群

### 2.3 核心能力清单
- **数据采集**：GCC 插件在 GIMPLE/IPA 阶段抽取语义数据
- **安全检测**：多检测器输出结构化漏洞事件
- **数据治理**：多运行 `run_id`、SQLite 持久化、历史复用
- **数据组织**：JSON/日志/CSV/SQLite 分层存储
- **可视化**：仪表盘统计、图谱采样、分页告警、专项页面
- **报告输出**：PDF 导出
- **可选图数据库**：CSV → Neo4j 导入深度查询

---

## 3. 技术栈与工程形态

### 3.1 技术栈
- **前端**：Vue 3 + Vite + Vue Router + Axios + ECharts
- **后端**：Flask（Python）+ SQLite
- **分析引擎**：GCC Plugin（C++17）+ Bash 自动化（内核 Kbuild 触发）
- **图谱（可选）**：CSV ETL + Neo4j

### 3.2 工程形态
- Web 控制台负责“**任务/历史/展示**”，核心入口在 `web_dashboard/`
- 分析脚本负责“**一键驱动编译期抽取 + 产物生成**”，核心在 `scripts/run_analysis.sh`
- GCC 插件负责“**语义抽取 + 检测器执行 + 结构化输出**”，核心在 `src/plugin/`
- 数据产物按职责落盘到 `analysis_data/`、`logs/`、`web_dashboard/data/`、`web_dashboard/backend/data/analysis.db`

---

## 4. 大数据赛道契合度说明（核心论证）

### 4.1 数据规模与复杂性
本作品面向的对象（Linux 内核、或同规模 C 工程）具备典型的大数据特征：
- **数据源多样**：编译输出日志、函数语义、调用关系、变量读写、告警与漏洞事件
- **数据结构复杂**：函数—函数调用图、函数—全局变量读写图、锁上下文、漏洞事件多维属性
- **数据量可持续增长**：支持多运行 `run_id`，历史积累形成长期数据资产

### 4.2 数据链路完整
从数据采集到数据服务形成闭环：
- **采集**：GCC 编译期抽取（结构化 JSON）
- **治理**：`run_id` 运行单元、状态管理、结果复用
- **存储**：原始（JSON/日志）、中间（CSV）、服务化（SQLite）
- **服务**：统一 API（统计、图谱、分页告警、专项漏洞）
- **应用**：仪表盘、专项页、报告导出

### 4.3 数据服务化
平台将“分析产物”变为“可查询的数据服务”：
- SQLite 将适合查询/分页的摘要与告警固化（减少前端每次扫全量文件）
- API 按 `run_id` 提供稳定一致的数据接口
- 前端对统计/图谱/列表/专项视图形成完整的“数据产品”形态

---

## 5. 总体架构（白皮书级）

### 5.1 分层架构

```mermaid
flowchart TB
    subgraph UI[前端展示层 Vue3 + Vite]
        Home[首页：上传/启动/历史]
        Dash[仪表盘：统计/图谱/Top/告警]
        Views[专项页：五类漏洞视图]
    end

    subgraph API[后端服务层 Flask + SQLite]
        Upload[上传与归档]
        Runs[run_id 与运行记录]
        Scheduler[任务调度与状态]
        Parser[解析 JSON/日志/CSV]
        Store[SQLite 持久化]
        Report[PDF 报告导出]
    end

    subgraph Engine[分析执行层 GCC Plugin + Scripts]
        Script[scripts/run_analysis.sh]
        Build[GCC/Kbuild 编译流程]
        Plugin[src/plugin/analyzer_plugin.cpp]
        Detectors[检测器：6 个]
    end

    subgraph Data[数据层]
        RawJSON[analysis_data/**/data_*.json]
        DetectJSON[analysis_data/**/detections_*.json]
        Logs[logs/analysis_*.log & race_warnings_*.txt]
        CSV[logs/neo4j_data_*/nodes.csv edges.csv]
        DB[web_dashboard/backend/data/analysis.db]
        Neo4j[(Neo4j 可选)]
    end

    Home --> Upload
    Home --> Scheduler
    Dash --> Parser
    Views --> Parser

    Upload --> Runs
    Runs --> Store
    Scheduler --> Runs

    Scheduler --> Script
    Script --> Build
    Build --> Plugin
    Plugin --> Detectors

    Plugin --> RawJSON
    Plugin --> DetectJSON
    Script --> Logs
    Script --> CSV

    Parser --> RawJSON
    Parser --> DetectJSON
    Parser --> Logs
    Parser --> CSV
    Parser --> Store
    Store --> DB

    CSV --> Neo4j
```

### 5.2 关键设计点
- **以 `run_id` 作为“一次运行/一次数据快照”的唯一标识**：所有查询与展示都可复现到该运行。
- **原始数据与服务数据分层**：原始（JSON/日志）用于可追溯；服务化（SQLite）用于快速查询与分页。
- **可选图数据库**：Web 主流程不强依赖 Neo4j，但保留图查询扩展能力。

---

## 6. 目录结构（比赛讲解版）

```text
linux_kernel_safety_tool/
├── src/                        # GCC 插件与 CLI
│   ├── main.c                  # CLI 主程序
│   └── plugin/                 # analyzer_plugin.cpp + detectors/
├── scripts/                    # run_analysis.sh / start_all.sh 等
├── web_dashboard/
│   ├── backend/                # Flask app.py + SQLite
│   ├── frontend/               # Vue3 页面与可视化
│   └── data/                   # uploads/ 与 analysis_results/
├── analysis_data/              # 原始分析数据（JSON）与构建目录
├── logs/                       # 统一日志与 Neo4j CSV
├── tools/                      # export_to_neo4j.py + Neo4j/JDK（可选）
└── docs/                       # 文档目录
```

---

## 7. 核心功能与交互流程（答辩可直接照讲）

### 7.1 首页（任务入口）
首页承担“数据入口 + 任务控制 + 历史管理”三件事：
- **目标选择**：内置内核 / 上传文件夹 / 上传压缩包
- **任务控制**：启动分析、恢复最近任务、查看进度与滚动日志
- **历史管理**：按 `run_id` 打开历史报告、删除某次运行、（上传目标）清理全部结果

### 7.2 仪表盘（数据总览）
围绕一个 `run_id`，仪表盘聚合展示：
- **总体指标**：分析文件数、函数数、调用边、五类问题计数等
- **可视化**：类型分布、Top 10、高危全局变量与函数、拓扑图采样
- **明细列表**：分页告警（支持关键词与严重度筛选）

### 7.3 五类专项页面（结构化漏洞数据产品）
- `MemorySafety`（BufferOverflow / NullPointer / UseAfterFree）
- `RaceCondition`
- `InfoLeak`
- `PrivilegeEscalation`
- `TOCTOU`

专项页统一按 `run_id` + `type` 从后端拉取结构化漏洞列表，并提供筛选与统计展示。

### 7.4 报告输出
支持导出 PDF，形成可归档的审计报告（适合比赛提交与成果展示）。

---

## 8. 数据链路与产物规范（大数据赛道关键章节）

### 8.1 数据链路（端到端）

```mermaid
sequenceDiagram
    participant U as 用户
    participant FE as 前端(Vue)
    participant BE as 后端(Flask)
    participant SH as 脚本(run_analysis.sh)
    participant PL as GCC插件
    participant DB as SQLite

    U->>FE: 选择内置/上传源码
    FE->>BE: POST /api/scan (创建 run_id)
    BE->>DB: 写入 analysis_runs (running)
    BE->>SH: 后台线程启动分析
    SH->>PL: 编译触发插件运行
    PL-->>SH: 产生 data_*.json / detections_*.json / ast/log 输出
    SH-->>BE: 分析完成信号
    BE->>BE: 解析 JSON/日志/CSV
    BE->>DB: 写入 summary_stats / warnings / 状态完成
    FE->>BE: GET /api/stats /api/graph /api/detections /api/warnings
    BE-->>FE: 返回可视化所需数据
```

### 8.2 产物分层
- **原始结构化数据**（可追溯）：
  - `analysis_data/<target>/data_*.json`：函数语义（调用、全局读写等）
  - `analysis_data/<target>/detections_*.json`：结构化漏洞事件
- **运行日志**（可审计）：
  - `logs/analysis_<target>.log`：编译与分析全过程日志
  - `logs/ast_<target>.log`：插件调试/结构输出
  - `logs/race_warnings_<target>.txt`：竞态告警抽取
- **图谱 CSV**（可计算/可导入）：
  - `logs/neo4j_data_<target>/nodes.csv`、`edges.csv`
- **服务化数据**（可查询/可分页）：
  - `web_dashboard/backend/data/analysis.db`：`analysis_runs`、`warnings`、`summary_stats`

### 8.3 自愈/兜底（数据治理能力）
平台在“产物缺失/旧布局存在”时尽量保证展示不空：
- **CSV 缺失可重建**：缺少 `nodes.csv`/`edges.csv` 时，根据 `data_*.json` 调用 `tools/export_to_neo4j.py` 自动重建
- **分析文件数回退**：日志中统计失败时，可回退通过 `data_*.json` 数量估算
- **兼容旧目录布局**：在多处路径尝试读取历史产物，提升老数据复用率

---

## 9. 后端 API（答辩讲解版）

> 接口实现集中在 `web_dashboard/backend/app.py`，并以 `run_id` 为核心索引。

### 9.1 上传与任务
- `POST /api/upload`：上传文件夹/压缩包，写入 `web_dashboard/data/uploads/<target>/...`
- `GET /api/uploaded-archives`：列出历史上传压缩包目标
- `POST /api/scan`：创建运行记录并启动分析（或复用既有结果），返回 `run_id`
- `GET /api/scan/status`：查询运行状态/进度/日志（前端轮询）
- `GET /api/scan/recover`：恢复最近任务/结果

### 9.2 历史与系统状态
- `GET /api/history`：分页查询运行历史（支持条件筛选）
- `DELETE /api/history/<run_id>`：删除一次运行（上传目标可扩展清理全部结果）
- `GET /api/status`：探活

### 9.3 数据展示
- `GET /api/stats`：总览统计
- `GET /api/graph`：图谱采样（供拓扑展示）
- `GET /api/warnings`：告警分页（支持关键词/严重度）
- `GET /api/detections`：按 `type` 获取专项漏洞列表
- `GET /api/detections/summary`：五类专项计数摘要
- `GET /api/report/pdf`：导出 PDF

---

## 10. 分析引擎与检测器体系（白皮书级）

### 10.1 GCC 插件执行位置与原因
插件位于 `src/plugin/analyzer_plugin.cpp`，注册为 GCC 的 `simple_ipa_opt_pass` 并插入到特定 pass 之后执行。

选择编译期语义抽取的原因：
- 能得到更接近真实编译语义的中间表示（比纯文本扫描更可靠）
- 能天然关联函数、调用、变量读写与控制流片段

### 10.2 抽取的核心语义
对每个函数输出：
- 函数名
- 调用集合 `callees`
- 全局变量读取集合 `global_reads`
- 全局变量写入集合 `global_writes`

并维护过程间信息以支撑锁效应与竞态检测。

### 10.3 检测器（6 个）与前端五类归并
插件内注册 6 个检测器，前端按五类专项组织展示：
- `MemorySafety`：`BufferOverflow` / `NullPointer` / `UseAfterFree`
- `InfoLeak`
- `PrivilegeEscalation`
- `TOCTOU`
- `RaceCondition`（结合锁集与全局读写输出告警）

检测结果以 `detections_*.json` 结构化输出，并在后端聚合为摘要与列表。

---

## 11. 核心技术创新点（比赛重点章节）

> 本章是面向“大数据赛道”与“答辩创新点提问”的重点准备。

### 11.1 编译期语义数据工厂：用 GCC GIMPLE/IPA 抽取高可信结构化数据
- **创新点**：不同于文本正则或简单 AST 扫描，本作品在编译期进入 GCC 中间表示阶段，抽取函数调用、全局读写等语义数据。
- **价值**：数据质量更高，可支撑后续统计、图谱化、告警定位与可视化联动。

### 11.2 `run_id` 多运行快照：把一次分析固化为可复现的数据资产
- **创新点**：以 `run_id` 将一次运行的状态、产物与展示绑定，实现可回溯、可对比、可复盘。
- **价值**：符合大数据系统对“数据版本/批次”的管理要求，便于形成长期数据仓库。

### 11.3 原始数据与服务化数据分层：JSON/日志/CSV/SQLite 的多层治理
- **创新点**：原始 JSON/日志用于可追溯，CSV 用于图谱计算与导入，SQLite 用于高频查询/分页。
- **价值**：兼顾可解释性与交互性能，减少每次展示对海量文件的重复扫描。

### 11.4 结果自愈与兜底：面对缺产物/旧布局仍能稳定出数
- **创新点**：当 `nodes.csv`/`edges.csv` 缺失可由 `data_*.json` 重建；当日志统计失败可回退从 JSON 计数；兼容旧目录布局。
- **价值**：提升工程交付稳定性，适合比赛演示与长期迭代（“不会因为少一个文件就全空”）。

### 11.5 安全检测“产品化”：五类专项统一数据协议与页面呈现
- **创新点**：将检测器输出统一为结构化事件，按 `type` 形成五类专项“数据产品”，支持筛选、统计、列表化呈现。
- **价值**：把研究型检测输出转为可用的产品形态，提升可读性与演示表现。

### 11.6 图谱采样展示 + Neo4j 可选增强：兼顾轻量交互与深度查询
- **创新点**：Web 侧提供图谱采样满足交互展示，保留 CSV→Neo4j 的深度图查询能力。
- **价值**：在不强依赖重组件的前提下提供可扩展图能力，适合比赛环境的部署与演示。

### 11.7 在线任务调度与过程可观测：进度 + 日志滚动 + 恢复
- **创新点**：前端轮询状态与日志，支持恢复最近任务；后端管理运行状态并落 SQLite。
- **价值**：提升“可观测性”，让评委能看见平台在“跑数据—产出数据—服务数据”。

### 11.8 数据资产可输出：PDF 报告与可归档的运行目录
- **创新点**：对外输出 PDF 报告，并保留按 `run_id` 组织的结果目录。
- **价值**：符合比赛作品“成果可展示、可提交、可归档”的要求。

---

## 12. 运行与演示（比赛现场推荐脚本）

### 12.1 一键启动 Web 控制台

```bash
cd /home/ldd_team/linux_kernel_safety_tool
./scripts/start_all.sh
```

默认访问：
- 前端：`http://localhost:5173`
- 后端：`http://localhost:5000`

### 12.2 现场演示建议（3～5 分钟版本）
- **步骤 1**：进入首页，选择内置目标（如 `linux-6.6.1`），点击开始/打开报告
- **步骤 2**：进入仪表盘，讲清楚统计卡片、Top、图谱采样、告警分页
- **步骤 3**：切换五类专项页，展示结构化问题列表与筛选
- **步骤 4**：打开历史记录，说明 `run_id` 多次运行与复用
- **步骤 5**：导出 PDF，强调成果可提交与可归档

### 12.3 真实分析演示建议（时间充裕版本）
- 上传压缩包 → 启动审计 → 展示实时日志与进度 → 完成后切换仪表盘与专项页 → 在历史中看到新的 `run_id`

---

## 13. 环境与依赖（交付说明）

### 13.1 基础环境
- Linux（建议）
- GCC 工具链（用于编译期插件分析）
- Python（Flask 后端）
- Node.js（Vite 前端）

### 13.2 可选组件
- Neo4j：用于深度图查询（Web 主流程不强依赖）

---

## 14. 风险、边界与对策（答辩常问）

### 14.1 边界
- 分析依赖 GCC 编译链路，不适合脱离编译环境的纯源码扫描
- 竞态检测基于锁集与全局读写的静态启发式，不能等价于运行时“必然竞态证明”
- 大规模工程真实全量分析受 CPU/内存/磁盘影响

### 14.2 对策
- 预置结果与历史复用：保证演示稳定、降低现场耗时
- 数据自愈兜底：缺产物也能恢复显示
- 分层存储 + SQLite 服务化：提升查询与分页性能

---

## 15. 文档与材料产出建议（用于提交与论文）

如果你要把本作品扩写成正式材料，建议结构：
- **摘要/背景/问题定义**（安全审计 → 数据问题）
- **总体技术方案与系统架构**（分层、数据链路、run_id）
- **关键算法与检测器设计**（语义抽取、锁集、事件化输出）
- **数据治理与存储设计**（多层产物、SQLite 服务化、自愈兜底）
- **可视化与交互设计**（仪表盘、专项页、历史、PDF）
- **创新点与优势对比**（对比纯文本扫描、一次性脚本、单图展示等）
- **局限性与未来工作**（跨函数更强推理、更多图分析与指标体系）

---

## 16. 总结（可直接作为答辩结尾）

本作品将 Linux 内核安全审计工程化为一个“**大规模语义数据生产与服务系统**”：以 GCC 插件在编译期抽取高可信结构化数据，结合多检测器输出安全事件，通过 `run_id` 管理多运行历史并将结果服务化到 SQLite，最终以 Web 仪表盘与专项页实现可视化决策，并支持 PDF 与图谱导出，形成可复用、可归档、可扩展的数据资产闭环。
