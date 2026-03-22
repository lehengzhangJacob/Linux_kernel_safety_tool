<template>
  <div class="home">
    <MainNav :has-audit-data="scanComplete" />
    <!-- 背景装饰 -->
    <div class="absolute inset-0 z-0" style="background: linear-gradient(to bottom right, rgba(30, 58, 138, 0.2), rgba(126, 34, 206, 0.2));"></div>
    <div class="grid-container absolute inset-0 opacity-10 z-0">
      <div v-for="i in 144" :key="i" class="grid-item"></div>
    </div>
    
    <!-- 主内容 -->
    <div class="main-content relative z-10">
      <!-- 头部 -->
      <div class="header text-center mb-12">
        <div class="logo-container" style="background: linear-gradient(to bottom right, #2563eb, #4338ca);">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z" />
          </svg>
        </div>
        <h1 class="title">内核并发安全分析系统</h1>
        <p class="subtitle">Kernel Concurrency Safety Analyzer - SaaS Platform</p>
        <div class="status-indicator">
          <span class="status-dot"></span>
          <span class="status-text">系统就绪，随时可以开始分析</span>
        </div>
      </div>

      <!-- 主面板 -->
      <div class="main-panel glass-panel">
        <!-- 装饰元素 -->
        <div class="decor-top-right"></div>
        <div class="decor-bottom-left"></div>
        
        <div v-if="!isScanning && !scanComplete" class="content-section">
          <div>
            <label class="section-label">选择分析目标</label>
            <div class="button-group">
              <button @click="scanMode = 'server'" :class="scanMode === 'server' ? 'active-button' : 'inactive-button'" class="mode-button">
                <div class="button-content">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2m-2-4h.01M17 16h.01" />
                  </svg>
                  <span>服务器内置内核</span>
                </div>
              </button>
              <button @click="scanMode = 'local_folder'" :class="scanMode === 'local_folder' ? 'active-button' : 'inactive-button'" class="mode-button">
                <div class="button-content">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                  </svg>
                  <span>上传文件夹</span>
                </div>
              </button>
              <button @click="scanMode = 'local_archive'" :class="scanMode === 'local_archive' ? 'active-button' : 'inactive-button'" class="mode-button">
                <div class="button-content">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1M8 12h8M8 8h8M8 16h5" />
                  </svg>
                  <span>上传压缩包</span>
                </div>
              </button>
            </div>

            <!-- 服务器模式 -->
            <div v-if="scanMode === 'server'" class="server-mode-section">
              <select v-model="selectedTarget" class="server-select">
                <option value="linux-6.6.1">linux-6.6.1 (推荐)</option>
                <option value="linux-6.12.6">linux-6.12.6</option>
              </select>
              <div class="select-help">
                选择服务器上预配置的内核版本进行分析
              </div>
            </div>

            <!-- 文件夹上传模式 -->
            <div v-if="scanMode === 'local_folder'" class="upload-section" @click="triggerFolderInput" @dragover.prevent="dragOver = true" @dragleave.prevent="dragOver = false" @drop.prevent="handleDrop" :class="{'drag-over': dragOver}">
              <input type="file" id="fileInput" class="hidden" webkitdirectory directory multiple @change="handleFileSelect">
              <div class="upload-content">
                <div class="upload-icon-container">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
                  </svg>
                </div>
                <h3 class="upload-title" v-if="!selectedLocalFolder">上传内核源代码目录</h3>
                <h3 class="upload-title selected" v-else>已选择: {{ selectedLocalFolder }}</h3>
                <p class="upload-description" v-if="!selectedLocalFolder">点击选择文件夹，或将文件夹拖拽到此处</p>
                <p class="upload-description" v-else>包含 {{ fileCount }} 个文件</p>
                <p class="upload-help">支持上传完整的内核源码目录</p>
              </div>
            </div>

            <!-- 压缩包上传模式 -->
            <div v-if="scanMode === 'local_archive'" class="upload-section archive-upload-section" @click="triggerArchiveInput">
              <input type="file" id="archiveInput" class="hidden" accept=".zip,.tar,.tar.gz,.tgz,.tar.xz,.txz,.tar.bz2,.tbz2" @change="handleArchiveSelect">
              <div class="upload-content">
                <div class="upload-icon-container">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1M8 12h8M8 8h8M8 16h5" />
                  </svg>
                </div>
                <h3 class="upload-title" v-if="!selectedLocalFolder">上传内核源代码压缩包</h3>
                <h3 class="upload-title selected" v-else>已选择: {{ selectedLocalFolder }}</h3>
                <p class="upload-description" v-if="!selectedLocalFolder">点击选择 .tar.gz/.tgz/.tar/.zip/.tar.xz 文件</p>
                <p class="upload-description" v-else>文件: {{ fileCount }}</p>
                <p class="upload-help">上传后自动解压并进入分析流程</p>
                <button type="button" class="archive-select-button" @click.stop="triggerArchiveInput">选择压缩包文件</button>
              </div>
            </div>

            <div v-if="scanMode === 'local_archive'" class="archive-history-block">
              <div class="archive-history-row">
                <select v-model="selectedExistingArchiveTarget" class="server-select" @change="onExistingArchiveChange">
                  <option value="">或选择历史上传压缩包（可直接重审）</option>
                  <option v-for="item in uploadedArchiveOptions" :key="item.target" :value="item.target">
                    {{ item.target }} - {{ item.archive_name || '未命名压缩包' }}{{ item.archive_exists ? '' : '（压缩包已丢失）' }}
                  </option>
                </select>
                <button type="button" class="history-refresh" @click="loadUploadedArchiveOptions" :disabled="uploadedArchiveLoading">刷新</button>
              </div>

              <div v-if="selectedExistingArchiveTarget" class="archive-strategy-block">
                <label class="section-label">历史压缩包处理方式</label>
                <div class="button-group archive-strategy-group">
                  <button
                    type="button"
                    class="mode-button"
                    :class="archiveReuseMode === 'reuse_report' ? 'active-button' : 'inactive-button'"
                    @click="archiveReuseMode = 'reuse_report'"
                  >
                    直接查看以前运行好的报告
                  </button>
                  <button
                    type="button"
                    class="mode-button"
                    :class="archiveReuseMode === 'rerun_overwrite' ? 'active-button' : 'inactive-button'"
                    @click="archiveReuseMode = 'rerun_overwrite'"
                  >
                    全部重新跑并覆盖历史报告
                  </button>
                </div>

                <div v-if="archiveReuseMode === 'reuse_report'" class="archive-report-picker">
                  <select v-model="selectedExistingRunId" class="server-select">
                    <option value="">请选择历史报告</option>
                    <option v-for="item in existingCompletedReports" :key="item.run_id" :value="item.run_id">
                      {{ item.started_at_text || '-' }} | run_id: {{ item.run_id }} | 告警: {{ item.total_warnings }}
                    </option>
                  </select>
                </div>
              </div>

              <p v-if="selectedExistingArchiveTarget && !selectedExistingArchiveAvailable" class="archive-missing-tip">
                该历史压缩包文件已不存在，请重新上传压缩包后再分析。
              </p>
            </div>

          </div>

          <div class="action-section">
            <button v-if="!isScanning && !scanComplete" @click="recoverLastTask" class="recover-button">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
              </svg>
              恢复上次任务/结果
            </button>

            <button v-if="(scanMode === 'local_folder' || scanMode === 'local_archive') && !uploadComplete" @click="uploadFiles" class="upload-button">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
              </svg>
              <span v-if="isUploading">正在上传 ({{ uploadProgress }}%)...</span>
              <span v-else>{{ scanMode === 'local_archive' ? '第一步：上传压缩包' : '第一步：上传文件夹' }}</span>
            </button>

            <button @click="startScan" :disabled="(scanMode === 'local_folder' || scanMode === 'local_archive') && !uploadComplete" class="scan-button" :class="{'disabled': (scanMode === 'local_folder' || scanMode === 'local_archive') && !uploadComplete}">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              {{ (scanMode === 'local_folder' || scanMode === 'local_archive') ? '第二步：开始安全审计' : '开始安全审计' }}
            </button>
          </div>

          <div class="history-section">
            <div class="history-header">
              <label class="section-label">历史审计记录</label>
              <button class="history-refresh" @click="loadHistory" :disabled="historyLoading">刷新</button>
            </div>

            <div class="history-filters">
              <select v-model="historyFilterType" class="history-select" @change="reloadHistoryFromFirstPage">
                <option value="all">全部类型</option>
                <option value="builtin">内置内核</option>
                <option value="uploaded">用户上传</option>
              </select>
              <select v-model="historyFilterStatus" class="history-select" @change="reloadHistoryFromFirstPage">
                <option value="all">全部状态</option>
                <option value="completed">已完成</option>
                <option value="running">运行中</option>
                <option value="error">失败</option>
              </select>
              <input
                v-model.trim="historyFilterTarget"
                class="history-input"
                type="text"
                placeholder="按目标名称筛选"
                @keyup.enter="reloadHistoryFromFirstPage"
              >
              <button class="history-search" @click="reloadHistoryFromFirstPage" :disabled="historyLoading">查询</button>
            </div>

            <div class="history-list" v-if="historyItems.length">
              <div v-for="item in historyItems" :key="item.run_id" class="history-item">
                <div class="history-item-top">
                  <div>
                    <div class="history-title">{{ item.target_name }} <span class="history-type">[{{ item.target_type }}]</span></div>
                    <div class="history-meta">
                      run_id: {{ item.run_id }}
                    </div>
                    <div class="history-meta">
                      开始: {{ item.started_at_text || '-' }} | 结束: {{ item.finished_at_text || '-' }}
                    </div>
                  </div>
                  <span class="history-status" :class="`status-${item.status}`">{{ item.status }}</span>
                </div>

                <div class="history-stats">
                  告警: {{ item.total_warnings }} | 分析文件: {{ item.analysis_files }}
                  <span v-if="item.is_uploaded"> | 上传占用: {{ formatBytes(item.upload_size_bytes) }} | 结果占用: {{ formatBytes(item.result_size_bytes) }}</span>
                </div>

                <div class="history-actions">
                  <button class="history-open" :disabled="!item.can_open_report" @click="openHistoryReport(item)">查看该次报告</button>
                  <button class="history-delete" :disabled="historyDeletingRunId === item.run_id" @click="deleteHistory(item, false)">删除该次记录</button>
                  <button
                    v-if="item.is_uploaded"
                    class="history-delete-all"
                    :disabled="historyDeletingRunId === item.run_id"
                    @click="deleteHistory(item, true)"
                  >
                    删除该上传内核及全部结果
                  </button>
                </div>
              </div>
            </div>

            <div v-else class="history-empty">暂无历史记录</div>

            <div class="history-pagination">
              <button class="history-page-btn" :disabled="historyPage <= 1 || historyLoading" @click="changeHistoryPage(-1)">上一页</button>
              <span>第 {{ historyPage }} 页 / 共 {{ historyTotalPages }} 页</span>
              <button class="history-page-btn" :disabled="historyPage >= historyTotalPages || historyLoading" @click="changeHistoryPage(1)">下一页</button>
            </div>
          </div>
        </div>

        <!-- 扫描进度 -->
        <div v-else class="content-section">
          <div class="progress-header">
            <h3 class="progress-title">
              <svg v-if="!scanComplete" class="spin-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              <svg v-else class="check-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              {{ scanComplete ? '审计完成' : '正在执行深度并发安全分析...' }}
            </h3>
            <span class="progress-percentage" :class="scanComplete ? 'complete' : 'in-progress'">{{ progress }}%</span>
          </div>
          
          <div class="progress-bar-container">
            <div class="progress-bar" :class="scanComplete ? 'complete' : 'in-progress'" :style="`width: ${progress}%`">
              <div class="progress-shimmer"></div>
            </div>
          </div>

          <div class="log-container" id="logBox">
            <div v-for="(log, index) in logs" :key="index" class="log-entry">
              <span class="log-time">{{ new Date().toLocaleTimeString() }}</span> 
              <span :class="{'success': log.includes('完成') || log.includes('成功'), 'warning': log.includes('警告'), 'error': log.includes('错误')}">{{ log }}</span>
            </div>
            <div v-if="!scanComplete" class="log-pulse">_</div>
          </div>

          <!-- 数据类型提示 -->
          <div v-if="scanComplete && dataSource" class="data-source-notice" :class="dataSource.is_demo ? 'demo' : 'real'">
            <svg v-if="dataSource.is_demo" xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span>{{ dataSource.message }}</span>
          </div>

          <div v-if="scanComplete" class="complete-section">
            <button @click="goToDashboard" class="complete-button">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3" />
              </svg>
              查看可视化分析报告
            </button>
          </div>
        </div>
      </div>
      
      <div class="footer text-center">
        <p>基于 GCC 插件的静态分析引擎 | 版本 1.0.0</p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import MainNav from './navigation/MainNav.vue'

export default {
  name: 'Home',
  components: {
    MainNav
  },
  data() {
    return {
      scanMode: 'server',
      selectedTarget: 'linux-6.6.1',
      selectedLocalFolder: '',
      fileCount: 0,
      dragOver: false,
      isScanning: false,
      scanComplete: false,
      isUploading: false,
      uploadComplete: false,
      uploadProgress: 0,
      progress: 0,
      logs: [],
      pollInterval: null,
      currentRunId: null,
      lastServerLogCount: 0,
      historyLoading: false,
      historyDeletingRunId: null,
      historyItems: [],
      historyPage: 1,
      historyPageSize: 8,
      historyTotal: 0,
      historyFilterType: 'all',
      historyFilterStatus: 'all',
      historyFilterTarget: '',
      uploadedArchiveOptions: [],
      uploadedArchiveLoading: false,
      selectedExistingArchiveTarget: '',
      archiveReuseMode: 'reuse_report',
      existingCompletedReports: [],
      selectedExistingRunId: '',
      dataSource: null
    }
  },
  async mounted() {
    await this.tryResumeRunningTask()
    await this.loadHistory()
    await this.loadUploadedArchiveOptions()
  },
  beforeUnmount() {
    if (this.pollInterval) {
      clearInterval(this.pollInterval)
      this.pollInterval = null
    }
  },
  methods: {
    isSupportedArchiveFile(fileName) {
      const normalized = (fileName || '').trim().toLowerCase()
      const supported = ['.zip', '.tar.gz', '.tgz', '.tar', '.tar.xz', '.txz', '.tar.bz2', '.tbz2']
      return supported.some(ext => normalized.endsWith(ext))
    },
    archiveTargetDir(fileName) {
      const normalized = (fileName || '').trim()
      return normalized.replace(/\.(tar\.gz|tgz|tar|zip|tar\.xz|txz|tar\.bz2|tbz2)$/i, '')
    },
    triggerFolderInput() {
      document.getElementById('fileInput').click()
    },
    triggerArchiveInput() {
      document.getElementById('archiveInput').click()
    },
    handleFileSelect(event) {
      const files = event.target.files
      if (files.length > 0) {
        const pathParts = files[0].webkitRelativePath.split('/')
        this.selectedLocalFolder = pathParts[0]
        this.fileCount = files.length
        this.uploadComplete = false
        this.uploadProgress = 0
      }
    },
    handleArchiveSelect(event) {
      const files = event.target.files
      if (files.length > 0) {
        const archive = files[0]
        this.selectedExistingArchiveTarget = ''
        this.selectedLocalFolder = this.archiveTargetDir(archive.name)
        this.fileCount = archive.name
        this.uploadComplete = false
        this.uploadProgress = 0
      }
    },
    async loadUploadedArchiveOptions() {
      this.uploadedArchiveLoading = true
      try {
        const res = await axios.get('/api/uploaded-archives')
        this.uploadedArchiveOptions = Array.isArray(res.data?.items) ? res.data.items : []
      } catch (_error) {
        this.uploadedArchiveOptions = []
      } finally {
        this.uploadedArchiveLoading = false
      }
    },
    onExistingArchiveChange() {
      if (!this.selectedExistingArchiveTarget) {
        this.existingCompletedReports = []
        this.selectedExistingRunId = ''
        return
      }

      const selected = this.uploadedArchiveOptions.find(item => item.target === this.selectedExistingArchiveTarget)
      if (!selected) {
        this.uploadComplete = false
        this.existingCompletedReports = []
        this.selectedExistingRunId = ''
        return
      }

      this.selectedLocalFolder = selected.target
      this.fileCount = selected.archive_name || '历史压缩包'
      this.uploadComplete = !!selected.archive_exists
      this.uploadProgress = selected.archive_exists ? 100 : 0
      this.archiveReuseMode = 'reuse_report'

      const archiveInput = document.getElementById('archiveInput')
      if (archiveInput) {
        archiveInput.value = ''
      }

      this.loadCompletedReportsForTarget(selected.target)

      if (!selected.archive_exists) {
        alert('该历史压缩包已不存在，请重新上传压缩包。')
      }
    },
    async loadCompletedReportsForTarget(targetName) {
      this.existingCompletedReports = []
      this.selectedExistingRunId = ''
      if (!targetName) {
        return
      }

      try {
        const res = await axios.get('/api/history', {
          params: {
            page: 1,
            page_size: 100,
            target_type: 'uploaded',
            status: 'completed',
            target: targetName
          }
        })
        const items = Array.isArray(res.data?.items) ? res.data.items : []
        this.existingCompletedReports = items.filter(item => item.target_name === targetName)
        if (this.existingCompletedReports.length > 0) {
          this.selectedExistingRunId = this.existingCompletedReports[0].run_id
        }
      } catch (_error) {
        this.existingCompletedReports = []
      }
    },
    handleDrop(event) {
      this.dragOver = false
      if (event.dataTransfer.items && event.dataTransfer.items.length > 0) {
        const item = event.dataTransfer.items[0]
        if (item.kind === 'file') {
          const entry = item.webkitGetAsEntry()
          if (entry && entry.isDirectory) {
            this.selectedLocalFolder = entry.name
            this.fileCount = "多个"
            this.uploadComplete = false
            this.uploadProgress = 0
          }
        }
      }
    },
    scrollToBottom() {
      setTimeout(() => {
        const box = document.getElementById('logBox')
        if (box) box.scrollTop = box.scrollHeight
      }, 100)
    },
    buildRecoverParams() {
      const target = this.scanMode === 'server' ? this.selectedTarget : (this.selectedLocalFolder || '')
      const isUploaded = this.scanMode !== 'server'
      const params = { is_uploaded: isUploaded ? 1 : 0 }
      if (target) {
        params.target = target
      }
      return params
    },
    startPollingStatus() {
      if (this.pollInterval) {
        clearInterval(this.pollInterval)
        this.pollInterval = null
      }

      this.pollInterval = setInterval(async () => {
        try {
          const res = await axios.get('/api/scan/status')
          const data = res.data || {}

          this.progress = typeof data.progress === 'number' ? data.progress : this.progress
          this.currentRunId = data.run_id || this.currentRunId
          if (this.currentRunId) {
            localStorage.setItem('currentRunId', this.currentRunId)
          }

          if (Array.isArray(data.logs)) {
            if (data.logs.length < this.lastServerLogCount) {
              this.logs = []
              this.lastServerLogCount = 0
            }
            if (data.logs.length > this.lastServerLogCount) {
              const newLogs = data.logs.slice(this.lastServerLogCount)
              this.logs.push(...newLogs)
              this.lastServerLogCount = data.logs.length
              this.scrollToBottom()
            }
          }

          if (data.status === 'completed') {
            clearInterval(this.pollInterval)
            this.pollInterval = null
            this.scanComplete = true
            this.isScanning = false
            this.progress = 100
            localStorage.setItem('hasAuditData', 'true')
            // 获取数据类型信息
            this.fetchDataSourceInfo()
            setTimeout(() => {
              this.goToDashboard()
            }, 2000)
          } else if (data.status === 'error') {
            clearInterval(this.pollInterval)
            this.pollInterval = null
            this.isScanning = false
            this.scanComplete = false
            this.logs.push('[-] 分析过程中发生错误，请检查日志。')
          }
        } catch (error) {
          clearInterval(this.pollInterval)
          this.pollInterval = null
          this.isScanning = false
          this.scanComplete = false
          this.logs.push(`错误: 获取扫描进度失败 (${error.message})`)
        }
      }, 1000)
    },
    async recoverLastTask(showAlert = true) {
      try {
        const params = this.buildRecoverParams()
        const res = await axios.get('/api/scan/recover', { params })
        const data = res.data || {}

        if (!data.recoverable) {
          if (showAlert) {
            alert(data.message || '没有可恢复的历史任务，请发起新的审计。')
          }
          return
        }

        this.currentRunId = data.run_id || null
        if (this.currentRunId) {
          localStorage.setItem('currentRunId', this.currentRunId)
        }
        this.progress = typeof data.progress === 'number' ? data.progress : 0
        this.logs = Array.isArray(data.logs) ? [...data.logs] : []
        this.lastServerLogCount = this.logs.length
        this.scrollToBottom()

        if (data.status === 'running') {
          this.isScanning = true
          this.scanComplete = false
          this.startPollingStatus()
          if (showAlert) {
            alert('已恢复到进行中的任务进度。')
          }
          return
        }

        this.isScanning = false
        this.scanComplete = true
        this.progress = 100
        localStorage.setItem('hasAuditData', 'true')
        if (showAlert) {
          alert('已恢复最近一次完成的分析结果，无需重新审计。')
        }
      } catch (error) {
        if (showAlert) {
          alert(`恢复失败: ${error?.response?.data?.message || error.message}`)
        }
      }
    },
    async tryResumeRunningTask() {
      try {
        const params = this.buildRecoverParams()
        const res = await axios.get('/api/scan/recover', { params })
        const data = res.data || {}

        // 自动恢复仅用于“进行中的任务”，避免每次打开首页都跳到历史完成结果
        if (!data.recoverable || data.status !== 'running') {
          return
        }

        this.currentRunId = data.run_id || null
        if (this.currentRunId) {
          localStorage.setItem('currentRunId', this.currentRunId)
        }
        this.progress = typeof data.progress === 'number' ? data.progress : 0
        this.logs = Array.isArray(data.logs) ? [...data.logs] : ['[*] 已恢复进行中的任务']
        this.lastServerLogCount = this.logs.length
        this.isScanning = true
        this.scanComplete = false
        this.scrollToBottom()
        this.startPollingStatus()
      } catch (_error) {
        // 自动恢复失败不打断用户正常使用
      }
    },
    formatBytes(value) {
      const size = Number(value || 0)
      if (!Number.isFinite(size) || size <= 0) return '0 B'
      const units = ['B', 'KB', 'MB', 'GB', 'TB']
      let num = size
      let idx = 0
      while (num >= 1024 && idx < units.length - 1) {
        num /= 1024
        idx += 1
      }
      return `${num.toFixed(idx === 0 ? 0 : 1)} ${units[idx]}`
    },
    async loadHistory() {
      this.historyLoading = true
      try {
        const params = {
          page: this.historyPage,
          page_size: this.historyPageSize,
          target_type: this.historyFilterType,
          status: this.historyFilterStatus
        }
        if (this.historyFilterTarget) {
          params.target = this.historyFilterTarget
        }

        const res = await axios.get('/api/history', { params })
        this.historyItems = Array.isArray(res.data?.items) ? res.data.items : []
        this.historyTotal = Number(res.data?.total || 0)
      } catch (error) {
        alert(`加载历史记录失败: ${error?.response?.data?.error || error.message}`)
      } finally {
        this.historyLoading = false
      }
    },
    reloadHistoryFromFirstPage() {
      this.historyPage = 1
      this.loadHistory()
    },
    changeHistoryPage(delta) {
      const nextPage = this.historyPage + delta
      if (nextPage < 1 || nextPage > this.historyTotalPages) {
        return
      }
      this.historyPage = nextPage
      this.loadHistory()
    },
    openHistoryReport(item) {
      if (!item?.run_id) {
        return
      }
      this.currentRunId = item.run_id
      localStorage.setItem('currentRunId', item.run_id)
      this.$router.push({ path: '/dashboard', query: { run_id: item.run_id } })
    },
    async deleteHistory(item, purgeUploadedPayload) {
      if (!item?.run_id) {
        return
      }

      const tip = purgeUploadedPayload
        ? `确认删除上传目标 ${item.target_name} 的源码压缩包、源码目录、全部历史结果和数据库记录吗？`
        : `确认删除该次审计记录 ${item.run_id} 吗？`

      if (!window.confirm(tip)) {
        return
      }

      this.historyDeletingRunId = item.run_id
      try {
        await axios.delete(`/api/history/${encodeURIComponent(item.run_id)}`, {
          params: {
            purge_uploaded_payload: purgeUploadedPayload ? 1 : 0
          }
        })
        await this.loadHistory()
      } catch (error) {
        alert(`删除失败: ${error?.response?.data?.error || error.message}`)
      } finally {
        this.historyDeletingRunId = null
      }
    },
    async uploadFiles() {
      if (!this.selectedLocalFolder) {
        alert(this.scanMode === 'local_archive' ? '请先选择压缩包文件！' : '请先选择要上传的本地源代码文件夹！')
        return
      }

      this.isUploading = true
      this.uploadProgress = 0
      if (this.scanMode === 'local_archive') {
        const archiveInput = document.getElementById('archiveInput')
        const archive = archiveInput.files[0]
        if (!archive) {
          alert('请先选择压缩包文件！')
          this.isUploading = false
          return
        }
        const formData = new FormData()
        formData.append('target_dir', this.selectedLocalFolder)
        formData.append('archive', archive)

        try {
          await axios.post('/api/upload', formData, {
            headers: {
              'Content-Type': 'multipart/form-data'
            },
            onUploadProgress: (event) => {
              if (event && event.total) {
                this.uploadProgress = Math.min(99, Math.floor((event.loaded / event.total) * 100))
              }
            }
          })
          this.uploadProgress = 100
        } catch (err) {
          const backendMessage = err?.response?.data?.error
          alert(`上传失败: ${backendMessage || err.message}`)
          this.isUploading = false
          return
        }
      } else {
        const fileInput = document.getElementById('fileInput')
        const files = fileInput.files
        const totalFiles = files.length

        const batchSize = 300
        let uploadedCount = 0

        for (let i = 0; i < files.length; i += batchSize) {
          const formData = new FormData()
          formData.append('target_dir', this.selectedLocalFolder)

          const batch = Array.from(files).slice(i, i + batchSize)
          batch.forEach(file => {
            formData.append('files', file, file.webkitRelativePath)
          })
          const batchStart = uploadedCount

          try {
            await axios.post('/api/upload', formData, {
              headers: {
                'Content-Type': 'multipart/form-data'
              },
              onUploadProgress: (event) => {
                if (event && event.total) {
                  const batchRatio = event.loaded / event.total
                  const combined = (batchStart + (batch.length * batchRatio)) / totalFiles
                  this.uploadProgress = Math.min(99, Math.floor(combined * 100))
                }
              }
            })
            uploadedCount += batch.length
            this.uploadProgress = Math.floor((uploadedCount / files.length) * 100)
          } catch (err) {
            alert(`上传失败: ${err.message}`)
            this.isUploading = false
            return
          }
        }
      }
      
      this.isUploading = false
      this.uploadComplete = true
      if (this.scanMode === 'local_archive') {
        alert('压缩包上传成功！解压将在分析阶段进行，现在可以开始安全审计。')
      } else {
        alert('源代码上传成功！现在可以开始安全审计了。')
      }
    },
    async startScan() {
      if (this.scanMode === 'local_archive' && this.selectedExistingArchiveTarget && !this.selectedExistingArchiveAvailable) {
        alert('所选历史压缩包已不存在，请重新上传压缩包后再分析。')
        return
      }

      if (this.scanMode === 'local_archive' && this.selectedExistingArchiveTarget && this.archiveReuseMode === 'reuse_report') {
        if (!this.selectedExistingRunId) {
          alert('请先选择一个历史报告。')
          return
        }
        this.currentRunId = this.selectedExistingRunId
        localStorage.setItem('currentRunId', this.selectedExistingRunId)
        localStorage.setItem('hasAuditData', 'true')
        this.$router.push({ path: '/dashboard', query: { run_id: this.selectedExistingRunId } })
        return
      }

      if ((this.scanMode === 'local_folder' || this.scanMode === 'local_archive') && !this.uploadComplete) {
        alert('请先完成源代码上传！')
        return
      }

      this.isScanning = true
      this.scanComplete = false
      this.progress = 0

      if (this.pollInterval) {
        clearInterval(this.pollInterval)
        this.pollInterval = null
      }
      
      const targetName = this.scanMode === 'server' ? this.selectedTarget : this.selectedLocalFolder
      const isUploaded = this.scanMode !== 'server'
      const forceReanalyze = this.scanMode === 'local_archive' && !!this.selectedExistingArchiveTarget && this.archiveReuseMode === 'rerun_overwrite'
      this.logs = ['初始化分析引擎...', `目标: ${targetName}`]
      this.lastServerLogCount = 0
      
      try {
        // Call backend API to start scan
        const payload = {
          target: targetName,
          is_uploaded: isUploaded,
          force_reanalyze: forceReanalyze
        }
        if (forceReanalyze) {
          payload.overwrite_existing = true
        }
        const startRes = await axios.post('/api/scan', payload)
        this.currentRunId = startRes?.data?.run_id || null
        if (this.currentRunId) {
          localStorage.setItem('currentRunId', this.currentRunId)
        }
        this.startPollingStatus()

      } catch (error) {
        this.logs.push(`错误: 无法连接到分析服务器 (${error.message})`)
        this.isScanning = false
      }
    },
    goToDashboard() {
      const query = this.currentRunId ? { run_id: this.currentRunId } : {}
      this.$router.push({ path: '/dashboard', query })
    },
    async fetchDataSourceInfo() {
      if (!this.currentRunId) return
      try {
        const res = await axios.get(`/api/data/${this.currentRunId}`)
        const data = res.data || {}
        if (data.is_demo_data) {
          this.dataSource = {
            is_demo: true,
            message: '当前显示的是演示数据，真实分析未产生有效结果'
          }
        } else {
          this.dataSource = {
            is_demo: false,
            message: '当前显示的是真实分析结果'
          }
        }
      } catch (error) {
        console.log('获取数据源信息失败:', error)
      }
    }
  },
  computed: {
    selectedExistingArchiveAvailable() {
      if (!this.selectedExistingArchiveTarget) {
        return false
      }
      const selected = this.uploadedArchiveOptions.find(item => item.target === this.selectedExistingArchiveTarget)
      return !!selected?.archive_exists
    },
    historyTotalPages() {
      const pages = Math.ceil(this.historyTotal / this.historyPageSize)
      return pages > 0 ? pages : 1
    }
  },
  watch: {
    scanMode(newValue) {
      if (newValue !== 'local_archive') {
        this.selectedExistingArchiveTarget = ''
        this.existingCompletedReports = []
        this.selectedExistingRunId = ''
        this.archiveReuseMode = 'reuse_report'
      } else {
        this.loadUploadedArchiveOptions()
      }
    }
  }
}
</script>

<style scoped>
.home {
  width: 100%;
  min-height: 100vh;
  position: relative;
  overflow: hidden;
  background-color: #0f172a;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* 网格背景 */
.grid-container {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  grid-template-rows: repeat(12, 1fr);
  height: 100%;
  width: 100%;
}

.grid-item {
  border: 1px solid rgba(59, 130, 246, 0.1);
}

/* 主内容区 */
.main-content {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

/* 头部 */
.header {
  text-align: center;
  margin-bottom: 48px;
}

.logo-container {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 80px;
  height: 80px;
  border-radius: 16px;
  margin-bottom: 24px;
  box-shadow: 0 10px 15px -3px rgba(59, 130, 246, 0.3);
  transition: transform 0.2s ease;
}

.logo-container:hover {
  transform: scale(1.05);
}

.title {
  font-size: 40px;
  font-weight: bold;
  margin-bottom: 12px;
  background: linear-gradient(to right, #60a5fa, #818cf8);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.subtitle {
  color: #94a3b8;
  font-size: 18px;
  margin-bottom: 16px;
}

.status-indicator {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 24px;
  background-color: rgba(30, 41, 59, 0.5);
  border-radius: 9999px;
  border: 1px solid rgba(51, 65, 85, 0.7);
}

.status-dot {
  display: inline-block;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background-color: #10b981;
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

.status-text {
  font-size: 14px;
  color: #e2e8f0;
}

/* 主面板 */
.main-panel {
  width: 100%;
  max-width: 48rem;
  border-radius: 24px;
  padding: 32px;
  position: relative;
  overflow: hidden;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
}

.decor-top-right {
  position: absolute;
  top: 0;
  right: 0;
  width: 160px;
  height: 160px;
  background-color: rgba(59, 130, 246, 0.1);
  border-radius: 50%;
  filter: blur(48px);
}

.decor-bottom-left {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 160px;
  height: 160px;
  background-color: rgba(99, 102, 241, 0.1);
  border-radius: 50%;
  filter: blur(48px);
}

/* 内容区域 */
.content-section {
  position: relative;
  z-index: 10;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.section-label {
  display: block;
  font-size: 14px;
  font-weight: 500;
  color: #e2e8f0;
  margin-bottom: 12px;
}

/* 按钮组 */
.button-group {
  display: flex;
  gap: 16px;
  margin-bottom: 24px;
}

.recover-button {
  width: 100%;
  margin-bottom: 12px;
  padding: 10px 12px;
  border-radius: 10px;
  border: 1px solid #334155;
  background-color: rgba(30, 41, 59, 0.7);
  color: #cbd5e1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  transition: all 0.2s ease;
}

.recover-button:hover {
  border-color: #3b82f6;
  color: #dbeafe;
}

.mode-button {
  flex: 1;
  padding: 12px 16px;
  border-radius: 12px;
  border: 1px solid;
  transition: all 0.2s ease;
}

.mode-button:hover {
  transform: scale(1.02);
}

.mode-button:active {
  transform: scale(0.98);
}

.active-button {
  background-color: #2563eb;
  color: white;
  border-color: #3b82f6;
  box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.2);
}

.inactive-button {
  background-color: #1e293b;
  color: #94a3b8;
  border-color: #334155;
}

.button-content {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

/* 服务器模式 */
.server-mode-section {
  margin-bottom: 24px;
}

.server-select {
  width: 100%;
  background-color: #1e293b;
  border: 1px solid #334155;
  color: #e2e8f0;
  padding: 12px 16px;
  border-radius: 12px;
  outline: none;
  transition: all 0.2s ease;
}

.server-select:focus {
  border-color: #3b82f6;
  box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
}

.select-help {
  margin-top: 8px;
  font-size: 12px;
  color: #94a3b8;
}

.history-section {
  margin-top: 8px;
  border: 1px solid #334155;
  border-radius: 12px;
  padding: 14px;
  background: rgba(15, 23, 42, 0.45);
}

.history-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 10px;
}

.history-refresh,
.history-search,
.history-page-btn {
  border: 1px solid #334155;
  background-color: #1e293b;
  color: #cbd5e1;
  border-radius: 8px;
  padding: 6px 10px;
}

.history-filters {
  display: grid;
  grid-template-columns: 1fr 1fr 1.2fr auto;
  gap: 8px;
  margin-bottom: 12px;
}

.history-select,
.history-input {
  border: 1px solid #334155;
  background: #0f172a;
  color: #e2e8f0;
  border-radius: 8px;
  padding: 8px;
}

.history-list {
  max-height: 360px;
  overflow: auto;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.history-item {
  border: 1px solid #334155;
  border-radius: 10px;
  padding: 10px;
  background: rgba(30, 41, 59, 0.45);
}

.history-item-top {
  display: flex;
  justify-content: space-between;
  gap: 8px;
}

.history-title {
  color: #e2e8f0;
  font-weight: 600;
  font-size: 14px;
}

.history-type,
.history-meta,
.history-stats,
.history-empty,
.history-pagination {
  color: #94a3b8;
  font-size: 12px;
}

.history-stats {
  margin-top: 6px;
}

.history-status {
  font-size: 12px;
  border: 1px solid #334155;
  border-radius: 999px;
  padding: 3px 10px;
  height: fit-content;
}

.status-completed {
  color: #86efac;
  border-color: #166534;
}

.status-running {
  color: #93c5fd;
  border-color: #1d4ed8;
}

.status-error {
  color: #fca5a5;
  border-color: #b91c1c;
}

.history-actions {
  margin-top: 8px;
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.history-open,
.history-delete,
.history-delete-all {
  border-radius: 8px;
  padding: 6px 10px;
  font-size: 12px;
  border: 1px solid #334155;
}

.history-open {
  background: #1d4ed8;
  color: #fff;
}

.history-delete {
  background: #7f1d1d;
  color: #fee2e2;
}

.history-delete-all {
  background: #991b1b;
  color: #fee2e2;
}

.history-pagination {
  margin-top: 10px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

/* 上传区域 */
.upload-section {
  margin-bottom: 24px;
  border: 2px dashed #334155;
  border-radius: 12px;
  padding: 32px;
  text-align: center;
  cursor: pointer;
  transition: all 0.2s ease;
}

.archive-upload-section {
  cursor: default;
}

.archive-select-button {
  margin-top: 12px;
  background-color: #2563eb;
  color: #fff;
  border: 1px solid #3b82f6;
  border-radius: 10px;
  padding: 8px 14px;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.2s ease;
}

.archive-select-button:hover {
  background-color: #1d4ed8;
}

.archive-history-block {
  margin-top: 12px;
}

.archive-history-row {
  display: flex;
  gap: 10px;
  align-items: center;
}

.archive-strategy-block {
  margin-top: 10px;
}

.archive-strategy-group {
  margin-bottom: 10px;
}

.archive-report-picker {
  margin-top: 8px;
}

.archive-missing-tip {
  margin-top: 8px;
  color: #f59e0b;
  font-size: 13px;
}

.upload-section:hover {
  border-color: #3b82f6;
}

.upload-section.drag-over {
  border-color: #3b82f6;
  background-color: rgba(59, 130, 246, 0.1);
}

.upload-content {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.upload-icon-container {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background-color: #1e293b;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16px;
}

.upload-title {
  font-size: 18px;
  font-weight: 600;
  color: #e2e8f0;
  margin-bottom: 8px;
}

.upload-title.selected {
  color: #60a5fa;
}

.upload-description {
  color: #94a3b8;
  margin-bottom: 8px;
}

.upload-help {
  color: #64748b;
  font-size: 14px;
}

/* 操作区域 */
.action-section {
  padding-top: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.upload-button,
.scan-button {
  width: 100%;
  color: white;
  font-weight: 600;
  padding: 14px 16px;
  border-radius: 10px;
  box-shadow: 0 6px 10px -3px rgba(37, 99, 235, 0.2);
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  font-size: 14px;
  min-height: 48px;
}

.upload-button {
  background: linear-gradient(to right, #4f46e5, #9333ea);
  box-shadow: 0 6px 10px -3px rgba(79, 70, 229, 0.2);
}

.upload-button:hover {
  background: linear-gradient(to right, #4338ca, #7e22ce);
  transform: translateY(-1px);
  box-shadow: 0 8px 12px -3px rgba(79, 70, 229, 0.3);
}

.upload-button:active {
  transform: translateY(0);
  box-shadow: 0 4px 6px -3px rgba(79, 70, 229, 0.2);
}

.scan-button {
  background: linear-gradient(to right, #2563eb, #4f46e5);
}

.scan-button:hover:not(.disabled) {
  background: linear-gradient(to right, #1d4ed8, #4338ca);
  transform: translateY(-1px);
  box-shadow: 0 8px 12px -3px rgba(37, 99, 235, 0.3);
}

.scan-button:active:not(.disabled) {
  transform: translateY(0);
  box-shadow: 0 4px 6px -3px rgba(37, 99, 235, 0.2);
}

.scan-button.disabled {
  background: linear-gradient(to right, #64748b, #94a3b8);
  color: white;
  cursor: not-allowed;
  box-shadow: none;
}

.scan-button.disabled:hover {
  transform: none;
  box-shadow: none;
}

/* 进度区域 */
.progress-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 8px;
}

.progress-title {
  font-size: 18px;
  font-weight: 600;
  color: #60a5fa;
  display: flex;
  align-items: center;
  gap: 8px;
}

.spin-icon {
  width: 20px;
  height: 20px;
  color: #60a5fa;
  animation: spin 1s linear infinite;
}

.check-icon {
  width: 20px;
  height: 20px;
  color: #10b981;
}

.progress-percentage {
  font-size: 24px;
  font-weight: bold;
  font-family: monospace;
}

.progress-percentage.in-progress {
  color: #60a5fa;
}

.progress-percentage.complete {
  color: #10b981;
}

.progress-bar-container {
  width: 100%;
  background-color: #1e293b;
  border-radius: 9999px;
  height: 20px;
  border: 1px solid #334155;
  overflow: hidden;
  box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.1);
}

.progress-bar {
  height: 100%;
  border-radius: 9999px;
  transition: width 0.5s ease-out;
  position: relative;
}

.progress-bar.in-progress {
  background: linear-gradient(to right, #2563eb, #4f46e5);
}

.progress-bar.complete {
  background: #10b981;
}

.progress-shimmer {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
  transform: skewX(-20deg);
  animation: shimmer 2s infinite linear;
}

/* 日志容器 */
.log-container {
  background-color: rgba(15, 23, 42, 0.7);
  border: 1px solid rgba(51, 65, 85, 0.5);
  border-radius: 12px;
  padding: 16px;
  height: 208px;
  overflow-y: auto;
  font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
  font-size: 12px;
  line-height: 1.5;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.log-entry {
  animation: fadeIn 0.3s ease-in-out;
}

.log-time {
  color: #64748b;
}

.log-entry.success {
  color: #10b981;
}

.log-entry.warning {
  color: #f59e0b;
}

.log-entry.error {
  color: #ef4444;
}

.log-pulse {
  color: #3b82f6;
  animation: pulse 1.5s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

/* 数据源提示 */
.data-source-notice {
  margin: 12px 0;
  padding: 10px 16px;
  border-radius: 8px;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 8px;
  animation: fadeIn 0.3s ease-in-out;
}

.data-source-notice.demo {
  background-color: rgba(245, 158, 11, 0.15);
  border: 1px solid rgba(245, 158, 11, 0.3);
  color: #fbbf24;
}

.data-source-notice.real {
  background-color: rgba(16, 185, 129, 0.15);
  border: 1px solid rgba(16, 185, 129, 0.3);
  color: #6ee7b7;
}

/* 完成区域 */
.complete-section {
  padding-top: 8px;
  animation: fadeIn 0.3s ease-in-out;
}

.complete-button {
  width: 100%;
  color: white;
  font-weight: bold;
  padding: 12px;
  border-radius: 12px;
  box-shadow: 0 10px 15px -3px rgba(5, 150, 105, 0.2);
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  background: linear-gradient(to right, #059669, #0d9488);
}

.complete-button:hover {
  background: linear-gradient(to right, #047857, #0f766e);
  transform: scale(1.02);
}

.complete-button:active {
  transform: scale(0.98);
}

/* 页脚 */
.footer {
  text-align: center;
  margin-top: 32px;
  color: #64748b;
  font-size: 14px;
}

/* 动画 */
@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

@keyframes shimmer {
  0% {
    transform: translateX(-100%) skewX(-20deg);
  }
  100% {
    transform: translateX(200%) skewX(-20deg);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(5px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .title {
    font-size: 32px;
  }
  
  .main-panel {
    border-radius: 16px;
    padding: 24px;
  }
  
  .button-group {
    flex-direction: column;
  }
  
  .upload-section {
    padding: 24px;
  }
}
</style>