# Google Chrome

|  CP Information |            |
|-----------------|------------|
| Package | Google Chrome - Current Stable Version |
| Script Name | [chrome-cp-init-script.sh](chrome-cp-init-script.sh) |
| CP Mount Path | /custom/chrome |
| CP Size | 600M |
| IGEL OS Version (min) | 11.4.200 |
| Metadata File <br /> chrome.inf | [INFO] <br /> [PART] <br /> file="chrome.tar.bz2" <br /> version="87.0.4280.88" <br /> size="600M" <br /> name="chrome" <br /> minfw="11.03.110" |
| Path to Executable | /custom/chrome/usr/bin/google-chrome-stable |
| Path to Icon | /custom/chrome/opt/google/chrome/product_logo_256.png |
| Missing Libraries | None |
| Download package and missing library | apt-get download google-chrome-stable |
| Packaging Notes | Create folder: **chrome** <br /><br /> dpkg -x <package/lib> custom/chrome <br /><br /> Need to move the mime folder: <br /><br />mv /custom/chrome/usr/share/applications /custom/chrome/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/chrome/config/bin/[chrome_cp_apparmor_reload](chrome_cp_apparmor_reload) <br /> /custom/chrome/lib/systemd/system/[igel-chrome-cp-apparmor-reload.service](igel-chrome-cp-apparmor-reload.service) |
| Package automation | [build-chrome-cp.sh](build-chrome-cp.sh) <br /><br /> Tested with 87.0.4280.88 |

**Automation Notes:** [build-chrome-cp.sh](build-chrome-cp.sh)

Add respsitory:

```{add-respsitory}
sudo apt install curl -y
sudo curl https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
   ```
