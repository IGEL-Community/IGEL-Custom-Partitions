#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for F5 VPN
## Development machine (Ubuntu 18.04)
# https://support.f5.com/csp/article/K13757
# https://techdocs.f5.com/kb/en-us/products/big-ip_apm/manuals/product/apm-client-configuration-13-0-0/4.html
if ! compgen -G "$HOME/Downloads/linux_f5cli.x86_64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain the three VPN deb files (linux_f5cli, linux_f5epi, linux_f5vpn) , save into $HOME/Downloads and re-run this script "
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/f5vpn/usr/local/lib/F5Networks/postinst
mkdir -p custom/userhome/.F5Networks

dpkg -x $HOME/Downloads/linux_f5cli.x86_64.deb custom/f5vpn
mkdir getpostinst
cd getpostinst
ar -x $HOME/Downloads/linux_f5cli.x86_64.deb
tar xf control.tar.*
cp postinst ../custom/f5vpn/usr/local/lib/F5Networks/postinst/f5cli_postinst.sh
chmod a+x ../custom/f5vpn/usr/local/lib/F5Networks/postinst/f5cli_postinst.sh
cd ..
rm -rf getpostinst

dpkg -x $HOME/Downloads/linux_f5epi.x86_64.deb custom/f5vpn
mkdir getpostinst
cd getpostinst
ar -x $HOME/Downloads/linux_f5epi.x86_64.deb
tar xf control.tar.*
cp postinst ../custom/f5vpn/usr/local/lib/F5Networks/postinst/f5epi_postinst.sh
chmod a+x ../custom/f5vpn/usr/local/lib/F5Networks/postinst/f5epi_postinst.sh
cd ..
rm -rf getpostinst

dpkg -x $HOME/linux_f5vpn.x86_64.deb custom/f5vpn
mkdir getpostinst
cd getpostinst
ar -x $HOME/Downloads/linux_f5vpn.x86_64.deb
tar xf control.tar.*
cp postinst ../custom/f5vpn/usr/local/lib/F5Networks/postinst/f5vpn_postinst.sh
chmod a+x ../custom/f5vpn/usr/local/lib/F5Networks/postinst/f5vpn_postinst.sh
cd ..
rm -rf getpostinst

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Network/F5_VPN.zip

unzip F5_VPN.zip -d custom
mv custom/target/build/f5vpn-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/linux_f5vpn.x86_64.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/f5vpn.inf
#echo "f5vpn.inf file is:"
#cat target/f5vpn.inf

# new build process into zip file
tar cvjf target/f5vpn.tar.bz2 f5vpn f5vpn-cp-init-script.sh
zip -g ../F5_VPN.zip target/f5vpn.tar.bz2 target/f5vpn.inf
zip -d ../F5_VPN.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../F5_VPN.zip ../../F5_VPN-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
