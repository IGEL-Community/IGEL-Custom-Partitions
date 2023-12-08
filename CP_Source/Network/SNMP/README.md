# SNMP (2 May)

|  CP Information |            |
|-----------------|------------|
| Package | SNMP |
| Script Name | [snmp-cp-init-script.sh](build/snmp-cp-init-script.sh) |
| CP Mount Path | /custom/snmp |
| CP Size | 100M |
| IGEL OS Version (min) | 11.05.133 |
| Packaging Notes | Details can be found in the build script [build-snmp-cp.sh](build/build-snmp-cp.sh) |
| OS 11.09 Builder | [build-snmp-cp-os1109.sh](build/build-snmp-cp-os1109.sh) |

**NOTES:**

- A reboot is required before the client can start.

Command to test snmp:

```bash
snmpwalk -v 2c -c public localhost
  ```
