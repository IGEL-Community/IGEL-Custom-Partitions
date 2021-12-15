#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Thunar
## Development machine (Ubuntu 18.04)

MISSING_LIBS="exo-utils libexo-1-0 libexo-2-0 libexo-common libexo-helpers libgarcon-1-0 libgarcon-common libthunarx-2-0 libtumbler-1-0 libwnck-common libwnck22 libxfce4ui-1-0 libxfce4ui-2-0 libxfce4ui-common libxfce4util-bin libxfce4util-common libxfce4util7 libxfconf-0-2 thunar thunar-data thunar-volman tumbler tumbler-common xfce4-panel xfconf"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/thunar

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/thunar
done

mv custom/thunar/usr/share/applications/ custom/thunar/usr/share/applications.mime

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/thunar/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/thunar/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/thunar/userhome/.config/Thunar

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Thunar.zip

unzip Thunar.zip -d custom
mv custom/target/build/thunar-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../thunar_*.deb
tar xf control.tar.gz ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/thunar.inf
#echo "thunar.inf file is:"
#cat target/thunar.inf

# new build process into zip file
tar cvjf target/thunar.tar.bz2 thunar thunar-cp-init-script.sh
zip -g ../Thunar.zip target/thunar.tar.bz2 target/thunar.inf
zip -d ../Thunar.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Thunar.zip ../../Thunar-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
