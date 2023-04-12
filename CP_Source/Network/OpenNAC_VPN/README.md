# OpenNAC VPN (12 April)

-----

**NOTE:** Builder works for OS11 (build with Ubuntu 18.04 - bionic) and **pending** OS12 (build with Ubuntu 20.04 - focal)

-----

**NOTE:** CP in development and pending final testing.

-----

|  CP Information |            |
|-----------------|------------|
| Package | [OpenNAC VPN](https://opencloudfactory.com/en/opennac-enterprise/) <br /><br /> OpenNAC Enterprise - The OpenNAC Enterprise network access control (NAC) solution is an internationally renowned solution to increase network security via visibility, control and compliance of all the devices connected to the company network. |
| Script Name | [opennac-cp-init-script.sh](build/opennac-cp-init-script.sh) |
| Icon name | /custom/opennac/opt/opencloudfactory/opencloudfactory.agent.ui/OpenNacAgent.png |
| Command | env OPENCLOUD_AGENT_ENVIRONMENT=production OPENCLOUD_AGENT_EXECUTION_MODE=service OPENCLOUD_AGENT_PRODUCT_NAME="OpenNAC Agent" OPENCLOUD_AGENT_UI_NAME="OpenNAC UI Console" OPENCLOUD_AGENT_SERVICE_NAME="OpenNACService" OPENCLOUD_AGENT_GLOBALIZATION_CUSTOM_COUNTRY="False" /custom/opennac/opt/opencloudfactory/opencloudfactory.agent.ui/OpenCloudFactory.Agent.UI |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-opennac-cp.sh](build/build-opennac-cp.sh) |

-----

**NOTE:** The postinst script from init script requires the following file in /wfs

- Need to add the file, agentInstallationPackageFileName, as a UMS file download into /wfs
