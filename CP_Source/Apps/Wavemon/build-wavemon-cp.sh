#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Wavemon
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

mkdir build_tar
cd build_tar

apt-get download wavemon

mkdir -p custom/wavemon

dpkg -x wavemon_* custom/wavemon

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Wavemon.zip

unzip Wavemon.zip -d custom
mv custom/target/wavemon-cp-init-script.sh custom

cd custom

tar cvjf wavemon.tar.bz2 wavemon wavemon-cp-init-script.sh
mv wavemon.tar.bz2 ../..
mv target/wavemon.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
