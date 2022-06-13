#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Synergy
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
#synergy_1.14.4-stable.ad7273eb_ubuntu18_amd64.deb
if ! compgen -G "$HOME/Downloads/synergy_*_ubuntu18_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://symless.com/synergy/downloads"
  echo "***********"
  exit 1
fi

MISSING_LIBS="libdouble-conversion1 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libxcb-xinerama0 qt5-gtk-platformtheme qttranslations5-l10n"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/synergy

dpkg -x $HOME/Downloads/synergy_*_ubuntu18_amd64.deb custom/synergy

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/synergy
done

mv custom/synergy/usr/share/applications/ custom/synergy/usr/share/applications.mime
mkdir -p custom/synergy/userhome/.config/Synergy
mkdir -p custom/synergy/userhome/.synergy

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/synergy/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/synergy/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Synergy.zip

unzip Synergy.zip -d custom
mv custom/target/build/synergy-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/synergy_*_ubuntu18_amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/synergy.inf
#echo "synergy.inf file is:"
#cat target/synergy.inf

# new build process into zip file
tar cvjf target/synergy.tar.bz2 synergy synergy-cp-init-script.sh
zip -g ../Synergy.zip target/synergy.tar.bz2 target/synergy.inf
zip -d ../Synergy.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Synergy.zip ../../Synergy-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
