import { createRouter, createWebHistory } from 'vue-router'
import Home from '../components/Home.vue'
import Dashboard from '../components/Dashboard.vue'
import MemorySafety from '../views/MemorySafety.vue'
import RaceCondition from '../views/RaceCondition.vue'
import InfoLeak from '../views/InfoLeak.vue'
import PrivilegeEscalation from '../views/PrivilegeEscalation.vue'
import TOCTOU from '../views/TOCTOU.vue'

const routes = [
  {
    path: '/',
    component: Home
  },
  {
    path: '/dashboard',
    component: Dashboard
  },
  {
    path: '/memory-safety',
    component: MemorySafety,
    meta: { title: '内存安全检测', requiresAudit: true }
  },
  {
    path: '/race-condition',
    component: RaceCondition,
    meta: { title: '竞态条件检测', requiresAudit: true }
  },
  {
    path: '/info-leak',
    component: InfoLeak,
    meta: { title: '信息泄露检测', requiresAudit: true }
  },
  {
    path: '/privilege-escalation',
    component: PrivilegeEscalation,
    meta: { title: '权限提升检测', requiresAudit: true }
  },
  {
    path: '/toctou',
    component: TOCTOU,
    meta: { title: 'TOCTOU检测', requiresAudit: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  document.title = to.meta.title ? `${to.meta.title} - 内核安全分析系统` : '内核安全分析系统'
  
  if (to.meta.requiresAudit) {
    const hasAuditData = localStorage.getItem('hasAuditData') === 'true'
    if (!hasAuditData) {
      next('/')
      return
    }
  }
  
  next()
})

export default router