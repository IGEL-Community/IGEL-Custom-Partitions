#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for AWS WorkSpaces
## Development machine (Ubuntu 18.04)
sudo apt install curl -y
sudo apt install unzip -y
sudo curl https://workspaces-client-linux-public-key.s3-us-west-2.amazonaws.com/ADB332E7.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu bionic main" > /etc/apt/sources.list.d/amazon-workspaces-clients.list'
sudo apt-get update

MISSING_LIBS="workspacesclient i965-va-driver libgraphicsmagick++-q16-12 libgraphicsmagick-q16-3 libhiredis0.13 libva2 mesa-va-drivers va-driver-all"

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/aws_ws

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/aws_ws
done

mv custom/aws_ws/usr/share/applications/ custom/aws_ws/usr/share/applications.mime
#mkdir -p custom/vscode/userhome/.workspaces

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.07.100_usr_lib.txt custom/aws_ws/usr/lib
./clean_cp_usr_share.sh 11.07.100_usr_share.txt custom/aws_ws/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Amazon_WorkSpaces.zip

unzip Amazon_WorkSpaces.zip -d custom
mv custom/target/build/aws_ws-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../code*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/aws_ws.inf
#echo "aws_ws.inf file is:"
#cat target/aws_ws.inf

# new build process into zip file
tar cvjf target/aws_ws.tar.bz2 aws_ws aws_ws-cp-init-script.sh
zip -g ../Amazon_WorkSpaces.zip target/aws_ws.tar.bz2 target/aws_ws.inf
zip -d ../Amazon_WorkSpaces.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Amazon_WorkSpaces.zip ../../Amazon_WorkSpaces-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
