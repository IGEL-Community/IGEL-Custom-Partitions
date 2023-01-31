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

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/gpvpn

dpkg -x $HOME/Downloads/GlobalProtect_UI_deb-*.deb custom/gpvpn

mv custom/gpvpn/usr/share/applications/ custom/gpvpn/usr/share/applications.mime
GPDIR=/opt/paloaltonetworks/globalprotect
cp custom/gpvpn/$GPDIR/gp.desktop custom/gpvpn/usr/share/applications.mime/gp.desktop

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
