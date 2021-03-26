# Dislocker (Read Microsoft Bitlocker encrypted disks)

|  CP Information |            |
|--------------------|------------|
| Package | [Dislocker](https://github.com/Aorimn/dislocker) reads BitLocker encrypted partitions under a Linux system (read / write). <br /><br /> Here is a good article for using dislocker: [How to access Windows Bitlocker partitions in Linux](https://www.addictivetips.com/ubuntu-linux-tips/access-windows-bitlocker-partitions-in-linux/) |
| Script Name | [dislocker-cp-init-script.sh](dislocker-cp-init-script.sh) |
| CP Mount Path | /custom/dislocker |
| CP Size | 50M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> dislocker.inf | [INFO] <br /> [PART] <br /> file="dislocker.tar.bz2" <br /> version="0.7.1" <br /> size="50M" <br /> name="dislocker" <br /> minfw="11.04.240" |
| Path to Executable | /custom/dislocker/usr/bin/dislocker |
| Path to Icon | N/A |
| Download package and missing libraries | See build script for missing libraries |
| Packaging Notes | See build script for steps to build |
| Package automation | [build-dislocker-cp.sh](build-dislocker-cp.sh) |
