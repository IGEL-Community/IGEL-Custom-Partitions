# Fortinet FortiClient (13 April)

|  CP Information |            |
|-----------------|------------|
| Package | [Fortinet FortiClient](https://anydesk.com/en) - Advanced Endpoint Security |
| Script Name | [forticlient-cp-init-script.sh](build/forticlient-cp-init-script.sh) |
| CP Mount Path | /custom/forticlient |
| CP Size | 500M |
| IGEL OS Version (min) | 11.05.133 |
| Packaging Notes | Details can be found in the build script [build-forticlient-cp.sh](build/build-forticlient-cp.sh) |

**NOTES:**

- A reboot is required before the agent can start.

[userinterface.rccustom.custom_cmd_x11_final](igel/forticlient-profile.xml)

```
systemctl enable /custom/forticlient/lib/systemd/system/forticlient-scheduler.service;
systemctl start forticlient-scheduler.service;
pkexec -u user env XAUTHORITY=$XAUTHORITY DISPLAY=$DISPLAY DBUS_SESSION_BUS_ADDRESS=/run/user/777/bus XDG_RUNTIME_DIR=/run/user/777 setsid /opt/forticlient/fortitraylauncher &>/dev/null &
   ```
