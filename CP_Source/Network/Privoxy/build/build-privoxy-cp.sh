#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Privoxy
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://www.privoxy.org/sf-download-mirror/Debian/
# https://www.privoxy.org/sf-download-mirror/Debian/3.0.33%20%28stable%29%20bullseye/privoxy_3.0.33-1~pp%2B1_amd64.deb
if ! compgen -G "$HOME/Downloads/privoxy_*_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://www.privoxy.org/sf-download-mirror/Debian/"
  echo "https://www.privoxy.org/sf-download-mirror/Debian/3.0.33%20%28stable%29%20bullseye/privoxy_3.0.33-1~pp%2B1_amd64.deb"
  echo "***********"
  exit 1
fi

MISSING_LIBS="libmbedcrypto1 libmbedtls10 libmbedx509-0"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/privoxy

dpkg -x $HOME/Downloads/privoxy_*_amd64.deb custom/privoxy

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/privoxy
done

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/privoxy/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/privoxy/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Network/Privoxy.zip

unzip Privoxy.zip -d custom
mv custom/target/build/privoxy-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/privoxy_*_amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/privoxy.inf
#echo "privoxy.inf file is:"
#cat target/privoxy.inf

# new build process into zip file
tar cvjf target/privoxy.tar.bz2 privoxy privoxy-cp-init-script.sh
zip -g ../Privoxy.zip target/privoxy.tar.bz2 target/privoxy.inf
zip -d ../Privoxy.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Privoxy.zip ../../Privoxy-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
