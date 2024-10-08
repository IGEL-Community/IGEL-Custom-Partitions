# CrowdStrike Falcon (2 October)

|  CP Information |            |
|--------------------|------------|
| Package | [CrowdStrike Falcon Agent](https://www.crowdstrike.com/tech-hub/endpoint-security/installing-falcon-sensor-for-linux/) - Current Version |
| Script Name | [falcon-cp-init-script.sh](build/falcon-cp-init-script.sh) |
| CP Mount Path | /custom/falcon |
| CP Size | 100M |
| IGEL OS Version (min) | 11.05.133 |
| Download package | [Follow these steps to download installer and CID](https://www.crowdstrike.com/tech-hub/endpoint-security/installing-falcon-sensor-for-linux/) |
| Packaging Notes | See build script for details |
| Package automation | [build-falcon-cp.sh](build/build-falcon-cp.sh) |

**NOTES:**

- A reboot is required before the service can start.

- Copy your Customer ID Checksum (CID), displayed on Sensor Downloads and update the profile custom command to replace [CID]:

[falcon-profile.xml -- custom_cmd_x11_final](igel/falcon-profile.xml)

```
/custom/falcon/opt/CrowdStrike/falconctl -s --cid=[CID]
   ```

-----

## Configuring a proxy

If your hosts use a proxy, configure the Falcon sensor to use it.

- Configure proxy: `/custom/falcon/opt/CrowdStrike/falconctl -s --aph=<proxy host> --app=<proxy port>`

- Confirm config: `/custom/falcon/opt/CrowdStrike/falconctl -g --aph --app`

- Enable proxy: `/custom/falcon/opt/CrowdStrike/falconctl -s --apd=FALSE`

- Disable proxy: `/custom/falcon/opt/CrowdStrike/falconctl -s --apd=TRUE`

-----

## IGEL OS Kernel

- Crowdstrike full functionality is supported in LTS kernel versions. 
- Crowdstrike on non-LTS kernel runs in reduced functionality mode (RFM).
- IGEL OS may ship with non-LTS kernel to support new features or new hardware.