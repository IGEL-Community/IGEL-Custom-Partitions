#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for SpeedCrunch
## Development machine (Ubuntu 18.04)

MISSING_LIBS="libdouble-conversion1 libqt5core5a libqt5dbus5 libqt5gui5 libqt5help5 libqt5network5 libqt5sql5 libqt5sql5-sqlite libqt5svg5 libqt5widgets5 libxcb-xinerama0 qt5-gtk-platformtheme qttranslations5-l10n speedcrunch"

sudo apt-get update
sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/speedcrunch

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/speedcrunch
done

mv custom/speedcrunch/usr/share/applications/ custom/speedcrunch/usr/share/applications.mime

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/speedcrunch/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/speedcrunch/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

mkdir -p custom/speedcrunch/userhome/.speedcrunch
mkdir -p custom/speedcrunch/userhome/.local/share/SpeedCrunch

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/SpeedCrunch.zip

unzip SpeedCrunch.zip -d custom
mv custom/target/build/speedcrunch-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../speedcrunch*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/speedcrunch.inf
#echo "speedcrunch.inf file is:"
#cat target/speedcrunch.inf

# new build process into zip file
tar cvjf target/speedcrunch.tar.bz2 speedcrunch speedcrunch-cp-init-script.sh
zip -g ../SpeedCrunch.zip target/speedcrunch.tar.bz2 target/speedcrunch.inf
zip -d ../SpeedCrunch.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../SpeedCrunch.zip ../../SpeedCrunch-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
