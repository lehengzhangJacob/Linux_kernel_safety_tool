# net 分支变更记录

## 提交信息
- 分支：`net`
- 提交哈希：`51935fabc`
- 提交信息：`feat(web): add history report management and uploaded data cleanup`
- 提交文件：
  - `web_dashboard/backend/app.py`
  - `web_dashboard/frontend/src/components/Home.vue`
  - `web_dashboard/frontend/src/components/Dashboard.vue`
- 变更统计：`3 files changed, 1955 insertions(+), 431 deletions(-)`

## 相对最开始版本的核心变化

### 1) 任务模型升级：引入 run_id
- 每次审计生成独立 `run_id`，前后端按 `run_id` 查询统计、图谱、告警、PDF。
- 解决了历史任务和当前任务数据串线问题。

### 2) 存储架构升级：SQLite + 文件结果协同
- 新增 SQLite 表：`analysis_runs`、`warnings`、`summary_stats`。
- 告警支持服务端分页/过滤/检索（按严重级别和关键词）。
- 统计接口优先走数据库，稳定性与可查询性提升。

### 3) 上传内核流程升级：真实 full_run
- 上传任务改为调用完整真实分析链路（`full_run.sh`）。
- 上传压缩包采用“延迟解压”，减少上传阶段等待。
- 修复了压缩包后缀识别、内核根目录识别、进度卡在 10% 感知等问题。

### 4) 内置内核体验优化：预置结果快速命中
- 内置目标可命中预置结果并快速返回，减少重复分析。
- 恢复了 display 数据优先策略。
- 修复 `analysis_files` 显示为 0 的问题（从分析日志统计编译对象数）。

### 5) 卡住恢复能力增强
- 新增恢复接口：可恢复运行中的任务；可恢复最近完成的结果。
- 前端自动恢复仅续接 `running` 任务，不再自动占用 `completed` 历史结果。

### 6) 新增历史审计记录管理
- 首页新增历史记录列表（分页、筛选、按目标名查询）。
- 支持“查看任意历史报告”（按 `run_id` 跳转）。
- 支持两种删除模式：
  - 删除单次审计记录。
  - 删除某个上传目标及其全部上传数据和分析结果（释放磁盘空间）。

### 7) 交互与可用性提升
- 首页布局与操作流优化：恢复任务、上传、审计、历史管理更清晰。
- Dashboard 告警列表改为服务端分页查询，适配大规模告警数据。

