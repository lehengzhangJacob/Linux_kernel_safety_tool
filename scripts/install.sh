#!/bin/bash
set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# 项目根目录（scripts的上级目录）
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=================================================="
echo "  Linux Kernel Safety Analyzer - Installer"
echo "=================================================="

# 1. Check OS
if ! grep -q "Ubuntu\|Debian" /etc/os-release 2>/dev/null; then
    echo "Warning: This tool is officially supported on Ubuntu/Debian."
fi

# 2. Install System Dependencies
echo "[1/4] Installing system dependencies (requires sudo)..."
sudo apt update
sudo apt install -y build-essential gcc-13 g++-13 gcc-13-plugin-dev \
    libncurses-dev bison flex libssl-dev libelf-dev bc dwarves rsync cpio \
    python3 python3-venv wget tar nodejs npm

# 3. Setup internal tools (JDK & Neo4j)
echo "[2/4] Setting up JDK and Neo4j..."
cd "$SCRIPT_DIR"
./setup_tools.sh
cd "$PROJECT_ROOT"

# 4. Compile GCC Plugin
echo "[3/4] Compiling GCC Plugin..."
make -C src/plugin clean
make -C src/plugin

# 5. Compile main executable
echo "[4/4] Compiling main executable..."
gcc src/main.c -o kernel_analyzer
chmod +x kernel_analyzer

echo "=================================================="
echo "  Installation Complete!"
echo "=================================================="
echo ""
echo "Usage:"
echo "  ./kernel_analyzer --help       Show all commands"
echo "  ./kernel_analyzer analyze      Run full kernel analysis"
echo "  ./kernel_analyzer start-db     Start Neo4j database"
echo "  ./kernel_analyzer test         Run toolchain test"
