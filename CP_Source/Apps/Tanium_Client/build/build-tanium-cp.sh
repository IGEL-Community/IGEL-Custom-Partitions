#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Tanium Client
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain latest package and save into Downloads
# Download App for Linux (Debian)
# https://docs.tanium.com/client/client/deployment.html
# taniumclient_7.4.7.1094-ubuntu18_amd64.deb
if ! compgen -G "$HOME/Downloads/taniumclient_*-ubuntu18_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://docs.tanium.com/client/client/deployment.html"
  exit 1
fi
if ! compgen -G "$HOME/Downloads/tanium-init.dat" > /dev/null; then
  echo "***********"
  echo "Obtain your site's tanium-init.dat file, save into $HOME/Downloads and re-run this script "
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/tanium

dpkg -x $HOME/Downloads/taniumclient_*-ubuntu18_amd64.deb custom/tanium
cp $HOME/Downloads/tanium-init.dat custom/tanium/opt/Tanium/TaniumClient

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Tanium_Client.zip

unzip Tanium_Client.zip -d custom
mv custom/target/build/tanium-cp-init-script.sh custom

mkdir -p custom/tanium/bin
mv custom/target/build/igel_start_tanium.sh custom/tanium/bin

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/taniumclient_*-ubuntu18_amd64.deb
tar xf control.tar.* ./control
#VERSION=$(grep Version control | cut -d " " -f 2)
VERSION=$(grep Version control | cut -d " " -f 2 | cut -d "-" -f 1)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/tanium.inf
####****  ADD SED for XML Profile ****####
sed -i "s/TVERNUM/${VERSION}/" igel/tanium-profile.xml
#echo "tanium.inf file is:"
#cat target/tanium.inf

# new build process into zip file
tar cvjf target/tanium.tar.bz2 tanium tanium-cp-init-script.sh
zip -g ../Tanium_Client.zip target/tanium.tar.bz2 target/tanium.inf igel/tanium-profile.xml
zip -d ../Tanium_Client.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Tanium_Client.zip ../../Tanium_Client-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
