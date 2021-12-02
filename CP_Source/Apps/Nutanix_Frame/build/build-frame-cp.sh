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
  echo "https://portal.nutanix.com/page/downloads?product=xiframe"
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
mv custom/target/build/Frame.png custom/frame/usr/share/pixmaps
mv custom/target/build/frame-launcher.sh custom/frame
mv custom/target/build/frame-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/Frame-*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/frame.inf
#echo "frame.inf file is:"
#cat target/frame.inf

# new build process into zip file
tar cvjf target/frame.tar.bz2 frame frame-cp-init-script.sh
zip -g ../Nutanix_Frame.zip target/frame.tar.bz2 target/frame.inf
zip -d ../Nutanix_Frame.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Nutanix_Frame.zip ../../Nutanix_Frame-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
