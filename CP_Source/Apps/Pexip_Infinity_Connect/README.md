# Pexip Infinity Connect

|  CP Information |            |
|--------------------|------------|
| Package | [Pexip Infinity Connect](https://www.pexip.com/) - Current Version |
| Script Name | [pexip-cp-init-script.sh](pexip-cp-init-script.sh) |
| CP Mount Path | /custom/pexip |
| CP Size | 500M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> pexip.inf | [INFO] <br /> [PART] <br /> file="pexip.tar.bz2" <br /> version="1.6.2" <br /> size="250M" <br /> name="pexip" <br /> minfw="11.04.240" |
| Path to Executable | /custom/pexip/usr/lib/pexip-infinity-connect_linux-x64/pexip-infinity-connect |
| Path to Icon | /custom/pexip/usr/lib/pexip-infinity-connect_linux-x64/resources/vendor/snoreToast/app-notifier.png |
| Missing Libraries | None |
| Download package and missing library | Download for Linux (debian) https://www.pexip.com/apps |
| Packaging Notes | Create folder: **pexip** <br /><br /> dpkg -x pexip_* custom/pexip <br /><br /> Need to move the mime folder: <br /><br />mv /custom/pexip/usr/share/applications /custom/pexip/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/pexip/config/bin/[pexip_cp_apparmor_reload](pexip_cp_apparmor_reload) <br /> /custom/pexip/lib/systemd/system/[igel-pexip-cp-apparmor-reload.service](igel-pexip-cp-apparmor-reload.service) |
| Package automation | [build-pexip-cp.sh](build-pexip-cp.sh) <br /><br /> Tested with 1.6.2 |
