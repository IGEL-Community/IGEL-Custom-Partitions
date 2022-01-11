#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Dynamsoft Dynamic Web TWAIN Demo
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y
sudo apt install zip -y

# Obtain latest package and save into Downloads
# Download App for Linux (Debian)
# Dynamsoft - Dynamic Web TWAIN (Demo)
# https://demo.dynamsoft.com/web-twain/
# DynamsoftServiceSetup.deb
if ! compgen -G "$HOME/Downloads/DynamsoftServiceSetup.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest agent, save into $HOME/Downloads and re-run this script "
  echo "https://demo.dynamsoft.com/web-twain/"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/dynamsoft

dpkg -x $HOME/Downloads/DynamsoftServiceSetup.deb custom/dynamsoft

# START: items from postinst
CP_PATH="custom/dynamsoft"
mkdir -p ${CP_PATH}/usr/bin
ln -s ${CP_PATH}/opt/dynamsoft/DynamsoftService/pnm2bmp ${CP_PATH}/usr/bin/pnm2bmp
ln -s ${CP_PATH}/opt/dynamsoft/DynamsoftService/server.der ${CP_PATH}/usr/bin/server.der
ln -s ${CP_PATH}/opt/dynamsoft/DynamsoftService/DynamsoftServiceMgr ${CP_PATH}/usr/bin/DynamsoftServiceMgr
ln -s ${CP_PATH}/opt/dynamsoft/DynamsoftService/DynamsoftCertCheckMgr ${CP_PATH}/usr/bin/DynamsoftCertCheckMgr

# Create otpclient.cfg -- move this into init script for non-persistency
cat << 'EOF' >> ${CP_PATH}/usr/bin/igel_dynamsoft_autostart.sh
#!/bin/bash

systemctl enable /opt/dynamsoft/DynamsoftService/dynamsoft.service
systemctl start dynamsoft.service

/opt/dynamsoft/DynamsoftService/AutoStartMgr "sudo -u user /opt/dynamsoft/DynamsoftService/DynamsoftCertCheckMgr&"
/opt/dynamsoft/DynamsoftService/AutoStartMgr "sudo -u user /opt/dynamsoft/DynamsoftService/DynamsoftScanning gtkproxy&"
EOF
chmod a+x ${CP_PATH}/usr/bin/igel_dynamsoft_autostart.sh
# END: items from postinst

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Dynamsoft_Dynamic_Web_TWAIN.zip

unzip Dynamsoft_Dynamic_Web_TWAIN.zip -d custom
mv custom/target/build/dynamsoft-cp-init-script.sh custom

cd custom

# edit inf file for version number
# create ClientLaunchParameters.txt
mkdir getversion
cd getversion
ar -x $HOME/Downloads/DynamsoftServiceSetup.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/dynamsoft.inf
#echo "dynamsoft.inf file is:"
#cat target/dynamsoft.inf

# new build process into zip file
tar cvjf target/dynamsoft.tar.bz2 dynamsoft dynamsoft-cp-init-script.sh
zip -g ../Dynamsoft_Dynamic_Web_TWAIN.zip target/dynamsoft.tar.bz2 target/dynamsoft.inf
zip -d ../Dynamsoft_Dynamic_Web_TWAIN.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Dynamsoft_Dynamic_Web_TWAIN.zip ../../Dynamsoft_Dynamic_Web_TWAIN-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
