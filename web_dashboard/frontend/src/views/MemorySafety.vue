<template>
  <div class="memory-safety-page">
    <MainNav :has-audit-data="true" />
    
    <div class="page-container">
      <div class="page-header">
        <div class="header-content">
          <div class="header-icon memory-icon">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
          </div>
          <div class="header-text">
            <h1 class="page-title">内存安全检测</h1>
            <p class="page-subtitle">检测缓冲区溢出、空指针解引用、使用后释放等内存安全问题</p>
          </div>
        </div>
      </div>

      <div class="stats-grid">
        <div class="stat-card buffer-overflow">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
              </svg>
            </div>
            <div class="stat-title">缓冲区溢出</div>
          </div>
          <div class="stat-value">{{ stats.bufferOverflow }}</div>
          <div class="stat-severity critical">严重</div>
        </div>

        <div class="stat-card null-pointer">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
              </svg>
            </div>
            <div class="stat-title">空指针解引用</div>
          </div>
          <div class="stat-value">{{ stats.nullPointer }}</div>
          <div class="stat-severity high">高危</div>
        </div>

        <div class="stat-card use-after-free">
          <div class="stat-header">
            <div class="stat-icon">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
              </svg>
            </div>
            <div class="stat-title">使用后释放</div>
          </div>
          <div class="stat-value">{{ stats.useAfterFree }}</div>
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
              <h2 class="section-title">检测结果详情</h2>
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
                <option value="BufferOverflow">缓冲区溢出</option>
                <option value="NullPointer">空指针</option>
                <option value="UseAfterFree">使用后释放</option>
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
                <div class="info-item-title">缓冲区溢出</div>
                <div class="info-item-desc">检测数组越界访问、字符串操作溢出、内存拷贝越界等问题</div>
              </div>
              <div class="info-item">
                <div class="info-item-title">空指针解引用</div>
                <div class="info-item-desc">检测未检查的指针解引用操作，防止空指针崩溃</div>
              </div>
              <div class="info-item">
                <div class="info-item-title">使用后释放</div>
                <div class="info-item-desc">检测释放后的内存被再次访问的漏洞</div>
              </div>
            </div>
          </div>

          <div class="info-card">
            <h3 class="info-title">常见漏洞示例</h3>
            <div class="code-example">
              <pre><code>char buffer[10];
strcpy(buffer, "This is too long");  // 缓冲区溢出

int *ptr = NULL;
*ptr = 42;  // 空指针解引用

free(ptr);
ptr->data = 1;  // 使用后释放</code></pre>
            </div>
          </div>

          <div class="info-card">
            <h3 class="info-title">防护建议</h3>
            <ul class="suggestions-list">
              <li>使用安全的字符串操作函数（strncpy、strncat等）</li>
              <li>在使用指针前进行空指针检查</li>
              <li>释放内存后将指针置为NULL</li>
              <li>使用内存安全工具（如AddressSanitizer）</li>
              <li>采用现代编程语言（如Rust）避免内存安全问题</li>
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
  name: 'MemorySafety',
  components: {
    MainNav
  },
  data() {
    return {
      loading: false,
      filterType: 'all',
      filterSeverity: 'all',
      issues: [],
      stats: {
        bufferOverflow: 0,
        nullPointer: 0,
        useAfterFree: 0,
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
        const response = await axios.get('/api/detections?type=MemorySafety')
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
          type: 'BufferOverflow',
          severity: 'Critical',
          message: 'Potential buffer overflow in array write',
          file: 'kernel/net/socket.c',
          line: 1234,
          column: 5,
          suggestion: 'Add bounds checking before array access'
        },
        {
          type: 'NullPointer',
          severity: 'High',
          message: 'Potential null pointer dereference',
          file: 'kernel/fs/file.c',
          line: 567,
          column: 12,
          suggestion: 'Add null check before dereferencing pointer'
        },
        {
          type: 'UseAfterFree',
          severity: 'High',
          message: 'Use after free detected',
          file: 'kernel/mm/slab.c',
          line: 890,
          column: 8,
          suggestion: 'Set pointer to NULL after free'
        }
      ]
      this.updateStats()
    },
    updateStats() {
      this.stats.bufferOverflow = this.issues.filter(i => i.type === 'BufferOverflow').length
      this.stats.nullPointer = this.issues.filter(i => i.type === 'NullPointer').length
      this.stats.useAfterFree = this.issues.filter(i => i.type === 'UseAfterFree').length
      this.stats.total = this.issues.length
    },
    async refreshData() {
      await this.loadData()
    }
  }
}
</script>

<style scoped>
.memory-safety-page {
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

.memory-icon {
  background: linear-gradient(to bottom right, #dc2626, #b91c1c);
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

.buffer-overflow .stat-icon {
  background: linear-gradient(to bottom right, #dc2626, #b91c1c);
}

.null-pointer .stat-icon {
  background: linear-gradient(to bottom right, #f59e0b, #d97706);
}

.use-after-free .stat-icon {
  background: linear-gradient(to bottom right, #f97316, #ea580c);
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