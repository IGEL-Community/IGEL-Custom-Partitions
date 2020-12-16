# Magnus Screen Magnifier

|  CP Information |            |
|-----------------|--------------|
| Package | Magnus - Current Version |
| Script Name | [magnus-cp-init-script.sh](magnus-cp-init-script.sh) |
| CP Mount Path | /custom/magnus |
| CP Size | 10M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> magnus.inf | [INFO] <br /> [PART] <br /> file="magnus.tar.bz2" <br /> version="1.0.2-1" <br /> size="10M" <br /> name="magnus" <br /> minfw="11.03.110" |
| Path to Executable | /usr/bin/magnus |
| Path to Icon | applications-other |
| Missing Libraries | gir1.2-keybinder-3.0 <br /> libkeybinder-3.0-0 <br /> python3-setproctitle |
| Download package and missing libraries | apt-get download magnus <br /> apt-get download gir1.2-keybinder-3.0 <br /> apt-get download libkeybinder-3.0-0 <br /> apt-get download python3-setproctitle |
| Packaging Notes | Create folder: **magnus** <br /><br /> dpkg -x <package/lib> custom/magnus <br /><br /> Need to move the mime folder: <br /><br />mv /custom/magnus/usr/share/applications /custom/magnus/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/magnus/config/bin/[magnus_cp_apparmor_reload](magnus_cp_apparmor_reload) <br /> /custom/magnus/lib/systemd/system/[igel-magnus-cp-apparmor-reload.service](igel-magnus-cp-apparmor-reload.service) |
| Package automation | [build-magnus-cp.sh](build-magnus-cp.sh) <br /><br /> Tested with 1.0.2-1 |
