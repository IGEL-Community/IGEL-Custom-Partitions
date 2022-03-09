# LibreOffice (9 March)

|  CP Information |            |
|--------------------|------------|
| Package | [LibreOffice](https://www.libreoffice.org) - Current Version <br /><br /> [Installing LibreOffice on Linux](https://wiki.documentfoundation.org/Documentation/Install/Linux) <br /><br /> [LibreOffice Help](https://help.libreoffice.org)|
| CP Mount Path | /custom/libreoffice |
| CP Size | 900M |
| IGEL OS Version (min) | 11.05.133 |
| Packaging Notes | See build script for details. |
| Package automation | [build-libreoffice-cp.sh](build/build-libreoffice-cp.sh) <br /><br /> Tested with 7.3.X |

**NOTES**

- For Help to open files in browser, you will need to enable browser (such as Firefox), allow the browser to read files on the filesystem, and disable **system.security.apparmor**.

- The **version number is embedded in path** (currently 7.3) and references to 7.3 will need to be modified when 7.4 or later versions are released!
