<template>
  <div class="toctou-page">
    <MainNav :has-audit-data="true" />
    
    <div class="page-container">
      <div class="page-header">
        <div class="header-content">
          <div class="header-icon toctou-icon">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <div class="header-text">
            <h1 class="page-title">TOCTOU检测</h1>
            <p class="page-subtitle">检测时间检查到时间使用（TOCTOU）漏洞，防止竞态条件攻击</p>
          </div>
        </div>
      </div>

      <div class="stats-grid">
        <div class="stat-card file-toctou">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
              </svg>
            </div>
            <div class="stat-title">文件TOCTOU</div>
          </div>
          <div class="stat-value">{{ stats.fileToctou }}</div>
          <div class="stat-severity critical">严重</div>
        </div>

        <div class="stat-card symlink">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
              </svg>
            </div>
            <div class="stat-title">符号链接攻击</div>
          </div>
          <div class="stat-value">{{ stats.symlinkAttack }}</div>
          <div class="stat-severity critical">严重</div>
        </div>

        <div class="stat-card race-window">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <div class="stat-title">竞态窗口</div>
          </div>
          <div class="stat-value">{{ stats.raceWindow }}</div>
          <div class="stat-severity high">高危</div>
        </div>

        <div class="stat-card total">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
              </svg>
            </div>
            <div class="stat-title">总计</div>
          </div>
          <div class="stat-value">{{ stats.total }}</div>
          <div class="stat-severity">全部</div>
        </div>
      </div>

      <div class="content-grid">
        <div class="main-content">
          <div class="section-card">
            <div class="section-header">
              <h2 class="section-title">TOCTOU漏洞详情</h2>
              <div class="section-actions">
                <button @click="refreshData" class="action-btn" :disabled="loading">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                  </svg>
                  刷新
                </button>
              </div>
            </div>

            <div class="filter-section">
              <select v-model="filterType" class="filter-select">
                <option value="all">全部类型</option>
                <option value="FileTOCTOU">文件TOCTOU</option>
                <option value="SymlinkAttack">符号链接攻击</option>
                <option value="RaceWindow">竞态窗口</option>
              </select>
              <select v-model="filterSeverity" class="filter-select">
                <option value="all">全部严重程度</option>
                <option value="Critical">严重</option>
                <option value="High">高危</option>
                <option value="Medium">中等</option>
                <option value="Low">低危</option>
              </select>
            </div>

            <div v-if="loading" class="loading-state">
              <div class="spinner"></div>
              <p>加载数据中...</p>
            </div>

            <div v-else-if="filteredIssues.length === 0" class="empty-state">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <p>暂无检测到的问题</p>
            </div>

            <div v-else class="issues-list">
              <div v-for="(issue, index) in filteredIssues" :key="index" class="issue-item" :class="issue.type.toLowerCase()">
                <div class="issue-header">
                  <div class="issue-type-badge" :class="issue.severity.toLowerCase()">
                    {{ issue.type }}
                  </div>
                  <div class="issue-severity" :class="issue.severity.toLowerCase()">
                    {{ issue.severity }}
                  </div>
                </div>
                <div class="issue-message">{{ issue.message }}</div>
                <div v-if="issue.checkFunction" class="issue-function">
                  <span class="function-label">检查函数：</span>
                  <code>{{ issue.checkFunction }}</code>
                </div>
                <div v-if="issue.useFunction" class="issue-function">
                  <span class="function-label">使用函数：</span>
                  <code>{{ issue.useFunction }}</code>
                </div>
                <div class="issue-location">
                  <span class="location-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                  </span>
                  {{ issue.file }}:{{ issue.line }}:{{ issue.column }}
                </div>
                <div v-if="issue.suggestion" class="issue-suggestion">
                  <span class="suggestion-label">修复建议：</span>
                  {{ issue.suggestion }}
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="sidebar">
          <div class="info-card">
            <h3 class="info-title">检测原理</h3>
            <div class="info-content">
              <div class="info-item">
                <div class="info-item-title">文件TOCTOU</div>
                <div class="info-item-desc">检测文件检查与使用之间的时间窗口，防止文件被替换</div>
              </div>
              <div class="info-item">
                <div class="info-item-title">符号链接攻击</div>
                <div class="info-item-desc">检测符号链接替换攻击，防止指向敏感文件</div>
              </div>
              <div class="info-item">
                <div class="info-item-title">竞态窗口</div>
                <div class="info-item-desc">分析检查与使用之间的时间差，识别可利用的竞态窗口</div>
              </div>
            </div>
          </div>

          <div class="info-card">
            <h3 class="info-title">常见漏洞示例</h3>
            <div class="code-example">
              <pre><code>int fd;
struct stat st;

if (stat("/tmp/file", &st) == 0) {
    if (st.st_uid == 0) {
        fd = open("/tmp/file", O_RDONLY);
        // TOCTOU: 攻击者可以在stat和open之间
        // 替换文件或创建符号链接
        process_file(fd);
    }
}

// 更安全的做法
fd = open("/tmp/file", O_RDONLY);
if (fd >= 0 && fstat(fd, &st) == 0) {
    if (st.st_uid == 0) {
        process_file(fd);
    }
}</code></pre>
            </div>
          </div>

          <div class="info-card">
            <h3 class="info-title">防护建议</h3>
            <ul class="suggestions-list">
              <li>使用原子操作，避免检查与使用分离</li>
              <li>使用O_NOFOLLOW标志防止符号链接攻击</li>
              <li>使用fstat替代stat，对已打开的文件描述符操作</li>
              <li>使用secure_getenv等安全函数</li>
              <li>在临时文件中使用O_EXCL标志</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import MainNav from '../components/navigation/MainNav.vue'

export default {
  name: 'TOCTOU',
  components: {
    MainNav
  },
  data() {
    return {
      loading: false,
      filterType: 'all',
      filterSeverity: 'all',
      issues: [],
      totalCountFromApi: 0,
      stats: {
        fileToctou: 0,
        symlinkAttack: 0,
        raceWindow: 0,
        total: 0
      }
    }
  },
  computed: {
    filteredIssues() {
      return this.issues.filter(issue => {
        const typeMatch = this.filterType === 'all' || issue.type === this.filterType
        const severityMatch = this.filterSeverity === 'all' || issue.severity === this.filterSeverity
        return typeMatch && severityMatch
      })
    }
  },
  async mounted() {
    await this.loadData()
  },
  watch: {
    '$route.query.run_id': {
      async handler() {
        await this.loadData()
      }
    }
  },
  methods: {
    async loadData() {
      this.loading = true
      try {
        const runId = this.$route?.query?.run_id || localStorage.getItem('currentRunId') || undefined
        const response = await axios.get('/api/detections', {
          params: {
            type: 'TOCTOU',
            run_id: runId
          }
        })
        if (response?.data?.run_id) {
          localStorage.setItem('currentRunId', response.data.run_id)
        }
        this.issues = response.data.issues || []
        this.totalCountFromApi = Number(response?.data?.total_count || this.issues.length)
        this.stats.fileToctou = 0
        this.stats.symlinkAttack = 0
        this.stats.raceWindow = 0
        const subtypeCounts = response?.data?.subtype_counts || {}
        if (Object.keys(subtypeCounts).length > 0) {
          this.stats.fileToctou = Number(subtypeCounts.FileTOCTOU || 0)
          this.stats.symlinkAttack = Number(subtypeCounts.SymlinkAttack || 0)
          this.stats.raceWindow = Number(subtypeCounts.RaceWindow || 0)
        }
        this.updateStats()
      } catch (error) {
        console.error('加载数据失败:', error)
        this.issues = []
        this.totalCountFromApi = 0
        this.stats.fileToctou = 0
        this.stats.symlinkAttack = 0
        this.stats.raceWindow = 0
        this.updateStats()
      } finally {
        this.loading = false
      }
    },
    loadDemoData() {
      this.issues = [
        {
          type: 'FileTOCTOU',
          severity: 'Critical',
          message: 'Time-of-check to time-of-use vulnerability in file access',
          checkFunction: 'stat',
          useFunction: 'open',
          file: 'kernel/fs/open.c',
          line: 1234,
          column: 5,
          suggestion: 'Use atomic operations or open with O_NOFOLLOW flag'
        },
        {
          type: 'SymlinkAttack',
          severity: 'Critical',
          message: 'Potential symlink attack in file operation',
          checkFunction: 'access',
          useFunction: 'open',
          file: 'kernel/fs/namei.c',
          line: 567,
          column: 12,
          suggestion: 'Use O_NOFOLLOW and O_PATH flags to prevent symlink attacks'
        },
        {
          type: 'RaceWindow',
          severity: 'High',
          message: 'Race condition window detected between check and use',
          checkFunction: 'lstat',
          useFunction: 'openat',
          file: 'kernel/fs/stat.c',
          line: 890,
          column: 8,
          suggestion: 'Minimize time between check and use, use atomic operations'
        }
      ]
      this.updateStats()
    },
    updateStats() {
      if (!this.stats.fileToctou && !this.stats.symlinkAttack && !this.stats.raceWindow) {
        this.stats.fileToctou = this.issues.filter(i => i.type === 'FileTOCTOU').length
        this.stats.symlinkAttack = this.issues.filter(i => i.type === 'SymlinkAttack').length
        this.stats.raceWindow = this.issues.filter(i => i.type === 'RaceWindow').length
      }
      this.stats.total = this.totalCountFromApi || this.issues.length
    },
    async refreshData() {
      await this.loadData()
    }
  }
}
</script>

<style scoped>
.toctou-page {
  min-height: 100vh;
  background: linear-gradient(to bottom, #f8fafc, #e2e8f0);
}

.page-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 2rem;
}

.page-header {
  margin-bottom: 2rem;
}

.header-content {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.header-icon {
  width: 4rem;
  height: 4rem;
  border-radius: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.toctou-icon {
  background: linear-gradient(to bottom right, #ec4899, #db2777);
}

.page-title {
  font-size: 2rem;
  font-weight: 700;
  color: #1e293b;
  margin: 0;
}

.page-subtitle {
  color: #64748b;
  margin: 0.5rem 0 0 0;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  background: white;
  border-radius: 1rem;
  padding: 1.5rem;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s;
}

.stat-card:hover {
  transform: translateY(-2px);
}

.stat-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1rem;
}

.stat-icon {
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.file-toctou .stat-icon {
  background: linear-gradient(to bottom right, #dc2626, #b91c1c);
}

.symlink .stat-icon {
  background: linear-gradient(to bottom right, #f97316, #ea580c);
}

.race-window .stat-icon {
  background: linear-gradient(to bottom right, #f59e0b, #d97706);
}

.total .stat-icon {
  background: linear-gradient(to bottom right, #ec4899, #db2777);
}

.stat-title {
  font-weight: 600;
  color: #475569;
}

.stat-value {
  font-size: 2.5rem;
  font-weight: 700;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.stat-severity {
  font-size: 0.875rem;
  font-weight: 600;
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
  display: inline-block;
}

.stat-severity.critical {
  background: #fee2e2;
  color: #dc2626;
}

.stat-severity.high {
  background: #fef3c7;
  color: #d97706;
}

.stat-severity {
  background: #dbeafe;
  color: #2563eb;
}

.content-grid {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 1.5rem;
}

@media (max-width: 1024px) {
  .content-grid {
    grid-template-columns: 1fr;
  }
}

.section-card {
  background: white;
  border-radius: 1rem;
  padding: 1.5rem;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.section-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: #1e293b;
  margin: 0;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: #3b82f6;
  color: white;
  border: none;
  border-radius: 0.5rem;
  cursor: pointer;
  font-weight: 500;
  transition: background 0.2s;
}

.action-btn:hover:not(:disabled) {
  background: #2563eb;
}

.action-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.filter-section {
  display: flex;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.filter-select {
  flex: 1;
  padding: 0.5rem 0.75rem;
  border: 1px solid #e2e8f0;
  border-radius: 0.5rem;
  font-size: 0.875rem;
}

.loading-state,
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3rem;
  color: #64748b;
}

.spinner {
  width: 3rem;
  height: 3rem;
  border: 3px solid #e2e8f0;
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 1rem;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.issues-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.issue-item {
  border: 1px solid #e2e8f0;
  border-radius: 0.75rem;
  padding: 1rem;
  transition: box-shadow 0.2s;
}

.issue-item:hover {
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.issue-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
}

.issue-type-badge {
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
}

.issue-type-badge.critical {
  background: #fee2e2;
  color: #dc2626;
}

.issue-type-badge.high {
  background: #fef3c7;
  color: #d97706;
}

.issue-severity {
  font-size: 0.75rem;
  font-weight: 600;
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
}

.issue-severity.critical {
  background: #fee2e2;
  color: #dc2626;
}

.issue-severity.high {
  background: #fef3c7;
  color: #d97706;
}

.issue-message {
  font-weight: 500;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.issue-function {
  background: #fef3c7;
  padding: 0.5rem;
  border-radius: 0.5rem;
  font-size: 0.875rem;
  margin-bottom: 0.5rem;
}

.function-label {
  font-weight: 600;
  color: #92400e;
}

.issue-function code {
  font-family: 'Courier New', monospace;
  color: #92400e;
}

.issue-location {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  color: #64748b;
  font-size: 0.875rem;
  margin-bottom: 0.5rem;
}

.location-icon {
  color: #94a3b8;
}

.issue-suggestion {
  background: #f8fafc;
  padding: 0.75rem;
  border-radius: 0.5rem;
  font-size: 0.875rem;
  color: #475569;
}

.suggestion-label {
  font-weight: 600;
  color: #1e293b;
}

.sidebar {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.info-card {
  background: white;
  border-radius: 1rem;
  padding: 1.5rem;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.info-title {
  font-size: 1.125rem;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 1rem 0;
}

.info-content {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.info-item-title {
  font-weight: 600;
  color: #475569;
  margin-bottom: 0.25rem;
}

.info-item-desc {
  color: #64748b;
  font-size: 0.875rem;
  line-height: 1.5;
}

.code-example {
  background: #1e293b;
  border-radius: 0.5rem;
  padding: 1rem;
  overflow-x: auto;
}

.code-example pre {
  margin: 0;
  font-family: 'Courier New', monospace;
  font-size: 0.875rem;
  line-height: 1.5;
}

.code-example code {
  color: #e2e8f0;
}

.suggestions-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.suggestions-list li {
  padding: 0.5rem 0;
  padding-left: 1.5rem;
  position: relative;
  color: #475569;
  font-size: 0.875rem;
}

.suggestions-list li::before {
  content: '✓';
  position: absolute;
  left: 0;
  color: #22c55e;
  font-weight: bold;
}
</style>