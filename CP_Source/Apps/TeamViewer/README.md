# TeamViewer (29 November)

|  CP Information |            |
|-----------------|------------|
| Package | [TeamViewer](https://www.teamviewer.com/en-us/download/linux/) <br /><br /> - Establish incoming and outgoing connections between devices <br /> - Real-time remote access and support |
| Script Name | [teamviewer-cp-init-script.sh](teamviewer-cp-init-script.sh) |
| CP Mount Path | /custom/teamviewer |
| CP Size | 400M |
| IGEL OS Version (min) | 11.05.133 |
| Path to Executable | /custom/teamviewer/usr/bin/teamviewer |
| Path to Icon | /custom/teamviewer/usr/share/icons/hicolor/256x256/apps/TeamViewer.png |
| Packaging Notes | Details can be found in the build script [build-teamviewer-cp.sh](build-teamviewer-cp.sh) |
| Package automation | [build-teamviewer-cp.sh](build-teamviewer-cp.sh) <br /><br /> This script will build the latest version based on Ubuntu 18.04 |
