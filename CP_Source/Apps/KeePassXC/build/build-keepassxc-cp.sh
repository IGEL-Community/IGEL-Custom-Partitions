#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for keepassxc
## Development machine (Ubuntu 18.04)

#version 2.7.4 on 221230
sudo add-apt-repository ppa:phoerious/keepassxc
#sudo sh -c 'echo "deb [arch=amd64] http://ppa.launchpadcontent.net/phoerious/keepassxc/ubuntu bionic main" > /etc/apt/sources.list.d/phoerious-ubuntu-keepassxc-bionic.list'
sudo apt-get update
MISSING_LIBS="keepassxc libbotan-kpxc-2 libdouble-conversion1 libminizip1 libqrencode3 libqt5concurrent5 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libqt5x11extras5 libquazip5-1 libtspi1 libxcb-xinerama0 libykpers-1-1 libyubikey0 libzxcvbn0 qt5-gtk-platformtheme qttranslations5-l10n"

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

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/keepassxc/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/keepassxc/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

mkdir -p custom/keepassxc/userhome/.config/keepassxc
mkdir -p custom/keepassxc/userhome/KeePassXCDB

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/KeePassXC.zip

unzip KeePassXC.zip -d custom
mv custom/target/build/keepassxc-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../keepassxc*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/keepassxc.inf
#echo "keepassxc.inf file is:"
#cat target/keepassxc.inf

# new build process into zip file
tar cvjf target/keepassxc.tar.bz2 keepassxc keepassxc-cp-init-script.sh
zip -g ../KeePassXC.zip target/keepassxc.tar.bz2 target/keepassxc.inf
zip -d ../KeePassXC.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../KeePassXC.zip ../../KeePassXC-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
