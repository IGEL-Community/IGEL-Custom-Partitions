# LibreOffice (DRAFT Build)

|  CP Information |            |
|--------------------|------------|
| Package | [LibreOffice](https://www.libreoffice.org) - Current Version <br /><br /> [Installing LibreOffice on Linux](https://wiki.documentfoundation.org/Documentation/Install/Linux) <br /><br /> [LibreOffice Help](https://help.libreoffice.org)|
| Script Name | [libreoffice-cp-init-script.sh](libreoffice-cp-init-script.sh) |
| CP Mount Path | /custom/libreoffice |
| CP Size | 900M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> libreoffice.inf | [INFO] <br /> [PART] <br /> file="libreoffice.tar.bz2" <br /> version="7.0.4" <br /> size="900M" <br /> name="libreoffice" <br /> minfw="11.04.240" |
| Path to Executable | /custom/libreoffice/opt/libreoffice7.0/program/soffice |
| Path to Icon | /custom/libreoffice/usr/share/icons/hicolor/256x256/apps/libreoffice7.0-main.png |
| Missing Libraries | None |
| Download package and missing library | Download for Linux (debian) https://www.libreoffice.com/apps |
| Packaging Notes | Create folder: **libreoffice** <br /><br /> dpkg -x lib* custom/libreoffice <br /><br /> Need to move the mime folder: <br /><br />mv /custom/libreoffice/usr/share/applications /custom/libreoffice/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/libreoffice/config/bin/[libreoffice_cp_apparmor_reload](libreoffice_cp_apparmor_reload) <br /> /custom/libreoffice/lib/systemd/system/[igel-libreoffice-cp-apparmor-reload.service](igel-libreoffice-cp-apparmor-reload.service) |
| Package automation | [build-libreoffice-cp.sh](build-libreoffice-cp.sh) <br /><br /> Tested with 7.0.4 |
