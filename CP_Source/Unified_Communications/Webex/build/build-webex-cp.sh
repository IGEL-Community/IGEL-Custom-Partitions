#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Webex
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
#https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb
#https://www.webex.com/downloads.html
if ! compgen -G "$HOME/Downloads/Webex*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  #echo "https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb"
  echo "https://www.webex.com/downloads.html"
  echo "***********"
  exit 1
fi

MISSING_LIBS="libxcb-xinerama0"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

#wget https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/webex

dpkg -x $HOME/Downloads/Webex*.deb custom/webex
#dpkg -x Webex*.deb custom/webex

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/webex
done

mkdir -p custom/webex/usr/share/applications.mime
cp custom/webex/opt/Webex/bin/webex.desktop custom/webex/usr/share/applications.mime

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/webex/userhome/.local/share/Webex

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Webex.zip

unzip Webex.zip -d custom
mkdir -p custom/webex/config/bin
mkdir -p custom/webex/lib/systemd/system
mv custom/target/build/webex_cp_apparmor_reload custom/webex/config/bin
mv custom/target/build/igel-webex-cp-apparmor-reload.service custom/webex/lib/systemd/system/
mv custom/target/build/webex-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/Webex*.deb
#ar -x ../../Webex*.deb
tar xf control.tar.gz ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/webex.inf
#echo "webex.inf file is:"
#cat target/webex.inf

# new build process into zip file
tar cvjf target/webex.tar.bz2 webex webex-cp-init-script.sh
zip -g ../Webex.zip target/webex.tar.bz2 target/webex.inf
zip -d ../Webex.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Webex.zip ../../Webex-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
