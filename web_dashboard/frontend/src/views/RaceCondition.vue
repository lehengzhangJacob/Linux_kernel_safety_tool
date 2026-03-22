<template>
  <div class="race-condition-page">
    <MainNav :has-audit-data="true" />
    
    <div class="page-container">
      <div class="page-header">
        <div class="header-content">
          <div class="header-icon race-icon">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
            </svg>
          </div>
          <div class="header-text">
            <h1 class="page-title">竞态条件检测</h1>
            <p class="page-subtitle">检测内核中的并发访问竞态条件，包括数据竞争、死锁等</p>
          </div>
        </div>
      </div>

      <div class="stats-grid">
        <div class="stat-card read-race">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
              </svg>
            </div>
            <div class="stat-title">读取竞态</div>
          </div>
          <div class="stat-value">{{ stats.readRace }}</div>
          <div class="stat-severity medium">中等</div>
        </div>

        <div class="stat-card write-race">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
              </svg>
            </div>
            <div class="stat-title">写入竞态</div>
          </div>
          <div class="stat-value">{{ stats.writeRace }}</div>
          <div class="stat-severity high">高危</div>
        </div>

        <div class="stat-card deadlock">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
              </svg>
            </div>
            <div class="stat-title">潜在死锁</div>
          </div>
          <div class="stat-value">{{ stats.deadlock }}</div>
          <div class="stat-severity critical">严重</div>
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
              <h2 class="section-title">竞态条件详情</h2>
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
                <option value="Read">读取竞态</option>
                <option value="Write">写入竞态</option>
                <option value="Deadlock">潜在死锁</option>
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
                <div v-if="issue.variable" class="issue-variable">
                  <span class="variable-label">变量：</span>
                  <code>{{ issue.variable }}</code>
                </div>
                <div v-if="issue.function" class="issue-function">
                  <span class="function-label">函数：</span>
                  <code>{{ issue.function }}</code>
                </div>
                <div class="issue-location">
                  <span class="location-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                  </span>
                  {{ issue.file }}:{{ issue.line }}
                </div>
                <div v-if="issue.suggestion" class="issue-suggestion">
                  <span class="suggestion-label">修复建议：</span>
                  {{ issue.suggestion }}
                </div>
              </div>
            </div>
          </div>

          <div class="section-card">
            <div class="section-header">
              <h2 class="section-title">高风险变量排名</h2>
            </div>
            <div class="ranking-list">
              <div v-for="(item, index) in topVariables" :key="index" class="ranking-item">
                <div class="ranking-number">{{ index + 1 }}</div>
                <div class="ranking-content">
                  <div class="ranking-name">{{ item.variable }}</div>
                  <div class="ranking-stats">
                    <span class="ranking-stat">
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                      </svg>
                      {{ item.reads }} 读取
                    </span>
                    <span class="ranking-stat">
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                      </svg>
                      {{ item.writes }} 写入
                    </span>
                  </div>
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
                <div class="info-item-title">数据竞争</div>
                <div class="info-item-desc">检测多个线程/进程同时访问共享数据且至少有一个是写操作的情况</div>
              </div>
              <div class="info-item">
                <div class="info-item-title">死锁风险</div>
                <div class="info-item-desc">分析锁的获取顺序，识别可能导致死锁的锁依赖关系</div>
              </div>
              <div class="info-item">
                <div class="info-item-title">无保护访问</div>
                <div class="info-item-desc">检测未使用锁或其他同步机制保护的共享变量访问</div>
              </div>
            </div>
          </div>

          <div class="info-card">
            <h3 class="info-title">常见漏洞示例</h3>
            <div class="code-example">
              <pre><code>int counter = 0;

void thread_func() {
    counter++;  // 数据竞争：无保护
}

spinlock_t lock;
void unsafe_func() {
    if (condition) {
        spin_lock(&lock);
    }
    critical_section();
    if (condition) {
        spin_unlock(&lock);  // 死锁风险
    }
}</code></pre>
            </div>
          </div>

          <div class="info-card">
            <h3 class="info-title">防护建议</h3>
            <ul class="suggestions-list">
              <li>使用适当的同步机制（自旋锁、互斥锁等）</li>
              <li>遵循锁的获取顺序，避免死锁</li>
              <li>使用RCU（Read-Copy-Update）机制优化读多写少场景</li>
              <li>避免在持有锁时进行可能阻塞的操作</li>
              <li>使用原子操作处理简单的共享变量</li>
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
  name: 'RaceCondition',
  components: {
    MainNav
  },
  data() {
    return {
      loading: false,
      filterType: 'all',
      filterSeverity: 'all',
      issues: [],
      topVariables: [],
      stats: {
        readRace: 0,
        writeRace: 0,
        deadlock: 0,
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
  methods: {
    async loadData() {
      this.loading = true
      try {
        const response = await axios.get('/api/race-conditions')
        this.issues = response.data.issues || []
        this.topVariables = response.data.topVariables || []
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
          type: 'Read',
          severity: 'Medium',
          message: 'Unprotected read from global variable',
          variable: 'global_counter',
          function: 'test_race_condition',
          file: 'kernel/sched/core.c',
          line: 1234,
          suggestion: 'Add read lock or use atomic operations'
        },
        {
          type: 'Write',
          severity: 'High',
          message: 'Unprotected write to global variable',
          variable: 'global_counter',
          function: 'test_race_condition',
          file: 'kernel/sched/core.c',
          line: 1235,
          suggestion: 'Add write lock or use atomic operations'
        },
        {
          type: 'Deadlock',
          severity: 'Critical',
          message: 'Potential deadlock detected',
          variable: 'lock_a, lock_b',
          function: 'complex_locking',
          file: 'kernel/locking/lockdep.c',
          line: 567,
          suggestion: 'Ensure locks are always acquired in the same order'
        }
      ]
      this.topVariables = [
        { variable: 'global_counter', reads: 156, writes: 89 },
        { variable: 'shared_buffer', reads: 124, writes: 67 },
        { variable: 'status_flag', reads: 98, writes: 45 }
      ]
      this.updateStats()
    },
    updateStats() {
      this.stats.readRace = this.issues.filter(i => i.type === 'Read').length
      this.stats.writeRace = this.issues.filter(i => i.type === 'Write').length
      this.stats.deadlock = this.issues.filter(i => i.type === 'Deadlock').length
      this.stats.total = this.issues.length
    },
    async refreshData() {
      await this.loadData()
    }
  }
}
</script>

<style scoped>
.race-condition-page {
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

.race-icon {
  background: linear-gradient(to bottom right, #f59e0b, #d97706);
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

.read-race .stat-icon {
  background: linear-gradient(to bottom right, #f59e0b, #d97706);
}

.write-race .stat-icon {
  background: linear-gradient(to bottom right, #f97316, #ea580c);
}

.deadlock .stat-icon {
  background: linear-gradient(to bottom right, #dc2626, #b91c1c);
}

.total .stat-icon {
  background: linear-gradient(to bottom right, #3b82f6, #2563eb);
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

.stat-severity.medium {
  background: #dbeafe;
  color: #2563eb;
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
  margin-bottom: 1.5rem;
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

.issue-type-badge.medium {
  background: #dbeafe;
  color: #2563eb;
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

.issue-severity.medium {
  background: #dbeafe;
  color: #2563eb;
}

.issue-message {
  font-weight: 500;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.issue-variable,
.issue-function {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
  font-size: 0.875rem;
}

.variable-label,
.function-label {
  font-weight: 600;
  color: #475569;
}

.issue-variable code,
.issue-function code {
  background: #f1f5f9;
  padding: 0.125rem 0.5rem;
  border-radius: 0.25rem;
  font-family: 'Courier New', monospace;
  color: #1e293b;
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

.ranking-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.ranking-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem;
  background: #f8fafc;
  border-radius: 0.5rem;
}

.ranking-number {
  width: 2rem;
  height: 2rem;
  border-radius: 50%;
  background: linear-gradient(to bottom right, #3b82f6, #2563eb);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 0.875rem;
}

.ranking-content {
  flex: 1;
}

.ranking-name {
  font-weight: 600;
  color: #1e293b;
  margin-bottom: 0.25rem;
  font-family: 'Courier New', monospace;
}

.ranking-stats {
  display: flex;
  gap: 1rem;
}

.ranking-stat {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  font-size: 0.75rem;
  color: #64748b;
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