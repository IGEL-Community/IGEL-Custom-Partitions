# Slack (18 November)

|  CP Information |            |
|-----------------|-----------|
| Package | [Slack](https://slack.com/help/categories/360000049043-Getting-started#download-slack) - Current Version |
| Script Name | [slack-cp-init-script.sh](slack-cp-init-script.sh) |
| CP Mount Path | /custom/slack |
| CP Size | 600M |
| IGEL OS Version (min) | 11.05.133 |
| Path to Executable | /custom/slack/usr/bin/slack |
| Path to Icon | /custom/slack/usr/share/pixmaps/slack.png |
| Packaging Notes | Details can be found in the build script [build-slack-cp.sh](build-slack-cp.sh) |
| Package automation | [build-slack-cp.sh](build-slack-cp.sh) <br /><br /> 4.22.0 is having sign in issues with AppArmor and we are looking into the issue. To disable AppArmor (System > Registry > system > security > Enable app armor profiles (uncheck))  |
