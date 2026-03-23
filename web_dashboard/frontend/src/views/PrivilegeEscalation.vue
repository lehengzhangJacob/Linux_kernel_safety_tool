<template>
  <div class="privilege-escalation-page">
    <MainNav :has-audit-data="true" />
    
    <div class="page-container">
      <div class="page-header">
        <div class="header-content">
          <div class="header-icon privilege-icon">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
            </svg>
          </div>
          <div class="header-text">
            <h1 class="page-title">权限提升检测</h1>
            <p class="page-subtitle">检测内核中的权限提升漏洞，包括特权系统调用、权限检查绕过等</p>
          </div>
        </div>
      </div>

      <div class="stats-grid">
        <div class="stat-card syscall">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
              </svg>
            </div>
            <div class="stat-title">特权系统调用</div>
          </div>
          <div class="stat-value">{{ stats.privilegedSyscall }}</div>
          <div class="stat-severity high">高危</div>
        </div>

        <div class="stat-card permission">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
              </svg>
            </div>
            <div class="stat-title">权限检查绕过</div>
          </div>
          <div class="stat-value">{{ stats.permissionBypass }}</div>
          <div class="stat-severity critical">严重</div>
        </div>

        <div class="stat-card capability">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <div class="stat-title">能力检查缺失</div>
          </div>
          <div class="stat-value">{{ stats.capabilityCheck }}</div>
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
              <h2 class="section-title">权限提升详情</h2>
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
                <option value="PrivilegedSyscall">特权系统调用</option>
                <option value="PermissionBypass">权限检查绕过</option>
                <option value="CapabilityCheck">能力检查缺失</option>
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
                <div v-if="issue.syscall" class="issue-syscall">
                  <span class="syscall-label">系统调用：</span>
                  <code>{{ issue.syscall }}</code>
                </div>
                <div v-if="issue.capability" class="issue-capability">
                  <span class="capability-label">所需能力：</span>
                  <code>{{ issue.capability }}</code>
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
                <div class="info-item-title">特权系统调用</div>
                <div class="info-item-desc">检测未进行充分权限检查的特权系统调用</div>
              </div>
              <div class="info-item">
                <div class="info-item-title">权限检查绕过</div>
                <div class="info-item-desc">识别可能被绕过的权限检查逻辑</div>
              </div>
              <div class="info-item">
                <div class="info-item-title">能力检查缺失</div>
                <div class="info-item-desc">检测缺少Linux能力检查的操作</div>
              </div>
            </div>
          </div>

          <div class="info-card">
            <h3 class="info-title">常见漏洞示例</h3>
            <div class="code-example">
              <pre><code>asmlinkage long sys_mknod(const char __user *filename,
                               umode_t mode, unsigned dev) {
    // 缺少权限检查
    return vfs_mknod(filename, mode, dev);
}

asmlinkage long sys_setuid(uid_t uid) {
    // 直接设置UID，未检查调用者权限
    current->cred->uid = uid;
    return 0;
}</code></pre>
            </div>
          </div>

          <div class="info-card">
            <h3 class="info-title">防护建议</h3>
            <ul class="suggestions-list">
              <li>在所有特权操作前进行严格的权限检查</li>
              <li>使用Linux能力机制替代传统UID/GID检查</li>
              <li>实施最小权限原则，避免过度授权</li>
              <li>使用内核安全模块（LSM）加强访问控制</li>
              <li>定期审计特权系统调用的实现</li>
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
  name: 'PrivilegeEscalation',
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
        privilegedSyscall: 0,
        permissionBypass: 0,
        capabilityCheck: 0,
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
            type: 'PrivilegeEscalation',
            run_id: runId
          }
        })
        if (response?.data?.run_id) {
          localStorage.setItem('currentRunId', response.data.run_id)
        }
        this.issues = response.data.issues || []
        this.totalCountFromApi = Number(response?.data?.total_count || this.issues.length)
        this.stats.privilegedSyscall = 0
        this.stats.permissionBypass = 0
        this.stats.capabilityCheck = 0
        const subtypeCounts = response?.data?.subtype_counts || {}
        if (Object.keys(subtypeCounts).length > 0) {
          this.stats.privilegedSyscall = Number(subtypeCounts.PrivilegedSyscall || 0)
          this.stats.permissionBypass = Number(subtypeCounts.PermissionBypass || 0)
          this.stats.capabilityCheck = Number(subtypeCounts.CapabilityCheck || 0)
        }
        this.updateStats()
      } catch (error) {
        console.error('加载数据失败:', error)
        this.issues = []
        this.totalCountFromApi = 0
        this.stats.privilegedSyscall = 0
        this.stats.permissionBypass = 0
        this.stats.capabilityCheck = 0
        this.updateStats()
      } finally {
        this.loading = false
      }
    },
    loadDemoData() {
      this.issues = [
        {
          type: 'PrivilegedSyscall',
          severity: 'High',
          message: 'Privileged system call without proper permission check',
          syscall: 'sys_mknod',
          file: 'kernel/fs/namei.c',
          line: 1234,
          column: 5,
          suggestion: 'Add proper permission checks before executing privileged operation'
        },
        {
          type: 'PermissionBypass',
          severity: 'Critical',
          message: 'Potential permission bypass in file access',
          capability: 'CAP_DAC_OVERRIDE',
          file: 'kernel/fs/open.c',
          line: 567,
          column: 12,
          suggestion: 'Verify caller has appropriate capabilities before granting access'
        },
        {
          type: 'CapabilityCheck',
          severity: 'High',
          message: 'Missing capability check for privileged operation',
          capability: 'CAP_SYS_ADMIN',
          file: 'kernel/kernel/sys.c',
          line: 890,
          column: 8,
          suggestion: 'Add capability check using capable() before privileged operation'
        }
      ]
      this.updateStats()
    },
    updateStats() {
      if (!this.stats.privilegedSyscall && !this.stats.permissionBypass && !this.stats.capabilityCheck) {
        this.stats.privilegedSyscall = this.issues.filter(i => i.type === 'PrivilegedSyscall').length
        this.stats.permissionBypass = this.issues.filter(i => i.type === 'PermissionBypass').length
        this.stats.capabilityCheck = this.issues.filter(i => i.type === 'CapabilityCheck').length
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
.privilege-escalation-page {
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

.privilege-icon {
  background: linear-gradient(to bottom right, #10b981, #059669);
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

.syscall .stat-icon {
  background: linear-gradient(to bottom right, #3b82f6, #2563eb);
}

.permission .stat-icon {
  background: linear-gradient(to bottom right, #dc2626, #b91c1c);
}

.capability .stat-icon {
  background: linear-gradient(to bottom right, #f59e0b, #d97706);
}

.total .stat-icon {
  background: linear-gradient(to bottom right, #10b981, #059669);
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

.issue-syscall,
.issue-capability {
  background: #fef3c7;
  padding: 0.5rem;
  border-radius: 0.5rem;
  font-size: 0.875rem;
  margin-bottom: 0.5rem;
}

.syscall-label,
.capability-label {
  font-weight: 600;
  color: #92400e;
}

.issue-syscall code,
.issue-capability code {
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