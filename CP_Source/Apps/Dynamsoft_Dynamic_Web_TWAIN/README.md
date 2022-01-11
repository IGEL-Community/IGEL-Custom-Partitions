# Dynamsoft Dynamic Web TWAIN Demo (11 January)

|  CP Information |            |
|--------------------|------------|
| Package | [Dynamsoft Dynamic Web TWAIN Demo](https://demo.dynamsoft.com/web-twain/) <br /><br /> Scan and upload documents in browsers |
| Script Name | [dynamsoft-cp-init-script.sh](build/dynamsoft-cp-init-script.sh) |
| CP Mount Path | /custom/dynamsoft |
| CP Size | 50M |
| IGEL OS Version (min) | 11.05.133 |
| Packaging Notes | See build script for details |
| Package automation | [build-dynamsoft-cp.sh](build/build-dynamsoft-cp.sh) |

**NOTES:**

- A reboot is required before the agent can start.

[userinterface.rccustom.custom_cmd_x11_final](igel/dynamsoft-profile.xml)

```
chmod a+x /custom/dynamsoft/usr/bin/igel_dynamsoft_autostart.sh
/custom/dynamsoft/usr/bin/igel_dynamsoft_autostart.sh &
   ```
