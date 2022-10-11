#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for AWS VPN
## Development machine (Ubuntu 18.04)
#https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-working-endpoint-export.html
if ! compgen -G "$HOME/Downloads/*.ovpn" > /dev/null; then
  echo "***********"
  echo "Obtain The Client VPN endpoint configuration file, save into $HOME/Downloads and re-run this script "
  echo "https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-working-endpoint-export.html"
  exit 1
fi

sudo apt install curl -y
sudo apt install unzip -y

# https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-linux.html
sudo curl https://d20adtppz83p9s.cloudfront.net/GTK/latest/debian-repo/awsvpnclient_public_key.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://d20adtppz83p9s.cloudfront.net/GTK/latest/debian-repo ubuntu-18.04 main" > /etc/apt/sources.list.d/aws-vpn-client.list'
sudo apt-get update

MISSING_LIBS="awsvpnclient"

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/awsvpn

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/awsvpn
done

mv custom/awsvpn/usr/share/applications/ custom/awsvpn/usr/share/applications.mime

mkdir -p custom/awsvpn/var/log/aws-vpn-client
#mkdir -p custom/awsvpn/userhome/.config/AWSVPNClient
mkdir -p custom/awsvpn/userhome/AWS_VPN
cp $HOME/Downloads/*.ovpn custom/awsvpn/userhome/AWS_VPN
chmod 777 custom/awsvpn/userhome/AWS_VPN

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Network/AWS_VPN.zip

unzip AWS_VPN.zip -d custom
mv custom/target/build/awsvpn-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../awsvpn*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/awsvpn.inf
#echo "awsvpn.inf file is:"
#cat target/awsvpn.inf

# new build process into zip file
tar cvjf target/awsvpn.tar.bz2 awsvpn awsvpn-cp-init-script.sh
zip -g ../AWS_VPN.zip target/awsvpn.tar.bz2 target/awsvpn.inf
zip -d ../AWS_VPN.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../AWS_VPN.zip ../../AWS_VPN-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
