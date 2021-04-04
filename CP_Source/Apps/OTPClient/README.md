# OTPClient (3 April Updated)

|  CP Information |            |
|-----------------|------------|
| Package | [OTPClient](https://github.com/paolostivanin/OTPClient/wiki/How-to-use-OTPClient)  <br /><br /> OTPClient is a highly secure and easy to use GTK+ 2FA tool that supports both time-based one-time Passwords (TOTP) and HMAC-based one-time passwords (HOTP). Other features include: <br /><br /> - Custom digits (between 4 and 10 inclusive) <br /> - Custom period for codes to be valid (between 10 and 120 seconds inclusive) <br /> - Supports SHA1, SHA256 and SHA512 algorithms <br /> - Supports steam codes <br /> - Import encrypted Authenticator Plus backup <br /> - Import and export encrypted and/or plain andOTP backup <br /> - Encrypted local database is encrypted using AES256-GCM |
| Script Name | [otpclient-cp-init-script.sh](otpclient-cp-init-script.sh) |
| CP Mount Path | /custom/otpclient |
| CP Size | 20M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> otpclient.inf | [INFO] <br /> [PART] <br /> file="otpclient.tar.bz2" <br /> version="2.4.4" <br /> size="20M" <br /> minfw="11.04.240" |
| Path to Executable | /custom/otpclient/usr/bin/otpclient |
| Path to Icon | /custom/otpclient/usr/share/icons/hicolor/256x256/apps/com.github.paolostivanin.OTPClient.png |
| Packaging Notes | Details can be found in the build script [build-otpclient-cp.sh](build-otpclient-cp.sh) |
| Package automation | [build-otpclient-cp.sh](build-otpclient-cp.sh) <br /><br /> This script will compile the latest version |

-----
## Outstanding Issues

### 1 - Error trying to take screenshot

**/etc/dbus-1/session.d/org.gnome.Shell.Screenshot.conf** is not in IGEL OS systems.

![Error-Take-Screenshot](Error-Take-screenshot.png)
![GDBus.ErrorScreenshot](GDBus.ErrorScreenshot.png)

To remove menu item "Take screenshot", edit the following file to remove the following code:

```
OTPClient/src/ui/shortcuts.ui (currently lines 65,79):
<child>
  <object class="GtkModelButton" id="screenshot_model_btn_id">
    <property name="visible">True</property>
    <property name="can_focus">True</property>
    <property name="receives_default">True</property>
    <property name="action_name">add_menu.screenshot</property>
    <property name="text" translatable="yes">Take screenshot</property>
    <accelerator key="t" signal="activate" modifiers="GDK_CONTROL_MASK"/>
  </object>
  <packing>
    <property name="expand">False</property>
    <property name="fill">True</property>
    <property name="position">1</property>
  </packing>
</child>
  ```
Then rebuild package:

```
cd OTPClient/build
make clean
make
sudo make install
  ```  

### 2 - Saving configuration and database files after reboot

The [build-otpclient-cp.sh](build-otpclient-cp.sh) creates the OTPClient configuration file /userhome/.config/otpclient.cfg with the following contents:

```{config file}
[config]
column_id=0
sort_order=0
window_width=500
window_height=300
db_path=/userhome/otpclient/NewDatabase.enc
  ```
The database file has to be called **NewDatabase.enc** and must reside in **/userhome/otpclient** folder.
