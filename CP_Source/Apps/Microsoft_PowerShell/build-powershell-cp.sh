#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Microsoft PowerShell
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm -f packages-microsoft-prod.deb
sudo apt-get update
sudo add-apt-repository universe

MISSING_LIBS="liblttng-ust-ctl4 liblttng-ust0 liburcu6 powershell"

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/powershell

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/powershell
done

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Microsoft_PowerShell.zip

unzip Microsoft_PowerShell.zip -d custom
mv custom/target/powershell-cp-init-script.sh custom

cd custom

tar cvjf powershell.tar.bz2 powershell powershell-cp-init-script.sh
mv powershell.tar.bz2 ../..
mv target/powershell.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
