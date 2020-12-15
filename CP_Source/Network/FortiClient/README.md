# FortiClient

|  CP Information |            |
|--------------------|------------|
| Package | FortiClient - Current Version |
| Script Name | [forticlient-cp-init-script.sh](forticlient-cp-init-script.sh) |
| CP Mount Path | /custom/forticlient |
| CP Size | 400M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> forticlient.inf | [INFO] <br /> [PART] <br /> file="forticlient.tar.bz2" <br /> version="1.3.00.30857" <br /> size="400M" <br /> name="forticlient" <br /> minfw="11.03.110" |
| Path to Executable | /custom/forticlient/opt/forticlient/gui/FortiClient-linux-x64/FortiClient |
| Path to Icon | /custom/forticlient/usr/share/icons/hicolor/256x256/apps/forticlient.png |
| Download package and missing library | apt-get download forticlient <br /> apt-get download libindicator7 <br /> apt-get download libappindicator1 |
| Packaging Notes | Create folder: **forticlient** <br /><br /> dpkg -x <package/lib> custom/forticlient <br /><br /> Need to move the mime folder: <br /><br />mv /custom/forticlient/usr/share/applications /custom/forticlient/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/forticlient/config/bin/[forticlient_cp_apparmor_reload](forticlient_cp_apparmor_reload) <br /> /custom/forticlient/lib/systemd/system/[igel-forticlient-cp-apparmor-reload.service](igel-forticlient-cp-apparmor-reload.service) |
| Package automation | [build-forticlient-cp.sh](build-forticlient-cp.sh) <br /><br /> Tested with 6.4.1.0895 |
