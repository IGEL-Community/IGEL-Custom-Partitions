# PicoScope (26 August - Development Testing)

|  CP Information |            |
|-----------------|------------|
| Package | [PicoScope](https://www.picotech.com/downloads/linux) 6 for Linux brings many of the features of their powerful oscilloscope software to a large number of platforms. Their Drivers and APIs can also be used, with bindings available for C and other higher-level languages. |
| Script Name | [picoscope-cp-init-script.sh](picoscope-cp-init-script.sh) |
| CP Mount Path | /custom/picoscope |
| CP Size | 400M |
| IGEL OS Version (min) | 11.05.133 |
| Metadata File <br /> picoscope.inf | [INFO] <br /> [PART] <br /> file="picoscope.tar.bz2" <br /> version="6.14.47.5899" <br /> size="600M" <br /> name="picoscope" <br /> minfw="11.05.133" |
| Path to Executable | /custom/picoscope/opt/picoscope/bin/picoscope |
| Path to Icon | /custom/picoscope/opt/picoscope/share/picoscope.png |
| Missing Libraries | See build script |
| Download package and missing library | apt-get download microsoft-picoscope-beta <br /> apt-get download libatomic1 |
| Packaging Notes | See build script |
| Package automation | [build-picoscope-cp.sh](build-picoscope-cp.sh) <br /><br /> Tested with 6.14.47.5899 |
