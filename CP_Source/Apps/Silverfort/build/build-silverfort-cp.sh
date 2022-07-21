#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Google silverfort
## Development machine (Ubuntu 18.04)
#silverfort-client_2.5.6_amd64.deb
if ! compgen -G "$HOME/Downloads/silverfort-client_*_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain the silverfort-client amd64.deb , save into $HOME/Downloads and re-run this script "
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/silverfort

dpkg -x $HOME/Downloads/silverfort-client_*_amd64.deb /custom/silverfort

mv custom/silverfort/usr/share/applications/ custom/silverfort/usr/share/applications.mime
mkdir -p /custom/silverfort/userhome/.pki/nssdb
mkdir -p /custom/silverfort/userhome/.config/Silverfort\ Client/

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Silverfort.zip

unzip Silverfort.zip -d custom
mkdir -p custom/silverfort/config/bin
mkdir -p custom/silverfort/lib/systemd/system
mv custom/target/build/silverfort_cp_apparmor_reload custom/silverfort/config/bin
mv custom/target/build/igel-silverfort-cp-apparmor-reload.service custom/silverfort/lib/systemd/system/
mv custom/target/build/silverfort-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/silverfort-client_*_amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/silverfort.inf
#echo "silverfort.inf file is:"
#cat target/silverfort.inf

# new build process into zip file
tar cvjf target/silverfort.tar.bz2 silverfort silverfort-cp-init-script.sh
zip -g ../Silverfort.zip target/silverfort.tar.bz2 target/silverfort.inf
zip -d ../Silverfort.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Silverfort.zip ../../Silverfort-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
