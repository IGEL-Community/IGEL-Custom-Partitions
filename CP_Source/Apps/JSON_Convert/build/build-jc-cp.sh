#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for JSON Convert
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://github.com/kellyjonbrazil/jc
# https://github.com/kellyjonbrazil/jc/releases
if ! compgen -G "$HOME/Downloads/jc_*_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://github.com/kellyjonbrazil/jc/releases"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/jc

dpkg -x $HOME/Downloads/jc_*_amd64.deb custom/jc

mv custom/jc/usr/local/bin custom/jc/usr/bin
rm -rf custom/jc/usr/local

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/JSON_Convert.zip

unzip JSON_Convert.zip -d custom
mv custom/target/build/jc-cp-init-script.sh custom
cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/vuex64-*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/jc.inf
#echo "jc.inf file is:"
#cat target/jc.inf

# new build process into zip file
tar cvjf target/jc.tar.bz2 jc jc-cp-init-script.sh
zip -g ../JSON_Convert.zip target/jc.tar.bz2 target/jc.inf
zip -d ../JSON_Convert.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../JSON_Convert.zip ../../JSON_Convert-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
