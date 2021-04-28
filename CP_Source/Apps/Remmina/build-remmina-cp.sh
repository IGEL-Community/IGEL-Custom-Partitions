#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for remmina
## Development machine (Ubuntu 18.04)
MISSING_LIBS="i965-va-driver libavahi-ui-gtk3-0 libavcodec57 libavutil55 libcacard0 libcrystalhd3 libfreerdp-client2-2 libfreerdp2-2 libgsm1 libopenjp2-7 libphodav-2.0-0 libphodav-2.0-common libshine3 libsnappy1v5 libsoxr0 libspice-client-glib-2.0-8 libspice-client-gtk-3.0-5 libssh-4 libswresample2 libusbredirhost1 libusbredirparser1 libva-drm2 libva-x11-2 libva2 libvdpau1 libvncclient1 libwinpr2-2 libx264-152 libx265-146 libxvidcore4 libzvbi-common libzvbi0 mesa-va-drivers mesa-vdpau-drivers remmina remmina-common remmina-plugin-rdp remmina-plugin-secret remmina-plugin-spice remmina-plugin-vnc spice-client-glib-usb-acl-helper va-driver-all vdpau-driver-all"

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

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/ApPS/Remmina.zip

unzip Remmina.zip -d custom
mkdir -p custom/remmina/config/bin
mkdir -p custom/remmina/lib/systemd/system
mv custom/target/remmina_cp_apparmor_reload custom/remmina/config/bin
mv custom/target/igel-remmina-cp-apparmor-reload.service custom/remmina/lib/systemd/system/
mv custom/target/remmina-cp-init-script.sh custom

cd custom

tar cvjf remmina.tar.bz2 remmina remmina-cp-init-script.sh
mv remmina.tar.bz2 ../..
mv target/remmina.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
