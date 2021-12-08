# CrowdStrike Falcon (7 December)

|  CP Information |            |
|--------------------|------------|
| Package | [CrowdStrike Falcon Agent](https://www.crowdstrike.com/blog/tech-center/install-falcon-sensor-for-linux/) - Current Version |
| Script Name | [falcon-cp-init-script.sh](build/falcon-cp-init-script.sh) |
| CP Mount Path | /custom/falcon |
| CP Size | 100M |
| IGEL OS Version (min) | 11.05.133 |
| Download package | [Follow these steps to download installer and CID](https://www.crowdstrike.com/blog/tech-center/install-falcon-sensor-for-linux/) |
| Packaging Notes | See build script for details |
| Package automation | [build-falcon-cp.sh](build/build-falcon-cp.sh) |

**NOTES:**

- A reboot is required before the service can start.

- Copy your Customer ID Checksum (CID), displayed on Sensor Downloads and update the profile custom command to replace [CID]:

[falcon-profile.xml -- custom_cmd_x11_final](igel/falcon-profile.xml)

```
/custom/falcon/opt/CrowdStrike/falconctl -s --cid=[CID]
   ```
