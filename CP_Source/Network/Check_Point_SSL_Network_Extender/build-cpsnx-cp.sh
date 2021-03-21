#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Check Point SSL Network Extender (SNX)
## Development machine (Ubuntu 18.04)
MISSING_LIBS="gcc-8-base:i386 libaudit1:i386 libbsd0:i386 libc6:i386 libcap-ng0:i386 libgcc1:i386 libpam0g:i386 libstdc++5 libstdc++5:i386 libstdc++6:i386 libx11-6:i386 libxau6:i386 libxcb1:i386 libxdmcp6:i386"
SNX_INSTALL="$HOME/Downloads/snx_install.sh"

if ! compgen -G "$SNX_INSTALL" > /dev/null; then
  echo "***********"
  echo "Obtain latest snx_install.sh package, save into $HOME/Downloads and re-run this script "
  echo "***********"
  exit 1
fi

OFFSET=`head -10 $SNX_INSTALL | grep ARCHIVE_OFFSET | awk -F "=" '{print $2}'`

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/cpsnx/usr/bin
mkdir -p custom/cpsnx/etc/snx

tail -n +$OFFSET $SNX_INSTALL | bunzip2 -c - | tar xf - > /dev/null 2>&1
mv snx custom/cpsnx/usr/bin

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/cpsnx
done

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Network/Check_Point_SSL_Network_Extender.zip

unzip Check_Point_SSL_Network_Extender.zip -d custom
mv custom/target/cpsnx-cp-init-script.sh custom

cd custom

tar cvjf cpsnx.tar.bz2 cpsnx cpsnx-cp-init-script.sh
mv cpsnx.tar.bz2 ../..
mv target/cpsnx.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
