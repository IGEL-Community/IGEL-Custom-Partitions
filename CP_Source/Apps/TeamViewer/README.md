# TeamViewer (21 March)

-----

**NOTE:** Builder works for OS11 (build with Ubuntu 18.04 - bionic) and OS12 (build with Ubuntu 20.04 - focal)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [TeamViewer](https://www.teamviewer.com/en-us/download/linux/) <br /><br /> - Establish incoming and outgoing connections between devices <br /> - Real-time remote access and support <br /><br /> The builder is able to build either: <br /><br /> - TeamViewer for Linux <br /> - TeamViewer Host|
| Script Name | [teamviewer-cp-init-script.sh](build/teamviewer-cp-init-script.sh) |
| Icon name | /custom/teamviewer/usr/share/icons/hicolor/256x256/apps/TeamViewer.png |
| Command | /custom/teamviewer/usr/bin/teamviewer |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-teamviewer-cp.sh](build/build-teamviewer-cp.sh) |

-----

**NOTE:** A reboot is required before the TeamViewer service can start.

```
systemctl enable /custom/teamviewer/opt/teamviewer/tv_bin/script/teamviewerd.service; systemctl start teamviewerd.service
   ```
