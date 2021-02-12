#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Google Chrome
## Development machine (Ubuntu 18.04)
sudo apt install curl -y
sudo apt install unzip -y
sudo curl https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo sh -c 'echo "deb [arch=amd64] http://packages.cloud.google.com/apt endpoint-verification main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update

mkdir build_tar
cd build_tar

apt-get download google-chrome-stable
apt-get download endpoint-verification

mkdir -p custom/chrome

dpkg -x google* custom/chrome
dpkg -x endpoint* custom/chrome

mv custom/chrome/usr/share/applications/ custom/chrome/usr/share/applications.mime
mkdir -p custom/chrome/userhome/.config/google-chrome

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Browsers/Google_Chrome.zip

unzip Google_Chrome.zip -d custom
mkdir -p custom/chrome/config/bin
mkdir -p custom/chrome/lib/systemd/system
mv custom/target/chrome_cp_apparmor_reload custom/chrome/config/bin
mv custom/target/igel-chrome-cp-apparmor-reload.service custom/chrome/lib/systemd/system/
mv custom/target/chrome-cp-init-script.sh custom

cd custom

tar cvjf chrome.tar.bz2 chrome chrome-cp-init-script.sh
mv chrome.tar.bz2 ../..
mv target/chrome.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
