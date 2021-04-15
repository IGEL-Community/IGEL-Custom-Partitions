#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Epson
## Development machine (Ubuntu 18.04)
# Obtain link to latest package and save into Downloads
# https://slack.com/downloads/linux
# http://support.epson.net/linux/en/imagescanv3.php
imagescan-bundle-ubuntu-18.04-*x64.deb.tar.gz
if ! compgen -G "$HOME/Downloads/imagescan-bundle-ubuntu-18.04-*x64.deb.tar.gz" > /dev/null; then
  echo "***********"
  echo "Download latest Ubuntu 18.04 64bit .deb package and re-run this script "
  echo "# http://support.epson.net/linux/en/imagescanv3.php"
  echo "***********"
  exit 1
fi

MISSING_LIBS="libatkmm-1.6-1v5 libboost-filesystem1.65.1 libboost-program-options1.65.1 libglibmm-2.4-1v5 libgraphicsmagick++-q16-12 libgraphicsmagick-q16-3 libgtkmm-2.4-1v5 libpangomm-1.4-1v5 libsigc++-2.0-0v5 graphicsmagick"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

tar xvf $HOME/Downloads/imagescan*.deb.tar.gz

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/epson

dpkg -x imagescan-bundle-ubuntu-18.04-*x64.deb/core/imagescan_*.deb custom/epson

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/epson
done

mv custom/epson/usr/share/applications/ custom/epson/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Epson_Scanner.zip

unzip Epson_Scanner.zip -d custom
mkdir -p custom/epson/config/bin
mkdir -p custom/epson/lib/systemd/system
mv custom/target/epson_cp_apparmor_reload custom/epson/config/bin
mv custom/target/igel-epson-cp-apparmor-reload.service custom/epson/lib/systemd/system/
mv custom/target/epson-cp-init-script.sh custom

cd custom

tar cvjf epson.tar.bz2 epson epson-cp-init-script.sh
mv epson.tar.bz2 ../..
mv target/epson.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
