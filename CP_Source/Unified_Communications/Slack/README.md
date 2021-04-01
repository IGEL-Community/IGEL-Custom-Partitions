# Slack (1 April Updated)

|  CP Information |            |
|-----------------|------------|
| Package | Slack - Current Version |
| Script Name | [slack-cp-init-script.sh](slack-cp-init-script.sh) |
| CP Mount Path | /custom/slack |
| CP Size | 300M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> slack.inf | [INFO] <br /> [PART] <br /> file="slack.tar.bz2" <br /> version="4.14.0" <br /> size="300M" <br /> minfw="11.03.110" |
| Path to Executable | /custom/slack/usr/bin/slack |
| Path to Icon | /custom/slack/usr/share/pixmaps/slack.png |
| Missing Libraries | None |
| Download package | Manually download .deb (64-Bit) ([LINK](https://slack.com/downloads/linux)) latest package and place into ~/Downloads folder |
| Packaging notes | Create folder: **slack** <br /><br /> dpkg -x <package/lib> custom/slack <br /><br /> Need to move the mime folder: <br /><br />mv /custom/slack/usr/share/applications /custom/slack/usr/share/applications.mime <br /><br />The init script needs additional files to configure AppArmor: <br /><br /> /custom/slack/config/bin/[slack_cp_apparmor_reload](slack_cp_apparmor_reload) <br /> /custom/slack/lib/systemd/system/[igel-slack-cp-apparmor-reload.service](igel-slack-cp-apparmor-reload.service) |
| Package automation | [build-slack-cp.sh](build-slack-cp.sh) <br /><br /> Tested with 4.14.0  |
