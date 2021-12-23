#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for PCMan File Manager
## Development machine (Ubuntu 18.04)

MISSING_LIBS="libfm-data libfm-extra4 libfm-gtk-data libfm-gtk4 libfm-modules libfm4 libmenu-cache-bin libmenu-cache3 lxde-icon-theme lxmenu-data pcmanfm"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/pcmanfm

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/pcmanfm
done

mv custom/pcmanfm/usr/share/applications/ custom/pcmanfm/usr/share/applications.mime

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/pcmanfm/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/pcmanfm/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/pcmanfm/userhome/.config/pcmanfm
mkdir -p custom/pcmanfm/userhome/.local/share/Trash
touch custom/pcmanfm/userhome/.gtk-bookmarks

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/PCManFM.zip

unzip PCManFM.zip -d custom
mv custom/target/build/pcmanfm-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../pcmanfm_*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/pcmanfm.inf
#echo "pcmanfm.inf file is:"
#cat target/pcmanfm.inf

# new build process into zip file
tar cvjf target/pcmanfm.tar.bz2 pcmanfm pcmanfm-cp-init-script.sh
zip -g ../PCManFM.zip target/pcmanfm.tar.bz2 target/pcmanfm.inf
zip -d ../PCManFM.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../PCManFM.zip ../../PCManFM-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
