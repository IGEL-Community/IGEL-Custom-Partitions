#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine Ubuntu (OS11.09+ = 22.04; OS12 = 20.04)
CP="vlc"
ZIP_LOC="https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps"
ZIP_FILE="VLC"
FIX_MIME="TRUE"
CLEAN="TRUE"
OS11_CLEAN1109="11.10.210"
OS12_CLEAN="12.6.0"
USERHOME_FOLDERS="TRUE"
USERHOME_FOLDERS_DIRS="custom/${CP}/userhome/.config/${CP} custom/${CP}/userhome/.local/share/${CP}"
APPARMOR="TRUE"
GETVERSION_FILE="../../${CP}_*amd64.deb"
#MISSING_LIBS_OS1109="i965-va-driver intel-media-va-driver liba52-0.7.4 libaacs0 libaom3 libaribb24-0 libass9 libavcodec58 libavformat58 libavutil56 libbdplus0 libbluray2 libcddb2 libchromaprint1 libcodec2-1.0 libdav1d5 libdc1394-25 libdca0 libdouble-conversion3 libdvbpsi10 libdvdnav4 libdvdread8 libebml5 libfaad2 libgme0 libgsm1 libigdgmm12 libixml10 libkate1 liblirc-client0 liblua5.2-0 libmad0 libmatroska7 libmd4c0 libmfx1 libmpcdec6 libmpeg2-4 libmysofa1 libnorm1 libopenmpt-modplug1 libopenmpt0 libpcre2-16-0 libpgm-5.3-0 libplacebo192 libpostproc55 libprotobuf-lite23 libproxy-tools libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libqt5x11extras5 librabbitmq4 libresid-builder0c2a libsdl-image1.2 libsdl1.2debian libshine3 libsidplay2 libsnappy1v5 libsndio7.0 libspatialaudio0 libsrt1.4-gnutls libssh-gcrypt-4 libssh2-1 libswresample3 libswscale5 libudfread0 libupnp13 libva-drm2 libva-wayland2 libva-x11-2 libva2 libvdpau1 libvlc-bin libvlc5 libvlccore9 libvncclient1 libx264-163 libx265-199 libxcb-composite0 libxcb-xinerama0 libxcb-xinput0 libxvidcore4 libzmq5 libzvbi-common libzvbi0 mesa-va-drivers mesa-vdpau-drivers ocl-icd-libopencl1 qt5-gtk-platformtheme qttranslations5-l10n va-driver-all vdpau-driver-all vlc vlc-bin vlc-data vlc-l10n vlc-plugin-access-extra vlc-plugin-base vlc-plugin-notify vlc-plugin-qt vlc-plugin-samba vlc-plugin-skins2 vlc-plugin-video-output vlc-plugin-video-splitter vlc-plugin-visualization"
MISSING_LIBS_OS1109="cabextract chromium-codecs-ffmpeg-extra gstreamer1.0-libav gstreamer1.0-plugins-ugly gstreamer1.0-vaapi i965-va-driver intel-media-va-driver liba52-0.7.4 libaacs0 libaom3 libaribb24-0 libass9 libavcodec-extra libavcodec-extra58 libavcodec58 libavfilter7 libavformat58 libavutil56 libbdplus0 libblas3 libbluray2 libbs2b0 libcddb2 libchromaprint1 libcodec2-1.0 libdav1d5 libdc1394-25 libdca0 libdouble-conversion3 libdvbpsi10 libdvdnav4 libdvdread8 libebml5 libfaad2 libflite1 libgfortran5 libgme0 libgsm1 libgstreamer-plugins-bad1.0-0 libigdgmm12 libixml10 libkate1 liblapack3 liblilv-0-0 liblirc-client0 liblua5.2-0 libmad0 libmatroska7 libmd4c0 libmfx1 libmpcdec6 libmpeg2-4 libmysofa1 libnorm1 libopencore-amrnb0 libopencore-amrwb0 libopenmpt-modplug1 libopenmpt0 libpcre2-16-0 libpgm-5.3-0 libplacebo192 libpocketsphinx3 libpostproc55 libprotobuf-lite23 libproxy-tools libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libqt5x11extras5 librabbitmq4 libresid-builder0c2a librubberband2 libsdl-image1.2 libsdl1.2debian libserd-0-0 libshine3 libsidplay1v5 libsidplay2 libsnappy1v5 libsndio7.0 libsord-0-0 libspatialaudio0 libsphinxbase3 libsratom-0-0 libsrt1.4-gnutls libssh-gcrypt-4 libssh2-1 libswresample3 libswscale5 libudfread0 libupnp13 libva-drm2 libva-wayland2 libva-x11-2 libva2 libvdpau1 libvidstab1.1 libvlc-bin libvlc5 libvlccore9 libvncclient1 libvo-amrwbenc0 libx264-163 libx265-199 libxcb-composite0 libxcb-xinerama0 libxcb-xinput0 libxvidcore4 libzimg2 libzmq5 libzvbi-common libzvbi0 mesa-va-drivers mesa-vdpau-drivers ocl-icd-libopencl1 pocketsphinx-en-us qt5-gtk-platformtheme qttranslations5-l10n ttf-mscorefonts-installer ubuntu-restricted-addons ubuntu-restricted-extras unrar va-driver-all vdpau-driver-all vlc vlc-bin vlc-data vlc-l10n vlc-plugin-access-extra vlc-plugin-base vlc-plugin-notify vlc-plugin-qt vlc-plugin-samba vlc-plugin-skins2 vlc-plugin-video-output vlc-plugin-video-splitter vlc-plugin-visualization"
MISSING_LIBS_OS12="i965-va-driver intel-media-va-driver liba52-0.7.4 libaacs0 libaom0 libaribb24-0 libass9 libavcodec58 libavformat58 libavutil56 libbasicusageenvironment1 libbdplus0 libbluray2 libcddb2 libchromaprint1 libcodec2-0.9 libdc1394-22 libdca0 libdouble-conversion3 libdvbpsi10 libdvdnav4 libdvdread7 libebml4v5 libfaad2 libgme0 libgroupsock8 libgsm1 libigdgmm11 libixml10 libkate1 liblirc-client0 liblivemedia77 liblua5.2-0 libmad0 libmatroska6v5 libmpcdec6 libmpeg2-4 libmysofa1 libopenmpt-modplug1 libopenmpt0 libpcre2-16-0 libplacebo7 libpostproc55 libprotobuf-lite17 libproxy-tools libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libqt5x11extras5 libresid-builder0c2a libsdl-image1.2 libsdl1.2debian libshine3 libsidplay2 libsnappy1v5 libsndio7.0 libspatialaudio0 libsrt1 libssh-gcrypt-4 libssh2-1 libswresample3 libswscale5 libupnp13 libusageenvironment3 libva-drm2 libva-wayland2 libva-x11-2 libva2 libvdpau1 libvlc-bin libvlc5 libvlccore9 libx264-155 libx265-179 libxcb-xinerama0 libxcb-xinput0 libxvidcore4 libzvbi-common libzvbi0 mesa-va-drivers mesa-vdpau-drivers ocl-icd-libopencl1 qt5-gtk-platformtheme qttranslations5-l10n va-driver-all vdpau-driver-all vlc vlc-bin vlc-data vlc-l10n vlc-plugin-base vlc-plugin-notify vlc-plugin-qt vlc-plugin-samba vlc-plugin-skins2 vlc-plugin-video-output vlc-plugin-video-splitter vlc-plugin-visualization"

VERSION_ID=$(grep "^VERSION_ID" /etc/os-release | cut -d "\"" -f 2)

if [ "${VERSION_ID}" = "22.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS1109}"
  IGELOS_ID="OS11"
  IGELOS_ID_VER="OS1109"
  OS11_CLEAN="${OS11_CLEAN1109}"
elif [ "${VERSION_ID}" = "20.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS12}"
  IGELOS_ID="OS12"
  IGELOS_ID_VER="OS12"
else
  echo "Not a valid Ubuntu OS release. OS11.09+ needs 22.04 (jammy), and OS12 needs 20.04 (focal)."
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

if [ "${FIX_MIME}" = "TRUE" ]; then
  mv custom/${CP}/usr/share/applications/ custom/${CP}/usr/share/applications.mime
fi

if [ "${USERHOME_FOLDERS}" = "TRUE" ]; then
  for folder in $USERHOME_FOLDERS_DIRS; do
    mkdir -p $folder
  done
fi

if [ "${CLEAN}" = "TRUE" ]; then
  echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
  wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
  chmod a+x clean_cp_usr_lib.sh
  wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
  chmod a+x clean_cp_usr_share.sh
  if [ "${IGELOS_ID}" = "OS11" ]; then
    ./clean_cp_usr_lib.sh ${OS11_CLEAN}_usr_lib.txt custom/${CP}/usr/lib
    ./clean_cp_usr_share.sh ${OS11_CLEAN}_usr_share.txt custom/${CP}/usr/share
  else
    ./clean_cp_usr_lib.sh ${OS12_CLEAN}_usr_lib.txt custom/${CP}/usr/lib
    ./clean_cp_usr_share.sh ${OS12_CLEAN}_usr_share.txt custom/${CP}/usr/share
  fi
  echo "+++++++=======  DONE CLEAN of USR =======+++++++"
fi

wget ${ZIP_LOC}/${ZIP_FILE}.zip

unzip ${ZIP_FILE}.zip -d custom

if [ "${APPARMOR}" = "TRUE" ]; then
  mkdir -p custom/${CP}/config/bin
  mkdir -p custom/${CP}/lib/systemd/system
  mv custom/target/build/${CP}_cp_apparmor_reload custom/${CP}/config/bin
  mv custom/target/build/igel-${CP}-cp-apparmor-reload.service custom/${CP}/lib/systemd/system/
fi
mv custom/target/build/${CP}-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ${GETVERSION_FILE}
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
mv ../${ZIP_FILE}.zip ../../${ZIP_FILE}-${VERSION}_${IGELOS_ID_VER}_igel01.zip

cd ../..
rm -rf build_tar