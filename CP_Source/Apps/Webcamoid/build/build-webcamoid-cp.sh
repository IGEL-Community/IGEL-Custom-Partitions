#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for webcamoid
## Development machine (Ubuntu 18.04)

#MISSING_LIBS="akqml i965-va-driver libaacs0 libavcodec57 libavformat57 libavkys8 libavresample3 libavutil55 libbdplus0 libbluray2 libchromaprint1 libcrystalhd3 libdouble-conversion1 libgme0 libgsm1 libopenjp2-7 libopenmpt0 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5qml5 libqt5quick5 libqt5svg5 libqt5widgets5 libshine3 libsnappy1v5 libsoxr0 libssh-gcrypt-4 libswresample2 libswscale4 libva-drm2 libva-x11-2 libva2 libvdpau1 libx264-152 libx265-146 libxcb-xinerama0 libxvidcore4 libzvbi-common libzvbi0 mesa-va-drivers mesa-vdpau-drivers qml-module-qt-labs-folderlistmodel qml-module-qt-labs-settings qml-module-qtgraphicaleffects qml-module-qtquick-controls qml-module-qtquick-dialogs qml-module-qtquick-layouts qml-module-qtquick-privatewidgets qml-module-qtquick-window2 qml-module-qtquick2 qt5-gtk-platformtheme qttranslations5-l10n va-driver-all vdpau-driver-all webcamoid webcamoid-data webcamoid-plugins"


sudo apt install unzip -y

mkdir build_tar
cd build_tar

#for lib in $MISSING_LIBS; do
  #apt-get download $lib
#done

mkdir -p custom/webcamoid

#find . -type f -name "*.deb" | while read LINE
#do
  #dpkg -x "${LINE}" custom/webcamoid
#done

#mv custom/webcamoid/usr/share/applications/ custom/webcamoid/usr/share/applications.mime

wget https://github.com/webcamoid/webcamoid/releases/download/8.7.1/webcamoid-portable-8.7.1-x86_64.tar.xz
tar xvf webcamoid-portable-8.7.1-x86_64.tar.xz --directory custom

#echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
#wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
#chmod a+x clean_cp_usr_lib.sh
#wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
#chmod a+x clean_cp_usr_share.sh
#./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/webcamoid/usr/lib
#./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/webcamoid/usr/share
#echo "+++++++=======  DONE CLEAN of USR =======+++++++"

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/webcamoid/userhome/.config/Webcamoid

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Webcamoid.zip

unzip Webcamoid.zip -d custom
mv custom/target/build/webcamoid-cp-init-script.sh custom

cd custom

# edit inf file for version number
#mkdir getversion
#cd getversion
#ar -x ../../webcamoid_*.deb
#tar xf control.tar.* ./control
#VERSION=$(grep Version control | cut -d " " -f 2)
VERSION=8.7.1
#echo "Version is: " ${VERSION}
#cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/webcamoid.inf
#echo "webcamoid.inf file is:"
#cat target/webcamoid.inf

# new build process into zip file
tar cvjf target/webcamoid.tar.bz2 webcamoid webcamoid-cp-init-script.sh
zip -g ../Webcamoid.zip target/webcamoid.tar.bz2 target/webcamoid.inf
zip -d ../Webcamoid.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Webcamoid.zip ../../Webcamoid-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
