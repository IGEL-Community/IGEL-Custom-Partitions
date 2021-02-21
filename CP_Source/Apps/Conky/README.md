# Conky

|  CP Information |            |
|--------------------|------------|
| Package | [Conky](https://github.com/brndnmtthws/conky) - Current Version <br /><br /> Conky is a free, light-weight system monitor for X, that displays any kind of information on your desktop. |
| Script Name | [conky-cp-init-script.sh](conky-cp-init-script.sh) |
| CP Mount Path | /custom/conky |
| CP Size | 20M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> conky.inf | [INFO] <br /> [PART] <br /> file="conky.tar.bz2" <br /> version="1.10.8" <br /> size="20M" <br /> name="conky" <br /> minfw="11.04.240" |
| Path to Executable | /custom/conky/usr/bin/conky |
| Path to Icon | N/A |
| Download package and missing libraries | apt-get download conky <br /> apt-get download conky-std <br /> apt-get download libgif7 <br /> apt-get download libid3tag0 <br /> apt-get download libimlib2 <br /> apt-get download liblua5.1-0 |
| Packaging Notes | Create folder: **conky** <br /><br /> dpkg -x <package/lib> custom/conky |
| Package automation | [build-conky-cp.sh](build-conky-cp.sh) <br /><br /> Tested with 1.10.8 |

![Screenshot Conky](screenshot_conky.png)
