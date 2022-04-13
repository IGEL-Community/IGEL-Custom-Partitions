#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for FortiClient
## Development machine (Ubuntu 18.04)

# https://www.fortinet.com/support/product-downloads/linux?msclkid=eab32f74ba6c11ecafb7d89dcf570180

sudo curl https://repo.fortinet.com/repo/6.4/ubuntu/DEB-GPG-KEY | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://repo.fortinet.com/repo/6.4/ubuntu/ /bionic multiverse" > /etc/apt/sources.list.d/fortinet-stable.list'
sudo apt-get update

#MISSING_LIBS="forticlient gconf-service gconf-service-backend gconf2-common libappindicator1 libgconf-2-4 libindicator7"
MISSING_LIBS="forticlient libappindicator1 libindicator7"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/forticlient

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/forticlient
done

mv custom/forticlient/usr/share/applications/ custom/forticlient/usr/share/applications.mime

mkdir -p custom/forticlient/userhome/.config/FortiClient

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Fortinet_FortiClient.zip

unzip Fortinet_FortiClient.zip -d custom
mv custom/target/build/forticlient-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../forticlient*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/forticlient.inf
#echo "forticlient.inf file is:"
#cat target/forticlient.inf

# new build process into zip file
tar cvjf target/forticlient.tar.bz2 forticlient forticlient-cp-init-script.sh
zip -g ../Fortinet_FortiClient.zip target/forticlient.tar.bz2 target/forticlient.inf
zip -d ../Fortinet_FortiClient.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Fortinet_FortiClient.zip ../../Fortinet_FortiClient-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
