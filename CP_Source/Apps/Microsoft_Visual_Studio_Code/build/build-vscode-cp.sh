#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Microsoft Visual Studio Code
## Development machine (Ubuntu 18.04)
sudo apt install curl -y
sudo apt install unzip -y
sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update

MISSING_LIBS="code"

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/vscode

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/vscode
done

mv custom/vscode/usr/share/applications/ custom/vscode/usr/share/applications.mime
mkdir -p custom/vscode/userhome/.config/Code
mkdir -p custom/vscode/userhome/.vscode

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Microsoft_Visual_Studio_Code.zip

unzip Microsoft_Visual_Studio_Code.zip -d custom
mv custom/target/build/vscode-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../code*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/vscode.inf
#echo "vscode.inf file is:"
#cat target/vscode.inf

# new build process into zip file
tar cvjf target/vscode.tar.bz2 vscode vscode-cp-init-script.sh
zip -g ../Microsoft_Visual_Studio_Code.zip target/vscode.tar.bz2 target/vscode.inf
zip -d ../Microsoft_Visual_Studio_Code.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Microsoft_Visual_Studio_Code.zip ../../Microsoft_Visual_Studio_Code-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
