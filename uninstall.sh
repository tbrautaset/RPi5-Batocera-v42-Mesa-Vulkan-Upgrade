#!/usr/bin/env bash
set -euo pipefail

INSTALL_ROOT="/userdata/system"
STACK_DIR_NAME="mesa-vulkan-25.3.0rc4-1.4.328.1"
INSTALL_DIR="${INSTALL_ROOT}/${STACK_DIR_NAME}"

echo "[mesa-vulkan uninstall] Removing ${INSTALL_DIR} ..."
rm -rf "${INSTALL_DIR}"

PROFILE="${INSTALL_ROOT}/.profile"
echo "[mesa-vulkan uninstall] Cleaning ${PROFILE} ..."
sed -i '/# MESA_VULKAN_STACK BEGIN/,/# MESA_VULKAN_STACK END/d' "${PROFILE}" || true

echo "[mesa-vulkan uninstall] Done. Reboot to return to stock Mesa/Vulkan."
