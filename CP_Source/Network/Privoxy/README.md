# Privoxy (9 April) (Debug Testing)

|  CP Information |            |
|-----------------|------------|
| Package | [Privoxy](https://www.privoxy.org/) is a non-caching web proxy with advanced filtering capabilities |
| Script Name | [privoxy-cp-init-script.sh](build/privoxy-cp-init-script.sh) |
| CP Mount Path | /custom/privoxy |
| CP Size | 50M |
| IGEL OS Version (min) | 11.05.133 |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-privoxy-cp.sh](build/build-privoxy-cp.sh) <br /><br /> This script will build the latest version based on Ubuntu 18.04 |

**NOTE:** Edit profile custom command with allowed web sites and [configure browser proxy for HTTP to be 127.0.0.1 on port 8118](https://kb.igel.com/igelos-11.07/en/proxy-57334636.html).

File name: **/custom/privoxy/etc/privoxy/user.action**

```
############################################################
# Blocklist
############################################################
{ +block }
/ # Block *all* URLs

############################################################
# Allowlist
############################################################
{ -block }
www.igel.com
  ```
