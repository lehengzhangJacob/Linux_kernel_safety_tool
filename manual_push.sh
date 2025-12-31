#!/bin/bash
set -e

echo "Starting manual split push..."

# Remove gitignore as requested
rm -f .gitignore
rm -f build_analysis_linux-6.6.1/.gitignore

# 1. Drivers GPU (42MB)
echo "Pushing drivers/gpu..."
git add build_analysis_linux-6.6.1/drivers/gpu
git commit -m "Add drivers/gpu" || echo "Nothing to commit"
git push

# --- NEW: Tools Split ---
# Tools JDK (308MB) - Needs splitting
echo "Pushing tools/jdk-17.0.2..."
# JDK bin
git add tools/jdk-17.0.2/bin
git commit -m "Add tools/jdk bin" || echo "Nothing to commit"
git push
# JDK lib (likely huge)
# modules is 121MB. We must split or ignore it.
# Since we cannot split a single file, we must ignore it or accept failure.
# The user wants to push "everything", but 50MB limit is hard.
# We will try to push everything EXCEPT modules.
echo "Pushing tools/jdk-17.0.2/lib (excluding modules)..."
git add tools/jdk-17.0.2/lib
if [ -f tools/jdk-17.0.2/lib/modules ]; then
    echo "Excluding tools/jdk-17.0.2/lib/modules (121MB)"
    git reset tools/jdk-17.0.2/lib/modules
fi
git commit -m "Add tools/jdk lib (excluding modules)" || echo "Nothing to commit"
git push

# JDK rest
git add tools/jdk-17.0.2
git commit -m "Add rest of tools/jdk" || echo "Nothing to commit"
git push

# Tools Neo4j (143MB)
echo "Pushing tools/neo4j..."
git add tools/neo4j-community-4.4.34/lib
git commit -m "Add tools/neo4j lib" || echo "Nothing to commit"
git push
git add tools/neo4j-community-4.4.34
git commit -m "Add rest of tools/neo4j" || echo "Nothing to commit"
git push

# Tools Archives (Large files)
# These might fail if > 50MB individually.
# openjdk tar.gz is 179MB. neo4j tar.gz is 113MB.
# We cannot push files > 50MB to this repo. We must ignore them or split them (not possible for tar.gz easily).
# For now, we will SKIP them or add to gitignore if they are not tracked.
echo "Skipping large tar.gz files in tools/..."

# --- NEW: Linux Source Split ---
# Linux Drivers GPU (479MB) - Needs splitting
echo "Pushing linux-6.6.1/drivers/gpu..."
git add linux-6.6.1/drivers/gpu/drm/amd
git commit -m "Add linux drivers/gpu/drm/amd" || echo "Nothing to commit"
git push
git add linux-6.6.1/drivers/gpu/drm/nouveau
git commit -m "Add linux drivers/gpu/drm/nouveau" || echo "Nothing to commit"
git push
git add linux-6.6.1/drivers/gpu/drm/i915
git commit -m "Add linux drivers/gpu/drm/i915" || echo "Nothing to commit"
git push
git add linux-6.6.1/drivers/gpu
git commit -m "Add rest of linux drivers/gpu" || echo "Nothing to commit"
git push

# Linux Drivers Net (145MB)
echo "Pushing linux-6.6.1/drivers/net..."
git add linux-6.6.1/drivers/net/ethernet
git commit -m "Add linux drivers/net/ethernet" || echo "Nothing to commit"
git push
git add linux-6.6.1/drivers/net/wireless
git commit -m "Add linux drivers/net/wireless" || echo "Nothing to commit"
git push
git add linux-6.6.1/drivers/net
git commit -m "Add rest of linux drivers/net" || echo "Nothing to commit"
git push

# Linux Drivers Rest
echo "Pushing rest of linux drivers..."
git add linux-6.6.1/drivers
git commit -m "Add rest of linux drivers" || echo "Nothing to commit"
git push

# Linux Arch (148MB)
echo "Pushing linux-6.6.1/arch..."
git add linux-6.6.1/arch/arm64
git commit -m "Add linux arch/arm64" || echo "Nothing to commit"
git push
git add linux-6.6.1/arch/x86
git commit -m "Add linux arch/x86" || echo "Nothing to commit"
git push
git add linux-6.6.1/arch
git commit -m "Add rest of linux arch" || echo "Nothing to commit"
git push

# Linux Rest
echo "Pushing rest of linux-6.6.1..."
git add linux-6.6.1
git commit -m "Add rest of linux-6.6.1" || echo "Nothing to commit"
git push

# 2. Drivers Rest
echo "Pushing rest of drivers..."
git add build_analysis_linux-6.6.1/drivers
git commit -m "Add rest of drivers" || echo "Nothing to commit"
git push

# 3. Arch Compressed vmlinux.bin (41MB)
echo "Pushing arch compressed vmlinux.bin..."
git add build_analysis_linux-6.6.1/arch/x86/boot/compressed/vmlinux.bin
git commit -m "Add arch compressed vmlinux.bin" || echo "Nothing to commit"
git push

# 4. Arch Compressed Rest
echo "Pushing rest of arch compressed..."
git add build_analysis_linux-6.6.1/arch/x86/boot/compressed
git commit -m "Add rest of arch compressed" || echo "Nothing to commit"
git push

# 5. Arch Rest
echo "Pushing rest of arch..."
git add build_analysis_linux-6.6.1/arch
git commit -m "Add rest of arch" || echo "Nothing to commit"
git push

# 6. Net IPv4/IPv6
echo "Pushing net ipv4/ipv6..."
git add build_analysis_linux-6.6.1/net/ipv4 build_analysis_linux-6.6.1/net/ipv6
git commit -m "Add net ipv4 ipv6" || echo "Nothing to commit"
git push

# 7. Net Rest
echo "Pushing rest of net..."
git add build_analysis_linux-6.6.1/net
git commit -m "Add rest of net" || echo "Nothing to commit"
git push

# 8. Top level vmlinux (49MB)
echo "Pushing top level vmlinux..."
if [ -f build_analysis_linux-6.6.1/vmlinux ]; then
    git add build_analysis_linux-6.6.1/vmlinux
    git commit -m "Add top level vmlinux" || echo "Nothing to commit"
    git push
fi

# 9. Everything else (EXCEPT vmlinux.o and large tar.gz)
echo "Pushing everything else..."
git add .
if [ -f build_analysis_linux-6.6.1/vmlinux.o ]; then
    echo "Excluding vmlinux.o (too large)"
    git reset build_analysis_linux-6.6.1/vmlinux.o
fi
# Exclude large tar.gz files in tools/
git reset tools/*.tar.gz || true

git commit -m "Add remaining files (excluding large files)" || echo "Nothing to commit"
git push

echo "Done!"
