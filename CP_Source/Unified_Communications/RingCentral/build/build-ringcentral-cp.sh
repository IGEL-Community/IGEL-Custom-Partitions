#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for RingCentral Embeddable
## Development machine (Ubuntu 18.04)
# https://github.com/ringcentral/ringcentral-embeddable-electron-app/releases
# ringcentral-embeddable-voice-app_0.2.0_amd64.deb
if ! compgen -G "$HOME/Downloads/ringcentral-embeddable-voice-app_*_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://github.com/ringcentral/ringcentral-embeddable-electron-app/releases"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/ringcentral

dpkg -x $HOME/Downloads/ringcentral-embeddable-voice-app_*_amd64.deb custom/ringcentral

mv custom/ringcentral/usr/share/applications/ custom/ringcentral/usr/share/applications.mime

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/ringcentral/userhome/.config/ringcentral-embeddable-voice-app

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/RingCentral.zip

unzip RingCentral.zip -d custom
mv custom/target/build/ringcentral-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/ringcentral-embeddable-voice-app_*_amd64.deb
tar xf control.tar.xz ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/ringcentral.inf
#echo "ringcentral.inf file is:"
#cat target/ringcentral.inf

# new build process into zip file
tar cvjf target/ringcentral.tar.bz2 ringcentral ringcentral-cp-init-script.sh
zip -g ../RingCentral.zip target/ringcentral.tar.bz2 target/ringcentral.inf
zip -d ../RingCentral.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../RingCentral.zip ../../RingCentral-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
