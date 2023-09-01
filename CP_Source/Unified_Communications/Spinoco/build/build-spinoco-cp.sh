#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine (Ubuntu 18.04)

# https://download.spinoco.com/spinoco/latest/linux-x64/Spinoco.AppImage
# Download latest AppImage
wget -O $HOME/Downloads/Spinoco.AppImage https://download.spinoco.com/spinoco/latest/linux-x64/Spinoco.AppImage

if ! compgen -G "$HOME/Downloads/Spinoco.AppImage" > /dev/null; then
  echo "***********"
  echo "Obtain latest package, save into $HOME/Downloads and re-run this script "
  echo "https://www.spinoco.com/en/for-existing-users"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/spinoco

# Final package destination
BASEDIR=$PWD/custom/spinoco

APPIMAGE0="$HOME/Downloads/Spinoco.AppImage"
APPIMAGE="$(basename $HOME/Downloads/Spinoco.AppImage)"

# chmod a+x
chmod a+x $APPIMAGE0

# executing AppImage
# Next version?: change to mount -o loop ....
$APPIMAGE0 2>&1 >/dev/null &

# wait for spinoco to start
while [ `ps ax | grep Spinoco.AppImage | grep -v grep | wc -l` -lt 1 ]
do
    echo "."
    sleep 1
done

echo "Spinoco started, proceding.............."

#where is it mounted under /tmp ?
APPTEMPDIR=$(mount | grep Spinoco | cut -d " " -f 3)

# copy it to the CP
(cd $APPTEMPDIR;cp -r -p * $BASEDIR)
# remove autoupdate
rm -f $BASEDIR/resources/app-update.yml

APPIMAGEVERSION=$(grep "^X-AppImage" $BASEDIR/spinoco.desktop | cut -d "=" -f 2)

# killall instances
killall spinoco

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/spinoco/userhome/.config/Spinoco

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Spinoco.zip

unzip Spinoco.zip -d custom
mv custom/target/build/spinoco-cp-init-script.sh custom

cd custom

# edit inf file for version number
VERSION=${APPIMAGEVERSION}
#echo "Version is: " ${VERSION}
sed -i "/^version=/c version=\"${VERSION}\"" target/spinoco.inf
#echo "spinoco.inf file is:"
#cat target/spinoco.inf

# new build process into zip file
tar cvjf target/spinoco.tar.bz2 spinoco spinoco-cp-init-script.sh
zip -g ../Spinoco.zip target/spinoco.tar.bz2 target/spinoco.inf
zip -d ../Spinoco.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Spinoco.zip ../../Spinoco-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
