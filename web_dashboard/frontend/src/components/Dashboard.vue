<template>
  <div class="dashboard">
    <MainNav :has-audit-data="!!data" />
    <!-- 背景装饰 -->
    <div class="absolute inset-0 z-0" style="background: linear-gradient(to bottom right, rgba(30, 58, 138, 0.1), rgba(79, 70, 229, 0.1));"></div>
    
    <!-- 顶部导航栏 -->
    <header class="bg-slate-900/80 backdrop-blur-md border-b border-slate-700 p-4 flex justify-between items-center shrink-0 relative z-10">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-lg flex items-center justify-center font-bold text-xl shadow-lg shadow-blue-500/20" style="background: linear-gradient(to bottom right, #2563eb, #4f46e5);">K</div>
        <div>
          <h1 class="text-xl font-bold tracking-wider text-white">内核并发安全分析仪表盘</h1>
          <p class="text-xs text-slate-400">Kernel Concurrency Safety Dashboard</p>
        </div>
      </div>
      <div class="flex items-center gap-6">
        <div class="text-sm" :class="apiStatus.includes('Live') ? 'text-emerald-400' : 'text-amber-400'">
          <span class="inline-block w-2 h-2 rounded-full mr-1" :class="apiStatus.includes('Live') ? 'bg-emerald-400 animate-pulse' : 'bg-amber-400'"></span>
          {{ apiStatus }}
        </div>
        <div class="text-sm text-slate-300">
          <span class="text-slate-400">当前版本:</span> 
          <span class="text-blue-400 font-mono font-bold ml-1">{{ data ? data.kernel_version : '加载中...' }}</span>
        </div>
        <!-- 数据源标识 -->
        <div v-if="data && data.is_demo_data" class="px-3 py-1 rounded-full text-xs font-medium bg-amber-500/20 text-amber-400 border border-amber-500/30 flex items-center gap-1">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          演示数据
        </div>
        <div v-else-if="data && data.is_prebuilt" class="px-3 py-1 rounded-full text-xs font-medium bg-blue-500/20 text-blue-400 border border-blue-500/30 flex items-center gap-1">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
          </svg>
          预置分析数据
        </div>
        <div v-else-if="data && !data.is_demo_data" class="px-3 py-1 rounded-full text-xs font-medium bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 flex items-center gap-1">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          真实分析结果
        </div>
        <button @click="downloadGeekLog('ast')" class="text-slate-200 px-3 py-2 rounded-lg text-sm font-medium border border-slate-600 hover:border-cyan-400/60 hover:text-cyan-300 transition-all flex items-center gap-2 bg-slate-800/60" title="下载原始 AST 日志">
          AST Log
        </button>
        <button @click="downloadGeekLog('race_warnings')" class="text-slate-200 px-3 py-2 rounded-lg text-sm font-medium border border-slate-600 hover:border-amber-400/60 hover:text-amber-300 transition-all flex items-center gap-2 bg-slate-800/60" title="下载原始竞态告警日志">
          Race Warnings
        </button>
        <button @click="exportReport" class="text-white px-4 py-2 rounded-lg text-sm font-medium transition-all transform hover:scale-[1.02] active:scale-[0.98] flex items-center gap-2 shadow-lg shadow-blue-600/20" style="background: linear-gradient(to right, #2563eb, #4f46e5); transition: all 0.2s ease;">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
          </svg>
          导出审计报告
        </button>
      </div>
    </header>

    <!-- 主要内容区 -->
    <main class="flex-1 overflow-auto p-6 relative z-10" v-if="data">
      <!-- 第一行：核心指标卡片 -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4 mb-6">
        <div class="card p-5 flex flex-col justify-center border border-slate-700/50 hover:border-blue-500/50 transition-colors">
          <div class="text-slate-400 text-xs uppercase tracking-wider mb-2 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            分析文件数
          </div>
          <div class="text-3xl font-bold text-blue-400">{{ formatNumber(data.summary.analysis_files) }}</div>
          <div class="text-xs text-slate-500 mt-1">C源文件总数</div>
        </div>
        <div class="card p-5 flex flex-col justify-center border border-slate-700/50 hover:border-emerald-500/50 transition-colors">
          <div class="text-slate-400 text-xs uppercase tracking-wider mb-2 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4M6 16l4 4-4 4M6 8l4 4-4 4" />
            </svg>
            提取函数数
          </div>
          <div class="text-3xl font-bold text-emerald-400">{{ formatNumber(data.summary.total_functions) }}</div>
          <div class="text-xs text-slate-500 mt-1">全局函数定义</div>
        </div>
        <div class="card p-5 flex flex-col justify-center border border-slate-700/50 hover:border-purple-500/50 transition-colors">
          <div class="text-slate-400 text-xs uppercase tracking-wider mb-2 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
            </svg>
            调用关系边
          </div>
          <div class="text-3xl font-bold text-purple-400">{{ formatNumber(data.summary.total_edges) }}</div>
          <div class="text-xs text-slate-500 mt-1">函数调用与变量访问</div>
        </div>
        <div class="card p-5 flex flex-col justify-center border-l-4 border-l-red-500 border border-slate-700/50 hover:border-red-500/50 transition-colors">
          <div class="text-slate-400 text-xs uppercase tracking-wider mb-2 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-.77-1.964-.77-2.732 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
            内存安全
          </div>
          <div class="text-3xl font-bold text-red-400">{{ formatNumber(data.summary.memory_safety || 0) }}</div>
          <div class="text-xs text-slate-500 mt-1">缓冲区溢出、空指针等</div>
        </div>
        <div class="card p-5 flex flex-col justify-center border-l-4 border-l-yellow-500 border border-slate-700/50 hover:border-yellow-500/50 transition-colors">
          <div class="text-slate-400 text-xs uppercase tracking-wider mb-2 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
            </svg>
            信息泄露
          </div>
          <div class="text-3xl font-bold text-yellow-400">{{ formatNumber(data.summary.info_leak || 0) }}</div>
          <div class="text-xs text-slate-500 mt-1">敏感数据泄露</div>
        </div>
      </div>

      <!-- 第二行：核心指标卡片 -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <div class="card p-5 flex flex-col justify-center border-l-4 border-l-green-500 border border-slate-700/50 hover:border-green-500/50 transition-colors">
          <div class="text-slate-400 text-xs uppercase tracking-wider mb-2 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
            </svg>
            权限提升
          </div>
          <div class="text-3xl font-bold text-green-400">{{ formatNumber(data.summary.privilege_escalation || 0) }}</div>
          <div class="text-xs text-slate-500 mt-1">特权系统调用</div>
        </div>
        <div class="card p-5 flex flex-col justify-center border-l-4 border-l-purple-500 border border-slate-700/50 hover:border-purple-500/50 transition-colors">
          <div class="text-slate-400 text-xs uppercase tracking-wider mb-2 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            TOCTOU
          </div>
          <div class="text-3xl font-bold text-purple-400">{{ formatNumber(data.summary.toctou || 0) }}</div>
          <div class="text-xs text-slate-500 mt-1">时间检查时间使用</div>
        </div>
        <div class="card p-5 flex flex-col justify-center border-l-4 border-l-blue-500 border border-slate-700/50 hover:border-blue-500/50 transition-colors">
          <div class="text-slate-400 text-xs uppercase tracking-wider mb-2 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            竞态条件
          </div>
          <div class="text-3xl font-bold text-blue-400">{{ formatNumber(data.summary.race_condition || 0) }}</div>
          <div class="text-xs text-slate-500 mt-1">未保护的全局变量访问</div>
        </div>
      </div>

      <!-- 第三行：图表区域 -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
        <!-- 漏洞类型分布 -->
        <div class="card p-5 min-h-[320px] border border-slate-700/50">
          <h3 class="text-sm font-bold text-slate-300 mb-4 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z" />
            </svg>
            漏洞类型分布
          </h3>
          <div ref="rwChart" class="chart-container" style="height: 240px;"></div>
        </div>

        <!-- 文件类型分布 -->
        <div class="card p-5 min-h-[320px] border border-slate-700/50">
          <h3 class="text-sm font-bold text-slate-300 mb-4 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2m0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6 0a2 2 0 002 2h2a2 2 0 002-2z" />
            </svg>
            代码统计概览
          </h3>
          <div ref="statsChart" class="chart-container" style="height: 240px;"></div>
        </div>

        <!-- 高危函数分布 -->
        <div class="card p-5 min-h-[320px] border border-slate-700/50">
          <h3 class="text-sm font-bold text-slate-300 mb-4 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
            </svg>
            高危函数 Top 10
          </h3>
          <div ref="funcChart" class="chart-container" style="height: 240px;"></div>
        </div>
      </div>

      <!-- 第四行：拓扑图和详细信息 -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
        <!-- 依赖拓扑图 -->
        <div class="card p-5 min-h-[400px] border border-slate-700/50">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-sm font-bold text-slate-300 flex items-center gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
              </svg>
              函数调用与变量访问拓扑图
            </h3>
            <div class="flex gap-4 text-xs">
              <span class="flex items-center gap-1 bg-slate-800/50 px-2 py-1 rounded-full">
                <span class="w-3 h-3 rounded-full bg-blue-500 inline-block"></span> 
                函数
              </span>
              <span class="flex items-center gap-1 bg-slate-800/50 px-2 py-1 rounded-full">
                <span class="w-3 h-3 rounded-full bg-orange-500 inline-block"></span> 
                全局变量
              </span>
            </div>
          </div>
          <div ref="topoChart" class="chart-container" style="height: 320px;"></div>
        </div>

        <!-- 高危变量列表 -->
        <div class="card p-5 min-h-[400px] border border-slate-700/50">
          <h3 class="text-sm font-bold text-slate-300 mb-4 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" />
            </svg>
            高危全局变量 Top 10
          </h3>
          <div class="overflow-y-auto" style="max-height: 320px;">
            <table class="w-full text-sm text-left">
              <thead class="text-xs text-slate-400 uppercase bg-slate-800/50 sticky top-0">
                <tr>
                  <th class="px-4 py-3 rounded-tl">排名</th>
                  <th class="px-4 py-3">变量名</th>
                  <th class="px-4 py-3 text-right rounded-tr">警告次数</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(item, index) in (data.race_warnings.top_variables || []).slice(0, 10)" :key="index" 
                    class="border-b border-slate-700/50 hover:bg-slate-700/30 transition-colors">
                  <td class="px-4 py-3">
                    <span class="inline-flex items-center justify-center w-6 h-6 rounded-full text-xs font-bold"
                          :class="index < 3 ? 'bg-red-500/20 text-red-400' : 'bg-slate-700 text-slate-400'">
                      {{ index + 1 }}
                    </span>
                  </td>
                  <td class="px-4 py-3 font-mono text-orange-300">{{ item.name }}</td>
                  <td class="px-4 py-3 text-right font-bold text-slate-300">{{ item.count }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- 第五行：警告详情 -->
      <div class="card p-5 border border-slate-700/50">
        <div class="flex flex-col gap-3 mb-4">
          <h3 class="text-sm font-bold text-slate-300 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-.77-1.964-.77-2.732 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
            漏洞警告详情
          </h3>
          <div class="flex flex-wrap gap-3 items-center">
            <input
              v-model="warningKeyword"
              @keyup.enter="applyWarningFilters"
              placeholder="搜索函数/变量"
              class="bg-slate-800 border border-slate-700 rounded px-3 py-2 text-sm text-slate-200"
            />
            <select v-model="warningSeverity" class="bg-slate-800 border border-slate-700 rounded px-3 py-2 text-sm text-slate-200">
              <option value="">全部等级</option>
              <option value="HIGH">HIGH</option>
              <option value="MEDIUM">MEDIUM</option>
            </select>
            <button @click="applyWarningFilters" class="text-xs px-3 py-2 rounded bg-blue-600 hover:bg-blue-500 text-white">查询</button>
          </div>
        </div>
        <div class="overflow-x-auto">
          <table class="w-full text-sm text-left">
            <thead class="text-xs text-slate-400 uppercase bg-slate-800/50">
              <tr>
                <th class="px-4 py-3 rounded-tl">类型</th>
                <th class="px-4 py-3">目标变量</th>
                <th class="px-4 py-3">所在函数</th>
                <th class="px-4 py-3">风险等级</th>
                <th class="px-4 py-3 rounded-tr">建议操作</th>
              </tr>
            </thead>
            <tbody>
                <tr v-for="(warn, index) in pagedWarnings" :key="index" 
                  class="border-b border-slate-700/50 hover:bg-slate-700/30 transition-colors">
                <td class="px-4 py-3">
                  <span :class="warn.type === 'Read' ? 'text-emerald-400 bg-emerald-400/10' : 'text-rose-400 bg-rose-400/10'"
                        class="px-2 py-1 rounded-full text-xs font-bold">
                    {{ warn.type === 'Read' ? '读取' : warn.type === 'Write' ? '写入' : warn.type }}
                  </span>
                </td>
                <td class="px-4 py-3 font-mono text-orange-300">{{ warn.variable }}</td>
                <td class="px-4 py-3 font-mono text-blue-300">{{ warn.function }}</td>
                <td class="px-4 py-3">
                  <span
                    class="flex items-center gap-1 px-2 py-1 rounded-full text-xs"
                    :class="warn.severity === 'HIGH' ? 'text-red-400 bg-red-400/10' : 'text-amber-300 bg-amber-400/10'"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" viewBox="0 0 20 20" fill="currentColor">
                      <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 002 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                    </svg>
                    {{ warn.severity || 'MEDIUM' }}
                  </span>
                </td>
                <td class="px-4 py-3">
                  <button class="text-blue-400 hover:text-blue-300 text-xs underline">查看详情</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="mt-4 flex items-center justify-between text-xs text-slate-400">
          <div>
            共 {{ warningsTotal }} 条，当前第 {{ warningsPage }} 页
          </div>
          <div class="flex items-center gap-2">
            <button
              @click="changeWarningsPage(warningsPage - 1)"
              :disabled="warningsPage <= 1 || warningsLoading"
              class="px-3 py-1 rounded border border-slate-700 disabled:opacity-40"
            >上一页</button>
            <button
              @click="changeWarningsPage(warningsPage + 1)"
              :disabled="warningsPage * warningsPageSize >= warningsTotal || warningsLoading"
              class="px-3 py-1 rounded border border-slate-700 disabled:opacity-40"
            >下一页</button>
          </div>
        </div>
      </div>
    </main>
    
    <!-- 加载状态 -->
    <div v-else class="flex-1 flex items-center justify-center flex-col gap-6 relative z-10">
      <div class="w-16 h-16 border-4 border-blue-600 border-t-transparent rounded-full animate-spin"></div>
      <div class="text-slate-400 text-lg">正在加载分析数据...</div>
      <div class="text-slate-500 text-sm">这可能需要几秒钟时间，请耐心等待</div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import * as echarts from 'echarts'
import MainNav from './navigation/MainNav.vue'
import { buildProfessionalPdf, WARNINGS_EXPORT_LIMIT } from '../utils/auditReportPdf.js'

export default {
  name: 'Dashboard',
  components: {
    MainNav
  },
  data() {
    return {
      data: null,
      apiStatus: 'Connecting...',
      rwChartInstance: null,
      statsChartInstance: null,
      funcChartInstance: null,
      topoChartInstance: null,
      runId: null,
      warningSeverity: '',
      warningKeyword: '',
      warningsPage: 1,
      warningsPageSize: 20,
      warningsTotal: 0,
      pagedWarnings: [],
      warningsLoading: false
    }
  },
  methods: {
    formatNumber(num) {
      if (typeof num !== 'number') return num
      return new Intl.NumberFormat('en-US').format(num)
    },
    downloadGeekLog(kind) {
      const runId = this.runId || this.$route?.query?.run_id || localStorage.getItem('currentRunId') || ''
      const params = new URLSearchParams()
      if (runId) params.set('run_id', runId)
      const target = this.data?.kernel_version || this.data?.target
      if (target) params.set('target', target)
      const qs = params.toString()
      const url = `/api/logs/${encodeURIComponent(kind)}/download${qs ? `?${qs}` : ''}`
      window.open(url, '_blank')
    },
    async loadDataFromResult() {
      try {
        this.runId = this.$route?.query?.run_id || localStorage.getItem('currentRunId') || null
        const params = this.runId ? { run_id: this.runId } : {}

        // 尝试加载我们的GCC插件生成的JSON数据
        try {
          const jsonFiles = await axios.get('/api/json_files')
          if (jsonFiles.data && jsonFiles.data.files && jsonFiles.data.files.length > 0) {
            const latestFile = jsonFiles.data.files[0]
            const jsonData = await axios.get(`/api/json_data/${latestFile}`)
            this.processGccPluginData(jsonData.data)
            this.apiStatus = 'Live'
            await this.fetchWarnings(1)
            
            // 使用setTimeout确保DOM完全渲染后再初始化图表
            setTimeout(() => {
              this.initCharts()
            }, 100)
            return
          }
        } catch (jsonError) {
          console.log('No GCC plugin JSON data found, using backend API:', jsonError)
        }

        // 回退到使用后端API
        const response = await axios.get('/api/stats', { params })
        const stats = response.data
        this.runId = stats?.run_id || this.runId
        if (this.runId) {
          localStorage.setItem('currentRunId', this.runId)
        }
        
        // 获取图数据
        const graphRes = await axios.get('/api/graph', { params: { ...params, limit: 150 } })
        const graphData = graphRes.data

        // 获取五类安全检测统计（按当前 run_id）
        let detectionSummary = {
          memory_safety: 0,
          info_leak: 0,
          privilege_escalation: 0,
          toctou: 0,
          race_condition: 0
        }
        try {
          const detectionRes = await axios.get('/api/detections/summary', { params })
          detectionSummary = {
            memory_safety: detectionRes?.data?.memory_safety || 0,
            info_leak: detectionRes?.data?.info_leak || 0,
            privilege_escalation: detectionRes?.data?.privilege_escalation || 0,
            toctou: detectionRes?.data?.toctou || 0,
            race_condition: detectionRes?.data?.race_condition || 0
          }
        } catch (e) {
          console.warn('Failed to load detection summary:', e)
        }
        
        // 改进数据转换逻辑
        // 统计变量和函数的出现次数
        const varCounter = {}
        const funcCounter = {}
        
        // 从warnings_sample中统计出现次数
        if (stats.warnings_sample && Array.isArray(stats.warnings_sample)) {
          stats.warnings_sample.forEach(warn => {
            if (warn.variable) {
              varCounter[warn.variable] = (varCounter[warn.variable] || 0) + 1
            }
            if (warn.function) {
              funcCounter[warn.function] = (funcCounter[warn.function] || 0) + 1
            }
          })
        }
        
        // 转换top_variables格式
        const topVars = Object.entries(varCounter)
          .map(([name, count]) => ({ name, count }))
          .sort((a, b) => b.count - a.count)
          .slice(0, 10)
        
        // 转换top_functions格式
        const topFuncs = Object.entries(funcCounter)
          .map(([name, count]) => ({ name, count }))
          .sort((a, b) => b.count - a.count)
          .slice(0, 10)
        
        // 如果没有足够的统计数据，使用原始数据
        const finalTopVars = topVars.length > 0 ? topVars : 
          (stats.top_variables || []).map(v => ({ name: v.variable || v.name, count: 1 }))
        
        const finalTopFuncs = topFuncs.length > 0 ? topFuncs : 
          (stats.top_functions || []).map(f => ({ name: f.function || f.name, count: 1 }))
        
        this.data = {
          kernel_version: stats.kernel_version || 'Unknown',
          scan_time: new Date().toISOString().split('T')[0],
          summary: {
            analysis_files: stats.analysis_files || 0,
            total_nodes: (stats.nodes?.Function || 0) + (stats.nodes?.GlobalVariable || 0),
            total_functions: stats.nodes?.Function || 0,
            total_variables: stats.nodes?.GlobalVariable || 0,
            total_edges: (stats.edges?.CALLS || 0) + (stats.edges?.READS || 0) + (stats.edges?.WRITES || 0),
            total_calls: stats.edges?.CALLS || 0,
            total_reads: stats.edges?.READS || 0,
            total_writes: stats.edges?.WRITES || 0,
            total_warnings: 0,
            warning_reads: stats.edges?.READS || 0,
            warning_writes: stats.edges?.WRITES || 0,
            memory_safety: detectionSummary.memory_safety,
            info_leak: detectionSummary.info_leak,
            privilege_escalation: detectionSummary.privilege_escalation,
            toctou: detectionSummary.toctou,
            race_condition: detectionSummary.race_condition
          },
          race_warnings: {
            top_variables: finalTopVars,
            top_functions: finalTopFuncs,
            warnings_sample: stats.warnings_sample || []
          },
          graph: graphData
        }
        
        this.apiStatus = 'Live'
        await this.fetchWarnings(1)
        
        // 使用setTimeout确保DOM完全渲染后再初始化图表
        setTimeout(() => {
          this.initCharts()
        }, 100)
      } catch (error) {
        console.error('Failed to load data:', error)
        this.apiStatus = 'Error'
        // 使用模拟数据
        this.loadMockData()
      }
    },
    processGccPluginData(jsonData) {
      if (!jsonData || !jsonData.detections) {
        console.error('Invalid GCC plugin JSON data')
        return
      }

      // 统计不同类型的漏洞
      const memorySafetyCount = jsonData.detections.filter(d => d.type === 'BufferOverflow' || d.type === 'NullPointer' || d.type === 'UseAfterFree').length
      const infoLeakCount = jsonData.detections.filter(d => d.type === 'InfoLeak').length
      const privilegeEscalationCount = jsonData.detections.filter(d => d.type === 'PrivilegeEscalation').length
      const toctouCount = jsonData.detections.filter(d => d.type === 'TOCTOU').length
      const raceConditionCount = jsonData.detections.filter(d => d.type === 'RaceCondition').length

      // 统计变量和函数的出现次数
      const varCounter = {}
      const funcCounter = {}

      jsonData.detections.forEach(det => {
        if (det.function) {
          funcCounter[det.function] = (funcCounter[det.function] || 0) + 1
        }
      })

      // 转换top_variables格式
      const topVars = []
      
      // 转换top_functions格式
      const topFuncs = Object.entries(funcCounter)
        .map(([name, count]) => ({ name, count }))
        .sort((a, b) => b.count - a.count)
        .slice(0, 10)

      // 准备警告样本
      const warningsSample = jsonData.detections.map(det => ({
        type: det.type,
        variable: det.variable || '',
        function: det.function || '',
        severity: det.severity || 'MEDIUM',
        message: det.message || '',
        line: det.line || 0
      }))

      this.data = {
        kernel_version: 'GCC Plugin Analysis',
        scan_time: new Date().toISOString().split('T')[0],
        summary: {
          analysis_files: 1,
          total_nodes: 0,
          total_functions: Object.keys(funcCounter).length,
          total_variables: 0,
          total_edges: 0,
          total_calls: 0,
          total_reads: 0,
          total_writes: 0,
          total_warnings: jsonData.detections.length,
          memory_safety: memorySafetyCount,
          info_leak: infoLeakCount,
          privilege_escalation: privilegeEscalationCount,
          toctou: toctouCount,
          race_condition: raceConditionCount
        },
        race_warnings: {
          top_variables: topVars,
          top_functions: topFuncs,
          warnings_sample: warningsSample
        },
        graph: {
          nodes: [],
          edges: []
        }
      }
    },
    loadMockData() {
      // 模拟数据用于测试
      this.data = {
        kernel_version: '未连接',
        scan_time: new Date().toISOString().split('T')[0],
        summary: {
          analysis_files: 8302,
          total_nodes: 150,
          total_functions: 120,
          total_variables: 30,
          total_edges: 280,
          total_calls: 200,
          total_reads: 50,
          total_writes: 30,
          total_warnings: 15,
          warning_reads: 8,
          warning_writes: 7,
          memory_safety: 5,
          info_leak: 3,
          privilege_escalation: 2,
          toctou: 1,
          race_condition: 4
        },
        race_warnings: {
          top_variables: [
            { name: 'global_counter', count: 5 },
            { name: 'static_var', count: 3 },
            { name: 'shared_data', count: 2 }
          ],
          top_functions: [
            { name: 'increment_counter', count: 4 },
            { name: 'read_counter', count: 3 }
          ],
          warnings_sample: [
            { type: 'Read', variable: 'global_counter', function: 'read_data' },
            { type: 'Write', variable: 'static_var', function: 'write_data' }
          ]
        },
        graph: {
          nodes: [
            { id: 'func_1', name: 'main', category: 0, symbolSize: 20, value: 10 },
            { id: 'func_2', name: 'process', category: 0, symbolSize: 15, value: 8 },
            { id: 'var_1', name: 'counter', category: 1, symbolSize: 12, value: 5 }
          ],
          edges: [
            { source: 'func_1', target: 'func_2', type: 'CALLS' },
            { source: 'func_2', target: 'var_1', type: 'READS' }
          ]
        }
      }
      this.pagedWarnings = this.data.race_warnings.warnings_sample || []
      this.warningsTotal = this.pagedWarnings.length
      this.data.summary.total_warnings = this.warningsTotal
      
      this.apiStatus = 'Live'
      
      // 使用setTimeout确保DOM完全渲染后再初始化图表
      setTimeout(() => {
        this.initCharts()
      }, 100)
    },
    async fetchWarnings(page = 1) {
      this.warningsLoading = true
      try {
        const params = {
          page,
          page_size: this.warningsPageSize,
          severity: this.warningSeverity || undefined,
          q: this.warningKeyword || undefined,
          run_id: this.runId || undefined
        }
        const res = await axios.get('/api/warnings', { params })
        this.runId = res.data.run_id || this.runId
        this.warningsPage = res.data.page || page
        this.warningsTotal = res.data.total || 0
        this.pagedWarnings = res.data.items || []

        if (this.data?.summary) {
          this.data.summary.total_warnings = this.warningsTotal
          this.data.race_warnings.warnings_sample = this.pagedWarnings
        }
      } catch (err) {
        console.error('Failed to load warnings:', err)
      } finally {
        this.warningsLoading = false
      }
    },
    applyWarningFilters() {
      this.fetchWarnings(1)
    },
    changeWarningsPage(nextPage) {
      if (nextPage < 1) return
      if ((nextPage - 1) * this.warningsPageSize >= this.warningsTotal) return
      this.fetchWarnings(nextPage)
    },
    initCharts() {
      // 确保DOM已经渲染
      this.$nextTick(() => {
        this.initRWChart()
        this.initStatsChart()
        this.initFuncChart()
        this.initTopoChart()
        
        // 监听窗口大小变化
        window.addEventListener('resize', () => {
          this.rwChartInstance?.resize()
          this.statsChartInstance?.resize()
          this.funcChartInstance?.resize()
          this.topoChartInstance?.resize()
        })
      })
    },
    initRWChart() {
      const chartDom = this.$refs.rwChart
      if (!chartDom) return
      
      // 销毁已存在的实例
      if (this.rwChartInstance) {
        this.rwChartInstance.dispose()
      }
      
      this.rwChartInstance = echarts.init(chartDom)
      this.rwChartInstance.setOption({
        backgroundColor: 'transparent',
        tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
        legend: { 
          orient: 'vertical', 
          right: '5%', 
          top: 'center',
          textStyle: { color: '#94a3b8' }
        },
        series: [{
          type: 'pie',
          radius: ['40%', '70%'],
          center: ['40%', '50%'],
          avoidLabelOverlap: false,
          itemStyle: { borderRadius: 8, borderColor: '#1e293b', borderWidth: 2 },
          label: { show: false },
          data: [
            { 
              value: this.data.summary.memory_safety || 0, 
              name: '内存安全', 
              itemStyle: { color: '#ef4444' }
            },
            { 
              value: this.data.summary.info_leak || 0, 
              name: '信息泄露', 
              itemStyle: { color: '#f59e0b' }
            },
            { 
              value: this.data.summary.privilege_escalation || 0, 
              name: '权限提升', 
              itemStyle: { color: '#10b981' }
            },
            { 
              value: this.data.summary.toctou || 0, 
              name: 'TOCTOU', 
              itemStyle: { color: '#8b5cf6' }
            },
            { 
              value: this.data.summary.race_condition || 0, 
              name: '竞态条件', 
              itemStyle: { color: '#3b82f6' }
            }
          ]
        }]
      })
    },
    initStatsChart() {
      const chartDom = this.$refs.statsChart
      if (!chartDom) return
      
      // 销毁已存在的实例
      if (this.statsChartInstance) {
        this.statsChartInstance.dispose()
      }
      
      this.statsChartInstance = echarts.init(chartDom)
      this.statsChartInstance.setOption({
        backgroundColor: 'transparent',
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
        xAxis: {
          type: 'category',
          data: ['函数', '变量', '调用', '读取', '写入'],
          axisLine: { lineStyle: { color: '#475569' } },
          axisLabel: { color: '#94a3b8' }
        },
        yAxis: {
          type: 'value',
          axisLine: { lineStyle: { color: '#475569' } },
          axisLabel: { color: '#94a3b8' },
          splitLine: { lineStyle: { color: '#334155' } }
        },
        series: [{
          type: 'bar',
          data: [
            { value: this.data.summary.total_functions, itemStyle: { color: '#3b82f6' } },
            { value: this.data.summary.total_variables, itemStyle: { color: '#f97316' } },
            { value: this.data.summary.total_calls, itemStyle: { color: '#8b5cf6' } },
            { value: this.data.summary.total_reads, itemStyle: { color: '#10b981' } },
            { value: this.data.summary.total_writes, itemStyle: { color: '#ef4444' } }
          ],
          barWidth: '60%',
          itemStyle: { borderRadius: [4, 4, 0, 0] }
        }]
      })
    },
    initFuncChart() {
      const chartDom = this.$refs.funcChart
      if (!chartDom) return
      
      // 销毁已存在的实例
      if (this.funcChartInstance) {
        this.funcChartInstance.dispose()
      }
      
      const topFuncs = (this.data.race_warnings.top_functions || []).slice(0, 10)
      
      this.funcChartInstance = echarts.init(chartDom)
      this.funcChartInstance.setOption({
        backgroundColor: 'transparent',
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
        xAxis: {
          type: 'value',
          axisLine: { lineStyle: { color: '#475569' } },
          axisLabel: { color: '#94a3b8' },
          splitLine: { lineStyle: { color: '#334155' } }
        },
        yAxis: {
          type: 'category',
          data: topFuncs.map(f => f.name).reverse(),
          axisLine: { lineStyle: { color: '#475569' } },
          axisLabel: { color: '#94a3b8', fontSize: 10 }
        },
        series: [{
          type: 'bar',
          data: topFuncs.map(f => ({
            value: f.count,
            itemStyle: { color: '#f59e0b' }
          })).reverse(),
          barWidth: '60%',
          itemStyle: { borderRadius: [0, 4, 4, 0] }
        }]
      })
    },
    initTopoChart() {
      const chartDom = this.$refs.topoChart
      if (!chartDom || !this.data.graph) return
      
      // 销毁已存在的实例
      if (this.topoChartInstance) {
        this.topoChartInstance.dispose()
      }
      
      const nodes = this.data.graph.nodes?.map(node => ({
        id: node.id,
        name: node.name,
        symbolSize: Math.max(node.symbolSize, 8),
        value: node.value,
        category: node.category,
        itemStyle: {
          color: node.category === 0 ? '#3b82f6' : '#f97316',
          borderColor: '#1e293b',
          borderWidth: 1
        }
      })) || []
      
      const edges = this.data.graph.edges?.map(edge => ({
        source: edge.source,
        target: edge.target
      })) || []
      
      this.topoChartInstance = echarts.init(chartDom)
      this.topoChartInstance.setOption({
        backgroundColor: 'transparent',
        tooltip: {
          formatter: (params) => {
            if (params.dataType === 'node') {
              return `${params.data.category === 0 ? '函数' : '变量'}: ${params.data.name}<br/>关联度: ${params.data.value}`
            }
            return `${params.data.source} → ${params.data.target}`
          }
        },
        series: [{
          type: 'graph',
          layout: 'force',
          data: nodes,
          links: edges,
          roam: true,
          label: {
            show: true,
            position: 'right',
            formatter: '{b}',
            color: '#cbd5e1',
            fontSize: 10
          },
          force: {
            repulsion: 150,
            edgeLength: [50, 100],
            gravity: 0.1
          },
          lineStyle: {
            color: '#475569',
            curveness: 0.2,
            width: 1,
            opacity: 0.6
          },
          emphasis: {
            focus: 'adjacency',
            lineStyle: { width: 2 }
          }
        }]
      })
    },
    async fetchWarningsForReport(limit = WARNINGS_EXPORT_LIMIT) {
      const runId = this.runId || this.$route?.query?.run_id || localStorage.getItem('currentRunId') || null
      const collected = []
      let total = 0
      const pageSize = Math.min(50, limit)

      try {
        // 先拉高危，再补中危，合计不超过 limit
        for (const severity of ['HIGH', 'MEDIUM', '']) {
          if (collected.length >= limit) break
          let page = 1
          while (collected.length < limit) {
            const need = limit - collected.length
            const res = await axios.get('/api/warnings', {
              params: {
                run_id: runId || undefined,
                page,
                page_size: Math.min(pageSize, need),
                severity: severity || undefined,
              },
              timeout: 20000,
            })
            const items = Array.isArray(res.data?.items) ? res.data.items : []
            total = Math.max(total, Number(res.data?.total || 0))
            if (!items.length) break

            for (const item of items) {
              const key = `${item.severity}|${item.type}|${item.variable}|${item.function}`
              if (collected.some((x) => `${x.severity}|${x.type}|${x.variable}|${x.function}` === key)) {
                continue
              }
              collected.push(item)
              if (collected.length >= limit) break
            }

            if (items.length < pageSize) break
            page += 1
            if (page > 5) break
          }
        }
      } catch (e) {
        console.warn('fetchWarningsForReport failed, fallback to sample:', e)
      }

      if (!collected.length) {
        const sample = this.data?.race_warnings?.warnings_sample || this.pagedWarnings || []
        return {
          items: sample.slice(0, limit),
          total: Number(this.warningsTotal || sample.length || this.data?.summary?.total_warnings || 0),
        }
      }

      return { items: collected.slice(0, limit), total: total || collected.length }
    },
    async exportReport() {
      if (!this.data) {
        alert('暂无分析数据，请等待仪表盘加载完成后再导出。')
        return
      }

      try {
        // 确保图表已渲染；若尚未初始化则尝试初始化一次
        if (!this.rwChartInstance || !this.statsChartInstance || !this.funcChartInstance) {
          this.initCharts()
          await new Promise((r) => setTimeout(r, 250))
        }

        const { items, total } = await this.fetchWarningsForReport(WARNINGS_EXPORT_LIMIT)
        // 用警告总数修正 summary，便于健康分与摘要准确
        if (this.data.summary && total > 0) {
          this.data.summary.total_warnings = Math.max(Number(this.data.summary.total_warnings || 0), total)
        }

        await buildProfessionalPdf({
          data: this.data,
          runId: this.runId,
          chartInstances: {
            rwChartInstance: this.rwChartInstance,
            statsChartInstance: this.statsChartInstance,
            funcChartInstance: this.funcChartInstance,
            topoChartInstance: this.topoChartInstance,
          },
          warnings: items,
          warningsTotal: total,
        })
      } catch (error) {
        console.error('Professional PDF export failed:', error)
        alert(`导出专业审计报告失败: ${error?.message || error}`)
      }
    }
  },
  mounted() {
    this.loadDataFromResult()
  },
  beforeUnmount() {
    // 清理图表实例
    this.rwChartInstance?.dispose()
    this.statsChartInstance?.dispose()
    this.funcChartInstance?.dispose()
    this.topoChartInstance?.dispose()
  }
}
</script>

<style scoped>
.dashboard {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #0f172a;
  color: #f8fafc;
}

.card {
  background-color: rgba(30, 41, 59, 0.8);
  border-radius: 0.5rem;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
  backdrop-filter: blur(8px);
}

.chart-container {
  width: 100%;
  height: 100%;
}

@media (max-width: 768px) {
  .dashboard {
    padding: 0;
  }
  
  main {
    padding: 1rem;
  }
}
</style>