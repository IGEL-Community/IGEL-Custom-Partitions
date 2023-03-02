#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for rdesktop
## Development machine (Ubuntu 18.04)
MISSING_LIBS="libgssglue1 rdesktop"

sudo apt update -y

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/rdesktop

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/rdesktop
done

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Rdesktop.zip

unzip Rdesktop.zip -d custom
mv custom/target/build/rdesktop-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../rdesktop_*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/rdesktop.inf
#echo "rdesktop.inf file is:"
#cat target/rdesktop.inf

# new build process into zip file
tar cvjf target/rdesktop.tar.bz2 rdesktop rdesktop-cp-init-script.sh
zip -g ../Rdesktop.zip target/rdesktop.tar.bz2 target/rdesktop.inf
zip -d ../Rdesktop.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Rdesktop.zip ../../Rdesktop-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
