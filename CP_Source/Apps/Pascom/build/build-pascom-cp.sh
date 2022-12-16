#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for pascom desktop client
## Development machine (Ubuntu 18.04)

# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://www.pascom.net/en/downloads/
if ! compgen -G "$HOME/Downloads/pascom_Client*.tar.bz2" > /dev/null; then
  echo "***********"
  echo "Obtain latest package, save into $HOME/Downloads and re-run this script "
  echo "https://www.pascom.net/en/downloads/"
  echo "***********"
  exit 1
fi
sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom

cd custom
tar xvf $HOME/Downloads/pascom_Client*.tar.bz2
cd ..

mkdir -p custom/pascom_Client/userhome/.local/share/AppRun

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Pascom.zip

unzip Pascom.zip -d custom
mv custom/target/pascom-cp-init-script.sh custom

cd custom

# edit inf file for version number
VERSION=$(basename $HOME/Downloads/pascom_Client*.tar.bz2 | cut -c 15- | rev | cut -c 9- | rev)
#echo "Version is: " ${VERSION}
sed -i "/^version=/c version=\"${VERSION}\"" target/pascom.inf
#echo "pascom.inf file is:"
#cat target/pascom.inf

# new build process into zip file
tar cvjf target/pascom.tar.bz2 pascom pascom-cp-init-script.sh
zip -g ../Pascom.zip target/pascom.tar.bz2 target/pascom.inf
zip -d ../Pascom.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Pascom.zip ../../Pascom-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
