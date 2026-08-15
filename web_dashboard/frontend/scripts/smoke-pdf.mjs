import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath, pathToFileURL } from 'node:url'

const __dirname = path.dirname(fileURLToPath(import.meta.url))
const frontendRoot = path.resolve(__dirname, '..')
const fontPath = path.join(frontendRoot, 'public/fonts/DroidSansFallback.ttf')
const outPath = path.join(frontendRoot, '../../logs/smoke_professional_audit.pdf')

if (!fs.existsSync(fontPath)) {
  console.error('Missing font:', fontPath)
  process.exit(1)
}

const fontBuf = fs.readFileSync(fontPath)
globalThis.fetch = async (url) => {
  const u = String(url)
  if (u.includes('DroidSansFallback') || u.endsWith('.ttf')) {
    return {
      ok: true,
      async arrayBuffer() {
        return fontBuf.buffer.slice(fontBuf.byteOffset, fontBuf.byteOffset + fontBuf.byteLength)
      },
    }
  }
  throw new Error(`Unexpected fetch in smoke: ${u}`)
}

const { buildProfessionalPdf, computeHealthScore, buildExecutiveSummary } = await import(
  pathToFileURL(path.join(frontendRoot, 'src/utils/auditReportPdf.js')).href
)

const mockData = {
  kernel_version: 'linux-6.6.1',
  scan_time: '2026-08-15',
  is_prebuilt: false,
  is_demo_data: false,
  summary: {
    analysis_files: 663,
    total_functions: 14732,
    total_variables: 880,
    total_edges: 36290,
    total_warnings: 1455,
    warning_reads: 800,
    warning_writes: 655,
    memory_safety: 31768,
    race_condition: 200,
    info_leak: 902,
    privilege_escalation: 4040,
    toctou: 36,
  },
  race_warnings: {
    top_variables: [
      { name: '_already_done', count: 164 },
      { name: 'jiffies', count: 136 },
      { name: 'system_state', count: 88 },
    ],
  },
}

const health = computeHealthScore(mockData.summary, mockData.race_warnings)
const summaryText = buildExecutiveSummary(mockData, health)
console.log('health:', health)
console.log('summary:', summaryText)

const warnings = [
  { severity: 'HIGH', type: 'Write', variable: 'jiffies', function: 'do_timer' },
  { severity: 'MEDIUM', type: 'Read', variable: '_already_done', function: 'kernel_init' },
  { severity: 'HIGH', type: 'Write', variable: 'system_state', function: 'rest_init' },
]

const result = await buildProfessionalPdf({
  data: mockData,
  runId: 'smoke-run-id',
  chartInstances: {},
  warnings,
  warningsTotal: 1455,
  download: false,
})

const pdfBytes = Buffer.from(result.doc.output('arraybuffer'))
fs.mkdirSync(path.dirname(outPath), { recursive: true })
fs.writeFileSync(outPath, pdfBytes)
console.log('wrote', outPath, `${(pdfBytes.length / 1024).toFixed(1)} KB`)
console.log('embeddedCharts', result.embeddedCharts, 'warningRows', result.warningRows)

// Basic PDF magic check
if (pdfBytes.subarray(0, 4).toString() !== '%PDF') {
  console.error('Not a PDF')
  process.exit(1)
}
console.log('SMOKE_OK')
