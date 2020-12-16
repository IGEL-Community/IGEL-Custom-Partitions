#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Slack
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain link to latest package and save into Downloads
# https://slack.com/downloads/linux
if ! compgen -G "$HOME/Downloads/slack-desktop-*.deb" > /dev/null; then
  echo "***********"
  echo "Download latest .deb package and re-run this script "
  echo "# https://slack.com/downloads/linux"
  echo "***********"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/slack

dpkg -x $HOME/Downloads/slack-desktop-*.deb custom/slack

mv custom/slack/usr/share/applications/ custom/slack/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Slack.zip

unzip Slack.zip -d custom
mkdir -p custom/slack/config/bin
mkdir -p custom/slack/lib/systemd/system
mv custom/target/slack_cp_apparmor_reload custom/slack/config/bin
mv custom/target/igel-slack-cp-apparmor-reload.service custom/slack/lib/systemd/system/
mv custom/target/slack-cp-init-script.sh custom

cd custom

tar cvjf slack.tar.bz2 slack slack-cp-init-script.sh
mv slack.tar.bz2 ../..
mv target/slack.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
