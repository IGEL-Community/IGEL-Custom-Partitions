#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for vlc
## Development machine (Ubuntu 18.04)
MISSING_LIBS="i965-va-driver liba52-0.7.4 libaacs0 libaribb24-0 libass9 libavcodec57 libavformat57 libavutil55 libbasicusageenvironment1 libbdplus0 libbluray2 libcddb2 libchromaprint1 libcrystalhd3 libdc1394-22 libdca0 libdouble-conversion1 libdvbpsi10 libdvdnav4 libdvdread4 libebml4v5 libfaad2 libgme0 libgroupsock8 libgsm1 libkate1 liblirc-client0 liblivemedia62 liblua5.2-0 libmad0 libmatroska6v5 libmicrodns0 libmpcdec6 libmpeg2-4 libnfs11 libopenjp2-7 libopenmpt-modplug1 libopenmpt0 libplacebo4 libpostproc54 libprotobuf-lite10 libproxy-tools libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libqt5x11extras5 libresid-builder0c2a libsdl-image1.2 libsdl1.2debian libshine3 libsidplay2 libsnappy1v5 libsndio6.1 libsoxr0 libssh-gcrypt-4 libssh2-1 libswresample2 libswscale4 libupnp6 libusageenvironment3 libva-drm2 libva-wayland2 libva-x11-2 libva2 libvdpau1 libvlc-bin libvlc5 libvlccore9 libvulkan1 libx264-152 libx265-146 libxcb-xinerama0 libxvidcore4 libzvbi-common libzvbi0 mesa-va-drivers mesa-vdpau-drivers qt5-gtk-platformtheme qttranslations5-l10n va-driver-all vdpau-driver-all vlc-bin vlc-data vlc-l10n vlc-plugin-base vlc-plugin-notify vlc-plugin-qt vlc-plugin-samba vlc-plugin-skins2 vlc-plugin-video-output vlc-plugin-video-splitter vlc-plugin-visualization"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

apt-get download vlc

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/vlc

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/vlc
done

mv custom/vlc/usr/share/applications/ custom/vlc/usr/share/applications.mime
mkdir -p custom/vlc/userhome/.config/vlc
mkdir -p custom/vlc/userhome/.local/share/vlc

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/VLC.zip

unzip VLC.zip -d custom
mkdir -p custom/vlc/config/bin
mkdir -p custom/vlc/lib/systemd/system
mv custom/target/build/vlc_cp_apparmor_reload custom/vlc/config/bin
mv custom/target/build/igel-vlc-cp-apparmor-reload.service custom/vlc/lib/systemd/system/
mv custom/target/build/vlc-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../vlc_*amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/vlc.inf
#echo "vlc.inf file is:"
#cat target/vlc.inf

# new build process into zip file
tar cvjf target/vlc.tar.bz2 vlc vlc-cp-init-script.sh
zip -g ../VLC.zip target/vlc.tar.bz2 target/vlc.inf
zip -d ../VLC.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../VLC.zip ../../VLC-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
