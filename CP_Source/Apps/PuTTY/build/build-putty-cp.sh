#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for PuTTY
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
#https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
#putty-0.78.tar.gz
if ! compgen -G "$HOME/Downloads/putty-*.tar.gz" > /dev/null; then
  echo "***********"
  echo "Obtain latest Unix source archive, save into $HOME/Downloads and re-run this script "
  echo "https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html"
  exit 1
fi

sudo apt install -y build-essential git libcurl4-gnutls-dev curl libssl-dev automake autoconf libtool cmake pkg-config libgcrypt20-dev libpng-dev libzip-dev libjansson-dev libzbar-dev libgtk-3-dev
sudo apt-get update

mkdir build_tar
cd build_tar

#compile PuTTY
mkdir putty_build
cd putty_build
tar xvf $HOME/Downloads/putty-*.tar.gz
cd putty-*
cmake .
cmake --build .
PUTTY_FILES="plink pscp psftp psusan puttygen pterm putty pageant"
tar cvf ../../cp-putty.tar ${PUTTY_FILES}
VERSION=$(grep "^#define RELEASE" version.h | cut -d " " -f 3)
cd ../..

mkdir -p custom/putty/usr/bin
tar xvf cp-putty.tar --directory custom/putty/usr/bin
chmod 755 custom/putty/usr/bin/*

mkdir -p custom/putty/userhome/.putty

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/PuTTY.zip

unzip PuTTY.zip -d custom
mv custom/target/build/putty-cp-init-script.sh custom

cd custom

# edit inf file for version number
#echo "Version is: " ${VERSION}
sed -i "/^version=/c version=\"${VERSION}\"" target/putty.inf
#echo "putty.inf file is:"
#cat target/putty.inf

# new build process into zip file
tar cvjf target/putty.tar.bz2 putty putty-cp-init-script.sh
zip -g ../PuTTY.zip target/putty.tar.bz2 target/putty.inf
zip -d ../PuTTY.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../PuTTY.zip ../../PuTTY-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
