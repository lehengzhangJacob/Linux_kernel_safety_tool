import { jsPDF } from 'jspdf'
import autoTable from 'jspdf-autotable'

const FONT_URL = '/fonts/DroidSansFallback.ttf'
const FONT_VFS_NAME = 'DroidSansFallback.ttf'
const FONT_FAMILY = 'DroidSansFallback'
const WARNINGS_EXPORT_LIMIT = 50

let fontBase64Cache = null

function arrayBufferToBase64(buffer) {
  let binary = ''
  const bytes = new Uint8Array(buffer)
  const chunkSize = 0x8000
  for (let i = 0; i < bytes.length; i += chunkSize) {
    binary += String.fromCharCode(...bytes.subarray(i, i + chunkSize))
  }
  return btoa(binary)
}

async function loadChineseFontBase64() {
  if (fontBase64Cache) return fontBase64Cache
  const res = await fetch(FONT_URL)
  if (!res.ok) {
    throw new Error(`无法加载中文字体: ${FONT_URL}`)
  }
  const buf = await res.arrayBuffer()
  fontBase64Cache = arrayBufferToBase64(buf)
  return fontBase64Cache
}

async function ensureChineseFont(doc) {
  const base64 = await loadChineseFontBase64()
  doc.addFileToVFS(FONT_VFS_NAME, base64)
  doc.addFont(FONT_VFS_NAME, FONT_FAMILY, 'normal')
  doc.addFont(FONT_VFS_NAME, FONT_FAMILY, 'bold')
  doc.setFont(FONT_FAMILY, 'normal')
}

function num(v, fallback = 0) {
  const n = Number(v)
  return Number.isFinite(n) ? n : fallback
}

function formatInt(v) {
  return new Intl.NumberFormat('zh-CN').format(num(v))
}

function dataSourceLabel(data) {
  if (data?.is_demo_data) return '演示数据'
  if (data?.is_prebuilt) return '预置分析数据'
  return '真实分析结果'
}

function riskTypeLabel(type) {
  if (type === 'Write' || type === '写入') return '未保护写'
  if (type === 'Read' || type === '读取') return '未保护读'
  return type || '未知'
}

function severityLabel(severity, type) {
  const raw = (severity || '').toUpperCase()
  if (raw === 'HIGH' || type === 'Write' || type === '写入') return '高危'
  if (raw === 'MEDIUM' || type === 'Read' || type === '读取') return '中危'
  return raw || '中危'
}

function remediationAdvice(type) {
  if (type === 'Write' || type === '写入') {
    return '建议为该全局变量的写路径补齐互斥锁/原子写，并复核跨函数锁顺序。'
  }
  if (type === 'Read' || type === '读取') {
    return '建议在读路径使用持锁读取或 READ_ONCE/atomic 语义，避免无保护并发读。'
  }
  return '建议复核该访问点的并发保护与调用上下文。'
}

/**
 * 综合健康分 0-100（基于已有统计，不新增检测逻辑）
 */
export function computeHealthScore(summary = {}, raceWarnings = {}) {
  let score = 100
  const warnings = num(summary.total_warnings)
  const writes = num(summary.warning_writes)
  const reads = num(summary.warning_reads)
  const memory = num(summary.memory_safety)
  const race = num(summary.race_condition)
  const info = num(summary.info_leak)
  const priv = num(summary.privilege_escalation)
  const toctou = num(summary.toctou)
  const detectionTotal = memory + race + info + priv + toctou

  // 告警规模扣分（对数近似，避免极端爆炸）
  if (warnings > 0) {
    score -= Math.min(35, Math.log10(warnings + 1) * 12)
  }
  // 写告警更危险
  const writeRatio = warnings > 0 ? writes / Math.max(warnings, writes + reads, 1) : 0
  score -= writeRatio * 15
  // 五类专项总量
  if (detectionTotal > 0) {
    score -= Math.min(25, Math.log10(detectionTotal + 1) * 8)
  }
  // 热点变量集中度
  const top = (raceWarnings.top_variables || [])[0]
  if (top && warnings > 0) {
    const concentration = num(top.count) / warnings
    if (concentration > 0.15) score -= 5
  }

  score = Math.max(5, Math.min(100, Math.round(score)))
  let grade = '差'
  if (score >= 85) grade = '优'
  else if (score >= 70) grade = '良'
  else if (score >= 50) grade = '中'
  return { score, grade }
}

export function buildExecutiveSummary(data = {}, health = {}) {
  const summary = data.summary || {}
  const warnings = num(summary.total_warnings)
  const topVars = data.race_warnings?.top_variables || []
  const top1 = topVars[0]
  const top2 = topVars[1]

  const cats = [
    { name: '竞态条件', count: num(summary.race_condition) },
    { name: '内存安全', count: num(summary.memory_safety) },
    { name: '信息泄露', count: num(summary.info_leak) },
    { name: '权限提升', count: num(summary.privilege_escalation) },
    { name: 'TOCTOU', count: num(summary.toctou) },
  ].sort((a, b) => b.count - a.count)

  const dominant = cats[0]?.count > 0 ? cats[0].name : '并发访问风险'
  let hotSpot = ''
  if (top1 && top2) {
    hotSpot = `本次扫描风险主要集中在 ${top1.name}（${formatInt(top1.count)} 次）和 ${top2.name}（${formatInt(top2.count)} 次）的并发访问上。`
  } else if (top1) {
    hotSpot = `本次扫描风险主要集中在 ${top1.name}（${formatInt(top1.count)} 次）的并发访问上。`
  }

  return (
    `针对目标内核 ${data.kernel_version || 'unknown'} 完成本次静态安全审计，综合健康分为 ${health.score}/100（等级：${health.grade}）。` +
    `共发现 ${formatInt(warnings)} 处竞态相关告警，风险类型以「${dominant}」为主。` +
    (hotSpot || '建议结合告警明细优先治理高频访问点。') +
    `系统已完成结构化归纳与可视化呈现，可供评测与工程复盘使用。`
  )
}

function chartToDataUrl(instance) {
  if (!instance || typeof instance.getDataURL !== 'function') return null
  try {
    return instance.getDataURL({
      type: 'png',
      pixelRatio: 2,
      backgroundColor: '#0f172a',
    })
  } catch (e) {
    console.warn('chart export failed:', e)
    return null
  }
}

export function collectChartImages(chartInstances = {}) {
  return {
    riskDist: chartToDataUrl(chartInstances.rwChartInstance),
    codeStats: chartToDataUrl(chartInstances.statsChartInstance),
    topFuncs: chartToDataUrl(chartInstances.funcChartInstance),
    topo: chartToDataUrl(chartInstances.topoChartInstance),
  }
}

function drawHeaderBar(doc, title) {
  doc.setFillColor(15, 23, 42)
  doc.rect(0, 0, 210, 28, 'F')
  doc.setFillColor(37, 99, 235)
  doc.rect(0, 28, 210, 1.5, 'F')
  doc.setTextColor(248, 250, 252)
  doc.setFont(FONT_FAMILY, 'normal')
  doc.setFontSize(14)
  doc.text(title, 14, 18)
}

function drawFooter(doc, runId) {
  const pageCount = doc.internal.getNumberOfPages()
  for (let i = 1; i <= pageCount; i++) {
    doc.setPage(i)
    doc.setDrawColor(203, 213, 225)
    doc.line(14, 285, 196, 285)
    doc.setFontSize(8)
    doc.setTextColor(100, 116, 139)
    doc.setFont(FONT_FAMILY, 'normal')
    doc.text('内核并发安全分析系统 · 自动生成审计报告', 14, 291)
    doc.text(`run_id: ${runId || '-'}`, 14, 296)
    doc.text(`第 ${i} / ${pageCount} 页`, 196, 291, { align: 'right' })
  }
}

function drawMetricBox(doc, x, y, w, h, label, value, color) {
  doc.setFillColor(248, 250, 252)
  doc.setDrawColor(226, 232, 240)
  doc.roundedRect(x, y, w, h, 2, 2, 'FD')
  doc.setFillColor(...color)
  doc.rect(x, y, 2.2, h, 'F')
  doc.setFontSize(8)
  doc.setTextColor(100, 116, 139)
  doc.text(label, x + 6, y + 8)
  doc.setFontSize(13)
  doc.setTextColor(30, 41, 59)
  doc.text(String(value), x + 6, y + 18)
}

/**
 * 生成专业审计 PDF 并触发下载
 */
export async function buildProfessionalPdf({
  data,
  runId,
  chartInstances,
  warnings = [],
  warningsTotal = 0,
  download = true,
}) {
  if (!data) {
    throw new Error('暂无分析数据，无法导出报告')
  }

  const doc = new jsPDF({ unit: 'mm', format: 'a4' })
  await ensureChineseFont(doc)

  const summary = data.summary || {}
  const health = computeHealthScore(summary, data.race_warnings || {})
  const executive = buildExecutiveSummary(data, health)
  const charts = collectChartImages(chartInstances || {})
  const generatedAt = new Date().toLocaleString('zh-CN', { hour12: false })

  // ===== Page 1: Cover + Executive Summary =====
  drawHeaderBar(doc, '内核并发安全审计报告')
  doc.setTextColor(71, 85, 105)
  doc.setFontSize(9)
  doc.text('Kernel Concurrency Safety Analyzer · SaaS Platform', 14, 36)

  doc.setTextColor(15, 23, 42)
  doc.setFontSize(11)
  doc.text(`目标内核：${data.kernel_version || 'unknown'}`, 14, 48)
  doc.text(`扫描时间：${data.scan_time || generatedAt}`, 14, 55)
  doc.text(`数据来源：${dataSourceLabel(data)}`, 110, 48)
  doc.text(`生成时间：${generatedAt}`, 110, 55)

  // Health score card
  doc.setFillColor(239, 246, 255)
  doc.setDrawColor(147, 197, 253)
  doc.roundedRect(14, 62, 182, 28, 3, 3, 'FD')
  doc.setTextColor(30, 64, 175)
  doc.setFontSize(10)
  doc.text('综合安全健康分', 20, 72)
  doc.setFontSize(26)
  doc.setTextColor(37, 99, 235)
  doc.text(`${health.score}`, 20, 85)
  doc.setFontSize(12)
  doc.setTextColor(30, 41, 59)
  doc.text(`/ 100　等级：${health.grade}`, 42, 84)

  doc.setFontSize(11)
  doc.setTextColor(15, 23, 42)
  doc.text('执行摘要', 14, 102)
  doc.setFontSize(9.5)
  doc.setTextColor(51, 65, 85)
  const summaryLines = doc.splitTextToSize(executive, 182)
  doc.text(summaryLines, 14, 110)

  let y = 110 + summaryLines.length * 5 + 8
  doc.setFontSize(11)
  doc.setTextColor(15, 23, 42)
  doc.text('关键指标一览', 14, y)
  y += 4

  const metrics = [
    ['分析文件', formatInt(summary.analysis_files), [37, 99, 235]],
    ['函数数', formatInt(summary.total_functions), [16, 185, 129]],
    ['调用边', formatInt(summary.total_edges), [139, 92, 246]],
    ['竞态告警', formatInt(summary.total_warnings), [239, 68, 68]],
    ['内存安全', formatInt(summary.memory_safety), [244, 63, 94]],
    ['信息泄露', formatInt(summary.info_leak), [234, 179, 8]],
    ['权限提升', formatInt(summary.privilege_escalation), [34, 197, 94]],
    ['TOCTOU', formatInt(summary.toctou), [168, 85, 247]],
  ]
  const boxW = 42
  const boxH = 22
  metrics.forEach((m, idx) => {
    const col = idx % 4
    const row = Math.floor(idx / 4)
    drawMetricBox(doc, 14 + col * (boxW + 4), y + 4 + row * (boxH + 4), boxW, boxH, m[0], m[1], m[2])
  })

  y += 4 + 2 * (boxH + 4) + 10
  doc.setFontSize(11)
  doc.setTextColor(15, 23, 42)
  doc.text('风险热点（Top 变量）', 14, y)
  const topVars = (data.race_warnings?.top_variables || []).slice(0, 5)
  autoTable(doc, {
    startY: y + 3,
    head: [['排名', '变量名', '告警次数']],
    body: topVars.map((item, i) => [String(i + 1), item.name || '-', formatInt(item.count)]),
    theme: 'grid',
    styles: { font: FONT_FAMILY, fontSize: 8, cellPadding: 2, textColor: [30, 41, 59] },
    headStyles: { fillColor: [37, 99, 235], textColor: [255, 255, 255], font: FONT_FAMILY },
    margin: { left: 14, right: 14 },
  })

  // ===== Page 2: Charts =====
  doc.addPage()
  drawHeaderBar(doc, '可视化分析')
  doc.setTextColor(51, 65, 85)
  doc.setFontSize(9)
  doc.text('以下图表来自仪表盘实时渲染结果，用于快速把握整体风险态势。', 14, 36)

  const chartSlots = [
    { title: '漏洞类型分布', img: charts.riskDist, x: 14, y: 42, w: 88, h: 72 },
    { title: '代码统计概览', img: charts.codeStats, x: 108, y: 42, w: 88, h: 72 },
    { title: '高危函数 Top 10', img: charts.topFuncs, x: 14, y: 128, w: 88, h: 72 },
    { title: '调用与变量访问拓扑', img: charts.topo, x: 108, y: 128, w: 88, h: 72 },
  ]

  let embedded = 0
  chartSlots.forEach((slot) => {
    doc.setFontSize(10)
    doc.setTextColor(15, 23, 42)
    doc.text(slot.title, slot.x, slot.y)
    if (slot.img) {
      doc.setDrawColor(226, 232, 240)
      doc.roundedRect(slot.x, slot.y + 3, slot.w, slot.h, 2, 2, 'S')
      doc.addImage(slot.img, 'PNG', slot.x + 1, slot.y + 4, slot.w - 2, slot.h - 2)
      embedded += 1
    } else {
      doc.setFillColor(248, 250, 252)
      doc.roundedRect(slot.x, slot.y + 3, slot.w, slot.h, 2, 2, 'FD')
      doc.setFontSize(9)
      doc.setTextColor(148, 163, 184)
      doc.text('图表暂不可用', slot.x + slot.w / 2, slot.y + slot.h / 2 + 3, { align: 'center' })
    }
  })

  if (embedded < 2) {
    doc.setFontSize(8)
    doc.setTextColor(245, 158, 11)
    doc.text('提示：部分图表未就绪时仍可导出；请在仪表盘加载完成后再导出以获得完整可视化。', 14, 215)
  }

  // ===== Page 3+: Warnings table =====
  doc.addPage()
  drawHeaderBar(doc, '告警明细（精选）')
  const total = Math.max(num(warningsTotal), warnings.length, num(summary.total_warnings))
  const shown = Math.min(WARNINGS_EXPORT_LIMIT, warnings.length)
  doc.setFontSize(9)
  doc.setTextColor(51, 65, 85)
  doc.text(
    `共发现 ${formatInt(total)} 条告警，本报告按优先级展示前 ${shown} 条（高危优先），避免流水账式全量罗列。`,
    14,
    36
  )

  const sorted = [...warnings].sort((a, b) => {
    const sa = severityLabel(a.severity, a.type) === '高危' ? 0 : 1
    const sb = severityLabel(b.severity, b.type) === '高危' ? 0 : 1
    return sa - sb
  }).slice(0, WARNINGS_EXPORT_LIMIT)

  const body = sorted.map((w) => [
    severityLabel(w.severity, w.type),
    w.variable || '-',
    w.function || '-',
    riskTypeLabel(w.type),
    remediationAdvice(w.type),
  ])

  autoTable(doc, {
    startY: 42,
    head: [['风险等级', '风险变量', '所在函数', '风险类型', '修复建议']],
    body: body.length
      ? body
      : [['-', '-', '-', '-', '当前无可用告警明细，请确认分析已完成。']],
    theme: 'grid',
    tableWidth: 182,
    styles: {
      font: FONT_FAMILY,
      fontSize: 7.5,
      cellPadding: 1.8,
      valign: 'middle',
      textColor: [30, 41, 59],
      overflow: 'linebreak',
    },
    headStyles: {
      fillColor: [15, 23, 42],
      textColor: [248, 250, 252],
      font: FONT_FAMILY,
      fontSize: 8,
    },
    columnStyles: {
      0: { cellWidth: 18 },
      1: { cellWidth: 32 },
      2: { cellWidth: 40 },
      3: { cellWidth: 24 },
      4: { cellWidth: 'auto' },
    },
    didParseCell(hookData) {
      if (hookData.section === 'body' && hookData.column.index === 0) {
        const v = String(hookData.cell.raw || '')
        if (v === '高危') {
          hookData.cell.styles.textColor = [220, 38, 38]
          hookData.cell.styles.fontStyle = 'bold'
        } else if (v === '中危') {
          hookData.cell.styles.textColor = [217, 119, 6]
        }
      }
    },
    margin: { left: 14, right: 14, bottom: 20 },
  })

  drawFooter(doc, runId)

  const safeTarget = String(data.kernel_version || 'kernel').replace(/[^\w.-]+/g, '_')
  const filename = `kernel_security_audit_${safeTarget}_${Date.now()}.pdf`
  if (download) {
    doc.save(filename)
  }
  return { filename, health, embeddedCharts: embedded, warningRows: shown, doc }
}

export { WARNINGS_EXPORT_LIMIT }
