# rdesktop (6 March) Latest version

|  CP Information |            |
|-----------------|------------|
| Package | [rdesktop](http://www.rdesktop.org/)
| Script Name | [rdesktop-cp-init-script.sh](build/rdesktop-cp-init-script.sh) |
| CP Mount Path | /custom/rdesktop |
| Packaging Notes | See build script for details |
| Package automation | [build-rdesktop-cp.sh](build/build-rdesktop-cp.sh) |

-----

**Notes:** 

- Latest version requires a wrapper script, `/usr/bin/start_rdesktop.sh` to start.

```bash
#!/bin/bash

export LD_LIBRARY_PATH=/tmp/x86_64-linux-gnu
exec /usr/bin/rdesktop "$@"
```