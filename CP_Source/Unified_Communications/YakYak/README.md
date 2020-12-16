# YakYak

|  CP Information |            |
|-----------------|------------|
| Package | YakYak - Current Version |
| Script Name | [yakyak-cp-init-script.sh](yakyak-cp-init-script.sh) |
| CP Mount Path | /custom/yakyak |
| CP Size | 350M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> yakyak.inf | [INFO] <br /> [PART] <br /> file="yakyak.tar.bz2" <br /> version="1.5.10" <br /> size="350M" <br /> minfw="11.03.110" |
| Path to Executable | /custom/yakyak/usr/bin/yakyak |
| Path to Icon | /custom/yakyak/usr/share/icons/hicolor/256x256/apps/yakyak.png |
| Missing Libraries | None |
| Download package | Manually download yakyak-LatestVersion-linux-amd64.deb ([LINK](https://github.com/yakyak/yakyak/releases/latest)) package and place into ~/Downloads folder |
| Packaging Notes | Create folder: **yakyak** <br /><br /> dpkg -x <package/lib> custom/yakyak <br /><br /> Need to move the mime folder: <br /><br />mv /custom/yakyak/usr/share/applications /custom/yakyak/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/yakyak/config/bin/[yakyak_cp_apparmor_reload](yakyak_cp_apparmor_reload) <br /> /custom/yakyak/lib/systemd/system/[igel-yakyak-cp-apparmor-reload.service](igel-yakyak-cp-apparmor-reload.service) |
| Package automation | [build-yakyak-cp.sh](build-yakyak-cp.sh) <br /><br /> Tested with 1.5.10 |
