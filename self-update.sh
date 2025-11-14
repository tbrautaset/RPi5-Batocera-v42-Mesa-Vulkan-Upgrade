#!/bin/sh
#
# Mesa/Vulkan override self-update for Batocera v42
# Supports: Raspberry Pi 4 (bcm2711) & Raspberry Pi 5 (bcm2712)

set -e

REPO_OWNER="tbrautaset"
REPO_NAME="rpi-batocera-mesa-vulkan"
STACK_DIR_NAME="mesa-vulkan-25.3.0rc4-1.4.328.1"
ASSET_TARBALL="mesa-vulkan-stack.tar.gz"
ASSET_SHA256="${ASSET_TARBALL}.sha256"

BASE_RELEASE_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/latest/download"

WORKDIR="/userdata/system"
TMPDIR="${WORKDIR}/.mesa-vulkan-tmp"
STACK_DIR="${WORKDIR}/${STACK_DIR_NAME}"

echo "[mesa-vulkan] Self-update starting..."

# Simple Batocera sanity check
if [ ! -f /etc/batocera-release ]; then
  echo "[mesa-vulkan] ERROR: This script is intended to run on Batocera."
  exit 1
fi

mkdir -p "${WORKDIR}" "${TMPDIR}"
cd "${TMPDIR}"

echo "[mesa-vulkan] Downloading latest ${ASSET_TARBALL}..."
if ! curl -fsSL "${BASE_RELEASE_URL}/${ASSET_TARBALL}" -o "${ASSET_TARBALL}"; then
  echo "[mesa-vulkan] ERROR: Failed to download ${ASSET_TARBALL}"
  exit 1
fi

echo "[mesa-vulkan] Downloading ${ASSET_SHA256}..."
if curl -fsSL "${BASE_RELEASE_URL}/${ASSET_SHA256}" -o "${ASSET_SHA256}"; then
  echo "[mesa-vulkan] Verifying SHA256 checksum..."
  if ! sha256sum -c "${ASSET_SHA256}"; then
    echo "[mesa-vulkan] ERROR: SHA256 verification failed!"
    exit 1
  fi
else
  echo "[mesa-vulkan] WARNING: No SHA256 file available, skipping integrity check."
fi

echo "[mesa-vulkan] Removing old stack directory (if present): ${STACK_DIR}"
rm -rf "${STACK_DIR}"

echo "[mesa-vulkan] Extracting new stack into ${WORKDIR}..."
tar -xzf "${ASSET_TARBALL}" -C "${WORKDIR}"

if [ ! -d "${STACK_DIR}" ]; then
  echo "[mesa-vulkan] ERROR: Expected directory ${STACK_DIR_NAME} not found after extraction."
  exit 1
fi

echo "[mesa-vulkan] Cleaning temporary files..."
rm -rf "${TMPDIR}"

echo "[mesa-vulkan] Self-update finished."

# Try to restart EmulationStation so the new stack is used immediately
if [ -x /etc/init.d/S31emulationstation ]; then
  echo "[mesa-vulkan] Restarting EmulationStation..."
  /etc/init.d/S31emulationstation restart || true
else
  echo "[mesa-vulkan] Could not restart EmulationStation automatically."
  echo "[mesa-vulkan] Please reboot Batocera or restart EmulationStation manually."
fi

echo "[mesa-vulkan] Done."
