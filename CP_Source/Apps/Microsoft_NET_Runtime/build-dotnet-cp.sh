#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Microsoft .NET 5.0 Runtime
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm -f packages-microsoft-prod.deb
sudo apt-get update

MISSING_LIBS="aspnetcore-runtime-5.0 dotnet-host dotnet-hostfxr-5.0 dotnet-runtime-5.0 dotnet-runtime-deps-5.0"

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
mv custom/target/dotnet-cp-init-script.sh custom

cd custom

tar cvjf dotnet.tar.bz2 dotnet dotnet-cp-init-script.sh
mv dotnet.tar.bz2 ../..
mv target/dotnet.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
