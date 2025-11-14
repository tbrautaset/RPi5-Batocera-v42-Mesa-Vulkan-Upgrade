#!/usr/bin/env bash
set -euo pipefail

INSTALL_ROOT="/userdata/system"
STACK_DIR_NAME="mesa-vulkan-25.3.0rc4-1.4.328.1"
INSTALL_DIR="${INSTALL_ROOT}/${STACK_DIR_NAME}"

echo "== LIB CONTENT =="
ls -lh "${INSTALL_DIR}/lib"

echo
echo "== ICD FILE =="
cat "${INSTALL_DIR}/icd/broadcom_icd.json"

echo
echo "== CHECK Mesa/V3DV driver =="
strings "${INSTALL_DIR}/lib/libvulkan_broadcom.so" | grep -E 'Mesa|V3DV' | head

echo
echo "== CHECK Vulkan loader =="
strings "${INSTALL_DIR}/lib/libvulkan.so.1.4.328"* | grep -i "Vulkan Loader" | head || true
