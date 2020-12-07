#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Devolutions Remote Desktop Manager Free
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

mkdir build_tar
cd build_tar

# Obtain link to latest package and copy into same folder as this script
# https://remotedesktopmanager.com/home/thankyou/rdmlinuxfreebin
if ! compgen -G "../RemoteDesktopManager*.deb" > /dev/null; then
  echo "***********"
  echo "Download latest package and re-run this script "
  echo "https://remotedesktopmanager.com/home/thankyou/rdmlinuxfreebin"
  echo "***********"
  exit 1
fi

mkdir -p custom/rdm

dpkg -x RemoteDesktopManager*.deb custom/rdm

mv custom/rdm/usr/share/applications/ custom/rdm/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Devolutions_RemoteDesktopManager_Free.zip

unzip Devolutions_RemoteDesktopManager_Free.zip -d custom
mkdir -p custom/rdm/config/bin
mkdir -p custom/rdm/lib/systemd/system
mv custom/target/rdm_cp_apparmor_reload custom/rdm/config/bin
mv custom/target/igel-rdm-cp-apparmor-reload.service custom/rdm/lib/systemd/system/
mv custom/target/rdm-cp-init-script.sh custom

cd custom

tar cvjf rdm.tar.bz2 rdm rdm-cp-init-script.sh
mv rdm.tar.bz2 ../..
mv target/rdm.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
