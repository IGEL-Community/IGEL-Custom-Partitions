# Magnus Screen Magnifier

**NOTE:** Builder works for OS11 (build with Ubuntu 22.04 - jammy) and OS12 (build with Ubuntu 20.04 - focal)

|  CP Information |            |
|-----------------|------------|
| Package | Magnus - Current Version |
| Script Name | [magnus-cp-init-script.sh](build/magnus-cp-init-script.sh) |
| Icon name | application-other |
| Command | /usr/bin/magnus |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-magnus-cp.sh](build/build-magnus-cp.sh) |

-----

**NOTE:** Removed `setproctitle` from /usr/bin/magnus in the builder.

```bash linenums="1"
# ***** REMOVE setproctitle from /usr/bin/magnus *****
sed -i "/setproctitle/d" custom/${CP}/usr/bin/magnus
# ***** REMOVE setproctitle from /usr/bin/magnus *****
```
