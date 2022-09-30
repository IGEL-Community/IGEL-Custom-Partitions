#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for VueScan
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://www.hamrick.com/alternate-versions.html
# vuex64-9.7.93.deb
if ! compgen -G "$HOME/Downloads/vuex64-*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://www.hamrick.com/alternate-versions.html"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/vuescan

dpkg -x $HOME/Downloads/vuex64-*.deb custom/vuescan

mv custom/vuescan/usr/share/applications/ custom/vuescan/usr/share/applications.mime

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/vuescan/userhome/.vuescan

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/VueScan.zip

unzip VueScan.zip -d custom
mv custom/target/build/vuescan-cp-init-script.sh custom
cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/vuex64-*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/vuescan.inf
#echo "vuescan.inf file is:"
#cat target/vuescan.inf

# new build process into zip file
tar cvjf target/vuescan.tar.bz2 vuescan vuescan-cp-init-script.sh
zip -g ../VueScan.zip target/vuescan.tar.bz2 target/vuescan.inf
zip -d ../VueScan.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../VueScan.zip ../../VueScan-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
