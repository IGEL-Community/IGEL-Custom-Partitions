# Dynamsoft Dynamic Web TWAIN Demo (11 January)

|  CP Information |            |
|--------------------|------------|
| Package | [Dynamsoft Dynamic Web TWAIN Demo](https://demo.dynamsoft.com/web-twain/) <br /><br /> [Scan and upload documents in browsers](https://github.com/Dynamsoft/Dynamic-Web-TWAIN) |
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


## Why is the browser prompting me to install Dynamsoft Service repeatedly?

https://www.dynamsoft.com/web-twain/docs/indepth/faqs/distribution/why-is-the-browser-prompting-me-to-install-dynamsoft-service-repeatedly.html

On your Linux client machine, visit https://127.0.0.1:18626 and https://127.0.0.1:18623 separately in Chrome and FireFox, manually add both certificates to the exception lists.
