# 🧩 RPi5 Batocera v42 — Mesa/Vulkan Upgrade (V3DV)

This repository provides a **local Vulkan/Mesa override stack** for **Batocera v42** on **Raspberry Pi 5 (bcm2712)**.
It replaces the built-in Vulkan and Mesa libraries with an updated V3DV Broadcom driver stack.

### Included versions

* 🧱 **Vulkan loader:** 1.4.328.1 (`libvulkan.so.1.4.328`)
* 🌀 **Mesa:** 25.3.0-rc2 (V3DV Broadcom Vulkan driver)
* 🎮 **Extra:** Per-game fix for *Mario Kart Double Dash* (`GM4E01.ini`)

---

## ⚙️ Installation

Run the installer directly from your Pi5 (as **root**):

```sh
curl -fsSL https://raw.githubusercontent.com/tbrautaset/pi5-batocera-v42-mesa-vulkan-upgrade/main/mesa-vulkan-upgrade.sh | sh -s -- \
  --url "https://github.com/tbrautaset/pi5-batocera-v42-mesa-vulkan-upgrade/releases/download/v1/mesa-vulkan-25.3.0rc2-1.4.328.1-2025-10-27.tar.gz"
```

This will:

* Download and extract the stack under `/userdata/system/mesa-vulkan-*`
* Configure a persistent `/userdata/system/custom.sh`
* Automatically restart EmulationStation
* Make the new Vulkan/Mesa stack active across reboots

---

## 🔍 Verify and Uninstall

To verify or roll back the upgrade, you can run:

```sh
# VERIFY – check that the upgraded stack is active
curl -fsSL https://raw.githubusercontent.com/tbrautaset/pi5-batocera-v42-mesa-vulkan-upgrade/main/verify.sh | sh -s --

# UNINSTALL – revert to Batocera’s default Mesa/Vulkan
curl -fsSL https://raw.githubusercontent.com/tbrautaset/pi5-batocera-v42-mesa-vulkan-upgrade/main/uninstall.sh | sh -s --
```

`verify.sh` prints the active Vulkan/Mesa versions.
`uninstall.sh` removes the override directory, cleans up `/userdata/system/custom.sh` and `.profile`,
and restarts EmulationStation to restore the stock drivers.

---

## 💡 Notes

* Designed specifically for **Batocera v42 (RPi5, bcm2712)**
* Requires no rebuild or system modifications
* Safe to run multiple times — idempotent installer/uninstaller
* Verified working stack:

  ```
  Vulkan Instance Version: 1.4.328
  driverVersion: 25.3.0 (Mesa 25.3.0-rc2)
  deviceName: V3D 7.1.7.0
  ```
