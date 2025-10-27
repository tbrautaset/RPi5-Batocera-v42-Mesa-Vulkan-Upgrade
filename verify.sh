#!/bin/sh
set -e
BASE="/userdata/system"
STACK_DIR="$(ls -1dt $BASE/mesa-vulkan-* 2>/dev/null | head -n1)"

if [ -z "$STACK_DIR" ]; then
  echo "No mesa-vulkan-* stack folder found in $BASE"
  exit 1
fi

export LD_LIBRARY_PATH="$STACK_DIR/lib:/usr/lib"
export VK_ICD_FILENAMES="$STACK_DIR/icd/broadcom_icd.cortex-a76.json"

echo "[i] Using stack: $STACK_DIR"
if command -v vulkaninfo >/dev/null 2>&1; then
  vulkaninfo | awk '/Vulkan Instance Version|apiVersion|driverVersion|deviceName/{print}'
else
  echo "vulkaninfo not found."
fi

echo
echo "[i] ICD dependency check:"
ldd "$STACK_DIR/lib/libvulkan_broadcom.so" || true

