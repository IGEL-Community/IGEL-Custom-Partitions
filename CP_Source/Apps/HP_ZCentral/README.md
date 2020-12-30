# HP ZCentral Remote Boost

|  CP Information |            |
|--------------------|------------|
| Package | HP ZCentral Remote Boost - Current Version |
| Script Name | [hpzcentral-cp-init-script.sh](hpzcentral-cp-init-script.sh) |
| CP Mount Path | /custom/hpzcentral |
| CP Size | 100M |
| IGEL OS Version (min) | 11.4.200 |
| Metadata File <br /> hpzcentral.inf | [INFO] <br /> [PART] <br /> file="hpzcentral.tar.bz2" <br /> version="1.3.00.30857" <br /> size="100M" <br /> name="hpzcentral" <br /> minfw="11.04.200" |
| Path to Executable | /custom/hpzcentral/usr/bin/hpzcentral |
| Path to Icon | /custom/hpzcentral/usr/share/pixmaps/hpzcentral.png |
| Missing Libraries | TBD |
| Download package | Obtain from client |
| Packaging Notes | Create folder: **hpzcentral** <br /><br /> dpkg -x <package/lib> custom/hpzcentral <br /><br /> Need to move the mime folder: <br /><br />mv /custom/hpzcentral/usr/share/applications /custom/hpzcentral/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/hpzcentral/config/bin/[hpzcentral_cp_apparmor_reload](hpzcentral_cp_apparmor_reload) <br /> /custom/hpzcentral/lib/systemd/system/[igel-hpzcentral-cp-apparmor-reload.service](igel-hpzcentral-cp-apparmor-reload.service) |
| Package automation | [build-hpzcentral-cp.sh](build-hpzcentral-cp.sh) |
