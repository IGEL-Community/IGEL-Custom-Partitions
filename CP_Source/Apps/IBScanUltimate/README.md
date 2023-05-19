# IBScanUltimate (19 April)

-----

**NOTE:** Builder works for OS11 (build with Ubuntu 18.04 - bionic) and **pending** OS12 (build with Ubuntu 20.04 - focal)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [IBScanUltimate](https://integratedbiometrics.com/products/fbi-certified-fingerprint-scanners/kojak) |
| Script Name | [ibscan-cp-init-script.sh](build/ibscan-cp-init-script.sh) |
| Icon name | /usr/share/icons/hicolor/256x256/apps/xfce4-whiskermenu.png  |
| Command | cd /custom/ibscan/opt/IBScanUltimate_x64_3.9.2/bin ; ./IBSU_FunctionTesterForJava.sh bash /custom/ibscan/opt/IBScanUltimate_x64_3.9.2/bin/IBSU_FunctionTesterForJava.sh |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-ibscan-cp.sh](build/build-ibscan-cp.sh) |


**NOTE:** Reboot needed after profile applied to allow for `systemctl start DeviceService.service` to start.