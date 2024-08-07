#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Pulse Secure VPN
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# pulsesecure_9.1.R12_amd64.deb
if ! compgen -G "$HOME/Downloads/pulsesecure_*_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest pulsesecure_*_amd64.deb package, save into $HOME/Downloads and re-run this script "
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

apt-get download libgnome-keyring0

mkdir -p custom/pulse
dpkg -x $HOME/Downloads/pulsesecure_*_amd64.deb custom/pulse
dpkg -x libg* custom/pulse

mv custom/pulse/usr/share/applications/ custom/pulse/usr/share/applications.mime
setfacl -d -m g::r custom/pulse/var/lib/pulsesecure/pulse
setfacl -d -m o::r custom/pulse/var/lib/pulsesecure/pulse
#CEF install change path from /tmp to /custom
SETUP_CEF=custom/pulse/opt/pulsesecure/bin/setup_cef.sh
sed -i -e "s|TMP_DIR=/tmp/cef.download|TMP_DIR=/custom/cef.download|" $SETUP_CEF
sed -i -e "s|CEF_INSTALL_ROOT_DIR=/opt|CEF_INSTALL_ROOT_DIR=/custom/pulse/opt|" $SETUP_CEF
TMP_DIR=.
CEF_INSTALL_ROOT_DIR=custom/pulse/opt
CEF_INSTALL_DIR=${CEF_INSTALL_ROOT_DIR}/pulsesecure/lib/cefRuntime
CEF_URL=`grep URL= $SETUP_CEF | grep linux | cut -d "=" -f 2`
CEF_PACKAGE_NAME=`grep CEF_PACKAGE_NAME= $SETUP_CEF | cut -d "=" -f 2`
wget -O cef64.tar.bz2 $CEF_URL
tar xvf cef64.tar.bz2
cp -r $CEF_PACKAGE_NAME/* $CEF_INSTALL_DIR/
cp -r $CEF_INSTALL_DIR/Resources/* $CEF_INSTALL_DIR/Release/

mkdir -p custom/pulse/userhome/.pulsesecure

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Network/Pulse_VPN.zip

unzip Pulse_VPN.zip -d custom
mv custom/target/pulse-cp-init-script.sh custom

cd custom

tar cvjf pulse.tar.bz2 pulse pulse-cp-init-script.sh
mv pulse.tar.bz2 ../..
mv target/pulse.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
