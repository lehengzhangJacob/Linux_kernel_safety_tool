#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

"$ROOT_DIR/stop_web.sh"
"$ROOT_DIR/start_web.sh"
