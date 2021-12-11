#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for FreshService agent
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain latest package and save into Downloads
# Download App for Linux (Debian)
# https://support.freshservice.com/support/solutions/articles/200393
# FS-Linux-Agent.py
if ! compgen -G "$HOME/Downloads/FS-Linux-Agent.py" > /dev/null; then
  echo "***********"
  echo "Obtain latest agent, save into $HOME/Downloads and re-run this script "
  echo "https://support.freshservice.com/support/solutions/articles/200393"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/freshservice

# install package onto Ubuntu system
cp $HOME/Downloads/FS-Linux-Agent.py .
sudo python3 ./FS-Linux-Agent.py

# copy files
mkdir -p custom/freshservice/usr/local/sbin
cp -R /usr/local/sbin/Freshdesk custom/freshservice/usr/local/sbin
cp -R /usr/local/sbin/Freshservice custom/freshservice/usr/local/sbin
# remove scan/log files
rm -f /custom/freshservice/usr/local/sbin/Freshservice/Discovery-Agent/bin/scandata.txt
rm -f /custom/freshservice/usr/local/sbin/Freshservice/Discovery-Agent/bin/last-scan-data.txt
rm -f /custom/freshservice/usr/local/sbin/Freshservice/Discovery-Agent/logs/fsagent.log

# Microsoft .NET 3.1
## Development machine (Ubuntu 18.04)
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm -f packages-microsoft-prod.deb
sudo apt-get update

MISSING_LIBS="aspnetcore-runtime-3.1 aspnetcore-targeting-pack-3.1 dotnet-apphost-pack-3.1 dotnet-host dotnet-hostfxr-3.1 dotnet-runtime-3.1 dotnet-runtime-deps-3.1 dotnet-sdk-3.1 dotnet-targeting-pack-3.1"

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/freshservice
done

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/FreshService.zip

unzip FreshService.zip -d custom
mv custom/target/build/freshservice-cp-init-script.sh custom

cd custom

# edit inf file for version number
VERSION=$(grep AGENT /usr/local/sbin/Freshservice/Discovery-Agent/logs/fsagent.log | cut -d "|" -f 2 | cut -d ":" -f 2 | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
sed -i "/^version=/c version=\"${VERSION}\"" target/freshservice.inf
#echo "freshservice.inf file is:"
#cat target/freshservice.inf

# new build process into zip file
tar cvjf target/freshservice.tar.bz2 freshservice freshservice-cp-init-script.sh
zip -g ../FreshService.zip target/freshservice.tar.bz2 target/freshservice.inf
zip -d ../FreshService.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../FreshService.zip ../../FreshService-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
