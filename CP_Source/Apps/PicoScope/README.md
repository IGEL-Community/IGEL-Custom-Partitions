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
| Packaging Notes | See build script |
| Package automation | [build-picoscope-cp.sh](build-picoscope-cp.sh) <br /><br /> Testing with 6.14.47.5899 |

**NOTE:** This application uses Mono () and the build script needs to be debugged. Here is the error from /opt/picoscope/bin/picoscope.


```
exec /usr/bin/mono /opt/picoscope/lib/PicoScope.GTK.exe

Unhandled Exception:
System.TypeLoadException: Could not load type 'Pico.' from assembly 'PicoScope.GTK, Version=6.14.47.5899, Culture=neutral, PublicKeyToken=d07fd3de7c3ccbb2'.

  ```

[Mono](https://www.mono-project.com/) is an open source implementation of Microsoft’s .NET Framework. If someone else has some time to look into it and let me know what to do to get it working…
