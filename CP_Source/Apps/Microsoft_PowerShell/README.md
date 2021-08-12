# Microsoft PowerShell (11 August)

|  CP Information |            |
|-----------------|------------|
| Package | [Microsoft PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1)
| Script Name | [powershell-cp-init-script.sh](powershell-cp-init-script.sh) |
| CP Mount Path | /custom/powershell |
| CP Size | 300M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> powershell.inf | [INFO] <br /> [PART] <br /> file="powershell.tar.bz2" <br /> version="7.1.3" <br /> size="200M" <br /> name="powershell" <br /> minfw="11.04.240" |
| Packing Notes | See build script for details |
| Package automation | [build-powershell-cp.sh](build-powershell-cp.sh) |

[PSIGEL](https://github.com/IGEL-Community/PSIGEL) is a powershell module that makes use of the REST API provided by the IGEL Management Interface (IMI).
