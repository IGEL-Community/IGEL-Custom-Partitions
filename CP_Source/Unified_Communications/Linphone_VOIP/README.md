# Linphone VOIP/SIP Client (13 October)

|  CP Information |            |
|--------------------|------------|
| Package | [Linphone](https://linphone.org/) open source application using SIP on Linux |
| Script Name | [linphone-cp-init-script.sh](build/linphone-cp-init-script.sh) |
| CP Mount Path | /custom/linphone |
| CP Size | 500M |
| Build Notes | Details can be found in the build script [build-linphone-cp.sh](build/build-linphone-cp.sh) |
| Packaging Notes | The CP Linphone is built from an AppImage. An AppImage will run on Linux without installation, because everthing needed is built into the package. AppImages are like .ISO files and cannot be changed.<br /><br /> The automated builder extracts the AppImage into a CP to disable the check and download of the latest version during startup since this is not possible on IGEL OS. To disable this, one line in a file has to be changed `usr/share/linphone/linphonerc-factory` and details of the change are in the build script. |
|Package automation | [build-linphone-cp.sh](build/build-linphone-cp.sh) |

-----

## Using Linphone as the Media Player

Update Linphone profile to change media player from `mediaplayer` to `/custom/linphone/AppRun`.

### System > Firmware Customization > Custom Commands > Desktop > Before Desktop Start

`sed -i "/^Exec=mediaplayer/c Exec=/custom/linphone/AppRun %U" /usr/share/applications.mime/mediaplayer.desktop`

See [Adding or Changing a MIME Type Hander](https://kb.igel.com/igelos-11.08/en/adding-or-changing-a-mime-type-handler-63803902.html) for additional details.
