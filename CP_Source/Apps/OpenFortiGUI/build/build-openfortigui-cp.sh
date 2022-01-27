#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for OpenFortiGUI
## Development machine (Ubuntu 18.04)
#https://hadler.me/linux/openfortigui/
if ! compgen -G "$HOME/Downloads/openfortigui_*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest Ubuntu 18.04 .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://hadler.me/linux/openfortigui"
  exit 1
fi

MISSING_LIBS="libdouble-conversion1 libqt5core5a libqt5dbus5 libqt5gui5 libqt5keychain1 libqt5network5 libqt5svg5 libqt5widgets5 libxcb-xinerama0 qt5-gtk-platformtheme qttranslations5-l10n"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/openfortigui

dpkg -x ${HOME}/Downloads/openfortigui_*.deb custom/openfortigui

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/openfortigui
done

mv custom/openfortigui/usr/share/applications/ custom/openfortigui/usr/share/applications.mime

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/openfortigui/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/openfortigui/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

############################################
# START: comment out for non-persistency!!!!
############################################
#run as root
mkdir -p custom/openfortigui/root/.openfortigui

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/OpenFortiGUI.zip

unzip OpenFortiGUI.zip -d custom
mv custom/target/build/openfortigui-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ${HOME}/Downloads/openfortigui_*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/openfortigui.inf
#echo "openfortigui.inf file is:"
#cat target/openfortigui.inf

# new build process into zip file
tar cvjf target/openfortigui.tar.bz2 openfortigui openfortigui-cp-init-script.sh
zip -g ../OpenFortiGUI.zip target/openfortigui.tar.bz2 target/openfortigui.inf
zip -d ../OpenFortiGUI.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../OpenFortiGUI.zip ../../OpenFortiGUI-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
