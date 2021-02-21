#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Conky
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

mkdir build_tar
cd build_tar

apt-get download conky
apt-get download conky-std
apt-get download libgif7
apt-get download libid3tag0
apt-get download libimlib2
apt-get download liblua5.1-0

mkdir -p custom/conky

dpkg -x conky_* custom/conky
dpkg -x conky-std_* custom/conky
dpkg -x libgif7_* custom/conky
dpkg -x libid3tag0_* custom/conky
dpkg -x libimlib2_* custom/conky
dpkg -x liblua5* custom/conky

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Conky.zip

unzip Conky.zip -d custom
mv custom/target/conky-cp-init-script.sh custom
mv custom/conky/etc/conky/conky.conf custom/conky/etc/conky/conky_orig.conf
mv custom/target/conky.conf custom/conky/etc/conky

cd custom

tar cvjf conky.tar.bz2 conky conky-cp-init-script.sh
mv conky.tar.bz2 ../..
mv target/conky.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
