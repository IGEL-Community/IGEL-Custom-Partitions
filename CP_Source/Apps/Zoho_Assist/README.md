# Zoho Assist (9 September)

-----

**NOTE:** Builder works for OS11.09+ (build with Ubuntu 22.04 - jammy) and OS12 (build with Ubuntu 20.04 - focal)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [Zoho Assist](https://www.zoho.com/assist)
| Script Name | [zohoassist-cp-init-script.sh](build/zohoassist-cp-init-script.sh) |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-zohoassist-cp.sh](build/build-zohoassist-cp.sh) |

-----

**NOTE:**

- The Deb file has a postinst script, this is copied into the CP and run as final desktop command. Look at this file if something is missing or need to adjust something.
 
`/custom/zohoassist/usr/local/ZohoAssist/igel_postinst.sh`