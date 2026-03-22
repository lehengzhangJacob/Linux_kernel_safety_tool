<template>
  <div class="info-leak-page">
    <MainNav :has-audit-data="true" />
    
    <div class="page-container">
      <div class="page-header">
        <div class="header-content">
          <div class="header-icon leak-icon">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
            </svg>
          </div>
          <div class="header-text">
            <h1 class="page-title">信息泄露检测</h1>
            <p class="page-subtitle">检测敏感信息泄露，包括日志、网络传输、文件输出等</p>
          </div>
        </div>
      </div>

      <div class="stats-grid">
        <div class="stat-card log-leak">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
            </div>
            <div class="stat-title">日志泄露</div>
          </div>
          <div class="stat-value">{{ stats.logLeak }}</div>
          <div class="stat-severity high">高危</div>
        </div>

        <div class="stat-card network-leak">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.111 16.404a5.5 5.5 0 017.778 0M12 20h.01m-7.08-7.071c3.904-3.905 10.236-3.905 14.141 0M1.394 9.393c5.857-5.857 15.355-5.857 21.213 0" />
              </svg>
            </div>
            <div class="stat-title">网络泄露</div>
          </div>
          <div class="stat-value">{{ stats.networkLeak }}</div>
          <div class="stat-severity critical">严重</div>
        </div>

        <div class="stat-card file-leak">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
              </svg>
            </div>
            <div class="stat-title">文件泄露</div>
          </div>
          <div class="stat-value">{{ stats.fileLeak }}</div>
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
              <h2 class="section-title">信息泄露详情</h2>
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
                <option value="Log">日志泄露</option>
                <option value="Network">网络泄露</option>
                <option value="File">文件泄露</option>
              </select>
              <select v-model="filterSeverity" class="filter-select">
                <option value="all">全部严重程度</option>
                <option value="Critical">严重</option>
                <option value="High">高危</option>
                <option value="Medium">中等</option>
                <option value="Low">低危</option>
              </select>
              <select v-model="filterData" class="filter-select">
                <option value="all">全部数据类型</option>
                <option value="password">密码</option>
                <option value="key">密钥</option>
                <option value="token">令牌</option>
                <option value="creditcard">信用卡</option>
                <option value="personal">个人信息</option>
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
                    {{ issue.type }} 泄露
                  </div>
                  <div class="issue-severity" :class="issue.severity.toLowerCase()">
                    {{ issue.severity }}
                  </div>
                  <div class="issue-data-type" :class="issue.dataType.toLowerCase()">
                    {{ issue.dataType }}
                  </div>
                </div>
                <div class="issue-message">{{ issue.message }}</div>
                <div v-if="issue.pattern" class="issue-pattern">
                  <span class="pattern-label">匹配模式：</span>
                  <code>{{ issue.pattern }}</code>
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
                <div class="info-item-title">日志泄露</div>
                <div class="info-item-desc">检测日志输出中包含的敏感信息，如密码、密钥等</div>
              </div>
              <div class="info-item">
                <div class="info-item-title">网络泄露</div>
                <div class="info-item-desc">检测网络传输中未加密的敏感数据</div>
              </div>
              <div class="info-item">
                <div class="info-item-title">文件泄露</div>
                <div class="info-item-desc">检测文件输出中包含的敏感信息</div>
              </div>
            </div>
          </div>

          <div class="info-card">
            <h3 class="info-title">敏感数据类型</h3>
            <div class="data-types-list">
              <div class="data-type-item">
                <div class="data-type-icon password">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                  </svg>
                </div>
                <div>
                  <div class="data-type-name">密码</div>
                  <div class="data-type-desc">明文密码、哈希值</div>
                </div>
              </div>
              <div class="data-type-item">
                <div class="data-type-icon key">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
                  </svg>
                </div>
                <div>
                  <div class="data-type-name">密钥</div>
                  <div class="data-type-desc">API密钥、私钥</div>
                </div>
              </div>
              <div class="data-type-item">
                <div class="data-type-icon token">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
                  </svg>
                </div>
                <div>
                  <div class="data-type-name">令牌</div>
                  <div class="data-type-desc">JWT、OAuth令牌</div>
                </div>
              </div>
              <div class="data-type-item">
                <div class="data-type-icon creditcard">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z" />
                  </svg>
                </div>
                <div>
                  <div class="data-type-name">信用卡</div>
                  <div class="data-type-desc">卡号、CVV</div>
                </div>
              </div>
              <div class="data-type-item">
                <div class="data-type-icon personal">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                  </svg>
                </div>
                <div>
                  <div class="data-type-name">个人信息</div>
                  <div class="data-type-desc">身份证、手机号、邮箱</div>
                </div>
              </div>
            </div>
          </div>

          <div class="info-card">
            <h3 class="info-title">防护建议</h3>
            <ul class="suggestions-list">
              <li>使用日志脱敏工具，避免记录敏感信息</li>
              <li>敏感数据传输必须使用加密协议（HTTPS、TLS）</li>
              <li>使用安全的存储方案，避免明文存储密码</li>
              <li>定期审计日志文件，及时清理敏感信息</li>
              <li>实施最小权限原则，限制敏感数据访问</li>
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
  name: 'InfoLeak',
  components: {
    MainNav
  },
  data() {
    return {
      loading: false,
      filterType: 'all',
      filterSeverity: 'all',
      filterData: 'all',
      issues: [],
      stats: {
        logLeak: 0,
        networkLeak: 0,
        fileLeak: 0,
        total: 0
      }
    }
  },
  computed: {
    filteredIssues() {
      return this.issues.filter(issue => {
        const typeMatch = this.filterType === 'all' || issue.type === this.filterType
        const severityMatch = this.filterSeverity === 'all' || issue.severity === this.filterSeverity
        const dataMatch = this.filterData === 'all' || issue.dataType.toLowerCase() === this.filterData
        return typeMatch && severityMatch && dataMatch
      })
    }
  },
  async mounted() {
    await this.loadData()
  },
  methods: {
    async loadData() {
      this.loading = true
      try {
        const response = await axios.get('/api/detections?type=InfoLeak')
        this.issues = response.data.issues || []
        this.updateStats()
      } catch (error) {
        console.error('加载数据失败:', error)
        this.loadDemoData()
      } finally {
        this.loading = false
      }
    },
    loadDemoData() {
      this.issues = [
        {
          type: 'Log',
          severity: 'High',
          dataType: 'password',
          message: 'Potential password leak in log output',
          pattern: 'password=.*',
          file: 'kernel/net/ipv4/tcp.c',
          line: 1234,
          column: 5,
          suggestion: 'Remove password from log output or use masking'
        },
        {
          type: 'Network',
          severity: 'Critical',
          dataType: 'key',
          message: 'Unencrypted API key transmitted over network',
          pattern: 'api_key=.*',
          file: 'kernel/net/socket.c',
          line: 567,
          column: 12,
          suggestion: 'Use encrypted transmission for sensitive data'
        },
        {
          type: 'File',
          severity: 'High',
          dataType: 'token',
          message: 'Authentication token written to file',
          pattern: 'token=.*',
          file: 'kernel/fs/file.c',
          line: 890,
          column: 8,
          suggestion: 'Avoid writing tokens to files, use secure storage'
        }
      ]
      this.updateStats()
    },
    updateStats() {
      this.stats.logLeak = this.issues.filter(i => i.type === 'Log').length
      this.stats.networkLeak = this.issues.filter(i => i.type === 'Network').length
      this.stats.fileLeak = this.issues.filter(i => i.type === 'File').length
      this.stats.total = this.issues.length
    },
    async refreshData() {
      await this.loadData()
    }
  }
}
</script>

<style scoped>
.info-leak-page {
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

.leak-icon {
  background: linear-gradient(to bottom right, #8b5cf6, #7c3aed);
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

.log-leak .stat-icon {
  background: linear-gradient(to bottom right, #f59e0b, #d97706);
}

.network-leak .stat-icon {
  background: linear-gradient(to bottom right, #dc2626, #b91c1c);
}

.file-leak .stat-icon {
  background: linear-gradient(to bottom right, #f97316, #ea580c);
}

.total .stat-icon {
  background: linear-gradient(to bottom right, #8b5cf6, #7c3aed);
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
  flex-wrap: wrap;
  gap: 0.5rem;
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

.issue-data-type {
  font-size: 0.75rem;
  font-weight: 600;
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
  background: #f3e8ff;
  color: #7c3aed;
}

.issue-message {
  font-weight: 500;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.issue-pattern {
  background: #fef3c7;
  padding: 0.5rem;
  border-radius: 0.5rem;
  font-size: 0.875rem;
  margin-bottom: 0.5rem;
}

.pattern-label {
  font-weight: 600;
  color: #92400e;
}

.issue-pattern code {
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

.data-types-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.data-type-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  background: #f8fafc;
  border-radius: 0.5rem;
}

.data-type-icon {
  width: 2rem;
  height: 2rem;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.data-type-icon.password {
  background: linear-gradient(to bottom right, #dc2626, #b91c1c);
}

.data-type-icon.key {
  background: linear-gradient(to bottom right, #f59e0b, #d97706);
}

.data-type-icon.token {
  background: linear-gradient(to bottom right, #8b5cf6, #7c3aed);
}

.data-type-icon.creditcard {
  background: linear-gradient(to bottom right, #3b82f6, #2563eb);
}

.data-type-icon.personal {
  background: linear-gradient(to bottom right, #10b981, #059669);
}

.data-type-name {
  font-weight: 600;
  color: #1e293b;
  font-size: 0.875rem;
}

.data-type-desc {
  color: #64748b;
  font-size: 0.75rem;
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