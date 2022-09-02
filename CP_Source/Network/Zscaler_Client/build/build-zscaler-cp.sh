#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for zscaler
## Development machine (Ubuntu 18.04)
# zscaler-client_1.3.0.30-0_amd64.deb
if ! compgen -G "$HOME/Downloads/zscaler-client_*_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain the zscaler-client amd64.deb , save into $HOME/Downloads and re-run this script "
  exit 1
fi

MISSING_LIBS="i965-va-driver jq libaacs0 libavcodec57 libavformat57 libavutil55 libbdplus0 libbluray2 libchromaprint1 libcrystalhd3 libdouble-conversion1 libevent-2.1-6 libgme0 libgsm1 libjq1 libminizip1 libnss-resolve libnss3-tools libonig4 libopenjp2-7 libopenmpt0 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5opengl5 libqt5positioning5 libqt5printsupport5 libqt5qml5 libqt5quick5 libqt5quickcontrols2-5 libqt5quickparticles5 libqt5quicktemplates2-5 libqt5quickwidgets5 libqt5sensors5 libqt5sql5 libqt5sql5-sqlite libqt5svg5 libqt5webchannel5 libqt5webengine-data libqt5webengine5 libqt5webenginecore5 libqt5webenginewidgets5 libqt5webkit5 libqt5webview5 libqt5widgets5 libre2-4 libshine3 libsnappy1v5 libsoxr0 libssh-gcrypt-4 libswresample2 libva-drm2 libva-x11-2 libva2 libvdpau1 libx264-152 libx265-146 libxcb-xinerama0 libxvidcore4 libzvbi-common libzvbi0 mesa-va-drivers mesa-vdpau-drivers net-tools qt5-gtk-platformtheme qttranslations5-l10n systemd-coredump va-driver-all vdpau-driver-all"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/zscaler

dpkg -x $HOME/Downloads/zscaler-client_*_amd64.deb custom/zscaler

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/zscaler
done

mv custom/zscaler/usr/share/applications/ custom/zscaler/usr/share/applications.mime
mv custom/zscaler/opt/zscaler/bin/ZSTray.Deb custom/zscaler/opt/zscaler/bin/ZSTray
rm -f custom/zscaler/opt/zscaler/bin/ZSTray.R*

mkdir -p custom/zscaler/userhome/.Zscaler

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.07.100_usr_lib.txt custom/zscaler/usr/lib
./clean_cp_usr_share.sh 11.07.100_usr_share.txt custom/zscaler/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Network/Zscaler_Client.zip

unzip Zscaler_Client.zip -d custom
mv custom/target/build/zscaler-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/zscaler-client_*_amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/zscaler.inf
#echo "zscaler.inf file is:"
#cat target/zscaler.inf

# new build process into zip file
tar cvjf target/zscaler.tar.bz2 zscaler zscaler-cp-init-script.sh
zip -g ../Zscaler_Client.zip target/zscaler.tar.bz2 target/zscaler.inf
zip -d ../Zscaler_Client.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Zscaler_Client.zip ../../Zscaler_Client-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
