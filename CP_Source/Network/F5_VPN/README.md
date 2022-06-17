# F5 VPN Client (17 June) (Debug Testing)

-----

## Need to obtain the F5 installer files

**NOTE:** Obtain the three installer files (linux_f5cli.x86_64.deb, linux_f5epi.x86_64.deb, linux_f5vpn.x86_64.deb) and save them in Downloads folder on the Ubuntu 18.04 VM.

-----

## Using the Linux client f5fpc for the first time

[Using the Linux client f5fpc to connect to the BIG-IP APM network access for the first time](https://support.f5.com/csp/article/K47922841)

Verify the f5fpc Linux client version by entering the following command:
```
/usr/local/bin/f5fpc -v
/usr/local/bin/f5fpc --help
  ```

-----

|  CP Information |            |
|-----------------|------------|
| Package | [F5 Client VPN for Linux](https://techdocs.f5.com/kb/en-us/products/big-ip_apm/manuals/product/apm-client-configuration-13-0-0/4.html) |
| Script Name | [f5vpn-cp-init-script.sh](build/f5vpn-cp-init-script.sh) |
| CP Mount Path | /custom/f5vpn |
| CP Size | 440M |
| IGEL OS Version (min) | 11.05.133 |
| Packaging Notes | Details can be found in the build script [build-f5vpn-cp.sh](build/build-f5vpn-cp.sh) |
