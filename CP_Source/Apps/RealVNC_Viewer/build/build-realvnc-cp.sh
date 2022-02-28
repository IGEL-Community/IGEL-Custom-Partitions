#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for realvnc
## Development machine (Ubuntu 18.04)
# https://www.realvnc.com/en/connect/download/viewer/
if ! compgen -G "$HOME/Downloads/VNC-Viewer-*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest Ubuntu 18.04 .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://www.realvnc.com/en/connect/download/viewer/"
  exit 1
fi

MISSING_LIBS=""

sudo apt install unzip -y

mkdir build_tar
cd build_tar

cp $HOME/Downloads/VNC-Viewer-*.deb .

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/realvnc

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/realvnc
done

mv custom/realvnc/usr/share/applications/ custom/realvnc/usr/share/applications.mime
mkdir -p custom/realvnc/userhome/.vnc

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/realvnc/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/realvnc/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/RealVNC_Viewer.zip

unzip RealVNC_Viewer.zip -d custom
mkdir -p custom/realvnc/config/bin
mkdir -p custom/realvnc/lib/systemd/system
mv custom/target/build/realvnc_cp_apparmor_reload custom/realvnc/config/bin
mv custom/target/build/igel-realvnc-cp-apparmor-reload.service custom/realvnc/lib/systemd/system/
mv custom/target/build/realvnc-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../realvnc_*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/realvnc.inf
#echo "realvnc.inf file is:"
#cat target/realvnc.inf

# new build process into zip file
tar cvjf target/realvnc.tar.bz2 realvnc realvnc-cp-init-script.sh
zip -g ../RealVNC_Viewer.zip target/realvnc.tar.bz2 target/realvnc.inf
zip -d ../RealVNC_Viewer.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../RealVNC_Viewer.zip ../../RealVNC_Viewer-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
