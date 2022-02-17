#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for remmina
## Development machine (Ubuntu 18.04)
MISSING_LIBS="firmware-crystalhd freerdp2-x11 i965-va-driver i965-va-driver-shaders libavahi-ui-gtk3-0 libavcodec57 libavutil55 libayatana-appindicator3-1 libayatana-indicator3-7 libcrystalhd3 libfreerdp2-2 libfreerdp-client2-2 libgsm1 libopenjp2-7 libshine3 libsnappy1v5 libsoxr0 libssh-4 libswresample2 libva2 libva-drm2 libva-x11-2 libvdpau1 libvdpau-va-gl1 libvncclient1 libwinpr2-2 libx264-152 libx265-146 libxvidcore4 libzvbi0 libzvbi-common mesa-va-drivers mesa-vdpau-drivers nvidia-legacy-340xx-vdpau-driver nvidia-vdpau-driver remmina remmina-common remmina-plugin-exec remmina-plugin-kwallet remmina-plugin-rdp remmina-plugin-secret remmina-plugin-spice remmina-plugin-vnc remmina-plugin-www remmina-plugin-x2go va-driver-all vdpau-driver-all"

sudo apt-add-repository ppa:remmina-ppa-team/remmina-next -y
sudo apt update -y

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/remmina

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/remmina
done

mv custom/remmina/usr/share/applications/ custom/remmina/usr/share/applications.mime
mkdir -p custom/remmina/userhome/.config/remmina
mkdir -p custom/remmina/userhome/.local/share/remmina

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/remmina/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/remmina/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Remmina_dev.zip

unzip Remmina_dev.zip -d custom
mkdir -p custom/remmina/config/bin
mkdir -p custom/remmina/lib/systemd/system
mv custom/target/build/remmina_cp_apparmor_reload custom/remmina/config/bin
mv custom/target/build/igel-remmina-cp-apparmor-reload.service custom/remmina/lib/systemd/system/
mv custom/target/build/remmina-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../remmina_*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/remmina.inf
#echo "remmina.inf file is:"
#cat target/remmina.inf

# new build process into zip file
tar cvjf target/remmina.tar.bz2 remmina remmina-cp-init-script.sh
zip -g ../Remmina_dev.zip target/remmina.tar.bz2 target/remmina.inf
zip -d ../Remmina_dev.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Remmina_dev.zip ../../Remmina_dev-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
