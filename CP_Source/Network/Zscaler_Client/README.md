# Zscaler Client (1 September)

|  CP Information |            |
|-----------------|------------|
| Package | [Zscaler Client Connector](https://help.zscaler.com/z-app/what-zscaler-app) <br /><br /> [Customizing Zscaler Client Connector with Install Options for Linux](https://help.zscaler.com/client-connector/customizing-zscaler-client-connector-install-options-linux) |
| Script Name | [zscaler-cp-init-script.sh](build/zscaler-cp-init-script.sh) |
| CP Mount Path | /custom/zscaler |
| CP Size | 500M |
| IGEL OS Version (min) | 11.07.100 |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-zscaler-cp.sh](build/build-zscaler-cp.sh) <br /><br /> This script will build the latest version based on Ubuntu 18.04 |


**Note [1]:** Use the [/custom/zscaler/opt/zscaler/scripts/zscaler-config](https://help.zscaler.com/client-connector/customizing-zscaler-client-connector-install-options-linux#Silent) script to edit the /custom/zscaler/opt/zscaler/.config.ini file.

**Note [2]:** A reboot is required after CP is deployed.

-----

[Zero Trust Networking](https://igel-community.github.io/IGEL-Docs-v02/Docs/HOWTO-Zero-Trust-Networking/)