# Microsoft Teams (9 October)

|  CP Information |            |
|-----------------|------------|
| Package | Microsoft Teams - Current Version |
| Script Name | [teams-cp-init-script.sh](teams-cp-init-script.sh) |
| CP Mount Path | /custom/teams |
| CP Size | 500M |
| IGEL OS Version (min) | 11.3.110 |
| Path to Executable | /custom/teams/usr/bin/teams [--proxy-server=http://proxy-host:proxy-port]|
| Path to Icon | /custom/teams/usr/share/pixmaps/teams.png |
| Packaging Notes | See build script for details |
| Package automation | [build-teams-cp.sh](build-teams-cp.sh) <br /><br />[Microsoft Teams Linux Versions](https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/) <br /><br /> Tested with 1.3.00.25560, 1.3.00.30857, 1.4.00.7556, 1.4.00.13653 1.4.00.26453 |

**NOTES:**

To use Teams over a proxy server append the following to Path to Executable:

```{use proxy server}
--proxy-server=http://proxy-host:proxy-port
  ```

| Customization | /wfs/user/.config/Microsoft/Microsoft Teams/desktop-config.json |
|---------------|----------------------- |
| English US | {currentWebLanguage":"en-us"} |
| German | {currentWebLanguage":"de-de"} |

Sample for setting German language (reboot required after CP deployed)
![desktop-config.json language German](teams-desktop-config-json-lang-german.png)

**Automation Notes:** [build-teams-cp.sh](build-teams-cp.sh)

Add respsitory:

```{add-respsitory}
sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list
sudo apt-get update
   ```
