#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for DVDTOOLS
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

mkdir build_tar
cd build_tar

apt-get download wodim
apt-get download dvd+rw-tools
apt-get download genisoimage
apt-get download growisofs

mkdir -p custom/dvdtools

dpkg -x wodim*.deb custom/dvdtools
dpkg -x dvd+rw-tools*.deb custom/dvdtools
dpkg -x genisoimage*.deb custom/dvdtools
dpkg -x growisofs*.deb custom/dvdtools

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/DVDTools.zip

unzip DVDTools.zip -d custom
mv custom/target/dvdtools-cp-init-script.sh custom

cd custom

tar cvjf dvdtools.tar.bz2 dvdtools dvdtools-cp-init-script.sh
mv dvdtools.tar.bz2 ../..
mv target/dvdtools.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
