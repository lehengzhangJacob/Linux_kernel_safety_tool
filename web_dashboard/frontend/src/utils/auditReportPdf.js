import { jsPDF } from 'jspdf'
import autoTable from 'jspdf-autotable'

const FONT_URL = '/fonts/DroidSansFallback.ttf'
const FONT_VFS_NAME = 'DroidSansFallback.ttf'
const FONT_FAMILY = 'DroidSansFallback'
const WARNINGS_EXPORT_LIMIT = 50

/** Print-oriented palette (light paper, one ink accent — not dashboard dark mode) */
const C = {
  ink: [28, 28, 30],
  muted: [90, 90, 95],
  line: [210, 210, 214],
  paper: [255, 255, 255],
  wash: [246, 246, 248],
  accent: [20, 90, 110], // deep teal
  accentSoft: [232, 242, 245],
  danger: [180, 50, 45],
  warn: [160, 100, 20],
  ok: [40, 120, 80],
}

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

/** DroidSansFallback via jsPDF drops Latin/digits; split runs across fonts. */
function isCjkChar(ch) {
  const cp = ch.codePointAt(0)
  return (
    (cp >= 0x3000 && cp <= 0x9fff) ||
    (cp >= 0xf900 && cp <= 0xfaff) ||
    (cp >= 0xff00 && cp <= 0xffef)
  )
}

function splitFontRuns(text) {
  const s = String(text ?? '')
  if (!s) return []
  const runs = []
  let buf = s[0]
  let cjk = isCjkChar(s[0])
  for (let i = 1; i < s.length; i++) {
    const next = isCjkChar(s[i])
    if (next === cjk) buf += s[i]
    else {
      runs.push({ text: buf, cjk })
      buf = s[i]
      cjk = next
    }
  }
  runs.push({ text: buf, cjk })
  return runs
}

function setReportFont(doc, cjk, size) {
  if (size) doc.setFontSize(size)
  doc.setFont(cjk ? FONT_FAMILY : 'helvetica', 'normal')
}

function measureMixedWidth(doc, text, size) {
  let w = 0
  for (const run of splitFontRuns(text)) {
    setReportFont(doc, run.cjk, size)
    w += doc.getTextWidth(run.text)
  }
  return w
}

function drawMixedText(doc, text, x, y, opts = {}) {
  const size = opts.fontSize || doc.getFontSize()
  const align = opts.align || 'left'
  let cursor = x
  if (align === 'right') {
    cursor = x - measureMixedWidth(doc, text, size)
  } else if (align === 'center') {
    cursor = x - measureMixedWidth(doc, text, size) / 2
  }
  for (const run of splitFontRuns(text)) {
    setReportFont(doc, run.cjk, size)
    doc.text(run.text, cursor, y)
    cursor += doc.getTextWidth(run.text)
  }
  return cursor
}

function drawWrappedMixed(doc, text, x, y, maxWidth, lineHeight = 5, fontSize = 9.5) {
  // Greedy wrap by characters using mixed-font widths
  const chars = Array.from(String(text ?? ''))
  let line = ''
  let yy = y
  const flush = () => {
    if (!line) return
    drawMixedText(doc, line, x, yy, { fontSize })
    yy += lineHeight
    line = ''
  }
  for (const ch of chars) {
    const trial = line + ch
    if (measureMixedWidth(doc, trial, fontSize) > maxWidth && line) {
      flush()
      line = ch
    } else {
      line = trial
    }
  }
  flush()
  return yy
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
    return '补齐写路径互斥/原子写，复核跨函数锁序。'
  }
  if (type === 'Read' || type === '读取') {
    return '读路径使用持锁或 READ_ONCE/atomic。'
  }
  return '复核该访问点的并发保护。'
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

  if (warnings > 0) {
    score -= Math.min(35, Math.log10(warnings + 1) * 12)
  }
  const writeRatio = warnings > 0 ? writes / Math.max(warnings, writes + reads, 1) : 0
  score -= writeRatio * 15
  if (detectionTotal > 0) {
    score -= Math.min(25, Math.log10(detectionTotal + 1) * 8)
  }
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
    hotSpot = `风险热点集中在 ${top1.name}（${formatInt(top1.count)}）与 ${top2.name}（${formatInt(top2.count)}）。`
  } else if (top1) {
    hotSpot = `风险热点集中在 ${top1.name}（${formatInt(top1.count)}）。`
  }

  return (
    `目标 ${data.kernel_version || 'unknown'} 静态审计完成，健康分 ${health.score}/100（${health.grade}）。` +
    `竞态相关告警 ${formatInt(warnings)} 处，以「${dominant}」为主。` +
    (hotSpot || '建议结合明细优先治理高频访问点。')
  )
}

function chartToDataUrl(instance) {
  if (!instance || typeof instance.getDataURL !== 'function') return null
  try {
    return instance.getDataURL({
      type: 'png',
      pixelRatio: 2,
      backgroundColor: '#ffffff',
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

function setInk(doc, rgb = C.ink) {
  doc.setTextColor(...rgb)
}

function drawPageChrome(doc, pageTitle) {
  doc.setFillColor(...C.accent)
  doc.rect(0, 0, 210, 3.2, 'F')
  doc.setFillColor(...C.wash)
  doc.rect(0, 3.2, 210, 14, 'F')
  doc.setDrawColor(...C.line)
  doc.setLineWidth(0.2)
  doc.line(0, 17.2, 210, 17.2)

  setInk(doc, C.muted)
  drawMixedText(doc, '内核并发安全分析系统', 14, 12, { fontSize: 8 })
  setInk(doc, C.ink)
  drawMixedText(doc, pageTitle, 196, 12, { fontSize: 10, align: 'right' })
}

function drawFooter(doc, runId) {
  const pageCount = doc.internal.getNumberOfPages()
  for (let i = 1; i <= pageCount; i++) {
    doc.setPage(i)
    doc.setDrawColor(...C.line)
    doc.setLineWidth(0.3)
    doc.line(14, 287, 196, 287)
    setInk(doc, C.muted)
    drawMixedText(doc, '自动生成 · 仅供工程复盘', 14, 292, { fontSize: 7.5 })
    if (runId) {
      drawMixedText(doc, `run ${String(runId).slice(0, 24)}`, 105, 292, {
        fontSize: 7.5,
        align: 'center',
      })
    }
    drawMixedText(doc, `${i} / ${pageCount}`, 196, 292, { fontSize: 7.5, align: 'right' })
  }
}

function sectionTitle(doc, text, y) {
  setInk(doc, C.ink)
  drawMixedText(doc, text, 14, y, { fontSize: 11 })
  setReportFont(doc, true, 11)
  const tw = measureMixedWidth(doc, text, 11)
  doc.setDrawColor(...C.accent)
  doc.setLineWidth(0.6)
  doc.line(14, y + 1.8, 14 + Math.min(tw, 48), y + 1.8)
  doc.setDrawColor(...C.line)
  doc.setLineWidth(0.2)
  doc.line(14 + Math.min(tw, 48) + 2, y + 1.8, 196, y + 1.8)
  return y + 8
}

function drawMetaRow(doc, y, pairs) {
  const leftX = 14
  const rightX = 110
  const labelW = 24
  pairs.forEach((pair, idx) => {
    const col = idx % 2
    const row = Math.floor(idx / 2)
    const x = col === 0 ? leftX : rightX
    const yy = y + row * 7
    setInk(doc, C.muted)
    drawMixedText(doc, pair[0], x, yy, { fontSize: 9 })
    setInk(doc, C.ink)
    drawMixedText(doc, String(pair[1] ?? '-'), x + labelW, yy, { fontSize: 9 })
  })
  return y + Math.ceil(pairs.length / 2) * 7
}

function gradeColor(grade) {
  if (grade === '优') return C.ok
  if (grade === '良') return C.accent
  if (grade === '中') return C.warn
  return C.danger
}

function drawScoreBlock(doc, x, y, w, h, health) {
  doc.setFillColor(...C.wash)
  doc.roundedRect(x, y, w, h, 1.5, 1.5, 'F')
  doc.setDrawColor(...C.line)
  doc.setLineWidth(0.3)
  doc.roundedRect(x, y, w, h, 1.5, 1.5, 'S')

  setInk(doc, C.muted)
  drawMixedText(doc, '综合健康分', x + 8, y + 10, { fontSize: 8 })

  setInk(doc, gradeColor(health.grade))
  drawMixedText(doc, String(health.score), x + 8, y + 28, { fontSize: 32 })
  const scoreW = measureMixedWidth(doc, String(health.score), 32)
  setInk(doc, C.ink)
  drawMixedText(doc, '/ 100', x + 8 + scoreW + 2, y + 27, { fontSize: 10 })

  setInk(doc, gradeColor(health.grade))
  drawMixedText(doc, `等级 ${health.grade}`, x + w - 8, y + 18, {
    fontSize: 11,
    align: 'right',
  })

  const barX = x + 8
  const barY = y + h - 10
  const barW = w - 16
  doc.setFillColor(...C.line)
  doc.roundedRect(barX, barY, barW, 2.2, 1, 1, 'F')
  doc.setFillColor(...gradeColor(health.grade))
  doc.roundedRect(barX, barY, Math.max(2, (barW * health.score) / 100), 2.2, 1, 1, 'F')
}

function drawStatGrid(doc, y, items) {
  const cols = 4
  const gap = 3.5
  const boxW = (182 - gap * (cols - 1)) / cols
  const boxH = 20
  items.forEach((item, idx) => {
    const col = idx % cols
    const row = Math.floor(idx / cols)
    const x = 14 + col * (boxW + gap)
    const yy = y + row * (boxH + gap)
    doc.setFillColor(...C.paper)
    doc.setDrawColor(...C.line)
    doc.setLineWidth(0.35)
    doc.roundedRect(x, yy, boxW, boxH, 1.2, 1.2, 'FD')
    setInk(doc, C.muted)
    drawMixedText(doc, item[0], x + 4, yy + 7, { fontSize: 7.5 })
    setInk(doc, C.ink)
    drawMixedText(doc, String(item[1]), x + 4, yy + 15.5, { fontSize: 12 })
  })
  const rows = Math.ceil(items.length / cols)
  return y + rows * (boxH + gap)
}

function drawHBarChart(doc, x, y, w, h, title, series) {
  setInk(doc, C.ink)
  drawMixedText(doc, title, x, y, { fontSize: 9 })
  const plotX = x
  const plotY = y + 4
  const plotW = w
  const plotH = h - 6
  doc.setFillColor(...C.wash)
  doc.roundedRect(plotX, plotY, plotW, plotH, 1.2, 1.2, 'F')

  const max = Math.max(1, ...series.map((s) => num(s.value)))
  const rowH = Math.min(9, (plotH - 8) / Math.max(series.length, 1))
  series.forEach((s, i) => {
    const yy = plotY + 6 + i * rowH
    const label = String(s.label || '').slice(0, 12)
    setInk(doc, C.muted)
    drawMixedText(doc, label, plotX + 4, yy + 2.5, { fontSize: 7 })
    const barMax = plotW - 52
    const barW = Math.max(1.5, (num(s.value) / max) * barMax)
    doc.setFillColor(...(s.color || C.accent))
    doc.roundedRect(plotX + 36, yy - 1.5, barW, 4, 0.8, 0.8, 'F')
    setInk(doc, C.ink)
    drawMixedText(doc, formatInt(s.value), plotX + 36 + barW + 2, yy + 2, { fontSize: 7 })
  })
}

function mixedTableHooks(doc, fontSize = 8) {
  return {
    willDrawCell(data) {
      const lines = data.cell.text || []
      data.cell._mixedLines = lines.map((t) => String(t))
      data.cell.text = lines.map(() => '')
    },
    didDrawCell(data) {
      const lines = data.cell._mixedLines
      if (!lines || !lines.length) return
      const padL = typeof data.cell.padding === 'function' ? data.cell.padding('left') : 2
      const x = data.cell.x + padL
      let yy = data.cell.y + 4.2
      const lh = Math.max(3.6, (data.cell.styles.fontSize || fontSize) * 0.45)
      setInk(doc, data.cell.styles.textColor || C.ink)
      lines.forEach((line) => {
        drawMixedText(doc, line, x, yy, { fontSize: data.cell.styles.fontSize || fontSize })
        yy += lh
      })
    },
  }
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
  const kernel = data.kernel_version || 'unknown'

  // ===== Page 1: Cover + summary =====
  drawPageChrome(doc, '审计报告')

  setInk(doc, C.ink)
  drawMixedText(doc, '内核并发安全审计报告', 14, 32, { fontSize: 18 })
  setInk(doc, C.muted)
  drawMixedText(doc, 'Kernel Concurrency Safety Audit', 14, 39, { fontSize: 9 })
  setInk(doc, C.accent)
  drawMixedText(doc, kernel, 14, 50, { fontSize: 13 })

  drawMetaRow(doc, 58, [
    ['扫描时间', data.scan_time || generatedAt],
    ['生成时间', generatedAt],
    ['数据来源', dataSourceLabel(data)],
    ['报告范围', `告警精选前 ${WARNINGS_EXPORT_LIMIT} 条`],
  ])

  drawScoreBlock(doc, 14, 78, 182, 36, health)

  let y = sectionTitle(doc, '执行摘要', 126)
  setInk(doc, C.ink)
  y = drawWrappedMixed(doc, executive, 14, y, 182, 5, 9.5) + 6

  y = sectionTitle(doc, '关键指标', y)
  y = drawStatGrid(doc, y, [
    ['分析文件', formatInt(summary.analysis_files)],
    ['函数数', formatInt(summary.total_functions)],
    ['调用边', formatInt(summary.total_edges)],
    ['竞态告警', formatInt(summary.total_warnings)],
    ['内存安全', formatInt(summary.memory_safety)],
    ['信息泄露', formatInt(summary.info_leak)],
    ['权限提升', formatInt(summary.privilege_escalation)],
    ['TOCTOU', formatInt(summary.toctou)],
  ])

  y += 4
  y = sectionTitle(doc, '风险热点 Top 变量', y)
  const topVars = (data.race_warnings?.top_variables || []).slice(0, 5)
  const tableHooks = mixedTableHooks(doc, 8.5)
  autoTable(doc, {
    startY: y,
    head: [['#', '变量', '告警次数']],
    body: topVars.length
      ? topVars.map((item, i) => [String(i + 1), item.name || '-', formatInt(item.count)])
      : [['-', '暂无热点变量', '-']],
    theme: 'plain',
    styles: {
      font: FONT_FAMILY,
      fontSize: 8.5,
      cellPadding: { top: 2.2, bottom: 2.2, left: 2, right: 2 },
      textColor: C.ink,
      lineColor: C.line,
      lineWidth: 0.2,
    },
    headStyles: {
      fillColor: C.wash,
      textColor: C.muted,
      font: FONT_FAMILY,
      fontStyle: 'normal',
      fontSize: 8,
    },
    alternateRowStyles: { fillColor: [252, 252, 253] },
    columnStyles: {
      0: { cellWidth: 12 },
      1: { cellWidth: 120 },
      2: { cellWidth: 50, halign: 'right' },
    },
    margin: { left: 14, right: 14 },
    tableLineColor: C.line,
    tableLineWidth: 0.2,
    willDrawCell: tableHooks.willDrawCell,
    didDrawCell: tableHooks.didDrawCell,
  })

  // ===== Page 2: Charts (prefer live images; always have native fallbacks) =====
  doc.addPage()
  drawPageChrome(doc, '态势与分布')
  y = sectionTitle(doc, '风险与代码态势', 28)
  setInk(doc, C.muted)
  drawMixedText(doc, '优先嵌入仪表盘图表；未就绪时用本次统计绘制，避免空白占位。', 14, y - 3, {
    fontSize: 8,
  })
  y += 2

  const riskSeries = [
    { label: '竞态', value: summary.race_condition, color: C.danger },
    { label: '内存', value: summary.memory_safety, color: [160, 70, 70] },
    { label: '泄露', value: summary.info_leak, color: C.warn },
    { label: '提权', value: summary.privilege_escalation, color: C.accent },
    { label: 'TOCTOU', value: summary.toctou, color: [90, 90, 140] },
  ]
  const codeSeries = [
    { label: '文件', value: summary.analysis_files, color: C.accent },
    { label: '函数', value: summary.total_functions, color: C.ok },
    { label: '变量', value: summary.total_variables, color: C.warn },
    { label: '调用边', value: summary.total_edges, color: [70, 100, 130] },
    { label: '告警', value: summary.total_warnings, color: C.danger },
  ]
  const hotSeries = topVars.slice(0, 5).map((v, i) => ({
    label: String(v.name || `var${i}`).slice(0, 10),
    value: v.count,
    color: i === 0 ? C.danger : C.accent,
  }))

  const slots = [
    { title: '漏洞类型分布', img: charts.riskDist, fallback: riskSeries },
    { title: '代码统计概览', img: charts.codeStats, fallback: codeSeries },
    { title: '高危函数 Top（仪表盘）', img: charts.topFuncs, fallback: hotSeries.length ? hotSeries : riskSeries },
    { title: '访问拓扑（仪表盘）', img: charts.topo, fallback: null },
  ]

  let embedded = 0
  const positions = [
    { x: 14, y: 40 },
    { x: 108, y: 40 },
    { x: 14, y: 128 },
    { x: 108, y: 128 },
  ]
  const slotW = 88
  const slotH = 78

  slots.forEach((slot, idx) => {
    const pos = positions[idx]
    if (slot.img) {
      setInk(doc, C.ink)
      drawMixedText(doc, slot.title, pos.x, pos.y, { fontSize: 9 })
      doc.setDrawColor(...C.line)
      doc.setLineWidth(0.3)
      doc.roundedRect(pos.x, pos.y + 2, slotW, slotH - 4, 1.2, 1.2, 'S')
      doc.addImage(slot.img, 'PNG', pos.x + 1.5, pos.y + 3.5, slotW - 3, slotH - 7)
      embedded += 1
    } else if (slot.fallback && slot.fallback.length) {
      drawHBarChart(doc, pos.x, pos.y, slotW, slotH, slot.title.replace('（仪表盘）', ''), slot.fallback)
    } else {
      setInk(doc, C.ink)
      drawMixedText(doc, slot.title, pos.x, pos.y, { fontSize: 9 })
      doc.setFillColor(...C.wash)
      doc.roundedRect(pos.x, pos.y + 2, slotW, slotH - 4, 1.2, 1.2, 'F')
      setInk(doc, C.muted)
      drawMixedText(doc, '拓扑图需在仪表盘加载后导出', pos.x + slotW / 2, pos.y + slotH / 2, {
        fontSize: 8,
        align: 'center',
      })
    }
  })

  // ===== Page 3+: Warnings =====
  doc.addPage()
  drawPageChrome(doc, '告警明细')
  y = sectionTitle(doc, '告警明细 精选', 28)
  const total = Math.max(num(warningsTotal), warnings.length, num(summary.total_warnings))
  const shown = Math.min(WARNINGS_EXPORT_LIMIT, warnings.length)
  setInk(doc, C.muted)
  drawMixedText(doc, `共 ${formatInt(total)} 条，按高危优先展示 ${shown} 条。`, 14, y - 2, {
    fontSize: 8.5,
  })

  const sorted = [...warnings]
    .sort((a, b) => {
      const sa = severityLabel(a.severity, a.type) === '高危' ? 0 : 1
      const sb = severityLabel(b.severity, b.type) === '高危' ? 0 : 1
      return sa - sb
    })
    .slice(0, WARNINGS_EXPORT_LIMIT)

  const body = sorted.map((w) => [
    severityLabel(w.severity, w.type),
    w.variable || '-',
    w.function || '-',
    riskTypeLabel(w.type),
    remediationAdvice(w.type),
  ])

  const warnHooks = mixedTableHooks(doc, 7.5)
  autoTable(doc, {
    startY: y + 4,
    head: [['等级', '变量', '函数', '类型', '建议']],
    body: body.length ? body : [['-', '-', '-', '-', '暂无告警明细']],
    theme: 'plain',
    tableWidth: 182,
    styles: {
      font: FONT_FAMILY,
      fontSize: 7.5,
      cellPadding: 2,
      valign: 'middle',
      textColor: C.ink,
      overflow: 'linebreak',
      lineColor: C.line,
      lineWidth: 0.15,
    },
    headStyles: {
      fillColor: C.wash,
      textColor: C.muted,
      font: FONT_FAMILY,
      fontSize: 8,
    },
    alternateRowStyles: { fillColor: [252, 252, 253] },
    columnStyles: {
      0: { cellWidth: 14 },
      1: { cellWidth: 34 },
      2: { cellWidth: 42 },
      3: { cellWidth: 22 },
      4: { cellWidth: 'auto' },
    },
    didParseCell(hookData) {
      if (hookData.section === 'body' && hookData.column.index === 0) {
        const v = String(hookData.cell.raw || '')
        if (v === '高危') {
          hookData.cell.styles.textColor = C.danger
        } else if (v === '中危') {
          hookData.cell.styles.textColor = C.warn
        }
      }
    },
    willDrawCell: warnHooks.willDrawCell,
    didDrawCell: warnHooks.didDrawCell,
    margin: { left: 14, right: 14, bottom: 18 },
  })

  drawFooter(doc, runId)

  const safeTarget = String(kernel).replace(/[^\w.-]+/g, '_')
  const filename = `kernel_security_audit_${safeTarget}_${Date.now()}.pdf`
  if (download) {
    doc.save(filename)
  }
  return { filename, health, embeddedCharts: embedded, warningRows: shown, doc }
}

export { WARNINGS_EXPORT_LIMIT }
