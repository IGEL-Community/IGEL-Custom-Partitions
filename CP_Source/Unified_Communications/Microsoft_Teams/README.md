# Microsoft Teams (24 April 2024)

**NOTE:** Microsoft dropped support for native Linux client and moved to PWA for Teams.

[HOWTO Microsoft Teams](https://igel-community.github.io/IGEL-Docs-v02/Docs/HOWTO-Microsoft-Teams-Optimization/)

<!---
This is a comment section
---------

|  CP Information |            |
|-----------------|------------|
| Package | Native Linux Microsoft Teams - Current Version |
| Script Name | [teams-cp-init-script.sh](build/teams-cp-init-script.sh) |
| CP Mount Path | /custom/teams |
| CP Size | 500M |
| IGEL OS Version (min) | 11.3.110 |
| Path to Executable | /custom/teams/usr/bin/teams |
| Path to Icon | /custom/teams/usr/share/pixmaps/teams.png |
| Packaging Notes | See build script for details |
| Package automation | [build-teams-cp.sh](build/build-teams-cp.sh) <br /><br />[Microsoft Teams Linux Versions](https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/) |

**NOTES:**

To use Teams over a proxy server, create a script with this content and use for the start of teams:

```
#!/bin/bash
export http_proxy=http://proxy-host:proxy-port
export https_proxy=https://proxy-host:proxy-port
teams --proxy-server=proxy-host:proxy-port
  ```

| Customization | /wfs/user/.config/Microsoft/Microsoft Teams/desktop-config.json |
|---------------|----------------------- |
| English US | {currentWebLanguage":"en-us"} |
| German | {currentWebLanguage":"de-de"} |

Sample for setting German language (reboot required after CP deployed)
![desktop-config.json language German](build/teams-desktop-config-json-lang-german.png)

**Automation Notes:** [build-teams-cp.sh](build/build-teams-cp.sh)

Add respsitory:

```{add-respsitory}
sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list
sudo apt-get update
   ```

-------

## Microsoft Teams Notes

[Microsoft Teams for Linux - Versions](https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/)

-->