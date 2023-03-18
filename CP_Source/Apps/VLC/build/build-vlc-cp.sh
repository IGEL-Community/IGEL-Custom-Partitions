#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine Ubuntu (OS11 = 18.04; OS12 = 20.04)
CP="vlc"
ZIP_LOC="https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps"
ZIP_FILE="VLC"
USERHOME_FOLDERS="custom/${CP}/userhome/.config/${CP} custom/${CP}/userhome/.local/share/${CP}"
MISSING_LIBS_OS11="i965-va-driver liba52-0.7.4 libaacs0 libaribb24-0 libass9 libavcodec57 libavformat57 libavutil55 libbasicusageenvironment1 libbdplus0 libbluray2 libcddb2 libchromaprint1 libcrystalhd3 libdc1394-22 libdca0 libdouble-conversion1 libdvbpsi10 libdvdnav4 libdvdread4 libebml4v5 libfaad2 libgme0 libgroupsock8 libgsm1 libkate1 liblirc-client0 liblivemedia62 liblua5.2-0 libmad0 libmatroska6v5 libmicrodns0 libmpcdec6 libmpeg2-4 libnfs11 libopenjp2-7 libopenmpt-modplug1 libopenmpt0 libplacebo4 libpostproc54 libprotobuf-lite10 libproxy-tools libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libqt5x11extras5 libresid-builder0c2a libsdl-image1.2 libsdl1.2debian libshine3 libsidplay2 libsnappy1v5 libsndio6.1 libsoxr0 libssh-gcrypt-4 libssh2-1 libswresample2 libswscale4 libupnp6 libusageenvironment3 libva-drm2 libva-wayland2 libva-x11-2 libva2 libvdpau1 libvlc-bin libvlc5 libvlccore9 libvulkan1 libx264-152 libx265-146 libxcb-xinerama0 libxvidcore4 libzvbi-common libzvbi0 mesa-va-drivers mesa-vdpau-drivers qt5-gtk-platformtheme qttranslations5-l10n va-driver-all vdpau-driver-all vlc vlc-bin vlc-data vlc-l10n vlc-plugin-base vlc-plugin-notify vlc-plugin-qt vlc-plugin-samba vlc-plugin-skins2 vlc-plugin-video-output vlc-plugin-video-splitter vlc-plugin-visualization"
MISSING_LIBS_OS12="i965-va-driver intel-media-va-driver liba52-0.7.4 libaacs0 libaom0 libaribb24-0 libass9 libavcodec58 libavformat58 libavutil56 libbasicusageenvironment1 libbdplus0 libbluray2 libcddb2 libchromaprint1 libcodec2-0.9 libdc1394-22 libdca0 libdouble-conversion3 libdvbpsi10 libdvdnav4 libdvdread7 libebml4v5 libfaad2 libgme0 libgroupsock8 libgsm1 libigdgmm11 libixml10 libkate1 liblirc-client0 liblivemedia77 liblua5.2-0 libmad0 libmatroska6v5 libmpcdec6 libmpeg2-4 libmysofa1 libopenmpt-modplug1 libopenmpt0 libpcre2-16-0 libplacebo7 libpostproc55 libprotobuf-lite17 libproxy-tools libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libqt5x11extras5 libresid-builder0c2a libsdl-image1.2 libsdl1.2debian libshine3 libsidplay2 libsnappy1v5 libsndio7.0 libspatialaudio0 libsrt1 libssh-gcrypt-4 libssh2-1 libswresample3 libswscale5 libupnp13 libusageenvironment3 libva-drm2 libva-wayland2 libva-x11-2 libva2 libvdpau1 libvlc-bin libvlc5 libvlccore9 libx264-155 libx265-179 libxcb-xinerama0 libxcb-xinput0 libxvidcore4 libzvbi-common libzvbi0 mesa-va-drivers mesa-vdpau-drivers ocl-icd-libopencl1 qt5-gtk-platformtheme qttranslations5-l10n va-driver-all vdpau-driver-all vlc vlc-bin vlc-data vlc-l10n vlc-plugin-base vlc-plugin-notify vlc-plugin-qt vlc-plugin-samba vlc-plugin-skins2 vlc-plugin-video-output vlc-plugin-video-splitter vlc-plugin-visualization"

VERSION_ID=$(grep "^VERSION_ID" /etc/os-release | cut -d "\"" -f 2)

if [ "${VERSION_ID}" = "18.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS11}"
  IGELOS_ID="OS11"
elif [ "${VERSION_ID}" = "20.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS12}"
  IGELOS_ID="OS12"
else
  echo "Not a valid Ubuntu OS release. OS11 needs 18.04 and OS12 needs 20.04."
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/${CP}

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/${CP}
done

mv custom/${CP}/usr/share/applications/ custom/${CP}/usr/share/applications.mime

for folder in $USERHOME_FOLDERS; do
  mkdir -p $folder
done

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
if [ "${IGELOS_ID}" = "OS11" ]; then
  ./clean_cp_usr_lib.sh 11.07.100_usr_lib.txt custom/${CP}/usr/lib
  ./clean_cp_usr_share.sh 11.07.100_usr_share.txt custom/${CP}/usr/share
else
  ./clean_cp_usr_lib.sh 12.01.100_usr_lib.txt custom/${CP}/usr/lib
  ./clean_cp_usr_share.sh 12.01.100_usr_share.txt custom/${CP}/usr/share
fi
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget ${ZIP_LOC}/${ZIP_FILE}.zip

unzip ${ZIP_FILE}.zip -d custom
mkdir -p custom/${CP}/config/bin
mkdir -p custom/${CP}/lib/systemd/system
mv custom/target/build/${CP}_cp_apparmor_reload custom/${CP}/config/bin
mv custom/target/build/igel-${CP}-cp-apparmor-reload.service custom/${CP}/lib/systemd/system/
mv custom/target/build/${CP}-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../${CP}_*amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/${CP}.inf
#echo "${CP}.inf file is:"
#cat target/${CP}.inf

# new build process into zip file
tar cvjf target/${CP}.tar.bz2 ${CP} ${CP}-cp-init-script.sh
zip -g ../${ZIP_FILE}.zip target/${CP}.tar.bz2 target/${CP}.inf
zip -d ../${ZIP_FILE}.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../${ZIP_FILE}.zip ../../${ZIP_FILE}-${VERSION}_${IGELOS_ID}_igel01.zip

cd ../..
rm -rf build_tar
