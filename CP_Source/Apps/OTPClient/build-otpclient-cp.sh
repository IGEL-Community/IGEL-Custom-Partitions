#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for otpclient
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y
sudo add-apt-repository ppa:dawidd0811/otpclient -y
sudo apt-get update

mkdir build_tar
cd build_tar

apt-get download otpclient
apt-get download libcotp12
apt-get download libzbar0
apt-get download libzip4
apt-get download libbaseencode1

mkdir -p custom/otpclient

dpkg -x otpclient_* custom/otpclient
dpkg -x libc* custom/otpclient
dpkg -x libzb* custom/otpclient
dpkg -x libzi* custom/otpclient
dpkg -x libb* custom/otpclient

mv custom/otpclient/usr/share/applications/ custom/otpclient/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/OTPClient.zip

unzip OTPClient.zip -d custom
mkdir -p custom/otpclient/config/bin
mkdir -p custom/otpclient/lib/systemd/system
mv custom/target/otpclient_cp_apparmor_reload custom/otpclient/config/bin
mv custom/target/igel-otpclient-cp-apparmor-reload.service custom/otpclient/lib/systemd/system/
mv custom/target/otpclient-cp-init-script.sh custom

cd custom

tar cvjf otpclient.tar.bz2 otpclient otpclient-cp-init-script.sh
mv otpclient.tar.bz2 ../..
mv target/otpclient.inf ../..

cd ../..
rm -rf build_tar
