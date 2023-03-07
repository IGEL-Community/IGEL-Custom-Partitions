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

-----

## The CP init script sets up NetIQ root cert into Firefox and chromium.
 
The best method is to manage Browser Certs via UMS as noted below
 
https://kb.igel.com/endpointmgmt-6.10/en/files-registering-files-on-the-igel-ums-server-and-transferring-them-to-devices-57321597.html
 
https://kb.igel.com/igelos-11.08/en/deploying-trusted-root-certificates-in-igel-os-63803399.html
 
-----

Location of cert
`/custom/netiq_ds/opt/NetIQ/DeviceService/bin/rootCA.crt`

Sample script to check for NetIQ in browser:
 
```bash
#!/bin/bash
 
firefox_certDir=/userhome/.mozilla/firefox/browser0
chromium_certDir=/userhome/.config/chromium/.pki/nssdb
 
#list firefox certs
certutil -d "sql:$firefox_certDir" -L
 
#list chromium certs
certutil -d "sql:$chromium_certDir" -L
```

**NOTE:** Edit the init script, `netiq_ds-cp-init-script.sh`, to comment out `certutil` commands as noted below: 

```bash
#firefox cert
#certutil -A -n "$certificateName" -t "TC,TC,TC" -i "$certificateFile" -d "sql:$firefox_certDir" | $LOGGER

  #chromium cert
  #certutil -A -n "$certificateName" -t "TC,TC,TC" -i "$certificateFile" -d "sql:$chromium_certDir" | $LOGGER
```