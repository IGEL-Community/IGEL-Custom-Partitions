# Fabulatech AVD Serial Port Redirection (20 April)

-----

**NOTE:** Builder works for OS11 (build with Ubuntu 18.04 - bionic) and **pending** OS12 (build with Ubuntu 20.04 - focal)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [Fabulatech Serial Port for Remote Desktop](https://www.fabulatech.com/serial-port-for-remote-desktop-linux-packages.html) |
| Script Name | [ftspr-cp-init-script.sh](build/ftspr-cp-init-script.sh) |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-ftspr-cp.sh](build/build-ftspr-cp.sh) |

-----

**NOTE:**

- Make sure to enable Fabulatech USB redirection to load the Fabulatech plugin to AVD during session start.

```bash
#Start
/opt/ftspr/sbin/ftsprd &
```