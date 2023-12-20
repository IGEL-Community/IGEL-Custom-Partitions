# Island Enterprise Browser (19 December)

-----

**NOTE:** Builder works for OS11.09+ (build with Ubuntu 22.04 - jammy) and OS12 (build with Ubuntu 20.04 - focal)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [Island Enterprise Browser](https://www.island.io/)
| Script Name | [island-cp-init-script.sh](build/island-cp-init-script.sh) |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-island-cp.sh](build/build-island-cp.sh) |

-----

**NOTE:**

- The Deb file has a postinst script, this is copied into the CP but did not run it. Look at this file if something is missing or need to adjust something.
 
`/custom/island/opt/island/island-browser/igel_postinst.sh`