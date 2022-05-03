# ThousandEyes Agent (3 May) (Debug Testing)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [ThousandEyes Agent](https://docs.thousandeyes.com/product-documentation/global-vantage-points/enterprise-agents/installing/enterprise-agent-deployment-using-linux-package-method) |
| Script Name | [thousandeyes-cp-init-script.sh](build/thousandeyes-cp-init-script.sh) |
| CP Mount Path | /custom/thousandeyes |
| CP Size | 100M |
| IGEL OS Version (min) | 11.05.133 |
| Packaging Notes | Details can be found in the build script [build-thousandeyes-cp.sh](build/build-thousandeyes-cp.sh) |

-----

**NOTES:**

- Profile needs to be updated to configure /custom/thousandeyes/etc/te-agent.cfg

- [BrowserBot](https://docs.thousandeyes.com/product-documentation/global-vantage-points/enterprise-agents/what-is-browserbot) is **not** installed

- A reboot is required before the agent can start.

-----

[userinterface.rccustom.custom_cmd_x11_final](igel/thousandeyes-profile.xml)

```
cat << 'EOF' > /custom/thousandeyes/etc/te-agent.cfg
log-path=/var/log
log-file-size=10
log-level=DEBUG
num-log-files=13
account-token=<account-token>
proxy-type=DIRECT
proxy-location=
proxy-user=
proxy-pass=
proxy-auth-type=
proxy-bypass-list=
kdc-user=
kdc-pass=
kdc-realm=
kdc-host=
kdc-port=88
kerberos-whitelist=
kerberos-rdns=1
crash-reports=1
EOF
   ```
