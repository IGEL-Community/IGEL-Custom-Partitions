# Nutanix Frame (21 March) (Added note for 6.10.1)

|  CP Information |            |
|--------------------|------------|
| Package | Nutanix Frame - Current Version |
| Script Name | [frame-cp-init-script.sh](build/frame-cp-init-script.sh) |
| CP Mount Path | /custom/frame |
| CP Size | 500M |
| IGEL OS Version (min) | 11.05.133 |
| Download package | Download Latest Frame App for Linux (Debian) <br /> https://portal.nutanix.com/page/downloads?product=xiframe |
| Packaging Notes | See build script for details |
| Package automation | [build-frame-cp.sh](build/build-frame-cp.sh) |

-----

# Frame 6.10.1

Fixed:

• Full screen will only exit when the Escape key is held for 10 seconds or more.
• For Frame App for Linux, generic USB devices can cause USB devices to lose connectivity.


-----

# Frame 6.10.0 and newer

Starting from Frame app 6.10.0 Administrators can control preferences on Linux, using configuration file located at:

```
/custom/frame/etc/nutanix-frame/preferences.conf
  ```

| Value Name | Type | Possible Value | Default Value |  
|------------|------|----------------|---------------|
| STARTUP_URL | REG_SZ | Valid URL | https://console.nutanix.com |
| SEND_ERROR_REPORTS | REG_SZ | ON/OFF | ON |
| CLEAR_CACHE_ON_STARTUP | REG_SZ | ON/OFF | OFF |
| CHECK_FOR_UPDATES_ON_STARTUP | REG_SZ | ON/OFF | ON |
| ADVANCED_USB | REG_SZ | ON/OFF | ON |

**NOTE:** VALID_VALUE for string preferences can be any string, for bool preferences it can be ON/OFF

**Example:**

```
STARTUP_URL=https://console.nutanix.com/customer/org/account
ADVANCED_USB=OFF
CHECK_FOR_UPDATES_ON_STARTUP=OFF
  ```

-----
# Advanced Profile Setup - Configure Frame Account for IGEL

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
