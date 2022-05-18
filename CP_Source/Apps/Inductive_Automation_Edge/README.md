# Inductive Automation Edge (18 May)

|  CP Information |            |
|-----------------|------------|
| Package | [Inductive Automation Edge](https://inductiveautomation.com/ignition/edge) <br /> Ignition Edge by Inductive Automation® is a line of limited, lightweight Ignition software solutions designed specifically for devices used in the field and OEM devices at the edge of the network. |
| Script Name | [iaedge-cp-init-script.sh](build/iaedge-cp-init-script.sh) |
| CP Mount Path | /custom/iaedge |
| CP Size | 2500M <br/> **NOTE: Very large CP** |
| IGEL OS Version (min) | 11.05.133 |
| Packaging Notes | See build script |
| Package automation | [build-iaedge-cp.sh](build/build-iaedge-cp.sh) |

**NOTES:**

- A reboot is required after CP deployed to allow for ignition to be started.

-----

[userinterface.rccustom.custom_cmd_x11_final](igel/thousandeyes-profile.xml)

```
/usr/local/bin/ignition/ignition.sh start
   ```
