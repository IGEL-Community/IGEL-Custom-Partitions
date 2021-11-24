#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Synergy
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
#synergy_1.14.2-stable.c6918b74_ubuntu18_amd64.deb
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

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Synergy.zip

unzip Synergy.zip -d custom
mv custom/target/synergy-cp-init-script.sh custom

cd custom

tar cvjf synergy.tar.bz2 synergy synergy-cp-init-script.sh
mv synergy.tar.bz2 ../..
mv target/synergy.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
