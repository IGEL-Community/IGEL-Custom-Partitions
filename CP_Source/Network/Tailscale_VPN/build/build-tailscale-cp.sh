#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Tailscale
## Development machine (Ubuntu 18.04)

#https://tailscale.com/download/linux/ubuntu-1804

sudo apt install curl -y
sudo apt install unzip -y

sudo curl https://pkgs.tailscale.com/stable/ubuntu/bionic.gpg | sudo apt-key add -
sudo curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/bionic.list | sudo tee /etc/apt/sources.list.d/tailscale.list

sudo apt-get update

MISSING_LIBS="tailscale"

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/tailscale

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/tailscale
done

#Tailscale_VPN CP: tailscaled.state file not persistent #25
mkdir -p custom/tailscale/var/lib/tailscale
sed -i "s|--state=/var|--state=/custom/tailscale/var|" custom/tailscale/lib/systemd/system/tailscaled.service

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Network/Tailscale_VPN.zip

unzip Tailscale_VPN.zip -d custom
mv custom/target/build/tailscale-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../tailscale*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/tailscale.inf
#echo "tailscale.inf file is:"
#cat target/tailscale.inf

# new build process into zip file
tar cvjf target/tailscale.tar.bz2 tailscale tailscale-cp-init-script.sh
zip -g ../Tailscale_VPN.zip target/tailscale.tar.bz2 target/tailscale.inf
zip -d ../Tailscale_VPN.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Tailscale_VPN.zip ../../Tailscale_VPN-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
