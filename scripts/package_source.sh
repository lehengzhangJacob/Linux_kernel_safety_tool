#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT_DIR="$PROJECT_ROOT/release"
STAMP="$(date +%Y%m%d_%H%M%S)"
OUT_FILE="$OUT_DIR/linux_kernel_safety_tool_source_${STAMP}.tar.gz"

mkdir -p "$OUT_DIR"

# 打包团队开发产物（源码/工程设计/模型相关文件），排除中间产物和第三方代码。
tar -czf "$OUT_FILE" \
  --exclude='.git' \
  --exclude='.vscode' \
  --exclude='.idea' \
  --exclude='release' \
  --exclude='repo' \
  --exclude='analysis_data' \
  --exclude='logs' \
  --exclude='bin' \
  --exclude='venv' \
  --exclude='import.report' \
  --exclude='test/comparison_results' \
  --exclude='test/performance_results' \
  --exclude='web_dashboard/frontend/node_modules' \
  --exclude='web_dashboard/frontend/dist' \
  --exclude='web_dashboard/backend/venv' \
  --exclude='web_dashboard/backend/__pycache__' \
  --exclude='web_dashboard/backend/data/*.db' \
  --exclude='web_dashboard/data/uploads/*/source' \
  --exclude='web_dashboard/data/uploads/*/archive' \
  --exclude='web_dashboard/data/linux-*' \
  --exclude='tools/jdk-*' \
  --exclude='tools/neo4j-community-*' \
  --exclude='tools/*.tar.gz' \
  --exclude='tools/__pycache__' \
  --exclude='**/__pycache__' \
  --exclude='*.o' \
  --exclude='*.a' \
  --exclude='*.so' \
  --exclude='*.pyc' \
  --exclude='*.pyo' \
  --exclude='*.tmp' \
  --exclude='*.bak' \
  --exclude='*.swp' \
  --exclude='*~' \
  -C "$PROJECT_ROOT" .

echo "Package created: $OUT_FILE"
