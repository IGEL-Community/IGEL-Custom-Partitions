# Nutanix Frame (14 October)

|  CP Information |            |
|--------------------|------------|
| Package | Nutanix Frame - Current Version |
| Script Name | [frame-cp-init-script.sh](frame-cp-init-script.sh) |
| CP Mount Path | /custom/frame |
| CP Size | 250M |
| IGEL OS Version (min) | 11.5.133 |
| Path to Executable | /custom/frame/usr/bin/frame |
| Path to Icon | /custom/frame/usr/share/pixmaps/frame.png |
| Download package | Download Latest Frame App for Linux (Debian) <br /> https://portal.nutanix.com/page/downloads?product=xiframe |
| Packaging Notes | See build script for details |
| Package automation | [build-frame-cp.sh](build-frame-cp.sh) |

-----
# Configure Frame Account for IGEL

## Enable "Secure Anonymous" sessions

![Secure Anonymous](images/Frame_01.png)

## Create Desktop/Application launchpad

[Add a launchpad](https://docs.frame.nutanix.com/launchpad-management/add-launchpad.html)

## Create Anonymous access provider
### (Account > Users > Secure Anonymous)

![Add Provider](images/Frame_02.png)

## Add Launchpad User Role on desktop

![Add Provider](images/Frame_03.png)

**Note:** If Launchpad User Role is not visible on the list, refresh the page and try again (NC-1055)

Copy Anonymous access provider name for later reference
(secure-anon-1c93a…)

## Enable API access
### (Account > Users > Authentication)

![Enable API](images/Frame_04.png)

## Add API
### (Account > Users > API)

![API - Generate](images/Frame_05.png)

## Create API Key)
### (Account > Users > API)

![Manage Credentials](images/Frame_06.png)
![Create new API key](images/Frame_07.png)
![Create new API key cont](images/Frame_08.png)

**Copy Client ID** and **Client secret** for later reference

-----

## Add Frame Varibles to IGEL Profile
### (System > Firmware Customization > Environment Variables > Predefined)

#### FRAME_CLIENT_ID
#### FRAME_CLIENT_SECRET
#### FRAME_ORGANIZATION_ID
#### FRAME_ANONYMOUS_PROVIDER_NAME
#### FRAME_ACCOUNT_ID

-----

## Additional Profile Customization

In order to hide taskbar and disable any user interaction with IGEL OS, following options must be enabled inside profile:

- User Interface - Desktop - Taskbar - Uncheck ‘Use Taskbar’
- User Interface - Desktop - Start Menu - Uncheck all options
