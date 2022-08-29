# Microsoft .NET 5.0 or 3.1 Runtime (29 August)

|  CP Information |            |
|-----------------|------------|
| Package | [Microsoft .NET 5.0 or 3.1 Runtime](https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu)
| Script Name | [dotnet-cp-init-script.sh](build/dotnet-cp-init-script.sh) |
| CP Mount Path | /custom/dotnet |
| Packing Notes | See build script for details |
| Package automation | [build-dotnet-cp.sh](build/build-dotnet-cp.sh) |

**NOTE:**

Default build is for 5.0 and can be changed to 3.1 in the build script as noted below:

```
# default build is for 5.0
MISSING_LIBS=$MISSING_LIBS_5_0
#MISSING_LIBS=$MISSING_LIBS_3_1
   ```
