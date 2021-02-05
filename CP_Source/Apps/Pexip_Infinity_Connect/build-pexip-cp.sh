#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Pexip Infinity Connect
## Development machine (Ubuntu 18.04)

# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://www.pexip.com/apps
if ! compgen -G "$HOME/Downloads/pexip*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://www.pexip.com/apps"
  echo "***********"
  exit 1
fi
sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/pexip

dpkg -x pexip*.deb custom/pexip

mv custom/pexip/usr/share/applications/ custom/pexip/usr/share/applications.mime
mkdir -p custom/pexip/userhome/.config/pexip-infinity-connect

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Pexip_Infinity_Connect.zip

unzip Pexip_Infinity_Connect.zip -d custom
mkdir -p custom/pexip/config/bin
mkdir -p custom/pexip/lib/systemd/system
mv custom/target/pexip_cp_apparmor_reload custom/pexip/config/bin
mv custom/target/igel-pexip-cp-apparmor-reload.service custom/pexip/lib/systemd/system/
mv custom/target/pexip-cp-init-script.sh custom

cd custom

tar cvjf pexip.tar.bz2 pexip pexip-cp-init-script.sh
mv pexip.tar.bz2 ../..
mv target/pexip.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
