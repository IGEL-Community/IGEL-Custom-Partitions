# Microsoft Edge (BETA Channel)

|  CP Information |            |
|-----------------|------------|
| Package | [Microsoft Edge](https://www.microsoftedgeinsider.com/en-us/download?platform=linux-deb) - Current Stable Version |
| Script Name | [edge-cp-init-script.sh](edge-cp-init-script.sh) |
| CP Mount Path | /custom/edge |
| CP Size | 600M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> edge.inf | [INFO] <br /> [PART] <br /> file="edge.tar.bz2" <br /> version="90.0.810.1" <br /> size="600M" <br /> name="edge" <br /> minfw="11.04.240" |
| Path to Executable | /custom/edge/usr/bin/microsoft-edge-beta |
| Path to Icon | /custom/edge/opt/microsoft/msedge-beta/product_logo_256_beta.png |
| Missing Libraries | None |
| Download package and missing library | apt-get download microsoft-edge-beta <br /> apt-get download libatomic1 |
| Packaging Notes | Create folder: **edge** <br /><br /> dpkg -x <package/lib> custom/edge <br /><br /> Need to move the mime folder: <br /><br />mv /custom/edge/usr/share/applications /custom/edge/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/edge/config/bin/[edge_cp_apparmor_reload](edge_cp_apparmor_reload) <br /> /custom/edge/lib/systemd/system/[igel-edge-cp-apparmor-reload.service](igel-edge-cp-apparmor-reload.service) |
| Package automation | [build-edge-cp.sh](build-edge-cp.sh) <br /><br /> Tested with 91.0.864.15
