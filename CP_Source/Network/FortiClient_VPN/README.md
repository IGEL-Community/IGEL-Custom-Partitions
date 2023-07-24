# FortiClient VPN (13 July 2023)

-----

## FortiClient GUI Issue

**NOTE:** FortiClient blank screen on start-up. The window opens with no text. Looking into the issue.

**WORKAROUND:** Run from the command line `/custom/forticlient/opt/forticlient/forticlient-cli vpn --help`

-----

|  CP Information |            |
|-----------------|------------|
| Package | [FortiClient VPN](https://www.fortinet.com/support/product-downloads/linux) |
| Script Name | [forticlient-cp-init-script.sh](build/forticlient-cp-init-script.sh) |
| CP Mount Path | /custom/forticlient |
| CP Size | 800M |
| IGEL OS Version (min) | 11.08.230 |
| Packaging Notes | Details can be found in the build script [build-forticlient-cp.sh](build/build-forticlient-cp.sh) |

-----

**Note:** Two reboots are required after CP assigned. First reboot is to install the CP and the second reboot to start FortiClient tray launcher.

-----

[IGEL Community Note on VPN](https://igel-community.github.io/IGEL-Docs-v02/Docs/HOWTO-VPN)