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
mkdir -p custom/bluejeans/userhome/.config/bluejeans-v2

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/BlueJeans.zip

unzip BlueJeans.zip -d custom
mkdir -p custom/bluejeans/config/bin
mkdir -p custom/bluejeans/lib/systemd/system
mv custom/target/bluejeans_cp_apparmor_reload custom/bluejeans/config/bin
mv custom/target/igel-bluejeans-cp-apparmor-reload.service custom/bluejeans/lib/systemd/system/
mv custom/target/bluejeans-cp-init-script.sh custom

cd custom

tar cvjf bluejeans.tar.bz2 bluejeans bluejeans-cp-init-script.sh
mv bluejeans.tar.bz2 ../..
mv target/bluejeans.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
