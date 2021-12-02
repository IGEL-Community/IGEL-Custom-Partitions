# Google Chrome (2 December) (new format)

|  CP Information |            |
|-----------------|------------|
| Package | Google Chrome - Current Stable Version |
| Script Name | [chrome-cp-init-script.sh](build/chrome-cp-init-script.sh) |
| CP Mount Path | /custom/chrome |
| CP Size | 600M |
| IGEL OS Version (min) | 11.05.133 |
| Path to Executable | /custom/chrome/usr/bin/google-chrome-stable |
| Path to Icon | /custom/chrome/opt/google/chrome/product_logo_256.png |
| Packaging Notes | See build script for details. |
| Package automation | [build-chrome-cp.sh](build/build-chrome-cp.sh) |

**Automation Notes:** [build-chrome-cp.sh](build/build-chrome-cp.sh)

Add respsitory:

```{add-respsitory}
sudo apt install curl -y
sudo curl https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
   ```

**Set up endpoint verification on your computer**

If you access your work account on a work or personal computer, your administrator might require you to set up endpoint verification. Endpoint verification lets the administrator review information about the device and control your access to apps based on your location, device security status, or other attributes.

[Steps to setup endpoint verification](https://support.google.com/a/users/answer/9018161?hl=en)
