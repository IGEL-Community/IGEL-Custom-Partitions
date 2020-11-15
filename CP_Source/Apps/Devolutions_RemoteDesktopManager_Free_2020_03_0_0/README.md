# Devolutions Remote Desktop Manager Free

|  CP Information |            |
|--------------------|------------|
| Package | RDM Free 2020.03.0.0 <br /> [Download RDM Free](https://remotedesktopmanager.com/home/downloadfree)
| Script Name | [rdm-cp-init-script.sh](rdm-cp-init-script.sh) |
| CP Mount Path | /custom/rdm |
| CP Size | 250M |
| IGEL OS Version (min) | 11.4.130 |
| Metadata File <br /> rdm-2020.03.0.0.inf | [INFO] <br /> [PART] <br /> file="rdm_amd64_2020.03.0.0.tar.bz2" <br /> version="2020.03.0.0" <br /> size="200M" <br /> minfw="11.04.130" |
| Path to Executable | /custom/rdm/bin/remotedesktopmanager.free |
| Path to Icon | /custom/rdm/usr/share/icons/remotedesktopmanager.free.png |
| Missing Libraries | NONE |
| Packaging Notes | Need to move the mime folder: <br /><br />mv /custom/rdm/usr/share/applications /custom/rdm/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/rdm/config/bin/[rdm_cp_apparmor_reload](rdm_cp_apparmor_reload) <br /> /custom/rdm/lib/systemd/system/[igel-rdm-cp-apparmor-reload.service](igel-rdm-cp-apparmor-reload.service) |
