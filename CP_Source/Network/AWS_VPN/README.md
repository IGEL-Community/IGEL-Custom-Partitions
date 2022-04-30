# AWS VPN Client (29 April) (In debug testing)

-----

## Need to obtain the client VPN endpoint configuration file

**NOTE:** Follow the link below to obtain client VPN endpoint configuration file **before** running the CP builder on your Ubuntu 18.04 VM. Save the file into Downloads folder on Ubuntu 18.04 VM.

https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-working-endpoint-export.html

-----

|  CP Information |            |
|-----------------|------------|
| Package | [AWS Client VPN for Linux](https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-linux.html) |
| Script Name | [awsvpn-cp-init-script.sh](build/awsvpn-cp-init-script.sh) |
| CP Mount Path | /custom/awsvpn |
| CP Size | 300M |
| IGEL OS Version (min) | 11.05.133 |
| Packaging Notes | Details can be found in the build script [build-awsvpn-cp.sh](build/build-awsvpn-cp.sh) |

**NOTES:**

- A reboot is required before the agent can start.

[userinterface.rccustom.custom_cmd_x11_final](igel/awsvpn-profile.xml)
