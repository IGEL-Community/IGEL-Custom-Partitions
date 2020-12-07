# Devolutions Remote Desktop Manager Free

|  CP Information |            |
|-----------------|------------|
| Package | RDM Free - Current Version |
| Script Name | [rdm-cp-init-script.sh](rdm-cp-init-script.sh) |
| CP Mount Path | /custom/rdm |
| CP Size | 250M |
| IGEL OS Version (min) | 11.4.130 |
| Metadata File <br /> rdm.inf | [INFO] <br /> [PART] <br /> file="rdm.tar.bz2" <br /> version="2020.03.1.0" <br /> size="250M" <br /> minfw="11.04.130" |
| Path to Executable | /custom/rdm/bin/remotedesktopmanager.free |
| Path to Icon | /custom/rdm/usr/share/icons/remotedesktopmanager.free.png |
| Missing Libraries | NONE |
| Download package | Manually download ([LINK](https://remotedesktopmanager.com/home/thankyou/rdmlinuxfreebin)) latest package and place into the same folder as the [build-rdm-cp.sh](build-rdm-cp.sh) script |
| Packaging Notes | Create folder: **rdm** <br /><br /> dpkg -x <package/lib> custom/rdm <br /><br /> Need to move the mime folder: <br /><br />mv /custom/rdm/usr/share/applications /custom/rdm/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/rdm/config/bin/[rdm_cp_apparmor_reload](rdm_cp_apparmor_reload) <br /> /custom/rdm/lib/systemd/system/[igel-rdm-cp-apparmor-reload.service](igel-rdm-cp-apparmor-reload.service) |
| Package automation | [build-rdm-cp.sh](build-rdm-cp.sh) <br /><br /> Tested with 2020.3.1.0 |
