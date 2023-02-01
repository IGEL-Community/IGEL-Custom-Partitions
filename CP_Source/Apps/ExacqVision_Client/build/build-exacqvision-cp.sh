#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for exacqVision Client
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://www.hamrick.com/alternate-versions.html
# https://www.exacq.com/support/downloads.php
# exacqVisionClient_22.09.3.0_x64.deb
if ! compgen -G "$HOME/Downloads/exacqVisionClient_*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://www.exacq.com/support/downloads.php"
  exit 1
fi

mkdir build_tar
cd build_tar

CP_PATH="custom/exacqvision"

mkdir -p ${CP_PATH}

dpkg -x $HOME/Downloads/exacqVisionClient_*.deb ${CP_PATH}

# Items from postinst
mkdir -p ${CP_PATH}/usr/share/applications.mime
find ${CP_PATH} -type f -name "*.desktop" -exec cp {} ${CP_PATH}/usr/share/applications.mime \;

mkdir -p ${CP_PATH}/usr/share/icons/hicolor/16x16/mimetypes
mkdir -p ${CP_PATH}/usr/share/icons/hicolor/32x32/mimetypes

cp ${CP_PATH}/usr/local/exacq/client/share/exacq-v-32x32.png ${CP_PATH}/usr/share/icons/hicolor/32x32/mimetypes/gnome-mime-application-psx.png
cp ${CP_PATH}/usr/local/exacq/client/share/exacq-v-32x32.png ${CP_PATH}/usr/share/icons/hicolor/32x32/mimetypes/application-psx.png
cp ${CP_PATH}/usr/local/exacq/client/share/exacq-v-16x16.png ${CP_PATH}/usr/share/icons/hicolor/16x16/mimetypes/gnome-mime-application-psx.png
cp ${CP_PATH}/usr/local/exacq/client/share/exacq-v-16x16.png ${CP_PATH}/usr/share/icons/hicolor/16x16/mimetypes/application-psx.png
cp ${CP_PATH}/usr/local/exacq/client/share/exacq-v-32x32.png ${CP_PATH}/usr/share/icons/hicolor/32x32/mimetypes/gnome-mime-application-xdv.png
cp ${CP_PATH}/usr/local/exacq/client/share/exacq-v-32x32.png ${CP_PATH}/usr/share/icons/hicolor/32x32/mimetypes/application-xdv.png
cp ${CP_PATH}/usr/local/exacq/client/share/exacq-v-16x16.png ${CP_PATH}/usr/share/icons/hicolor/16x16/mimetypes/gnome-mime-application-xdv.png
cp ${CP_PATH}/usr/local/exacq/client/share/exacq-v-16x16.png ${CP_PATH}/usr/share/icons/hicolor/16x16/mimetypes/application-xdv.png

mkdir -p ${CP_PATH}/etc
echo "libgssapi_krb5.so.2 mechglue_internal_krb5_init" >> ${CP_PATH}/etc/gssapi_mech.conf
cp ${CP_PATH}/usr/local/exacq/client/edvrClientNoServers.ini ${CP_PATH}/etc/edvrclient.conf

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p ${CP_PATH}/userhome/.edvrclient.dir

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/ExacqVision_Client.zip

unzip ExacqVision_Client.zip -d custom
mv custom/target/build/exacqvision-cp-init-script.sh custom
cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/exacqVisionClient_*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/exacqvision.inf
#echo "exacqvision.inf file is:"
#cat target/exacqvision.inf

# new build process into zip file
tar cvjf target/exacqvision.tar.bz2 exacqvision exacqvision-cp-init-script.sh
zip -g ../ExacqVision_Client.zip target/exacqvision.tar.bz2 target/exacqvision.inf
zip -d ../ExacqVision_Client.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../ExacqVision_Client.zip ../../ExacqVision_Client-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
