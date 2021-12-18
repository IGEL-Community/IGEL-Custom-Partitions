#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for LibreOffice
## Development machine (Ubuntu 18.04)

# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://www.libreoffice.org/download/download/?type=deb-x86_64
if ! compgen -G "$HOME/Downloads/LibreOffice_*_Linux_x86-64_deb.tar.gz" > /dev/null; then
  echo "***********"
  echo "Obtain latest Linux (64-bit) (deb) package, save into $HOME/Downloads and re-run this script "
  echo "https://www.libreoffice.org/download/download/?type=deb-x86_64"
  echo "***********"
  exit 1
fi
if ! compgen -G "$HOME/Downloads/LibreOffice_*_Linux_x86-64_deb_helppack_*.tar.gz" > /dev/null; then
  echo "***********"
  echo "Help for offline use"
  echo "Obtain latest Linux (64-bit) (deb) package, save into $HOME/Downloads and re-run this script "
  echo "https://www.libreoffice.org/download/download/?type=deb-x86_64"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/libreoffice

tar zxvf $HOME/Downloads/LibreOffice_*_Linux_x86-64_deb.tar.gz
LIBREOFFICEDIR="LibreOffice_*_Linux_x86-64_deb/DEBS"
find ${LIBREOFFICEDIR} -type f | while read LINE
do
  dpkg -x "${LINE}" custom/libreoffice
done

tar zxvf $HOME/Downloads/LibreOffice_*_Linux_x86-64_deb_helppack_*.tar.gz
dpkg -x LibreOffice_*_Linux_x86-64_deb_helppack_*/DEBS/lib*.deb custom/libreoffice

mv custom/libreoffice/usr/share/applications/ custom/libreoffice/usr/share/applications.mime
mkdir -p custom/libreoffice/userhome/.config/libreoffice
mkdir -p custom/libreoffice/userhome/Documents

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Office/LibreOffice.zip

unzip LibreOffice.zip -d custom
mkdir -p custom/libreoffice/config/bin
mkdir -p custom/libreoffice/lib/systemd/system
mv custom/target/build/libreoffice_cp_apparmor_reload custom/libreoffice/config/bin
mv custom/target/build/igel-libreoffice-cp-apparmor-reload.service custom/libreoffice/lib/systemd/system/
mv custom/target/build/libreoffice-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../LibreOffice_*/DEBS/libreoffice*-base_*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/libreoffice.inf
#echo "libreoffice.inf file is:"
#cat target/libreoffice.inf

# new build process into zip file
tar cvjf target/libreoffice.tar.bz2 libreoffice libreoffice-cp-init-script.sh
zip -g ../LibreOffice.zip target/libreoffice.tar.bz2 target/libreoffice.inf
zip -d ../LibreOffice.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../LibreOffice.zip ../../LibreOffice-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
