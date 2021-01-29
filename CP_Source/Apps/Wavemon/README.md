# Wavemon (Draft build / testing)

|  CP Information |            |
|--------------------|------------|
| Package | [Wavemon](https://github.com/uoaerg/wavemon) - Current Version <br /><br /> Wavemon is a wireless device monitoring application that allows you to watch signal and noise levels, packet statistics, device configuration and network parameters of your wireless network hardware.|
| Script Name | [wavemon-cp-init-script.sh](wavemon-cp-init-script.sh) |
| CP Mount Path | /custom/wavemon |
| CP Size | 10M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> wavemon.inf | [INFO] <br /> [PART] <br /> file="wavemon.tar.bz2" <br /> version="0.8.1" <br /> size="10M" <br /> name="wavemon" <br /> minfw="11.04.240" |
| Path to Executable | xterm -e '/usr/bin/wavemon' |
| Path to Icon | applications-other |
| Missing Libraries | None |
| Download package and missing library | apt-get download wavemon |
| Packaging Notes | Create folder: **wavemon** <br /><br /> dpkg -x <package/lib> custom/wavemon |
| Package automation | [build-wavemon-cp.sh](build-wavemon-cp.sh) <br /><br /> Tested with 0.8.1 |
