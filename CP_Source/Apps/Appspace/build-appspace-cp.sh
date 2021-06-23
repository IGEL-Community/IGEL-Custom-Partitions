#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Appspace
## Development machine (Ubuntu 18.04)
# https://www.appspace.com/
# Obtain latest package and save into Downloads
if ! compgen -G "$HOME/Downloads/appspace*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest appspace package, save into $HOME/Downloads and re-run this script "
  echo "https://app12.cloud.appspace.com/console/#!/ext/downloads"
  echo "Select -- Appspace App for Ubuntu"
  echo "***********"
  exit 1
fi
sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/appspace

dpkg -x $HOME/Downloads/appspace*.deb custom/appspace

mv custom/appspace/usr/share/applications/ custom/appspace/usr/share/applications.mime
mkdir -p custom/appspace/userhome/.config/Appspace\ App

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Appspace.zip

unzip Appspace.zip -d custom
mkdir -p custom/appspace/config/bin
mkdir -p custom/appspace/lib/systemd/system
mv custom/target/appspace_cp_apparmor_reload custom/appspace/config/bin
mv custom/target/igel-appspace-cp-apparmor-reload.service custom/appspace/lib/systemd/system/
mv custom/target/appspace-cp-init-script.sh custom

cd custom

tar cvjf appspace.tar.bz2 appspace appspace-cp-init-script.sh
mv appspace.tar.bz2 ../..
mv target/appspace.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
