# Microsoft Edge (18 September - BETA Channel)

|  CP Information |            |
|-----------------|------------|
| Package | [Microsoft Edge](https://www.microsoftedgeinsider.com/en-us/download?platform=linux-deb) - Current Stable Version <br /><br /> [Release notes for Microsoft Edge](https://docs.microsoft.com/en-us/deployedge/microsoft-edge-relnote-beta-channel) |
| Script Name | [edge-cp-init-script.sh](edge-cp-init-script.sh) |
| CP Mount Path | /custom/edge |
| CP Size | 600M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> edge.inf | [INFO] <br /> [PART] <br /> file="edge.tar.bz2" <br /> version="94.0.992.23" <br /> size="600M" <br /> name="edge" <br /> minfw="11.04.240" |
| Path to Executable | /custom/edge/usr/bin/microsoft-edge-beta |
| Path to Icon | /custom/edge/opt/microsoft/msedge-beta/product_logo_256_beta.png |
| Packaging Notes | See build script for details |
| Package automation | [build-edge-cp.sh](build-edge-cp.sh) <br /><br /> Tested with 94.0.992.23 |
