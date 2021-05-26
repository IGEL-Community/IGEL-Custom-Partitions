# Wireshark (25 May)

|  CP Information |            |
|-----------------|------------|
| Package | [Wireshark](https://www.wireshark.org/) is the world’s foremost and widely-used network protocol analyzer. It lets you see what’s happening on your network at a microscopic level and is the de facto (and often de jure) standard across many commercial and non-profit enterprises, government agencies, and educational institutions
| Script Name | [wireshark-cp-init-script.sh](wireshark-cp-init-script.sh) |
| CP Mount Path | /custom/wireshark |
| CP Size | 300M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> wireshark.inf | [INFO] <br /> [PART] <br /> file="wireshark.tar.bz2" <br /> version="2.6.10" <br /> size="300M" <br /> minfw="11.04.240" |
| Path to Executable (open terminal window and run as root)| /custom/wireshark/usr/bin/wireshark |
| Packaging Notes | Details can be found in the build script [build-wireshark-cp.sh](build-wireshark-cp.sh) |
| Package automation | [build-wireshark-cp.sh](build-wireshark-cp.sh) <br /><br /> This script will build latest version based on Ubuntu 18.04 |
