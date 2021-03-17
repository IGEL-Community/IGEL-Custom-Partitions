# BlueJeans

|  CP Information |            |
|-----------------|------------|
| Package | BlueJeans - [Current Version](https://www.bluejeans.com/downloads) |
| Script Name | [bluejeans-cp-init-script.sh](bluejeans-cp-init-script.sh) |
| CP Mount Path | /custom/bluejeans |
| CP Size | 800M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> bluejeans.inf | [INFO] <br /> [PART] <br /> file="bluejeans.tar.bz2" <br /> version="2.21.2.1" <br /> size="800M" <br /> minfw="11.04.240" |
| Path to Executable | /custom/bluejeans/usr/bin/bluejeans |
| Path to Icon | /custom/bluejeans/usr/share/pixmaps/bluejeans.png |
| Missing Libraries | None |
| Download package | Manually download .deb (64-Bit) ([LINK](https://www.bluejeans.com/downloads)) latest package and place into ~/Downloads folder |
| Packaging notes | Create folder: **bluejeans** <br /><br /> dpkg -x <package/lib> custom/bluejeans <br /><br /> Need to move the mime folder: <br /><br />mv /custom/bluejeans/usr/share/applications /custom/bluejeans/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/bluejeans/config/bin/[bluejeans_cp_apparmor_reload](bluejeans_cp_apparmor_reload) <br /> /custom/bluejeans/lib/systemd/system/[igel-bluejeans-cp-apparmor-reload.service](igel-bluejeans-cp-apparmor-reload.service) |
| Package automation | [build-bluejeans-cp.sh](build-bluejeans-cp.sh) <br /><br /> Tested with 2.21.2.1 |
