#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Zoom
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

mkdir build_tar
cd build_tar

wget https://zoom.us/client/latest/zoom_amd64.deb
apt-get download libxcb-xtest0

mkdir -p custom/zoom

dpkg -x zoom_amd64.deb custom/zoom
dpkg -x libxcb* custom/zoom

mv custom/zoom/usr/share/applications/ custom/zoom/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Zoom.zip

unzip Zoom.zip -d custom
mkdir -p custom/zoom/config/bin
mkdir -p custom/zoom/lib/systemd/system
mv custom/target/zoom_cp_apparmor_reload custom/zoom/config/bin
mv custom/target/igel-zoom-cp-apparmor-reload.service custom/zoom/lib/systemd/system/
mv custom/target/zoom-cp-init-script.sh custom

cd custom

tar cvjf zoom.tar.bz2 zoom zoom-cp-init-script.sh
mv zoom.tar.bz2 ../..
mv target/zoom.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
