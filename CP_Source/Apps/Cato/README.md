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

-----

## Authenticating with Headless SSO

Headless SSO lets you authenticate on devices without a browser.

To authenticate on a headless device:

- On the headless device, run the command:

```bash
cato-sdp start --account <account name>--headless
```
A unique code and URL are returned.

**Note:**

- The account name is the account Subdomain. To find the Subdomain, navigate to Access > Single Sign-On.
- For authentication without SSO, add the parameter --no-sso
- The --headless parameter is not required in version 5.1.0.21 and higher
- On a device that has a browser, access the URL and enter the unique code.
- Sign in with your SSO credentials.
- The headless device is connected to the Cato Cloud.
