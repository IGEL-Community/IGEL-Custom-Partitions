# Steam (DRAFT Package for Testing)

|  CP Information |            |
|--------------------|------------|
| Package | Steam - [Current Version](https://store.steampowered.com/about)
| Script Name | [steam-cp-init-script.sh](steam-cp-init-script.sh) |
| CP Mount Path | /custom/steam |
| CP Size | 3000M |
| IGEL OS Version (min) | 11.04.240 |
| Metadata File <br /> steam.inf | [INFO] <br /> [PART] <br /> file="steam.tar.bz2" <br /> version="1.0.0.68" <br /> size="3000M" <br /> name="steam" <br /> minfw="11.04.240" |
| Path to Executable | /custom/steam/usr/bin/steam |
| Path to Icon | /custom/steam/usr/share/icons/hicolor/256x256/apps/steam.png |
| Missing Libraries | See build script for details |
| Download package and missing library | See build script for details |
| Packaging Notes | Create folder: **steam** <br /><br /> dpkg -x <package/lib> custom/steam |
| Package automation | [build-steam-cp.sh](build-steam-cp.sh) <br /><br /> Tested with 1.0.0.68 |

**NOTE:** Games are large and an external disk may be needed.

![Steam](Steam.png)
