#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Nx Witness Desktop
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain latest package and save into Downloads
# https://nxvms.com/download/linux
# https://updates.networkoptix.com/default/32840/linux/nxwitness-client-4.2.0.32840-linux64.deb
if ! compgen -G "$HOME/Downloads/nxwitness-client-*-linux64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://nxvms.com/download/linux"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/nxwitness

dpkg -x $HOME/Downloads/nxwitness-client-*-linux64.deb custom/nxwitness

mv custom/nxwitness/usr/share/applications/ custom/nxwitness/usr/share/applications.mime

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/nxwitness/userhome/Videos
mkdir -p custom/nxwitness/userhome/.config/Network\ Optix

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Nx_Witness_Desktop.zip

unzip Nx_Witness_Desktop.zip -d custom
mv custom/target/build/nxwitness-cp-init-script.sh custom
cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/Frame-*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/nxwitness.inf
#echo "nxwitness.inf file is:"
#cat target/nxwitness.inf

# new build process into zip file
tar cvjf target/nxwitness.tar.bz2 nxwitness nxwitness-cp-init-script.sh
zip -g ../Nx_Witness_Desktop.zip target/nxwitness.tar.bz2 target/nxwitness.inf
zip -d ../Nx_Witness_Desktop.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Nx_Witness_Desktop.zip ../../Nx_Witness_Desktop-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
