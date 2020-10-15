# Microsoft Teams

|  CP Information |            |
|--------------------|------------|
| Package | Microsoft Teams 1.3.00.25560 |
| Script Name | [teams-cp-init-script.sh](teams-cp-init-script.sh) |
| CP Mount Path | /custom/teams |
| CP Size | 300M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> teams-1.3.00.25560.inf | [INFO] <br /> [PART] <br /> file="teams_amd64_1.3.00.25560.tar.bz2" <br /> version="1.3.00.25560" <br /> size="300M" <br /> name="teams" <br /> minfw="11.03.110" |
| Path to Executable | /custom/teams/usr/bin/teams [--proxy-server=http://proxy-host:proxy-port]|
| Path to Icon | /custom/teams/usr/share/pixmaps/teams.png |
| Missing Libraries | [libgnome-keyring.so.0](https://packages.ubuntu.com/bionic/libgnome-keyring0) |
| Packaging Notes | Need to move the mime folder: <br /><br />mv /custom/teams/usr/share/applications /custom/teams/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/teams/config/bin/[teams_cp_apparmor_reload](teams_cp_apparmor_reload) <br /> /custom/teams/lib/systemd/system/[igel-teams-cp-apparmor-reload.service](igel-teams-cp-apparmor-reload.service) |

**NOTE:**

To use Teams over a proxy server append the following to Path to Executable:

```{use proxy server}
--proxy-server=http://proxy-host:proxy-port
  ```
