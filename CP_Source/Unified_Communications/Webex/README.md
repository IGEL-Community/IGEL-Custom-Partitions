# Cisco Webex (11 May DRAFT)

|  CP Information |            |
|-----------------|------------|
| Package | [Cisco Webex Client for Linux](https://help.webex.com/en-us/9vstcdb/Webex-for-Linux) All the core Webex capabilities in a single app are supported to help you seamlessly collaborate. This is just the beginning; support for advanced calling and a full-featured meeting experience will be added in upcoming releases. |
| Script Name | [webex-cp-init-script.sh](webex-cp-init-script.sh) |
| CP Mount Path | /custom/webex |
| CP Size | 900M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> webex.inf | [INFO] <br /> [PART] <br /> file="webex.tar.bz2" <br /> version="41.5.0.18815" <br /> size="900M" <br /> minfw="11.04.240" |
| Path to Executable | /custom/webex/opt/Webex/bin/CiscoCollabHost |
| Path to Icon | /opt/Webex/bin/sparklogosmall.png |
| Packaging Notes | Details can be found in the build script [build-webex-cp.sh](build-webex-cp.sh) |
| Package automation | [build-webex-cp.sh](build-webex-cp.sh) <br /><br /> This script will build the latest version based on Ubuntu 18.04 |
