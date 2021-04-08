# VLC Media Player (8 April Updated)

|  CP Information |            |
|-----------------|------------|
| Package | [VLC Media Player](https://www.videolan.org/vlc/) VLC is a free and open source cross-platform multimedia player and framework that plays most multimedia files as well as DVDs, Audio CDs, VCDs, and various streaming protocols. |
| Script Name | [vlc-cp-init-script.sh](vlc-cp-init-script.sh) |
| CP Mount Path | /custom/vlc |
| CP Size | 300M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> vlc.inf | [INFO] <br /> [PART] <br /> file="vlc.tar.bz2" <br /> version="3.0.8" <br /> size="300M" <br /> minfw="11.04.240" |
| Path to Executable | /custom/vlc/usr/bin/vlc |
| Path to Icon | /custom/vlc/usr/share/icons/hicolor/256x256/apps/vlc.png |
| Packaging Notes | Details can be found in the build script [build-vlc-cp.sh](build-vlc-cp.sh) |
| Package automation | [build-vlc-cp.sh](build-vlc-cp.sh) <br /><br /> This script will compile the latest version |
