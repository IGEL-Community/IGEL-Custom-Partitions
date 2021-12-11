# FreshService Agent (11 December)

|  CP Information |            |
|--------------------|------------|
| Package | [FreshService Agent](https://support.freshservice.com/support/solutions/articles/200393) - Current Version |
| Script Name | [freshservice-cp-init-script.sh](build/freshservice-cp-init-script.sh) |
| CP Mount Path | /custom/freshservice |
| CP Size | 400M |
| IGEL OS Version (min) | 11.05.133 |
| Download package | [Follow these steps to download installer and CID](https://www.crowdstrike.com/blog/tech-center/install-freshservice-sensor-for-linux/) |
| Packaging Notes | See build script for details |
| Package automation | [build-freshservice-cp.sh](build/build-freshservice-cp.sh) |

**NOTES:**

- Microsoft .NET 3.1 is required as well and is included in this CP.

- A reboot is required before the agent can start.

- The file last-scan-data.txt is located here:

```
/custom/freshservice/usr/local/sbin/Freshservice/Discovery-Agent/bin/last-scan-data.txt
   ```
