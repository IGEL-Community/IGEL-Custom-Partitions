#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Teradici PCoIP Client
## Development machine (Ubuntu 18.04)

sudo curl -1sLf https://dl.teradici.com/DeAdBCiUYInHcSTy/pcoip-client/cfg/setup/bash.deb.sh | sudo -E distro=ubuntu codename=bionic bash
sudo apt-get update
MISSING_LIBS="i965-va-driver libdouble-conversion1 libgraphicsmagick++-q16-12 libgraphicsmagick-q16-3 libhiredis0.13 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5opengl5 libqt5qml5 libqt5quick5 libqt5quickwidgets5 libqt5svg5 libqt5waylandclient5 libqt5waylandcompositor5 libqt5widgets5 libva-drm2 libva-x11-2 libva2 libxcb-xinerama0 mesa-va-drivers pcoip-client qml-module-qtgraphicaleffects qml-module-qtquick-controls qml-module-qtquick-layouts qml-module-qtquick-window2 qml-module-qtquick2 qt5-gtk-platformtheme qttranslations5-l10n qtwayland5 va-driver-all"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/pcoip

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/pcoip
done

mv custom/pcoip/usr/share/applications/ custom/pcoip/usr/share/applications.mime

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/pcoip/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/pcoip/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

mkdir -p custom/pcoip/userhome/.config/Teradici

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Teradici_PCoIP_Client.zip

unzip Teradici_PCoIP_Client.zip -d custom
mv custom/target/build/pcoip-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../pcoip-client*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/pcoip.inf
#echo "pcoip.inf file is:"
#cat target/pcoip.inf

# new build process into zip file
tar cvjf target/pcoip.tar.bz2 pcoip pcoip-cp-init-script.sh
zip -g ../Teradici_PCoIP_Client.zip target/pcoip.tar.bz2 target/pcoip.inf
zip -d ../Teradici_PCoIP_Client.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Teradici_PCoIP_Client.zip ../../Teradici_PCoIP_Client-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
