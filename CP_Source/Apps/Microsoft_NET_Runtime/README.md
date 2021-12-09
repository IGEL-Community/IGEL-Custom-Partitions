# Microsoft .NET 5.0 or 3.1 Runtime (9 December)

|  CP Information |            |
|-----------------|------------|
| Package | [Microsoft .NET 5.0 or 3.1 Runtime](https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu)
| Script Name | [dotnet-cp-init-script.sh](dotnet-cp-init-script.sh) |
| CP Mount Path | /custom/dotnet |
| CP Size | 200M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> dotnet.inf | [INFO] <br /> [PART] <br /> file="dotnet.tar.bz2" <br /> version="5.0" <br /> size="200M" <br /> name="dotnet" <br /> minfw="11.04.240" |
| Packing Notes | See build script for details |
| Package automation | [build-dotnet-cp.sh](build-dotnet-cp.sh) |

**NOTE:**

Default build is for 5.0 and can be changed to 3.1 in the build script as noted below:

```
# default build is for 5.0
MISSING_LIBS=$MISSING_LIBS_5_0
#MISSING_LIBS=$MISSING_LIBS_3_1
   ```
