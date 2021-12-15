# ConnectWise Control Client (15 December) (in testing)

|  CP Information |            |
|--------------------|------------|
| Package | [ConnectWise Control Client](https://docs.connectwise.com/ConnectWise_Control_Documentation/Get_started/Host_page/Build_an_access_agent_installer) - Current Version |
| Script Name | [cwc_client-cp-init-script.sh](build/cwc_client-cp-init-script.sh) |
| CP Mount Path | /custom/cwc_client |
| CP Size | 20M |
| IGEL OS Version (min) | 11.05.133 |
| Download package | [Follow these steps to download client and save to Downloads folder on Ubuntu 18.04 build VM](https://docs.connectwise.com/ConnectWise_Control_Documentation/Get_started/Host_page/Build_an_access_agent_installer) |
| Packaging Notes | See build script for details |
| Package automation | [build-cwc_client-cp.sh](build/build-cwc_client-cp.sh) |

**NOTES:**

- A reboot is required before the agent can start.

[userinterface.rccustom.custom_cmd_x11_final](igel/cwc_client-profile.xml)

```
chmod a+x /custom/cwc_client/etc/init.d/connectwisecontrol*
/custom/cwc_client/etc/init.d/connectwisecontrol* start &
   ```
