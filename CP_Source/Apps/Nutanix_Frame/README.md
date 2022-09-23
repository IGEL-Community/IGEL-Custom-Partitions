# Nutanix Frame (15 September)

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

To launch Frame App with certain command line arguments, edit IGEL profile and append your command line argument(s) to the end of the command line.

Use the table below to understand command line argument options and their syntax.

| Command Line Argument | Description | Syntax |
|-----------------------|-------------|--------|
| help                  | New Help menu when starting Frame App via command line with --help argument. Displays all available command line arguments. | ./Frame --help |
| displays-auto-arrange | Frame App will launch with virtual displays configured to match your local environment. | ./Frame" --displays-auto-arrange |
| kiosk | Instructs Frame App to launch in full screen, a.k.a. “Kiosk mode.” | ./Frame" --kiosk |
| url | Designates the startup URL. | ./Frame --url=console.nutanix.com |

-----

# Frame 6.13.0

Published on 2022-09-15

Frame App 6.13.0

Added:

General

- New Help menu when starting Frame App via command line with --help argument. Displays all available command line arguments.

- Option for users to configure time (in seconds) in which Esc key must be pressed in order to exit full-screen mode (configurable via Preferences menu or command line).

Fixed:

General

- Issue where Frame App may crash unexpectedly resulting in a white screen. Also added ability for users to reload Frame App and return to Launchpad to resume their sessions in these situations.

Frame App for Linux

- Issue where Frame App application window may appear small upon start depending on screen resolution.

Additional reliability fixes.

-----

# Frame 6.12.0

Published on 2022-06-16

Frame App 6.12.0

Added:

General

- Support for locking mouse back/forward buttons while in session to prevent users from accidentally exiting the session.

- Support to enable/disable locking mouse back/forward buttons via command line argument (disable-mouse-lock).

Fixed:

General

- Users can now exit full screen and kiosk mode by pressing and holding Esc for 5 seconds (previously 10 seconds).

Frame App for Linux

- Issue where Windows key can become unresponsive in session.

- Issue where Ctrl, Alt, and Meta keys can become stuck in session.

- Issue where Linux error logs are not sent to Frame Platform.

- Changing application name from Frame Native Terminal to just Frame.

-----

# Frame 6.11.1

Published on 2022-05-19

Frame App 6.11.1 (Hotfix)

This version is a hotfix to Frame App 6.11.0.

- Fixed issue with ```addEventListener``` function which could prevent USB devices (including HID) from functioning properly from within the Frame session in certain situations.

# Frame 6.11.0

## Frame App 6.11

- Upgraded to Chromium 100
- Added support to clear cache on close of Frame App in addition to startup when **Clear user local cache** is enabled

## Frame App for Linux 6.11

-	Fixed issue where secondary displays would also show Frame Gear Icon/Menu
-	Fixed issue with keyboard shortcuts not working for shortcuts when **Windows** or **ALT** key is pressed first
-	Fixed issue when in full-screen mode, switching focus to another Linux app and back to Frame App would result in a blank screen
-	Fixed issue where after exiting full screen mode, Frame App menu bar shows up but there is no title bar or application window border and the Frame App window still takes up the full monitor without ability to resize.


-----

# Frame 6.10.1

Fixed:

- Full screen will only exit when the Escape key is held for 10 seconds or more.

- For Frame App for Linux, generic USB devices can cause USB devices to lose connectivity.


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
