# Slack (12 May)

|  CP Information |            |
|-----------------|-----------|
| Package | [Slack](https://slack.com/help/categories/360000049043-Getting-started#download-slack) - Current Version |
| Script Name | [slack-cp-init-script.sh](slack-cp-init-script.sh) |
| CP Mount Path | /custom/slack |
| CP Size | 600M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> slack.inf | [INFO] <br /> [PART] <br /> file="slack.tar.bz2" <br /> version="4.15.0" <br /> size="600M" <br /> minfw="11.04.240" |
| Path to Executable | /custom/slack/usr/bin/slack |
| Path to Icon | /custom/slack/usr/share/pixmaps/slack.png |
| Download package | Manually download .deb (64-Bit) ([LINK](https://slack.com/downloads/linux)) latest package and place into ~/Downloads folder |
| Packaging Notes | Details can be found in the build script [build-slack-cp.sh](build-slack-cp.sh) |
| Package automation | [build-slack-cp.sh](build-slack-cp.sh) <br /><br /> 4.15.0 is having sign in issues with AppArmor and we are looking into the issue. To disable AppArmor (System > Registry > system > security > Enable app armor profiles (uncheck))  |
