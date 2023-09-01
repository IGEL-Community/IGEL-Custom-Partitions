# Spinoco - Contact Center aaS (1 September)

|  CP Information |            |
|--------------------|------------|
| Package | [Spinoco](https://www.spinoco.com/)
| Script Name | [spinoco-cp-init-script.sh](build/spinoco-cp-init-script.sh) |
| CP Mount Path | /custom/spinoco |
| Build Notes | Details can be found in the build script [build-spinoco-cp.sh](build/build-spinoco-cp.sh) |
| Packaging Notes | The CP spinoco is built from an AppImage. An AppImage will run on Linux without installation, because everything needed is built into the package. AppImages are like .ISO files and cannot be changed.<br /><br /> The automated builder extracts the AppImage into a CP to disable the check and download of the latest version during startup since this is not possible on IGEL OS. |
|Package automation | [build-spinoco-cp.sh](build/build-spinoco-cp.sh) |
