#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Linphone
## Development machine (Ubuntu 18.04)

#https://download.linphone.org/releases/linux/app/
#Linphone-4.4.10.AppImage
# Download latest AppImage
#APPIMAGEVERSIONS=`wget -O - $BASEURL 2>/dev/null | sed -E 's/^.*href/href/; s/>.*//' | grep AppImage | awk -F"=" '{print $2}' | tr -d \" `

if ! compgen -G "$HOME/Downloads/Linphone-*.AppImage" > /dev/null; then
  echo "***********"
  echo "Obtain latest package, save into $HOME/Downloads and re-run this script "
  echo "https://download.linphone.org/releases/linux/app/"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/linphone

# Final package destination
BASEDIR=$PWD/custom/linphone

APPIMAGE0="$HOME/Downloads/Linphone-*.AppImage"
APPIMAGE="$(basename $HOME/Downloads/Linphone-*.AppImage)"

APPIMAGEVERSION=` echo $APPIMAGE  | cut -d- -f 2 | cut -d. -f 1-3`

# chmod a+x
chmod a+x $APPIMAGE0

# executing AppImage
# Next version?: change to mount -o loop ....
$APPIMAGE0 2>&1 >/dev/null &

# wait for Linphone to start
while [ `ps ax | grep AppRun.wrapped | grep -v grep | wc -l` -lt 1 ]
do
    echo "."
    sleep 1
done

echo "Linphone started, proceding.............."

#where is it mounted under /tmp ?
APPTEMPDIR=`mount | grep Lin | awk '{print $3}'`

# copy it to the CP
(cd $APPTEMPDIR;cp -r -p * $BASEDIR)

# killall instances
killall AppRun.wrapped

# comment one line in usr/share/linphone/linphonerc-factory to disable download messages for the CP
sed -i '/^version_check_url_root.*$/s/^/#/' ${BASEDIR}/usr/share/linphone/linphonerc-factory

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/linphone/userhome/.config/linphone
mkdir -p custom/linphone/userhome/Documents/linphone/captures
mkdir -p custom/linphone/userhome/.local/share/linphone/logs

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Linphone_VOIP.zip

unzip Linphone_VOIP.zip -d custom
mv custom/target/build/linphone-cp-init-script.sh custom

cd custom

# edit inf file for version number
VERSION=${APPIMAGEVERSION}
#echo "Version is: " ${VERSION}
sed -i "/^version=/c version=\"${VERSION}\"" target/linphone.inf
#echo "linphone.inf file is:"
#cat target/linphone.inf

# new build process into zip file
tar cvjf target/linphone.tar.bz2 linphone linphone-cp-init-script.sh
zip -g ../Linphone_VOIP.zip target/linphone.tar.bz2 target/linphone.inf
zip -d ../Linphone_VOIP.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Linphone_VOIP.zip ../../Linphone_VOIP-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
