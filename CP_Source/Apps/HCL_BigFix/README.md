# HCL BigFix (19 April)

-----

**NOTE:** Builder works for OS11 (build with Ubuntu 18.04 - bionic) and **pending** OS12 (build with Ubuntu 20.04 - focal)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [HCL BigFix](https://www.hcltechsw.com/bigfix/home)
| Script Name | [bigfix-cp-init-script.sh](build/bigfix-cp-init-script.sh) |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-bigfix-cp.sh](build/build-bigfix-cp.sh) |

-----

**NOTE:**

The init script, `bigfix-cp-init-script.sh` starts BixFix

```bash
# /etc/init.d/besclient
/usr/sbin/update-rc.d besclient defaults
```

-----

- Download the corresponding BigFix Client DEB package file and save into `$HOME/Downloads` folder
- Copy your actionsite masthead (actionsite.afxm) to the Ubuntu BigFix Client `$HOME/Downloads` folder
- The action site masthead (actionsite.afxm) can be found in your BigFix Installation folders (by default they are placed under C:\BigFix Installers).
- If the masthead is not named "actionsite.afxm", rename it to "actionsite.afxm" and place it on the computer at the following location: /etc/opt/BESClient/actionsite.afxm. 
- Note: In BigFix 4.0 and later, the masthead file for each BigFix Server is downloadable at http://servername:port/masthead/masthead.afxm (example: http://bes.bigfix.com:52311/masthead/masthead.afxm). 
- Source for instructions: https://support.bigfix.com/bes/install/besclients-nonwindows.html#ubuntu 
