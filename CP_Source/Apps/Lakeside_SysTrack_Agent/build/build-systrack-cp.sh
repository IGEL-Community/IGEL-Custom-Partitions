#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Lakeside SysTrack
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# SysTrack_10_2_1052_Install_Linux.zip
if ! compgen -G "$HOME/Downloads/SysTrack_*_Install_Linux.zip" > /dev/null; then
  echo "***********"
  echo "Obtain latest SysTrack_VERSION_Install_Linux.zip package, save into $HOME/Downloads and re-run this script "
  exit 1
fi
if ! compgen -G "$HOME/Downloads/systrack-cert.crt" > /dev/null; then
  echo "***********"
  echo "Obtain latest systrack-cert.crt file, save into $HOME/Downloads and re-run this script "
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/systrack/tmp

cp $HOME/Downloads/SysTrack_*_Install_Linux.zip custom/systrack/tmp
cp $HOME/Downloads/systrack-cert.crt custom/systrack/tmp

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Lakeside_SysTrack_Agent.zip

unzip Lakeside_SysTrack_Agent.zip -d custom
mv custom/target/build/systrack-cp-init-script.sh custom
cd custom

# new build process into zip file
tar cvjf target/systrack.tar.bz2 systrack systrack-cp-init-script.sh
zip -g ../Lakeside_SysTrack_Agent.zip target/systrack.tar.bz2 target/systrack.inf
zip -d ../Lakeside_SysTrack_Agent.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Lakeside_SysTrack_Agent.zip ../../Lakeside_SysTrack_Agent_igel01.zip

cd ../..
rm -rf build_tar
