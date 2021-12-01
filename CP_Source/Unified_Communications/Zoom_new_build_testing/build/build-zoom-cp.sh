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

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/zoom/userhome/.zoom
mkdir -p custom/zoom/userhome/.config
touch custom/zoom/userhome/.config/zoomus.config

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Zoom_new_build_testing.zip

unzip Zoom_new_build_testing.zip -d custom
mkdir -p custom/zoom/config/bin
mkdir -p custom/zoom/lib/systemd/system
mv custom/target/build/zoom_cp_apparmor_reload custom/zoom/config/bin
mv custom/target/build/igel-zoom-cp-apparmor-reload.service custom/zoom/lib/systemd/system/
mv custom/target/build/zoom-cp-init-script.sh custom

cd custom

# new build process into zip file
tar cvjf target/zoom.tar.bz2 zoom zoom-cp-init-script.sh
zip -g ../Zoom_new_build_testing.zip target/zoom.tar.bz2
zip -d ../Zoom_new_build_testing.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Zoom_new_build_testing.zip ../..

cd ../..
rm -rf build_tar
