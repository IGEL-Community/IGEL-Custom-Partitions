# Palo Alto GlobalProtect VPN Client (31 January)

-----

## This CP is not currently functional

**Having issue starting as user and therefore `globalprotect` cannot connect to local gpd service:**

`/opt/paloaltonetworks/globalprotect/PanGPA start`

`su -c 'XDG_RUNTIME_DIR="/run/user/$UID" DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus" systemctl --user start gpa' user`

`Update` The issue in starting PanGPA appears to be that the IGEL user uid is 777 (only 3 digits) and Ubuntu user uid is four (4) digits and the service stops starting.

- With `strace -s 9999 /opt/paloaltonetworks/globalprotect/PanGPA start`, the process exits after looking for the uid.

-----

|  CP Information |            |
|-----------------|------------|
| Package | [Palo Alto GlobalProtect VPN Client](https://docs.paloaltonetworks.com/globalprotect/5-1/globalprotect-app-user-guide/globalprotect-app-for-linux/download-and-install-the-globalprotect-app-for-linux) |
| Script Name | [gpvpn-cp-init-script.sh](build/gpvpn-cp-init-script.sh) |
| CP Mount Path | /custom/gpvpn |
| CP Size | 100M |
| IGEL OS Version (min) | 11.07.100 |
| Packaging Notes | Details can be found in the build script [build-gpvpn-cp.sh](build/build-gpvpn-cp.sh) |

**NOTES:**

- A reboot is required before the agent can start.

[userinterface.rccustom.custom_cmd_x11_final](igel/gpvpn-profile.xml)
