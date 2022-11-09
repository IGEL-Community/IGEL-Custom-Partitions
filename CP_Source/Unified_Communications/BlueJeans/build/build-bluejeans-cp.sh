#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain link to latest package and save into Downloads
# https://www.bluejeans.com/downloads
if ! compgen -G "$HOME/Downloads/BlueJeans_*.deb" > /dev/null; then
  echo "***********"
  echo "Download latest .deb package and re-run this script "
  echo "https://www.bluejeans.com/downloads"
  echo "***********"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/bluejeans

dpkg -x $HOME/Downloads/BlueJeans_*.deb custom/bluejeans

mv custom/bluejeans/usr/share/applications/ custom/bluejeans/usr/share/applications.mime

###########################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/bluejeans/userhome/.config/bluejeans-v2

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/BlueJeans.zip

unzip BlueJeans.zip -d custom
mkdir -p custom/bluejeans/config/bin
mkdir -p custom/bluejeans/lib/systemd/system
mv custom/target/build/bluejeans_cp_apparmor_reload custom/bluejeans/config/bin
mv custom/target/build/igel-bluejeans-cp-apparmor-reload.service custom/bluejeans/lib/systemd/system/
mv custom/target/build/bluejeans-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/BlueJeans_*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/bluejeans.inf
#echo "bluejeans.inf file is:"
#cat target/bluejeans.inf

# new build process into zip file
tar cvjf target/bluejeans.tar.bz2 bluejeans bluejeans-cp-init-script.sh
zip -g ../BlueJeans.zip target/bluejeans.tar.bz2 target/bluejeans.inf
zip -d ../BlueJeans.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../BlueJeans.zip ../../BlueJeans-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
