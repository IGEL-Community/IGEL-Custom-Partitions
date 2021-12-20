# AnyDesk (20 December)

|  CP Information |            |
|-----------------|------------|
| Package | [AnyDesk](https://anydesk.com/en) - Access any device at any time. From anywhere. Always secure and fast.
| Script Name | [anydesk-cp-init-script.sh](build/anydesk-cp-init-script.sh) |
| CP Mount Path | /custom/anydesk |
| CP Size | 50M |
| IGEL OS Version (min) | 11.05.133 |
| Packaging Notes | Details can be found in the build script [build-anydesk-cp.sh](build/build-anydesk-cp.sh) |

**NOTES:**

- A reboot is required before the agent can start.

[userinterface.rccustom.custom_cmd_x11_final](igel/anydesk-profile.xml)

```
systemctl enable /custom/anydesk/usr/share/anydesk/files/systemd/anydesk.service; systemctl start anydesk.service
   ```
