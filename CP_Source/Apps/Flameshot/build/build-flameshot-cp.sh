#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for flameshot
## Development machine (Ubuntu 18.04)

MISSING_LIBS="flameshot libdouble-conversion1 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libxcb-xinerama0 qt5-gtk-platformtheme qttranslations5-l10n"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/flameshot

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/flameshot
done

mv custom/flameshot/usr/share/applications/ custom/flameshot/usr/share/applications.mime
mkdir -p custom/flameshot/userhome/.config/Dharkael

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/flameshot/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/flameshot/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Flameshot.zip

unzip Flameshot.zip -d custom
mv custom/target/build/flameshot-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../flameshot_*_amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/flameshot.inf
#echo "flameshot.inf file is:"
#cat target/flameshot.inf

# new build process into zip file
tar cvjf target/flameshot.tar.bz2 flameshot flameshot-cp-init-script.sh
zip -g ../Flameshot.zip target/flameshot.tar.bz2 target/flameshot.inf
zip -d ../Flameshot.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Flameshot.zip ../../Flameshot-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
