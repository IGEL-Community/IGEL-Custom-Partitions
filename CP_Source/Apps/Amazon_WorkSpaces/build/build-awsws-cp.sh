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

mkdir -p custom/awsws

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/awsws
done

mv custom/awsws/usr/share/applications/ custom/awsws/usr/share/applications.mime
#mkdir -p custom/awsws/userhome/.workspaces

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.07.100_usr_lib.txt custom/awsws/usr/lib
./clean_cp_usr_share.sh 11.07.100_usr_share.txt custom/awsws/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Amazon_WorkSpaces.zip

unzip Amazon_WorkSpaces.zip -d custom
mv custom/target/build/awsws-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../workspacesclient*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/awsws.inf
#echo "awsws.inf file is:"
#cat target/awsws.inf

# new build process into zip file
tar cvjf target/awsws.tar.bz2 awsws awsws-cp-init-script.sh
zip -g ../Amazon_WorkSpaces.zip target/awsws.tar.bz2 target/awsws.inf
zip -d ../Amazon_WorkSpaces.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Amazon_WorkSpaces.zip ../../Amazon_WorkSpaces-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
