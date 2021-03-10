# IcedTea-Web (DRAFT Package for Testing)

|  CP Information |            |
|--------------------|------------|
| Package | IcedTea-Web - [Current Version](https://www.azul.com/downloads/icedtea-web-community) <br /><br /> IcedTea-Web is an open source implementation of Java Web Start. |
| Script Name | [icedtea-cp-init-script.sh](icedtea-cp-init-script.sh) |
| CP Mount Path | /custom/icedtea |
| CP Size | 100M |
| IGEL OS Version (min) | 11.04.240 |
| Metadata File <br /> icedtea.inf | [INFO] <br /> [PART] <br /> file="icedtea.tar.bz2" <br /> version="1.8.4" <br /> size="100M" <br /> name="icedtea" <br /> minfw="11.04.240" |
| Path to Executable | /custom/icedtea/services/zulu_jre8/jre/bin/javaws |
| Path to Icon | N/A |
| Missing Libraries | None |
| Download package and missing library | See build script for details |
| Packaging Notes | See build script for details |
| Package automation | [build-icedtea-cp.sh](build-icedtea-cp.sh) <br /><br /> Tested with 1.8.4 |
