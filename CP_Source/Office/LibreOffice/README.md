# LibreOffice (7 February)

-----

**NOTE:** Builder works for OS11 (build with Ubuntu 22.04 - jammy) and OS12 (build with Ubuntu 20.04 - focal)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [LibreOffice](https://www.libreoffice.org) - Current Version <br /><br /> [Installing LibreOffice on Linux](https://wiki.documentfoundation.org/Documentation/Install/Linux) <br /><br /> [LibreOffice Help](https://help.libreoffice.org)|
| Script Name | [libreoffice-cp-init-script.sh](build/libreoffice-cp-init-script.sh) |
| Icon name | /custom/libreoffice/usr/share/icons/hicolor/256x256/apps/libreoffice25.2-main.png |
| Command | /custom/libreoffice/opt/libreoffice25.2/program/soffice |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-libreoffice-cp.sh](build/build-libreoffice-cp.sh) |

-----

**NOTES**

- The **version number is embedded in path** (currently 25.2) and references to 25.2 will need to be modified if using a different version.

-----

**NOTES OS11**

- For Help to open files in browser, you will need to enable Firefox browser, allow the browser to read files on the filesystem **Sessions > Firefox Browser > Firefox Browser Global > Security > Hide local filesystem (disable / false)**, and disable **system.security.apparmor**. A reboot is needed **before** the apparmor change is in effect.

-----

**NOTES OS12**

- For certain features of the software - but not most - Java is required. Java is notably required for Base.

- Java can be installed with [IGEL App Portal: Java Runtime Environment 17](https://app.igel.com/java17)

- A browser will need to be installed for viewing help files.
