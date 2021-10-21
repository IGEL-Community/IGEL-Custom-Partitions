#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Talkdesk Callbar
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain link to latest package and save into Downloads
# https://downloadcallbar.talkdesk.com/download.html?platform=linux
if ! compgen -G "$HOME/Downloads/Callbar_*_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Download latest amd64.deb package and re-run this script "
  echo "https://downloadcallbar.talkdesk.com/download.html?platform=linux"
  echo "***********"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/talkdesk

dpkg -x $HOME/Downloads/Callbar_*_amd64.deb custom/talkdesk

mv custom/talkdesk/usr/share/applications/ custom/talkdesk/usr/share/applications.mime

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/talkdesk/userhome/.config/Callbar

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Talkdesk.zip

unzip Talkdesk.zip -d custom
mkdir -p custom/talkdesk/config/bin
mkdir -p custom/talkdesk/lib/systemd/system
mv custom/target/talkdesk_cp_apparmor_reload custom/talkdesk/config/bin
mv custom/target/igel-talkdesk-cp-apparmor-reload.service custom/talkdesk/lib/systemd/system/
mv custom/target/talkdesk-cp-init-script.sh custom

cd custom

tar cvjf talkdesk.tar.bz2 talkdesk talkdesk-cp-init-script.sh
mv talkdesk.tar.bz2 ../..
mv target/talkdesk.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
