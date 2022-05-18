#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Inductive Automation Edge
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://inductiveautomation.com/downloads/ignition
# Ignition-Edge-linux-x86-64-8.1.17.zip
if ! compgen -G "$HOME/Downloads/Ignition-Edge-linux-x86-64-*.zip" > /dev/null; then
  echo "***********"
  echo "Obtain latest package, Ignition-Edge-linux-x86-64-X.X.X.zip, save into $HOME/Downloads and re-run this script "
  echo " https://inductiveautomation.com/downloads/ignition"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir custom
cd custom

IA_EDGE_DIR="iaedge/usr/local/bin/ignition"
mkdir -p ${IA_EDGE_DIR}
unzip $HOME/Downloads/Ignition-Edge-linux-x86-64-*.zip -d ${IA_EDGE_DIR}
chmod +x ${IA_EDGE_DIR}/*.sh

cd ..

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Inductive_Automation_Edge.zip

unzip Inductive_Automation_Edge.zip -d custom
mv custom/target/build/iavision-cp-init-script.sh custom

cd custom

# edit inf file for version number
VERSION=$(grep "^\[Ignition" ${IA_EDGE_DIR}/Notice.txt | cut -d " " -f 3 | cut -d "]" -f 1)
#echo "Version is: " ${VERSION}
sed -i "/^version=/c version=\"${VERSION}\"" target/iaedge.inf
#echo "iaedge.inf file is:"
#cat target/iaedge.inf

# new build process into zip file
tar cvjf target/iaedge.tar.bz2 iaedge iaedge-cp-init-script.sh
zip -g ../Inductive_Automation_Edge.zip target/iaedge.tar.bz2 target/iaedge.inf
zip -d ../Inductive_Automation_Edge.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Inductive_Automation_Edge.zip ../../Inductive_Automation_Edge-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
