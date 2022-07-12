#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for wireshark
## Development machine (Ubuntu 18.04)
MISSING_LIBS="libc-ares2 libdouble-conversion1 liblua5.2-0 libmaxminddb0 libnl-route-3-200 libqgsttools-p1 libqt5core5a libqt5dbus5 libqt5gui5 libqt5multimedia5 libqt5multimedia5-plugins libqt5multimediawidgets5 libqt5network5 libqt5opengl5 libqt5printsupport5 libqt5svg5 libqt5widgets5 libsmi2ldbl libsnappy1v5 libspandsp2 libssh-gcrypt-4 libwireshark-data libwireshark11 libwiretap8 libwscodecs2 libwsutil9 libxcb-xinerama0 qt5-gtk-platformtheme qttranslations5-l10n wireshark wireshark-common wireshark-qt"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/wireshark

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/wireshark
done

mv custom/wireshark/usr/share/applications/ custom/wireshark/usr/share/applications.mime
#mkdir -p custom/wireshark/userhome/.config/wireshark
#mkdir -p custom/wireshark/userhome/.local/share/wireshark

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Wireshark.zip

unzip Wireshark.zip -d custom
mkdir -p custom/wireshark/config/bin
mkdir -p custom/wireshark/lib/systemd/system
mv custom/target/build/wireshark_cp_apparmor_reload custom/wireshark/config/bin
mv custom/target/build/igel-wireshark-cp-apparmor-reload.service custom/wireshark/lib/systemd/system/
mv custom/target/build/wireshark-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../wireshark_*_amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/wireshark.inf
#echo "wireshark.inf file is:"
#cat target/wireshark.inf

# new build process into zip file
tar cvjf target/wireshark.tar.bz2 wireshark wireshark-cp-init-script.sh
zip -g ../Wireshark.zip target/wireshark.tar.bz2 target/wireshark.inf
zip -d ../Wireshark.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Wireshark.zip ../../Wireshark-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
