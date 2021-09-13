# IcedTea-Web

|  CP Information |            |
|-----------------|------------|
| Package | IcedTea-Web - [Current Version](https://www.azul.com/products/components/icedtea-web/) <br /><br /> IcedTea-Web is an open source implementation of Java Web Start. <br /><br /> Steps to test [Open Notepad](https://docs.oracle.com/javase/tutorial/deployment/webstart/running.html#desktop) in Firefox |
| Script Name | [icedtea-cp-init-script.sh](icedtea-cp-init-script.sh) |
| CP Mount Path | /custom/icedtea |
| CP Size | 300M |
| IGEL OS Version (min) | 11.04.240 |
| Metadata File <br /> icedtea.inf | [INFO] <br /> [PART] <br /> file="icedtea.tar.bz2" <br /> version="1.8.4" <br /> size="300M" <br /> name="icedtea" <br /> minfw="11.04.240" |
| Path to Executable | /custom/icedtea/services/zulu_jre8/jre/bin/javaws |
| Path to Icon | N/A |
| Missing Libraries | None |
| Download package and missing library | See build script for details |
| Packaging Notes | See build script for details |
| Package automation | [build-icedtea-cp.sh](build-icedtea-cp.sh) <br /><br /> Tested with 1.8.4 |

**NOTE: Starting the UMS Console via Java Web Start on IGEL OS**

To start the IGEL UMS Console via Java Web Start:

In a web browser, open the address

```
https://[UMS-Server]:8443/start_rm.html
  ```
