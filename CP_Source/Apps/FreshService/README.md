# FreshService Agent (9 December)

|  CP Information |            |
|--------------------|------------|
| Package | [FreshService Agent](https://support.freshservice.com/support/solutions/articles/200393) - Current Version |
| Script Name | [freshservice-cp-init-script.sh](build/freshservice-cp-init-script.sh) |
| CP Mount Path | /custom/freshservice |
| CP Size | 250M |
| IGEL OS Version (min) | 11.05.133 |
| Download package | [Follow these steps to download installer and CID](https://www.crowdstrike.com/blog/tech-center/install-freshservice-sensor-for-linux/) |
| Packaging Notes | See build script for details |
| Package automation | [build-freshservice-cp.sh](build/build-freshservice-cp.sh) |

**NOTES:**

- [Microsoft .NET 3.1 CP](https://github.com/IGEL-Community/IGEL-Custom-Partitions/tree/master/CP_Source/Apps/Microsoft_NET_Runtime) is required as well.

- A reboot is required before the agent can start.
