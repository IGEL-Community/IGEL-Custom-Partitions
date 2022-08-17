#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for OneDrive Client
# https://github.com/abraunegg/onedrive
# https://github.com/abraunegg/onedrive/blob/master/docs/INSTALL.md
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

sudo apt install -y build-essential libcurl4-openssl-dev libsqlite3-dev pkg-config git curl libnotify-dev
curl -fsS https://dlang.org/install.sh | bash -s dmd
source ~/dlang/dmd-*/activate

mkdir -p build_tar/compile
cd build_tar/compile

git clone https://github.com/abraunegg/onedrive.git
cd onedrive
./configure
make clean
make
#sudo make install

cd ../..

mkdir -p custom/onedrive/usr/local/bin
mkdir -p custom/onedrive/usr/local/etc/logrotate.d
mkdir -p custom/onedrive/lib/systemd/system
mkdir -p custom/onedrive/usr/lib/systemd/user
mkdir -p custom/userhome/.config/onedrive
mkdir -p custom/userhome/OneDrive

cp compile/onedrive/onedrive custom/onedrive/usr/local/bin
chmod 0644 custom/onedrive/usr/local/bin/onedrive
cp compile/onedrive/config custom/onedrive/userhome/.config/onedrive
chmod 0644 custom/onedrive/usr/local/bin/onedrive
cp compile/onedrive/contrib/logrotate/onedrive.logrotate custom/onedrive/usr/local/etc/logrotate.d/onedrive
chmod 0644 custom/onedrive/usr/local/etc/logrotate.d/onedrive
cp compile/onedrive/contrib/systemd/onedrive@.service custom/onedrive/lib/systemd/system
chmod 0644 custom/onedrive/lib/systemd/system/onedrive@.service
cp compile/onedrive/contrib/systemd/onedrive.service custom/onedrive/usr/lib/systemd/user
chmod 0644 custom/onedrive/usr/lib/systemd/user/onedrive.service

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/OneDrive_Client.zip

unzip OneDrive_Client.zip -d custom
mv custom/target/build/onedrive-cp-init-script.sh custom

cd custom

# edit inf file for version number
VERSION=$(cat ../compile/onedrive/version)
#echo "Version is: " ${VERSION}
sed -i "/^version=/c version=\"${VERSION}\"" target/onedrive.inf
#echo "onedrive.inf file is:"
#cat target/onedrive.inf

# new build process into zip file
tar cvjf target/onedrive.tar.bz2 onedrive onedrive-cp-init-script.sh
zip -g ../OneDrive_Client.zip target/onedrive.tar.bz2 target/onedrive.inf
zip -d ../OneDrive_Client.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../OneDrive_Client.zip ../../OneDrive_Client-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
