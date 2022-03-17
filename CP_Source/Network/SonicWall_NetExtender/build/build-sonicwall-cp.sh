#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for SonicWall NetExtender VPN
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
#NetExtender.Linux-10.2.835.x86_64.tgz
#https://www.sonicwall.com/products/remote-access/vpn-clients/
if ! compgen -G "$HOME/Downloads/NetExtender.Linux-*.x86_64.tgz" > /dev/null; then
  echo "***********"
  echo "Obtain latest NetExtender.Linux-*.x86_64.tgz package, save into $HOME/Downloads and re-run this script "
  echo " https://www.sonicwall.com/products/remote-access/vpn-clients/"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

USRLIB='custom/sonicwall/usr/lib'
LIB='custom/sonicwall/lib'
CABUNDLE='ca-bundle.crt'
SWINSTALL='custom/swinstall'
SWFILEPATH='custom/swinstall/netExtenderClient'
CP_PATH='custom/sonicwall'
USRSHARE='custom/sonicwall/usr/share/netExtender'
USRSHAREICONS='custom/sonicwall/usr/share/netExtender/icons'
APPSMIME='custom/sonicwall/usr/share/applications.mime'
ETC='custom/sonicwall/etc/ppp/peers'
USRBIN='custom/sonicwall/usr/bin'
USRSBIN='custom/sonicwall/usr/sbin'

mkdir -p $CP_PATH
mkdir -p $SWINSTALL
mkdir -p $USRLIB
mkdir -p $LIB
mkdir -p $USRSHARE
mkdir -p $USRSHAREICONS
mkdir -p $APPSMIME
mkdir -p $ETC
mkdir -p $USRBIN
mkdir -p $USRSBIN

tar xvf $HOME/Downloads/NetExtender.Linux-*.x86_64.tgz --directory $SWINSTALL

install -m 644 $SWFILEPATH/sslvpn $ETC/sslvpn
install -m 755 $SWFILEPATH/netExtender $USRSBIN
install -m 755 $SWFILEPATH/netExtenderGui $USRBIN
install -m 744 $SWFILEPATH/nxMonitor $USRSBIN

install -m 755 $SWFILEPATH/libNetExtender.so $USRLIB
install -m 755 $SWFILEPATH/libNetExtenderEpc.so $USRLIB
install -m 644 $SWFILEPATH/$CABUNDLE $USRSHARE

install -m 644 $SWFILEPATH/NetExtender.jar $USRLIB
install -m 644 $SWFILEPATH/icons/* $USRSHAREICONS
install -m 664 $SWFILEPATH/NetExtender.desktop $USRSHARE
cp $USRSHARE/NetExtender.desktop $APPSMIME/sonicwall-netextender.desktop

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Network/SonicWall_NetExtender.zip

unzip SonicWall_NetExtender.zip -d custom
mv custom/target/build/sonicwall-cp-init-script.sh custom

# edit inf file for version number
VERSION=$(grep VERSION= $SWFILEPATH/install | cut -d "\"" -f 2)
#echo "Version is: " ${VERSION}
sed -i "/^version=/c version=\"${VERSION}\"" custom/target/sonicwall.inf
#echo "sonicwall.inf file is:"
#cat target/sonicwall.inf

cd custom

# new build process into zip file
tar cvjf target/sonicwall.tar.bz2 sonicwall sonicwall-cp-init-script.sh
zip -g ../SonicWall_NetExtender.zip target/sonicwall.tar.bz2 target/sonicwall.inf
zip -d ../SonicWall_NetExtender.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../SonicWall_NetExtender.zip ../../SonicWall_NetExtender-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
