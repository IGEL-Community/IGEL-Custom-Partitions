#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Azul Zulu JDKFX
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
#https://www.azul.com/downloads/zulu-community/?os=ubuntu&package=jdk-fx
#zulu8.52.0.23-ca-fx-jdk8.0.282-linux_amd64.deb
if ! compgen -G "$HOME/Downloads/zulu*fx*-linux_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://www.azul.com/downloads/zulu-community/?os=ubuntu&package=jdk-fx"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/jdkfx

dpkg -x $HOME/Downloads/zulu*fx*-linux_amd64.deb custom/jdkfx

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Azul_JDKFX.zip

unzip Azul_JDKFX.zip -d custom
mkdir -p custom/jdkfx/config/bin
mkdir -p custom/jdkfx/lib/systemd/system
mv custom/target/jdkfx_cp_apparmor_reload custom/jdkfx/config/bin
mv custom/target/igel-jdkfx-cp-apparmor-reload.service custom/jdkfx/lib/systemd/system/
mv custom/target/jdkfx-cp-init-script.sh custom

cd custom

tar cvjf jdkfx.tar.bz2 jdkfx jdkfx-cp-init-script.sh
mv jdkfx.tar.bz2 ../..
mv target/jdkfx.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
