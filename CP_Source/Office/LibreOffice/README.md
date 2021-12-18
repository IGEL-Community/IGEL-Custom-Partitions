# LibreOffice (18 December)

|  CP Information |            |
|--------------------|------------|
| Package | [LibreOffice](https://www.libreoffice.org) - Current Version <br /><br /> [Installing LibreOffice on Linux](https://wiki.documentfoundation.org/Documentation/Install/Linux) <br /><br /> [LibreOffice Help](https://help.libreoffice.org)|
| CP Mount Path | /custom/libreoffice |
| CP Size | 900M |
| IGEL OS Version (min) | 11.05.133 |
| Path to Executable | /custom/libreoffice/opt/libreoffice7.2/program/soffice |
| Path to Icon | /custom/libreoffice/usr/share/icons/hicolor/256x256/apps/libreoffice7.2-main.png |
| Packaging Notes | See build script for details. |
| Package automation | [build-libreoffice-cp.sh](build/build-libreoffice-cp.sh) <br /><br /> Tested with 7.2.X |

**NOTES**

- For Help to open files in browser, you will need to enable browser (such as Firefox), allow the browser to read files on the filesystem, and disable **system.security.apparmor**.

- The **version number is embedded in path** (currently 7.2) and references to 7.2 will need to be modified when 7.3 or later versions are released!
