#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Microsoft .NET 6.0, 5.0, or 3.1 Runtime
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm -f packages-microsoft-prod.deb
sudo apt-get update

MISSING_LIBS_6_0="aspnetcore-runtime-6.0 dotnet-host dotnet-hostfxr-6.0 dotnet-runtime-6.0 dotnet-runtime-deps-6.0"
MISSING_LIBS_5_0="aspnetcore-runtime-5.0 dotnet-host dotnet-hostfxr-5.0 dotnet-runtime-5.0 dotnet-runtime-deps-5.0"
MISSING_LIBS_3_1="aspnetcore-runtime-3.1 dotnet-host dotnet-hostfxr-3.1 dotnet-runtime-3.1 dotnet-runtime-deps-3.1"

# default build is for 6.0
MISSING_LIBS=$MISSING_LIBS_6_0
#MISSING_LIBS=$MISSING_LIBS_5_0
#MISSING_LIBS=$MISSING_LIBS_3_1

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/dotnet

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/dotnet
done

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Microsoft_NET_Runtime.zip

unzip Microsoft_NET_Runtime.zip -d custom
mv custom/target/build/dotnet-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../dotnet-runtime-[3-9]*_amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/dotnet.inf
#echo "dotnet.inf file is:"
#cat target/dotnet.inf

# new build process into zip file
tar cvjf target/dotnet.tar.bz2 dotnet dotnet-cp-init-script.sh
zip -g ../Microsoft_NET_Runtime.zip target/dotnet.tar.bz2 target/dotnet.inf
zip -d ../Microsoft_NET_Runtime.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Microsoft_NET_Runtime.zip ../../Microsoft_NET_Runtime-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
