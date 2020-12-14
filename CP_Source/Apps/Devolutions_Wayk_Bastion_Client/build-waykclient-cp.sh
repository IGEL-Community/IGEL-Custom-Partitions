#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Devolutions Wayk Bastion Client
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y
apt-get download libappindicator3-1

# Obtain link to latest package and savel into Downloads
# https://wayk.devolutions.net/home/thankyou/waykclientlinuxbin
if ! compgen -G "$HOME/Downloads/wayk-client*.deb" > /dev/null; then
  echo "***********"
  echo "Download latest package and re-run this script "
  echo "https://wayk.devolutions.net/home/thankyou/waykclientlinuxbin"
  echo "***********"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/waykclient

dpkg -x $HOME/Downloads/wayk-client*.deb custom/waykclient
rm -rf custom/waykclient/etc
dpkg -x ../libappindicator3-1*.deb custom/waykclient

mv custom/waykclient/usr/share/applications/ custom/waykclient/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Devolutions_Wayk_Bastion_Client.zip

unzip Devolutions_Wayk_Bastion_Client.zip -d custom
mkdir -p custom/waykclient/config/bin
mkdir -p custom/waykclient/lib/systemd/system
mv custom/target/waykclient_cp_apparmor_reload custom/waykclient/config/bin
mv custom/target/igel-waykclient-cp-apparmor-reload.service custom/waykclient/lib/systemd/system/
mv custom/target/waykclient-cp-init-script.sh custom

cd custom

tar cvjf waykclient.tar.bz2 waykclient waykclient-cp-init-script.sh
mv waykclient.tar.bz2 ../..
mv target/waykclient.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
rm libappindicator3-1*.deb
