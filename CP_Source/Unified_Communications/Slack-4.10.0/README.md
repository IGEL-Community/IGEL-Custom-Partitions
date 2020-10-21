# Slack

|  CP Information |            |
|-----------------|------------|
| Package | Slack 4.10.0 |
| Script Name | [slack-cp-init-script.sh](slack-cp-init-script.sh) |
| CP Mount Path | /custom/slack |
| CP Size | 250M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> slack-4.10.0.inf | [INFO] <br /> [PART] <br /> file="slack_amd64_4.10.0.tar.bz2" <br /> version="4.10.0" <br /> size="250M" <br /> minfw="11.03.110" |
| Path to Executable | /custom/slack/usr/bin/slack |
| Path to Icon | /custom/slack/usr/share/pixmaps/slack.png |
| Missing Libraries | None |
| Packaging notes | On your Ubuntu packaging system: <br /><br /> - Download Slack for Linux (Download .deb (64 bit)) [DOWNLOAD .DEB](https://slack.com/downloads/linux) <br /><br /> - Extract Slack into folder "slack" (dpkg -x slack-version.deb slack) <br /><br /> - Move the mime folder: <br /> mv /custom/slack/usr/share/applications /custom/slack/usr/share/applications.mime <br /><br /> - Copy slack init script <br /><br /> - The init script needs additional files to configure AppArmor: <br /><br /> /custom/slack/config/bin/[slack_cp_apparmor_reload](slack_cp_apparmor_reload) <br /> /custom/slack/lib/systemd/system/[igel-slack-cp-apparmor-reload.service](igel-slack-cp-apparmor-reload.service) <br /><br /> - Tar up package (tar cvjf slack_amd64_version.tar.bz2 slack slack-init-script)|
