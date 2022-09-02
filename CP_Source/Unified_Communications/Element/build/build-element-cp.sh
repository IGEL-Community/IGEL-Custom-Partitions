#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Element
## Development machine (Ubuntu 18.04)

# https://element.io/get-started#linux-details

sudo curl https://packages.element.io/debian/element-io-archive-keyring.gpg | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packages.element.io/debian/ default main" > /etc/apt/sources.list.d/element-main.list'
sudo apt-get update

MISSING_LIBS="element-desktop libappindicator3-1 libsqlcipher0"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/element

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/element
done

mv custom/element/usr/share/applications/ custom/element/usr/share/applications.mime

mkdir -p custom/element/userhome/.config/Element

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Element.zip

unzip Element.zip -d custom
mv custom/target/build/element-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../element-desktop_*_amd64.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/element.inf
#echo "element.inf file is:"
#cat target/element.inf

# new build process into zip file
tar cvjf target/element.tar.bz2 element element-cp-init-script.sh
zip -g ../Element.zip target/element.tar.bz2 target/element.inf
zip -d ../Element.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Element.zip ../../Element-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
