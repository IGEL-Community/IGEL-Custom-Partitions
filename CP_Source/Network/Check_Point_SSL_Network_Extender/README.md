# Check Point SSL Network Extender (SNX)

|  CP Information |            |
|--------------------|------------|
| Package | [Check Point SSL Network Extender (SNX)](https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk65210&partition=Basic&product=SSL) - Current Version <br /><br /> SSL Network Extender is a secure connectivity framework for remote access to a corporate network. SSL Network Extender uses a thin VPN client installed on the user's remote computer that connects to an SSL-enabled web server. The web server and the client are in the same VPN. <br /><br /> [How to install SSL Network Extender (SNX) client on Linux machine](https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk114267) <br /><br /> [How to establish Client-to-Site VPN from a Linux machine to a locally managed SMB appliance](https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk116576)  |
| Script Name | [cpsnx-cp-init-script.sh](cpsnx-cp-init-script.sh) |
| CP Mount Path | /custom/cpsnx |
| CP Size | 20M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> cpsnx.inf | [INFO] <br /> [PART] <br /> file="cpsnx.tar.bz2" <br /> version="1.0.0" <br /> size="20M" <br /> name="cpsnx" <br /> minfw="11.04.240" |
| Path to Executable | /custom/cpsnx/usr/bin/snx |
| Path to Icon | N/A |
| Download package and missing libraries | See build script for missing 32bit libraries |
| Packaging Notes | See build script for steps to build |
| Package automation | [build-cpsnx-cp.sh](build-cpsnx-cp.sh) |
