#!/bin/sh
set -eu

SYS_DIR="/userdata/system"
PROFILE="$SYS_DIR/.profile"
CUSTOM_SH="$SYS_DIR/custom.sh"

echo "[i] Disabling custom Vulkan/Mesa environment"

# 1) Stop using custom stack in this shell
unset VK_ICD_FILENAMES || true
case "${LD_LIBRARY_PATH-}" in
  *"$SYS_DIR/mesa-vulkan-"*":/usr/lib"*)
    # Best-effort prune; safest to clear entirely here
    export LD_LIBRARY_PATH="/usr/lib"
    ;;
esac

# 2) Remove .profile hook (only the line)
if [ -f "$PROFILE" ]; then
  TMP="$(mktemp)"
  sed '/\/userdata\/system\/custom\.sh/d' "$PROFILE" > "$TMP" || true
  mv "$TMP" "$PROFILE"
  chown root:root "$PROFILE"
  chmod 644 "$PROFILE"
  echo "[i] Cleaned .profile hook"
fi

# 3) Remove custom.sh
if [ -f "$CUSTOM_SH" ]; then
  rm -f "$CUSTOM_SH"
  echo "[i] Removed $CUSTOM_SH"
fi

# 4) Remove all extracted stacks (mesa-vulkan-*)
for d in "$SYS_DIR"/mesa-vulkan-*; do
  [ -d "$d" ] || continue
  rm -rf "$d"
  echo "[i] Removed $d"
done

# 5) Restart EmulationStation to return to system Mesa/Vulkan
if [ -x /etc/init.d/S31emulationstation ]; then
  /etc/init.d/S31emulationstation restart || true
else
  killall emulationstation 2>/dev/null || true
  /usr/bin/emulationstation & >/dev/null 2>&1 || true
fi

echo "[✓] Uninstall complete. System Vulkan/Mesa should be active after ES restart."

