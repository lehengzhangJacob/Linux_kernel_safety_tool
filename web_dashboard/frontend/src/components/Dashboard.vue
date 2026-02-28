<template>
  <div class="dashboard">
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
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
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
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
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
            发现竞态警告
          </div>
          <div class="text-3xl font-bold text-red-400">{{ formatNumber(data.summary.total_warnings) }}</div>
          <div class="text-xs text-slate-500 mt-1">需要关注的安全问题</div>
        </div>
      </div>

      <!-- 第二行：图表区域 -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
        <!-- 竞态警告类型分布 -->
        <div class="card p-5 min-h-[320px] border border-slate-700/50">
          <h3 class="text-sm font-bold text-slate-300 mb-4 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z" />
            </svg>
            竞态警告类型分布
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

      <!-- 第三行：拓扑图和详细信息 -->
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

      <!-- 第四行：警告详情 -->
      <div class="card p-5 border border-slate-700/50">
        <h3 class="text-sm font-bold text-slate-300 mb-4 flex items-center gap-2">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-.77-1.964-.77-2.732 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
          最新竞态警告详情
        </h3>
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
              <tr v-for="(warn, index) in (data.race_warnings.warnings_sample || []).slice(0, 20)" :key="index" 
                  class="border-b border-slate-700/50 hover:bg-slate-700/30 transition-colors">
                <td class="px-4 py-3">
                  <span :class="warn.type === 'Read' ? 'text-emerald-400 bg-emerald-400/10' : 'text-rose-400 bg-rose-400/10'" 
                        class="px-2 py-1 rounded-full text-xs font-bold">
                    {{ warn.type === 'Read' ? '读取' : '写入' }}
                  </span>
                </td>
                <td class="px-4 py-3 font-mono text-orange-300">{{ warn.variable }}</td>
                <td class="px-4 py-3 font-mono text-blue-300">{{ warn.function }}</td>
                <td class="px-4 py-3">
                  <span class="text-red-400 flex items-center gap-1 bg-red-400/10 px-2 py-1 rounded-full text-xs">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" viewBox="0 0 20 20" fill="currentColor">
                      <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 002 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                    </svg>
                    高
                  </span>
                </td>
                <td class="px-4 py-3">
                  <button class="text-blue-400 hover:text-blue-300 text-xs underline">查看详情</button>
                </td>
              </tr>
            </tbody>
          </table>
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
import jsPDF from 'jspdf'
import 'jspdf-autotable'

// 将jsPDF添加到window对象，以便在方法中使用
window.jspdf = { jsPDF }

export default {
  name: 'Dashboard',
  data() {
    return {
      data: null,
      apiStatus: 'Connecting...',
      rwChartInstance: null,
      statsChartInstance: null,
      funcChartInstance: null,
      topoChartInstance: null
    }
  },
  methods: {
    formatNumber(num) {
      if (typeof num !== 'number') return num
      return new Intl.NumberFormat('en-US').format(num)
    },
    async loadDataFromResult() {
      try {
        // 从结果目录加载分析数据
        const response = await axios.get('/api/stats')
        const stats = response.data
        
        // 获取图数据
        const graphRes = await axios.get('/api/graph?limit=150')
        const graphData = graphRes.data
        
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
            total_warnings: (stats.warnings_sample || []).length,
            warning_reads: stats.edges?.READS || 0,
            warning_writes: stats.edges?.WRITES || 0
          },
          race_warnings: {
            top_variables: finalTopVars,
            top_functions: finalTopFuncs,
            warnings_sample: stats.warnings_sample || []
          },
          graph: graphData
        }
        
        this.apiStatus = 'Live'
        
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
    loadMockData() {
      // 模拟数据用于测试
      this.data = {
        kernel_version: 'linux-6.6.1',
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
          warning_writes: 7
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
      
      this.apiStatus = 'Live'
      
      // 使用setTimeout确保DOM完全渲染后再初始化图表
      setTimeout(() => {
        this.initCharts()
      }, 100)
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
              value: this.data.summary.warning_reads, 
              name: '无保护读 (Read)', 
              itemStyle: { color: '#34d399' }
            },
            { 
              value: this.data.summary.warning_writes, 
              name: '无保护写 (Write)', 
              itemStyle: { color: '#fb7185' }
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
    exportReport() {
      // 生成PDF格式的审计报告
      const { jsPDF } = window.jspdf
      const doc = new jsPDF()
      
      // 设置字体
      doc.setFont('helvetica')
      
      // 添加标题
      doc.setFontSize(20)
      doc.setTextColor(40, 40, 40)
      doc.text('内核并发安全审计报告', 105, 20, { align: 'center' })
      
      // 添加版本号
      doc.setFontSize(10)
      doc.setTextColor(100, 100, 100)
      doc.text('版本: 1.0', 105, 28, { align: 'center' })
      
      // 添加分隔线
      doc.setDrawColor(200, 200, 200)
      doc.line(20, 35, 190, 35)
      
      // 添加基本信息
      doc.setFontSize(12)
      doc.setTextColor(40, 40, 40)
      doc.text('基本信息', 20, 45)
      
      doc.setFontSize(10)
      doc.setTextColor(80, 80, 80)
      doc.text(`内核版本: ${this.data.kernel_version}`, 25, 55)
      doc.text(`扫描时间: ${this.data.scan_time}`, 25, 62)
      doc.text(`分析文件数: ${this.data.summary.analysis_files}`, 25, 69)
      doc.text(`函数总数: ${this.data.summary.total_functions}`, 25, 76)
      doc.text(`变量总数: ${this.data.summary.total_variables}`, 25, 83)
      doc.text(`发现警告数: ${this.data.summary.total_warnings}`, 25, 90)
      
      // 添加统计摘要表格
      doc.setFontSize(12)
      doc.setTextColor(40, 40, 40)
      doc.text('统计摘要', 20, 105)
      
      const summaryData = [
        ['指标', '数值'],
        ['分析文件数', this.data.summary.analysis_files],
        ['函数总数', this.data.summary.total_functions],
        ['变量总数', this.data.summary.total_variables],
        ['调用关系边', this.data.summary.total_edges],
        ['函数调用数', this.data.summary.total_calls],
        ['读取操作数', this.data.summary.total_reads],
        ['写入操作数', this.data.summary.total_writes],
        ['竞态警告数', this.data.summary.total_warnings]
      ]
      
      doc.autoTable({
        startY: 110,
        head: [['指标', '数值']],
        body: summaryData.slice(1),
        theme: 'grid',
        styles: {
          fontSize: 9,
          cellPadding: 3
        },
        headStyles: {
          fillColor: [59, 130, 246],
          textColor: [255, 255, 255],
          fontStyle: 'bold'
        }
      })
      
      // 添加高危变量列表
      const topVars = (this.data.race_warnings.top_variables || []).slice(0, 10)
      if (topVars.length > 0) {
        doc.addPage()
        doc.setFontSize(12)
        doc.setTextColor(40, 40, 40)
        doc.text('高危全局变量 Top 10', 20, 20)
        
        const varData = [
          ['排名', '变量名', '警告次数'],
          ...topVars.map((item, index) => [
            index + 1,
            item.name,
            item.count
          ])
        ]
        
        doc.autoTable({
          startY: 30,
          head: [['排名', '变量名', '警告次数']],
          body: varData.slice(1),
          theme: 'grid',
          styles: {
            fontSize: 9,
            cellPadding: 3
          },
          headStyles: {
            fillColor: [239, 68, 68],
            textColor: [255, 255, 255],
            fontStyle: 'bold'
          }
        })
      }
      
      // 添加警告详情
      const warnings = (this.data.race_warnings.warnings_sample || []).slice(0, 20)
      if (warnings.length > 0) {
        doc.addPage()
        doc.setFontSize(12)
        doc.setTextColor(40, 40, 40)
        doc.text('竞态警告详情', 20, 20)
        
        const warningData = [
          ['类型', '目标变量', '所在函数'],
          ...warnings.map(warn => [
            warn.type === 'Read' ? '读取' : '写入',
            warn.variable,
            warn.function
          ])
        ]
        
        doc.autoTable({
          startY: 30,
          head: [['类型', '目标变量', '所在函数']],
          body: warningData.slice(1),
          theme: 'grid',
          styles: {
            fontSize: 8,
            cellPadding: 2
          },
          headStyles: {
            fillColor: [245, 158, 11],
            textColor: [255,255, 255],
            fontStyle: 'bold'
          }
        })
      }
      
      // 添加页脚
      const pageCount = doc.internal.getNumberOfPages()
      for (let i = 1; i <= pageCount; i++) {
        doc.setPage(i)
        doc.setFontSize(8)
        doc.setTextColor(150, 150, 150)
        doc.text(
          `第 ${i} 页 / 共 ${pageCount} 页`,
          105,
          290,
          { align: 'center' }
        )
        doc.text(
          '内核并发安全分析系统 v1.0',
          105,
          295,
          { align: 'center' }
        )
      }
      
      // 保存PDF文件
      doc.save(`kernel_security_report_${this.data.kernel_version}_${Date.now()}.pdf`)
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
  background-color: #0f172a;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.card {
  background: rgba(30, 41, 59, 0.7);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  border: 1px solid rgba(51, 65, 85, 0.5);
}

.chart-container {
  width: 100%;
  height: 100%;
}

/* 滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #1e293b;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: #475569;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #64748b;
}
</style>