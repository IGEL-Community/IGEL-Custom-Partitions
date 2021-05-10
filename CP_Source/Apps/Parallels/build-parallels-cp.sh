#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Parallels Client
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
if ! compgen -G "$HOME/Downloads/RASClient*_x86_64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "***********"
  exit 1
fi

MISSING_LIBS="libccid libmng2 libmysqlclient20 libqt4-dbus libqt4-declarative libqt4-network libqt4-script libqt4-sql libqt4-sql-mysql libqt4-xml libqt4-xmlpatterns libqtcore4 libqtdbus4 libqtgui4 mysql-common pcscd qdbus qt-at-spi qtchooser qtcore4-l10n"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/parallels

dpkg -x $HOME/Downloads/RASClient*_x86_64.deb custom/parallels

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/parallels
done

mv custom/parallels/usr/share/applications/ custom/parallels/usr/share/applications.mime
mkdir -p custom/parallels/userhome/.config/2X

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Parallels.zip

unzip Parallels.zip -d custom
mkdir -p custom/parallels/config/bin
mkdir -p custom/parallels/lib/systemd/system
mv custom/target/parallels_cp_apparmor_reload custom/parallels/config/bin
mv custom/target/igel-parallels-cp-apparmor-reload.service custom/parallels/lib/systemd/system/
mv custom/target/parallels-cp-init-script.sh custom

cd custom

tar cvjf parallels.tar.bz2 parallels parallels-cp-init-script.sh
mv parallels.tar.bz2 ../..
mv target/parallels.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
