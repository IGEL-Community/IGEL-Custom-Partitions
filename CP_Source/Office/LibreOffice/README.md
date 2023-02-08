# LibreOffice (22 August)

|  CP Information |            |
|--------------------|------------|
| Package | [LibreOffice](https://www.libreoffice.org) - Current Version <br /><br /> [Installing LibreOffice on Linux](https://wiki.documentfoundation.org/Documentation/Install/Linux) <br /><br /> [LibreOffice Help](https://help.libreoffice.org)|
| CP Mount Path | /custom/libreoffice |
| CP Size | 900M |
| IGEL OS Version (min) | 11.05.133 |
| Packaging Notes | See build script for details. |
| Package automation | [build-libreoffice-cp.sh](build/build-libreoffice-cp.sh) <br /><br /> Tested with 7.5.X |

**NOTES**

- For Help to open files in browser, you will need to enable Firefox browser, allow the browser to read files on the filesystem **Sessions > Firefox Browser > Firefox Browser Global > Security > Hide local filesystem (disable / false)**, and disable **system.security.apparmor**. A reboot is needed **before** the apparmor change is in effect.

- The **version number is embedded in path** (currently 7.5) and references to 7.5 will need to be modified if using a different version.
