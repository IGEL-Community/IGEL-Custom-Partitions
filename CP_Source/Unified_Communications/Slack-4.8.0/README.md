# Slack

|  CP Information |            |
|-----------------|------------|
| Package | Slack 4.8.0 |
| Script Name | [slack-cp-init-script.sh](slack-cp-init-script.sh) |
| CP Mount Path | /custom/slack |
| CP Size | 250M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> slack-4.8.0.inf | [INFO] <br /> [PART] <br /> file="slack_amd64_4.8.0.tar.bz2" <br /> version="4.8.0" <br /> size="250M" <br /> minfw="11.03.110" |
| Path to Executable | /custom/slack/usr/bin/slack |
| Path to Icon | /custom/slack/usr/share/pixmaps/slack.png |
| Missing Libraries | None |
| Packaging notes | On your Ubuntu packaging system: <br /> - Download Slack for Linux (Download .deb (64 bit)) [Slack Download](https://slack.com/downloads) <br /> - Extract Slack into folder "slack" (dpkg -x slack-version.deb slack) <br /> - Copy slack init script <br /> - Tar up package (tar cvjf slack_amd64_version.tar.bz2 slack-init-script slack)|
