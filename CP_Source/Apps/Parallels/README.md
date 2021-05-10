# Parallels Client (10 May DRAFT)

|  CP Information |            |
|-----------------|------------|
| Package | [Parallels Client for Linux](https://kb.parallels.com/en/123304) <br /><br /> Parallels RAS: A streamlined remote working solution that provides secure access to virtual desktops and applications. |
| Script Name | [parallels-cp-init-script.sh](parallels-cp-init-script.sh) |
| CP Mount Path | /custom/parallels |
| CP Size | 100M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> parallels.inf | [INFO] <br /> [PART] <br /> file="parallels.tar.bz2" <br /> version="99.17.65039" <br /> size="100M" <br /> minfw="11.04.240" |
| Path to Executable | /custom/parallels/opt/2X/Client/bin/2XClient |
| Path to Icon | /custom/parallels/usr/share/pixmaps/2X.png |
| Packaging Notes | Details can be found in the build script [build-parallels-cp.sh](build-parallels-cp.sh) |
| Package automation | [build-parallels-cp.sh](build-parallels-cp.sh) <br /><br /> This script will build the latest version based on Ubuntu 18.04 |
