# Mesa/Vulkan Override Stack for Batocera v42  
### Supports **Raspberry Pi 4 (bcm2711)** and **Raspberry Pi 5 (bcm2712)**  

Mesa **25.3.0-rc4** • Vulkan Loader **1.4.328.1** • V3DV Broadcom Driver

This project provides an upgraded Vulkan/Mesa stack for **Batocera v42** on both the Raspberry Pi 4 and Raspberry Pi 5.  
It replaces Batocera’s built-in Vulkan loader and V3DV Mesa driver with newer, optimized versions that improve rendering accuracy and fix multiple compatibility issues (including Mario Kart Double Dash).

---

## 🎬 Demonstration – Mario Kart Double Dash Fix

Bright/dark tint issue on RPi5 fixed using this Mesa/Vulkan stack.  
(Click to play)

<video width="720" controls muted playsinline>
  <source src="https://raw.githubusercontent.com/tbrautaset/rpi-batocera-mesa-vulkan/main/MKDD-Tint-Fix-RPi5.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

[▶️ Open video in a new tab](https://raw.githubusercontent.com/tbrautaset/rpi-batocera-mesa-vulkan/main/MKDD-Tint-Fix-RPi5.webm)


---

## 🔧 Included Components

| Component       | Version       | Notes                                          |
|----------------|---------------|-----------------------------------------------|
| Vulkan Loader  | 1.4.328.1     | `libvulkan.so.1.4.328`                        |
| Mesa (V3DV)    | 25.3.0-rc4    | Optimized Broadcom Vulkan driver              |
| V3DV Driver    | Auto-selected | RPi4 → cortex-a72 • RPi5 → cortex-a76         |
| ICD Files      | a72 / a76     | CPU-specific V3DV loader configuration        |
| Optional Fix   | `GM4E01.ini`  | Mario Kart Double Dash brightness / dark fix  |

---

## 📁 Layout of the override stack

Inside `mesa-vulkan-25.3.0rc4-1.4.328.1` (extracted under `/userdata/system/`):

```text
mesa-vulkan-25.3.0rc4-1.4.328.1/
  lib/
    libvulkan.so
    libvulkan.so.1
    libvulkan.so.1.4.328
    rpi4/libvulkan_broadcom.so     # V3DV for Raspberry Pi 4 (cortex-a72)
    rpi5/libvulkan_broadcom.so     # V3DV for Raspberry Pi 5 (cortex-a76)
  icd/
    broadcom_icd.cortex-a72.json   # ICD for RPi4 (points to rpi4/libvulkan_broadcom.so)
    broadcom_icd.cortex-a76.json   # ICD for RPi5 (points to rpi5/libvulkan_broadcom.so)
```

## 🚀 Installation (RPi4 & RPi5)

Run this **directly on your Batocera device** (RPi4 or RPi5):

```sh
curl -fsSL https://raw.githubusercontent.com/tbrautaset/rpi-batocera-mesa-vulkan/main/install.sh | sh
```

The installer will automatically:

* Detect whether you are on **RPi4** or **RPi5**
* Download the latest `mesa-vulkan-stack.tar.gz` from the GitHub release
* Install to:

  ```text
  /userdata/system/mesa-vulkan-25.3.0rc4-1.4.328.1
  ```
* Select the correct V3DV driver + ICD config
* Update `/userdata/system/.profile` to prepend the new Vulkan/Mesa stack
* Make the override persistent across reboots

Reboot Batocera to complete activation.

---

## 🔁 Update Existing Installation

If you already installed a previous version of this Mesa/Vulkan override stack:

```sh
curl -fsSL https://raw.githubusercontent.com/tbrautaset/rpi-batocera-mesa-vulkan/main/self-update.sh | sh
```

This will:

* Detect your CPU (RPi4 vs RPi5)
* Download the newest `mesa-vulkan-stack.tar.gz`
* Replace the existing `mesa-vulkan-25.3.0rc4-1.4.328.1` directory
* Preserve your `.profile` configuration
* Attempt to restart EmulationStation automatically (or instruct you to reboot)

This is the recommended way to move between versions of the override stack.

---

## 🎮 Optional Mario Kart Double Dash Fix (`GM4E01.ini`)

To fix the dark / dim image in **Mario Kart Double Dash (GameCube)** you can optionally install a per-game Dolphin config.

On Batocera, the file must end up here:

   ```text
   /userdata/system/configs/dolphin-emu/GameSettings/GM4E01.ini
   ```

Once in place, Dolphin will automatically apply the fix for the GM4E01 title.

---

## 🔍 Verification

```sh
curl -fsSL https://raw.githubusercontent.com/tbrautaset/rpi-batocera-mesa-vulkan/main/verify.sh | sh -s --
```

This script will show:

* Vulkan loader version (`libvulkan.so`)
* Mesa / V3DV version from `libvulkan_broadcom.so`
* Selected ICD file (a72 vs a76)
* Active library path used by Vulkan

---

## ❌ Uninstall (Revert to Batocera Defaults)

```sh
curl -fsSL https://raw.githubusercontent.com/tbrautaset/rpi-batocera-mesa-vulkan/main/uninstall.sh | sh -s --
```

The uninstaller will:

* Remove the override directory (`mesa-vulkan-25.3.0rc4-1.4.328.1`)
* Clean your `/userdata/system/.profile` and `custom.sh` entries added by the installer
* Restore stock Batocera Vulkan/Mesa libraries

---

## ✅ Verified Output Example (RPi5)

Typical Vulkan info dump after installation:

```text
Vulkan Instance Version: 1.4.328
driverVersion: 25.3.0 (Mesa 25.3.0-rc4)
deviceName: V3D 7.1.7.0
```

---

## 🧠 Notes

* Supports **Batocera v42**, **Raspberry Pi 4**, and **Raspberry Pi 5**
* Fully reversible — no core system files are modified
* All override files live under `/userdata/system`
* Scripts are idempotent — safe to run multiple times
* Can coexist with other tweaks, as long as `.profile` is managed carefully

---

## 📦 Assets

* **mesa-vulkan-stack.tar.gz** — complete override stack (`mesa-vulkan-25.3.0rc4-1.4.328.1/`)
* **mesa-vulkan-stack.tar.gz.sha256** — checksum for integrity verification
