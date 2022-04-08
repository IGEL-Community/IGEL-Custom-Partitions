#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Privoxy
## Development machine (Ubuntu 18.04)
# https://www.privoxy.org/
# https://www.privoxy.org/sf-download-mirror/Sources/3.0.33%20%28stable%29/privoxy-3.0.33-stable-src.tar.gz
VERSION=3.0.33

#MISSING_LIBS="libpcre3 zlib1g"

START_FOLDER=$(pwd)
BUILD_FOLDER=$START_FOLDER/build_tar

sudo apt install unzip -y

# build

mkdir build_tar
cd build_tar

#for lib in $MISSING_LIBS; do
  #apt-get download $lib
#done

sudo mkdir -p /custom/privoxy/usr
sudo chmod -R a+rwx /custom

# START download and compile source code:
mkdir build_src
cd build_src

#get the VERSION of source file
wget https://www.privoxy.org/sf-download-mirror/Sources/3.0.33%20%28stable%29/privoxy-3.0.33-stable-src.tar.gz
mkdir igel
tar xvf *.tar.gz --directory=igel

sudo apt-get install build-essential -y
sudo apt install autoconf -y
sudo apt install zlib1g-dev -y
sudo apt install libpcre3-dev -y
sudo sed -i '$a privoxy:x:7777:7777:privoxy proxy:/no/home:/no/shell' /etc/passwd
sudo sed -i '$a privoxy:x:7777:' /etc/group
cd igel/privoxy*
autoheader
autoconf
 ./configure --prefix=/custom/privoxy --with-user=root --with-group=root
make
sudo make install
sudo mv /custom/privoxy/share /custom/privoxy/usr
sudo mv /custom/privoxy/sbin /custom/privoxy/usr
cd ../../..
pwd
# END download and compile source code:

#find . -type f -name "*.deb" | while read LINE
#do
  #sudo dpkg -x "${LINE}" /custom/privoxy
#done

#echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
#wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
#chmod a+x clean_cp_usr_lib.sh
#wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
#chmod a+x clean_cp_usr_share.sh
#sudo ./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt /custom/privoxy/usr/lib
#sudo ./clean_cp_usr_share.sh 11.05.133_usr_share.txt /custom/privoxy/usr/share
#echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Network/Privoxy.zip

sudo unzip Privoxy.zip -d /custom
sudo mv /custom/target/build/privoxy-cp-init-script.sh /custom

cd /custom

# edit inf file for version number
sudo sed -i "/^version=/c version=\"${VERSION}\"" target/privoxy.inf
#echo "privoxy.inf file is:"
#cat target/privoxy.inf

# new build process into zip file
sudo tar cvjf target/privoxy.tar.bz2 privoxy privoxy-cp-init-script.sh
sudo zip -g $BUILD_FOLDER/Privoxy.zip target/privoxy.tar.bz2 target/privoxy.inf
zip -d $BUILD_FOLDER/Privoxy.zip "target/build/*" "target/igel/*" "target/target/*"
mv $BUILD_FOLDER/Privoxy.zip $START_FOLDER/Privoxy-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
