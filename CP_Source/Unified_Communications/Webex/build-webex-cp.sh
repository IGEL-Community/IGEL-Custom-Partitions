#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Webex
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
#https://www.webex.com/downloads.html
if ! compgen -G "$HOME/Downloads/Webex*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://www.webex.com/downloads.html"
  echo "***********"
  exit 1
fi

MISSING_LIBS="libxcb-xinerama0"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/webex

dpkg -x $HOME/Downloads/Webex*.deb custom/webex

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
mv custom/target/webex_cp_apparmor_reload custom/webex/config/bin
mv custom/target/igel-webex-cp-apparmor-reload.service custom/webex/lib/systemd/system/
mv custom/target/webex-cp-init-script.sh custom

cd custom

tar cvjf webex.tar.bz2 webex webex-cp-init-script.sh
mv webex.tar.bz2 ../..
mv target/webex.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
