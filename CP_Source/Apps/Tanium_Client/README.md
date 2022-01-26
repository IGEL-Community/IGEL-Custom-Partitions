# Tanium Client (26 January) (Debug testing - not functional)

|  CP Information |            |
|--------------------|------------|
| Package | [Tanium Client](https://docs.tanium.com/client/client/deployment.html#linux_client) - Current Version |
| Script Name | [tanium-cp-init-script.sh](build/tanium-cp-init-script.sh) |
| CP Mount Path | /custom/tanium |
| CP Size | 100M |
| IGEL OS Version (min) | 11.05.133 |
| Download package | [Follow these steps to download installer and tanium-init.dat](https://docs.tanium.com/client/client/deployment.html#linux_client) |
| Packaging Notes | See build script for details |
| Package automation | [build-tanium-cp.sh](build/build-tanium-cp.sh) |

**NOTES:**

- A reboot is required before the service can start.

-----

## Add Tanium Client Varibles to IGEL Profile
### (System > Firmware Customization > Environment Variables > Predefined)

#### TANIUM_VERSION (set via build CP process)
#### TANIUM_SERVERNAME (see your configuration tanium‑init.dat)
#### TANIUM_SERVERPORT (default is 17474)
#### TANIUM_LOGVERBOSITYLEVEL (default is 1)
