# Cato Linux Client (9 January)

-----

**NOTE:** Builder works for OS11 (build with Ubuntu 18.04 - bionic) and OS12 (build with Ubuntu 20.04 - focal)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [Cato Linux Client](https://support.catonetworks.com/hc/en-us/articles/11552180113821) |
| Script Name | [cato-cp-init-script.sh](build/cato-cp-init-script.sh) |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-cato-cp.sh](build/build-cato-cp.sh) |

-----

**NOTE:** A reboot is required before the service can start.

```
systemctl enable /custom/cato/lib/systemd/system/cato-client.service ; systemctl start cato-client.service
```