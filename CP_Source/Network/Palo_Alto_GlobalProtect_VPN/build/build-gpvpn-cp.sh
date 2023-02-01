#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Palo_Alto_GlobalProtect_VPN
## Development machine (Ubuntu 18.04)
#https://docs.paloaltonetworks.com/globalprotect/5-1/globalprotect-app-user-guide/globalprotect-app-for-linux/download-and-install-the-globalprotect-app-for-linux
#GlobalProtect_UI_deb-6.0.4.1-28.deb
if ! compgen -G "$HOME/Downloads/GlobalProtect_UI_deb-*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain and extract the VPN client GlobalProtect_UI_deb-*.deb , save into $HOME/Downloads and re-run this script "
  echo "https://docs.paloaltonetworks.com/globalprotect/5-1/globalprotect-app-user-guide/globalprotect-app-for-linux/download-and-install-the-globalprotect-app-for-linux"
  exit 1
fi

MISSING_LIBS="libdouble-conversion1 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5positioning5 libqt5printsupport5 libqt5qml5 libqt5quick5 libqt5sensors5 libqt5svg5 libqt5webchannel5 libqt5webkit5 libqt5widgets5 libxcb-xinerama0 qt5-gtk-platformtheme qttranslations5-l10n"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/gpvpn

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/gpvpn
done

dpkg -x $HOME/Downloads/GlobalProtect_UI_deb-*.deb custom/gpvpn

mv custom/gpvpn/usr/share/applications/ custom/gpvpn/usr/share/applications.mime
GPDIR=/opt/paloaltonetworks/globalprotect
cp custom/gpvpn/$GPDIR/gp.desktop custom/gpvpn/usr/share/applications.mime/gp.desktop

mkdir -p custom/gpvpn/userhome/.GlobalProtect

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.07.100_usr_lib.txt custom/gpvpn/usr/lib
./clean_cp_usr_share.sh 11.07.100_usr_share.txt custom/gpvpn/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Network/Palo_Alto_GlobalProtect_VPN.zip

unzip Palo_Alto_GlobalProtect_VPN.zip -d custom
mv custom/target/build/gpvpn-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/GlobalProtect_UI_deb-*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/gpvpn.inf
#echo "gpvpn.inf file is:"
#cat target/gpvpn.inf

# new build process into zip file
tar cvjf target/gpvpn.tar.bz2 gpvpn gpvpn-cp-init-script.sh
zip -g ../Palo_Alto_GlobalProtect_VPN.zip target/gpvpn.tar.bz2 target/gpvpn.inf
zip -d ../Palo_Alto_GlobalProtect_VPN.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Palo_Alto_GlobalProtect_VPN.zip ../../Palo_Alto_GlobalProtect_VPN-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
