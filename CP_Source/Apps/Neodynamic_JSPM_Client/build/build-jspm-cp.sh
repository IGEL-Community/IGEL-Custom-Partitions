#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Neodynamic JSPrintManager Client
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
#https://www.neodynamic.com/downloads/jspm
# https://www.neodynamic.com/downloads/jspm/jspm5-5.0.22.801-amd64.deb
if ! compgen -G "$HOME/Downloads/jspm*-amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://www.neodynamic.com/downloads/jspm"
  echo "***********"
  exit 1
fi

MISSING_LIBS="libappindicator1 libfreeimage3 sane"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/jspm

dpkg -x $HOME/Downloads/jspm*-amd64.deb custom/jspm

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/jspm
done

mkdir -p custom/jspm/userhome/.neodynamic

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.07.100_usr_lib.txt custom/jspm/usr/lib
./clean_cp_usr_share.sh 11.07.100_usr_share.txt custom/jspm/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Neodynamic_JSPM_Client.zip

unzip Neodynamic_JSPM_Client.zip -d custom
mv custom/target/build/jspm-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/jspm*-amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/jspm.inf
#echo "jspm.inf file is:"
#cat target/jspm.inf

# new build process into zip file
tar cvjf target/jspm.tar.bz2 jspm jspm-cp-init-script.sh
zip -g ../Neodynamic_JSPM_Client.zip target/jspm.tar.bz2 target/jspm.inf
zip -d ../Neodynamic_JSPM_Client.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Neodynamic_JSPM_Client.zip ../../Neodynamic_JSPM_Client-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
