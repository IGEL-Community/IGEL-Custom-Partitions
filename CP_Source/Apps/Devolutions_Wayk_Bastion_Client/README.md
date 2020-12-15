# Devolutions Wayk Bastion Client

|  CP Information |            |
|-----------------|------------|
| Package | Wayk Bastion Client - Current Version |
| Script Name | [waykclient-cp-init-script.sh](waykclient-cp-init-script.sh) |
| CP Mount Path | /custom/waykclient |
| CP Size | 50M |
| IGEL OS Version (min) | 11.4.130 |
| Metadata File <br /> waykclient.inf | [INFO] <br /> [PART] <br /> file="waykclient.tar.bz2" <br /> version="2020.03.2.0" <br /> size="50M" <br /> minfw="11.04.130" |
| Path to Executable | /custom/waykclient/usr/bin/wayk-client |
| Path to Icon | /custom/waykclient/usr/share/wayk-client/WaykClient.png |
| Missing Libraries | apt-get download libappindicator3-1 <br /> apt-get download libindicator3-7 <br /> apt-get download libdbusmenu-gtk3-4 <br /> apt-get download libdbusmenu-glib4 |
| Download package | Manually download ([LINK](https://wayk.devolutions.net/home/thankyou/waykclientlinuxbin)) latest package and place into ~/Downloads folder |
| Packaging Notes | Create folder: **waykclient** <br /><br /> dpkg -x <package/lib> custom/waykclient <br /><br /> Need to move the mime folder: <br /><br />mv /custom/waykclient/usr/share/applications /custom/waykclient/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/waykclient/config/bin/[waykclient_cp_apparmor_reload](waykclient_cp_apparmor_reload) <br /> /custom/waykclient/lib/systemd/system/[igel-waykclient-cp-apparmor-reload.service](igel-waykclient-cp-apparmor-reload.service) |
| Package automation | [build-waykclient-cp.sh](build-waykclient-cp.sh) <br /><br /> Tested with 2020.3.2.0 |
