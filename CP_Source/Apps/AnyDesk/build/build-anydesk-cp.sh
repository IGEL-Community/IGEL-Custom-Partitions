#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for AnyDesk
## Development machine (Ubuntu 18.04)

sudo curl https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list'
sudo apt-get update
MISSING_LIBS="anydesk libgtkglext1 libminizip1 libpangox-1.0-0"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/anydesk

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/anydesk
done

mv custom/anydesk/usr/share/applications/ custom/anydesk/usr/share/applications.mime

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/anydesk/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/anydesk/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

mkdir -p custom/anydesk/userhome/.anydesk

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/AnyDesk.zip

unzip AnyDesk.zip -d custom
mv custom/target/build/anydesk-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../anydesk*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/anydesk.inf
#echo "anydesk.inf file is:"
#cat target/anydesk.inf

# new build process into zip file
tar cvjf target/anydesk.tar.bz2 anydesk anydesk-cp-init-script.sh
zip -g ../AnyDesk.zip target/anydesk.tar.bz2 target/anydesk.inf
zip -d ../AnyDesk.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../AnyDesk.zip ../../AnyDesk-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
