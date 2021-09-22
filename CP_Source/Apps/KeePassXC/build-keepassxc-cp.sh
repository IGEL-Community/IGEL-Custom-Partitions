#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for keepassxc
## Development machine (Ubuntu 18.04)

#sudo add-apt-repository ppa:phoerious/keepassxc
sudo sh -c 'echo "deb [arch=amd64] http://ppa.launchpad.net/phoerious/keepassxc/ubuntu main" > /etc/apt/sources.list.d/phoerious-ubuntu-keepassxc-bionic.list'
sudo apt-get update
MISSING_LIBS="keepassxc libdouble-conversion1 libqrencode3 libqt5concurrent5 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libqt5x11extras5 libquazip5-1 libxcb-xinerama0 libykpers-1-1 libyubikey0 libzxcvbn0 qt5-gtk-platformtheme qttranslations5-l10n"

#MISSING_LIBS="keepassxc libdouble-conversion1 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libqt5x11extras5 libxcb-xinerama0 libykpers-1-1 libyubikey0 libzxcvbn0 qt5-gtk-platformtheme qttranslations5-l10n"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/keepassxc

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/keepassxc
done

mv custom/keepassxc/usr/share/applications/ custom/keepassxc/usr/share/applications.mime
mkdir -p custom/keepassxc/userhome/.config/keepassxc
mkdir -p custom/keepassxc/userhome/KeePassXCDB

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/KeePassXC.zip

unzip KeePassXC.zip -d custom
mv custom/target/keepassxc-cp-init-script.sh custom

cd custom

tar cvjf keepassxc.tar.bz2 keepassxc keepassxc-cp-init-script.sh
mv keepassxc.tar.bz2 ../..
mv target/keepassxc.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
