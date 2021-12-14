#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Microsoft edge_stable
## Development machine (Ubuntu 18.04)
#https://www.microsoft.com/en-us/edge
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
#apt-get download microsoft-edge-beta
apt-get download microsoft-edge-stable
apt-get download libatomic1

mkdir -p custom/edge_stable

dpkg -x microsoft*.deb custom/edge_stable
dpkg -x libatomic1*.deb custom/edge_stable

mv custom/edge_stable/usr/share/applications/ custom/edge_stable/usr/share/applications.mime
mkdir -p custom/edge_stable/userhome/.config/microsoft-edge
mkdir -p custom/edge_stable/userhome/.local/share/applications
touch custom/edge_stable/userhome/.local/share/applications/mimeapps.list

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Browsers/Microsoft_Edge_stable.zip

unzip Microsoft_Edge_stable.zip -d custom
mkdir -p custom/edge_stable/config/bin
mkdir -p custom/edge_stable/lib/systemd/system
mv custom/target/build/edge_stable_cp_apparmor_reload custom/edge_stable/config/bin
mv custom/target/build/igel-edge_stable-cp-apparmor-reload.service custom/edge_stable/lib/systemd/system/
mv custom/target/build/edge_stable-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../microsoft*.deb
tar xf control.tar.xz ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/edge_stable.inf
#echo "edge_stable.inf file is:"
#cat target/edge_stable.inf

# new build process into zip file
tar cvjf target/edge_stable.tar.bz2 edge_stable edge_stable-cp-init-script.sh
zip -g ../Microsoft_Edge_stable.zip target/edge_stable.tar.bz2 target/edge_stable.inf
zip -d ../Microsoft_Edge_stable.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Microsoft_Edge_stable.zip ../../Microsoft_Edge_stable-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
