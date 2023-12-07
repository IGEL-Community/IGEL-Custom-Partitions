#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Azul Zulu IcedTea-Web
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://www.azul.com/downloads/icedtea-web-community/
# https://www.azul.com/products/components/icedtea-web/
# azul-icedtea-web-1.8.8-28.portable.zip
if ! compgen -G "$HOME/Downloads/azul-icedtea-web*.zip" > /dev/null; then
  echo "***********"
  echo "Obtain latest .zip package, save into $HOME/Downloads and re-run this script "
  echo "https://www.azul.com/products/components/icedtea-web/"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/icedtea/services/zulu_jre8/jre

unzip $HOME/Downloads/azul-icedtea-web*.zip

cp -R azul-icedtea-web-*/* custom/icedtea/services/zulu_jre8/jre

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/icedtea/userhome/.config/icedtea-web
mkdir -p custom/icedtea/userhome/.cache/icedtea-web

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/IcedTea-Web.zip

unzip IcedTea-Web.zip -d custom
mkdir -p custom/icedtea/config/bin
mkdir -p custom/icedtea/lib/systemd/system
mv custom/target/build/icedtea_cp_apparmor_reload custom/icedtea/config/bin
mv custom/target/build/igel-icedtea-cp-apparmor-reload.service custom/icedtea/lib/systemd/system/
mv custom/target/build/icedtea-cp-init-script.sh custom
mkdir -p custom/icedtea/usr/share/applications.mime
mv custom/target/build/javaws-wrapper.desktop custom/icedtea/usr/share/applications.mime

cd custom

# edit inf file for version number
VERSION=$(basename $HOME/Downloads/azul-icedtea-web*.zip | cut -d "-" -f 4)
#echo "Version is: " ${VERSION}
sed -i "/^version=/c version=\"${VERSION}\"" target/icedtea.inf
#echo "icedtea.inf file is:"
#cat target/icedtea.inf

# new build process into zip file
tar cvjf target/icedtea.tar.bz2 icedtea icedtea-cp-init-script.sh
zip -g ../IcedTea-Web.zip target/icedtea.tar.bz2 target/icedtea.inf
zip -d ../IcedTea-Web.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../IcedTea-Web.zip ../../IcedTea-Web-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
