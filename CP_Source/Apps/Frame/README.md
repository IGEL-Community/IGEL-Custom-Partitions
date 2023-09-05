# Frame (22 June)

-----

**📢 Announcement:**
> [Dizzion Acquires Frame from Nutanix to Accelerate Growth in DaaS Market](https://www.dizzion.com/company/news/dizzion-acquires-frame/) 🎉

-----

| CP Information        |                                                                                                               |
| --------------------- | ------------------------------------------------------------------------------------------------------------- |
| Package               | Frame - Current Version                                                                                       |
| Script Name           | [frame-cp-init-script.sh](build/frame-cp-init-script.sh)                                                      |
| CP Mount Path         | /custom/frame                                                                                                 |
| CP Size               | 500M                                                                                                          |
| IGEL OS Version (min) | 11.08.230                                                                                                     |
| Download package      | Download Latest Frame App for Linux (Debian) <br /> https://docs.fra.me/downloads                             |
| Packaging Notes       | See build script for details                                                                                  |
| Package automation    | [build-frame-cp.sh](build/build-frame-cp.sh)                                                                  |

-----

## Frame App 7.x support

**Frame App 7.x is now supported**. You can now build Custom Partition bundles with Frame App 7.x.x!

**Note:** the *Basic Frame App Profile* now defaults to Frame App 7.x installation paths. If you'd like to bundle/use Frame App 6, please import the [Frame App 6 Basic Profile](igel/frame-app-v6-basic-profile.xml).

-----

## Frame App IGEL Bundling instructions For Ubuntu 18.04
1. Download the latest [Frame App for Linux (Debian)](https://docs.fra.me/downloads) to your `~/Downloads` directory.
2. Download and unzip `Frame.zip` from [https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Frame.zip](https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Frame.zip).
3. Using a terminal, navigate to the unzipped directory to `/target/build/` and execute `build-frame-cp.sh`
   - **Note:** For Frame App **6.x** and below, use `build-frame-cp-legacy.sh`.
4. Copy `frame.ini` and `frame.tar.bz2` from `/target/` to the UMS RemoteManager server.
   1. Linux UMS host: `/opt/IGEL/RemoteManager/rmguiserver/webapps/ums_filetransfer/Frame/`
   2. Windows UMS host: `C:/Program Files/IGEL/RemoteManager/rmguiserver/webapps/ums_filetransfer/Frame/`
5. Import Frame's Custom Profile(s) from `/igel/*`
6. Edit the profile and
set up *Firmware Customization -> Custom Partition -> Download* with your UMS server info and credentials.
7. Setup env variables as instructed in the guides below.

## Frame IGEL Custom Profiles

- [Basic Frame App Profile](#basic-frame-app-profile)
- [Frame SAML2 Kiosk Mode Profile](#frame-saml2-kiosk-mode-profile)
- [Frame SAT Kiosk Mode Profile](#frame-sat-kiosk-mode-profile)

-----

## Frame App Releases

### Frame App 7.0.21 (Tech Preview)

Published on June 2, 2023

**Added:**

- New architecture based on Electron (version 24.3.1) framework.
- Revamped and unified UX/GUI.
- New generic USB redirection architecture based on WebUSB (device driver must be compatible wth WebUSB) and includes support for multi-interface devices.
- Support for Google Sign-in (OAuth 2.0).
- Diagnostics tools (WebRTC Internals, GPU Internals, Developer Tools)
- Support for metadata logging locally and to Frame Platform.

**Known Limitations:**

- No support for installation via CLI.
- No support for centralized configuration (GPO, .plist, preferences.conf, etc.).
- No ability to enable/disable auto-update feature.
  - Enabled for Windows and macOS
  - Disabled for Linux
- No clear local cache feature.
- No support for FIDO2/WebAuthn hardware authentication tokens.
- **\[macOS\]** No kiosk mode support.

-----

### Frame App 6.16

Published on 2022-12-08

Added:

General

- Ability for users to automatically enable sound, microphone, and webcam via Preferences.

- Ability to hide the [Frame Status Bar](https://docs.fra.me/enduser/enduser-navaccount.html#status-bar) when in full-screen mode with Frame App. This feature can be enabled by setting the following Advanced Terminal Argument (either within Dashboard > Settings > Session > Advanced Options or Dashboard > Launchpads > Session Settings > Advanced Options).

- Advanced Terminal Argument: `hideStatusBarOnFullscreen`

Fixed:

General

- Issue where Frame App would automatically exit full-screen mode when session closed while in [kiosk mode](https://docs.fra.me/platform/session/frame-app/config/#frapp-args).

- Issue where users were able to exit full-screen mode while in [kiosk mode](https://docs.fra.me/platform/session/frame-app/config/#frapp-args).

- Additional reliability fixes.

-----

## Frame IGEL Custom Profiles

To get started, read each of the following profiles to see which sounds like the right fit for you and then import it into the IGEL UMS following the instructions below.

### Basic Frame App Profile
```js
import 'igel/frame-app-basic-profile.xml'
```

This Custom Profiles simply enables a Frame App icon on the IGEL Desktop. To launch Frame App with certain command line arguments, edit IGEL profile and append your command line argument(s) to the end of the command line.

Below is a table of [Linux command-line arguments for Frame App](https://docs.fra.me/platform/session/frame-app/config/?operating-systems=linux#frapp-args):

| Command Line Argument   | Description                                                                                                                                                                                                                                                    | Syntax                              |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `disable-mouse-lock`    | By default, Frame App will ignore mouse forward/back button events. If this argument is used, Frame App will respond to mouse forward/back button events. When a user is in session, these mouse events can cause the user to exit their session accidentally. | `./Frame --disable-mouse-lock`      |
| `displays-auto-arrange` | Frame App will launch with virtual displays configured to match your local environment.                                                                                                                                                                        | `./Frame --displays-auto-arrange`   |
| `kiosk`                 | Instructs Frame App to launch in full screen, a.k.a. “Kiosk mode.”                                                                                                                                                                                             | `./Frame --kiosk`                   |
| `url`                   | Designates the startup URL.                                                                                                                                                                                                                                    | `./Frame --url=console.nutanix.com` |
| `x11-window`            | Switch from GTK (default) to X11 Windows. This argument should be used with HP ThinPro OS clients.                                                                                                                                                             | `./Frame --x11-window`              |

---
### Frame SAML2 Kiosk Mode Profile

```js
import 'igel/frame-saml2-kiosk-profile.xml'
```

This profile is designed to support a specific end user workflow and assumes a particular Frame configuration.

#### SAML2 Kiosk Mode User Experience

1. Frame App's cache is wiped to ensure a fresh session and authentication.
2. Frame App is launched in Kiosk Mode with multiple monitor support, presenting a third-party identity provider's login screen.
3. After logging in, end users will be taken by Frame App directly to the desktop or application (depends on the Launch Link configuration).
4. When a Frame session starts, the remote desktop will be in full-screen mode.
5. When end users disconnects by action or inactivity timeout, they'll see an option to resume their session for the duration of the account/Launchpad's configured idle timeout.
6. When a user quits the session or shuts down windows, they'll be logged out and redirected to the identity provider's initial login page.
7. If Frame App is closed, user can start a new session by launching Frame App with the Frame icon on the IGEL Desktop.

#### SAML2 + Kiosk mode requirements:

1. A *Published* Launchpad.
2. Configured identity provider with associated roles/permissions allowing access to the desired Frame Account.
3. Frame Launch Link with additional ["Quit and log out"](https://docs.fra.me/platform/session/advanced-integrations/#supported-query-params) url parameter: `&qlo=1`.
4. *Optional:* The Frame account production workload VMs can be joined to a Windows domain, if desired.

5. **Edit your IGEL UMS Custom Profile and go to**:
   > System > Firmware Customization > Environment Variables > Predefined

6. Paste your Launch Link:

     - `FRAME_LAUNCH_URL` - obtained from an Account's *Dashboard > Launchpad > Advanced Integrations* to get a configurable dialog with Launch Links. While we recommend Launch Links for Kiosk scenarios, the value of FRAME_LAUNCH_URL could instead be a standard Launchpad URL.

---

### Frame SAT Kiosk Mode Profile
```js
import 'igel/frame-sat-kiosk-profile.xml'
```

The Frame SAT Kiosk Custom Profile is designed to support a specific end user workflow relying on Frame's SATs or [Secure Anonymous Tokens](https://docs.fra.me/platform/identity-and-access/secure-anonymous-tokens/) for identity; this flow also assumes a particular Frame configuration to support the kiosk experience as defined below.

#### SAT Kiosk Mode User Experience:

1. End users will not authenticate to a SAML2-based identity provider (this script uses the Frame Secure Anonymous Token (SAT) functionality for session authentication).
2. User cache is removed prior to start of Frame App to ensure no user preference settings have persisted since the prior use of Frame App.
3. Frame App will launch in "kiosk mode" (full screen).
4. End users will be taken by Frame App directly to the desktop or application (depends on the [Launch Link](https://docs.fra.me/platform/session/advanced-integrations/#launch-links) configuration).
5. When a Frame session starts, the remote desktop will be in full-screen mode.
6. When end users disconnect or close their session, Frame App will be restarted with a new SAT token. Disconnect behavior configurable with Frame Session Settings.

#### SAT + Kiosk configuration requirements:

1. A *Published* Launchpad.
2. API Provider configured at the Organization entity.
3. Secure Anonymous Token Provider at the Account entity granting a role of Launchpad User for a specific Launchpad in a Frame account (under the Organization entity).
4. Frame [Launch Link](https://docs.fra.me/platform/session/advanced-integrations/#launch-links) is used, rather than a Launchpad URL to support automatic start of the user's session and to simplify the UX.
5. *Optional:* The Frame account production workload VMs can be joined to a Windows domain, if desired.


#### Environment Variables

The following environment variables must be configured in the IGEL Custom Profile for this profile to work.

1. **Edit your IGEL UMS Custom Profile and go to**:
   > System > Firmware Customization > Environment Variables > Predefined

2. **Set the following environment variables:**
   - `FRAME_CLIENT_ID` - obtained from the API provider when a set of API credentials are created.
   - `FRAME_CLIENT_SECRET` - obtained from the API provider when a set of API credentials are created.
   -
      `FRAME_SAT_URL` - URL obtainable from the Playground.

      For example: `https://api.console.nutanix.com/v1/accounts/XXXXXXXX-XXXX-XXXX-XXXX-31d09e2881cd/secure-anonymous/secure-anon-XXXXXXXX-XXXX-XXXX-XXXX-c5e2dc93df1e/tokens`.
   - `FRAME_ACCOUNT_ID` - Sign in to [Frame Console](https://console.nutanix.com) as an Admin. Locate your account, click the three-dot menu, and select "update" to view the Account's entity settings. Next, copy the Account UUID from the browser's URL bar. For example: `https://console.nutanix.com/frame/account/YOUR-FRAME-ACCOUNT-UUID-HERE/basic-info`
   - `FRAME_EMAIL_DOMAIN` - email domain name used to create the anonymous user email addresses that will be visible in the Session Trail.
   - `FRAME_LAUNCH_URL` - obtained from an Account's *Dashboard > Launchpad > Advanced Integrations* to get a configurable dialog with Launch Links. While we recommend Launch Links for Kiosk scenarios, the value of FRAME_LAUNCH_URL could instead be a standard Launchpad URL.
   - `FRAME_TERMINAL_CONFIG_ID` - obtainable from the Launch Link URL or from your [Launchpad Settings -> Session API Integration](https://docs.fra.me/dev-hub/session-api/#required-session-api-components) dialog.
   - `FRAME_LOGOUT_URL` - Optional. Allows configuration of the "logout" behavior by specifying a URL. Useful when using a Frame Launch Link with additional ["Quit and log out"](https://docs.fra.me/platform/session/advanced-integrations/#supported-query-params) url parameter: `&qlo=1`.
   - `SESSION_RETRY_DURATION_MINUTES` - Optional. Default value of 10 (minutes). Specifies the duration this script will wait for a Session to connect to the workload VM. After this threshold is reached, the script will quit start over and try again.
   
---

### Frame Admin API and SAT quick setup guide

1. Enable API access

   > Account > Users > Authentication

   ![Enable API](images/Frame_04.png)

2. Add an API

   > Account > Users > API

   Create an API with with the ability to generate anonymous tokens an account or organization.

   ![API - Generate](images/Frame_05.png)

3. Create a set of credentials for use with the Custom Profile.
   <figure>

   ![Manage Credentials](images/Frame_06.png)
   <figcaption>Manage Credentials</figcaption>
   </figure>

   <figure>

   ![Create new API key](images/Frame_07.png)
   <figcaption>Create new API key</figcaption>
   </figure>

   <figure>

   ![Copy the credentials. Keep it secret; keep it safe.](images/Frame_08.png)
   <figcaption>Copy the credentials for use in the IGEL Environment Variables. Keep it secret; keep it safe.</figcaption>
   </figure>

### Secure Anonymous Access Setup

#### 1. Enable "Secure Anonymous" access

  > Account > Users > Authentication

  ![Secure Anonymous](images/Frame_01.png)

#### 2. Create Anonymous Access Provider

  > Account > Users > Secure Anonymous

  ![Add Provider](images/Frame_02.png)

#### 3. Add the Launchpad User role to the Provider

![Add Provider](images/Frame_03.png)

**Note:** If Launchpad User Role is not visible on the list, be sure you've created a launchpad first. If you have, refresh the page and try again.

#### 4. Copy Provide URL from Playground Examples

![Anon Provider Playground](images/Frame_09.png)
![Copy Provider URI](images/Frame_10.png)

-----

## Additional Frame Profile Customizations

In order to hide taskbar and disable any user interaction with IGEL OS, following options must be enabled inside profile:

- User Interface - Desktop - Taskbar - Uncheck ‘Use Taskbar’
- User Interface - Desktop - Start Menu - Uncheck all options
