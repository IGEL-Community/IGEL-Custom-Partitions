# Signal

|  CP Information |            |
|--------------------|------------|
| Package | [Signal](https://www.signal.org) - Current Version |
| Script Name | [signal-cp-init-script.sh](signal-cp-init-script.sh) |
| CP Mount Path | /custom/signal |
| CP Size | 500M |
| IGEL OS Version (min) | 11.4.200 |
| Metadata File <br /> signal.inf | [INFO] <br /> [PART] <br /> file="signal.tar.bz2" <br /> version="1.39.4" <br /> size="500M" <br /> name="signal" <br /> minfw="11.04.200" |
| Path to Executable | /custom/signal/opt/Signal/signal-desktop |
| Path to Icon | /custom/signal/usr/share/icons/hicolor/256x256/apps/signal-desktop.png |
| Download package and missing library | apt-get download signal-desktop <br /> apt-get download libappindicator1 <br /> apt-get download libindicator7 |
| Packaging Notes | Create folder: **signal** <br /><br /> dpkg -x <package/lib> custom/signal <br /><br /> Need to move the mime folder: <br /><br />mv /custom/signal/usr/share/applications /custom/signal/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/signal/config/bin/[signal_cp_apparmor_reload](signal_cp_apparmor_reload) <br /> /custom/signal/lib/systemd/system/[igel-signal-cp-apparmor-reload.service](igel-signal-cp-apparmor-reload.service) |
| Package automation | [build-signal-cp.sh](build-signal-cp.sh) <br /><br /> Tested with 1.39.4 |
