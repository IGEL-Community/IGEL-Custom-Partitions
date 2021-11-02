#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Microsoft Visual Studio Code
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y
sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
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
mv custom/target/vscode-cp-init-script.sh custom

cd custom

tar cvjf vscode.tar.bz2 vscode vscode-cp-init-script.sh
mv vscode.tar.bz2 ../..
mv target/vscode.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
