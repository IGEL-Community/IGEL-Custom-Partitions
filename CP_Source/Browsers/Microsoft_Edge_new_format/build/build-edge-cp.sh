#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Microsoft Edge
## Development machine (Ubuntu 18.04)
# https://www.microsoftedgeinsider.com/en-us/download?platform=linux-deb
sudo apt install curl -y
sudo apt install unzip -y
sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/edge.list'
sudo apt-get update

sudo apt install unzip -y

mkdir build_tar
cd build_tar

#apt-cache search microsoft-edge
#apt-get download microsoft-edge-dev
apt-get download microsoft-edge-beta
apt-get download libatomic1

mkdir -p custom/edge

dpkg -x microsoft*.deb custom/edge
dpkg -x libatomic1*.deb custom/edge

mv custom/edge/usr/share/applications/ custom/edge/usr/share/applications.mime
#mkdir -p custom/edge/userhome/.config/microsoft-edge-dev
mkdir -p custom/edge/userhome/.config/microsoft-edge-beta
mkdir -p custom/edge/userhome/.local/share/applications
touch custom/edge/userhome/.local/share/applications/mimeapps.list

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Browsers/Microsoft_Edge_new_format.zip

unzip Microsoft_Edge_new_format.zip -d custom
mkdir -p custom/edge/config/bin
mkdir -p custom/edge/lib/systemd/system
mv custom/target/build/edge_cp_apparmor_reload custom/edge/config/bin
mv custom/target/build/igel-edge-cp-apparmor-reload.service custom/edge/lib/systemd/system/
mv custom/target/build/edge-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../microsoft*.deb
tar xf control.tar.xz ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/edge.inf
#echo "edge.inf file is:"
#cat target/edge.inf

# new build process into zip file
tar cvjf target/edge.tar.bz2 edge edge-cp-init-script.sh
zip -g ../Microsoft_Edge_new_format.zip target/edge.tar.bz2 target/edge.inf
zip -d ../Microsoft_Edge_new_format.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Microsoft_Edge_new_format.zip ../../Microsoft_Edge_new_format-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
