# Elo Touch Legacy Serial Driver (15 September - Development)

|  CP Information |            |
|------------------|------------|
| Package | [Elo Touch Legacy Serial Driver](https://www.elotouch.com/support/downloads#/category/346LYmeuAUEI4Qa0sSyiSa/os/5hkYjkrw08oU08oCwCeSKq/legacy/legacy/tech/69YQ1PZI9agaqiaWCcq4SK) <br /><br /> Manual installer for serial driver with support for multiple monitors, multiple touchscreens, precalibration and video rotation. Release Date: 22-Sep-2020 |
| Steps to setup | [Steps to setup](https://assets.ctfassets.net/of6pv6scuh5x/6aeWc4SxtKgan27SNtGzfs/d8040f1c525aafa38e034208c35a2cdd/Elo-Linux-Serial-Driver-v3.5.0_Installation-Instructions.txt) |
| Script Name | [elotouch-cp-init-script.sh](elotouch-cp-init-script.sh) |
| CP Mount Path | /custom/elotouch |
| CP Size | 10M |
| IGEL OS Version (min) | 11.05.133 |
| Metadata File <br /> elotouch.inf | [INFO] <br /> [PART] <br /> file="elotouch.tar.bz2" <br /> version="3.5.0" <br /> size="10M" <br /> name="elotouch" <br /> minfw="11.05.133" |
| Packing Notes | See build script for details |
| Package automation | [build-elotouch-cp.sh](build-elotouch-cp.sh) |

**NOTE:** Reboot required after CP deployed.

Created script, igel_start_elo_service.sh, to modify loadEloSerial.sh as noted below.

```
Check COM port number to make sure the COM port connection is correct:

# vi loadEloSerial.sh

  /etc/opt/elo-ser/eloser <PORTNAME1> <PORTNAME2> ...  [See Note 1 below for <PORTNAME>]

[Save the file if make any change]

Note 1:
=======

Replace <PORTNAME> in the command /etc/opt/elo-ser/eloser <PORTNAME> with one of the following names based on which serial ports the touch inputs are connected.

  ttyS0 : for /dev/ttyS0
  ttyS1 : for /dev/ttyS1
  ttyS2 : for /dev/ttyS2
  etc.
  ```
