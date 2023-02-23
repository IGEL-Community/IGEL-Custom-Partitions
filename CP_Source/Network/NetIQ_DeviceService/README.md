# NetIQ Device Service (23 February)

-----

**NOTE:** Package in development / testing. I will remove this line once we complete testing.

-----

|  CP Information |            |
|-----------------|------------|
| Package | [NetIQ Device Service](https://www.netiq.com/documentation/advanced-authentication-64/device-service-installation/data/t48wtja92kh7.html) <br /><br /> With Device Service you can use compliant devices, such as fingerprint readers, contact and contact-less cards, PKI smart cards, crypto sticks, and FIDO U2F tokens for enrollment on the Advanced Authentication Self-Service portal and for further authentication. |
| Script Name | [netiq_ds-cp-init-script.sh](build/netiq_ds-cp-init-script.sh) |
| CP Mount Path | /custom/netiq_ds |
| CP Size | 200M |
| IGEL OS Version (min) | 11.08.230 |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-netiq_ds-cp.sh](build/build-netiq_ds-cp.sh) <br /><br /> This script will build the latest version based on Ubuntu 18.04 |


**NOTE:** Edit build script for your `config.properties` settings.
