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

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/slack/userhome/.config/Slack

##########################################
# END: comment out for non-persistency!!!!
##########################################


wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Slack.zip

unzip Slack.zip -d custom
mkdir -p custom/slack/config/bin
mkdir -p custom/slack/lib/systemd/system
mv custom/target/build/slack_cp_apparmor_reload custom/slack/config/bin
mv custom/target/build/igel-slack-cp-apparmor-reload.service custom/slack/lib/systemd/system/
mv custom/target/build/slack-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/slack-desktop-*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/slack.inf
#echo "slack.inf file is:"
#cat target/slack.inf

# new build process into zip file
tar cvjf target/slack.tar.bz2 slack slack-cp-init-script.sh
zip -g ../Slack.zip target/slack.tar.bz2 target/slack.inf
zip -d ../Slack.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Slack.zip ../../Slack-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
