#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for FortiClient
## Development machine (Ubuntu 18.04)
sudo apt install curl -y
sudo apt install unzip -y
sudo curl https://repo.fortinet.com/repo/6.4/ubuntu/DEB-GPG-KEY | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://repo.fortinet.com/repo/6.4/ubuntu/ /bionic multiverse" > /etc/apt/sources.list.d/forticlient.list'
sudo apt-get update

mkdir build_tar
cd build_tar

apt-get download forticlient
apt-get download libindicator7
apt-get download libappindicator1

mkdir -p custom/forticlient

dpkg -x forticlient* custom/forticlient
dpkg -x libindicator7* custom/forticlient
dpkg -x libappindicator1* custom/forticlient

mv custom/forticlient/usr/share/applications/ custom/forticlient/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/FortiClient.zip

unzip FortiClient.zip -d custom
mkdir -p custom/forticlient/config/bin
mkdir -p custom/forticlient/lib/systemd/system
mv custom/target/forticlient_cp_apparmor_reload custom/forticlient/config/bin
mv custom/target/igel-forticlient-cp-apparmor-reload.service custom/forticlient/lib/systemd/system/
mv custom/target/forticlient-cp-init-script.sh custom

cd custom

tar cvjf forticlient.tar.bz2 forticlient forticlient-cp-init-script.sh
mv forticlient.tar.bz2 ../..
mv target/forticlient.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
