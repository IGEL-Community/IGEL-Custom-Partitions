# Linphone VOIP/SIP Client (13 October)

|  CP Information |            |
|--------------------|------------|
| Package | [Linphone](https://linphone.org/) open source application using SIP on Linux |
| Script Name | [linphone-cp-init-script.sh](build/linphone-cp-init-script.sh) |
| CP Mount Path | /custom/linphone |
| CP Size | 500M |
| Build Notes | Details can be found in the build script [build-linphone-cp.sh](build/build-linphone-cp.sh) |
| Packaging Notes | The CP Linphone is built from an AppImage. An AppImage will run on Linux without installation,  because everthing they need is built into that package. AppImages are like .ISO files and not changeable.<br /><br /> So why does this script extract the AppImage into a CP?<br /><br /> This AppImage checks for a newer version and then offers the user to download this update as an AppImage. But this is not possible on IGEL OS. To disable this, one line in a file has to be changed (usr/share/linphone/linphonerc-factory, see build script). |
|Package automation | [build-linphone-cp.sh](build/build-linphone-cp.sh) |
