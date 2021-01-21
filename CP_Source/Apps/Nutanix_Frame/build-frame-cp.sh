#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Nutanix Frame
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain latest package and save into Downloads
# Download Latest Frame App for Linux (Debian)
# https://portal.nutanix.com/page/downloads?product=xiframe
if ! compgen -G "$HOME/Downloads/Frame-*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "***********"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/frame

dpkg -x $HOME/Downloads/Frame-*.deb custom/frame

mv custom/frame/usr/share/applications/ custom/frame/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Nutanix_Frame.zip

unzip Nutanix_Frame.zip -d custom
mkdir -p custom/frame/usr/share/pixmaps
mv custom/target/Frame.png custom/frame/usr/share/pixmaps
mv custom/target/frame-launcher.sh custom/frame
mv custom/target/frame-cp-init-script.sh custom

cd custom

tar cvjf frame.tar.bz2 frame frame-cp-init-script.sh
mv frame.tar.bz2 ../..
mv target/frame.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
