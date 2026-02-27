#!/bin/bash
set -e

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
    python3 wget tar

# 3. Setup internal tools (JDK & Neo4j)
echo "[2/4] Setting up JDK and Neo4j..."
./setup_tools.sh

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
