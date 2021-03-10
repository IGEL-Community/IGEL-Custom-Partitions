#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Azul Zulu IcedTea-Web
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://www.azul.com/downloads/icedtea-web-community/
if ! compgen -G "$HOME/Downloads/zulu-icedtea-web*.zip" > /dev/null; then
  echo "***********"
  echo "Obtain latest .zip package, save into $HOME/Downloads and re-run this script "
  echo "https://www.azul.com/downloads/icedtea-web-community/"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/icedtea/services/zulu_jre8/jre

unzip $HOME/Downloads/zulu-icedtea-web*.zip

cp -R icedtea-web-image/* custom/icedtea/services/zulu_jre8/jre

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/IcedTea-Web.zip

unzip IcedTea-Web.zip -d custom
mkdir -p custom/icedtea/config/bin
mkdir -p custom/icedtea/lib/systemd/system
mv custom/target/icedtea_cp_apparmor_reload custom/icedtea/config/bin
mv custom/target/igel-icedtea-cp-apparmor-reload.service custom/icedtea/lib/systemd/system/
mv custom/target/icedtea-cp-init-script.sh custom
mv custom/target/javaws-wrapper.desktop

cd custom

tar cvjf icedtea.tar.bz2 icedtea icedtea-cp-init-script.sh
mv icedtea.tar.bz2 ../..
mv target/icedtea.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
