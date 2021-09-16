#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain link to latest package and save into Downloads
# https://www.zoiper.com/en/voip-softphone/download/current#linux
# Zoiper5_5.5.5_x86_64.deb
if ! compgen -G "$HOME/Downloads/Zoiper*.deb" > /dev/null; then
  echo "***********"
  echo "Download latest .deb package and re-run this script"
  echo "https://www.zoiper.com/en/voip-softphone/download/current#linux"
  echo "***********"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/zoiper

dpkg -x $HOME/Downloads/Zoiper*.deb custom/zoiper

mv custom/zoiper/usr/share/applications/ custom/zoiper/usr/share/applications.mime
mkdir -p custom/zoiper/userhome/.Zoiper5

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Zoiper.zip

unzip Zoiper.zip -d custom
mkdir -p custom/zoiper/config/bin
mkdir -p custom/zoiper/lib/systemd/system
mv custom/target/zoiper_cp_apparmor_reload custom/zoiper/config/bin
mv custom/target/igel-zoiper-cp-apparmor-reload.service custom/zoiper/lib/systemd/system/
mv custom/target/zoiper-cp-init-script.sh custom

cd custom

tar cvjf zoiper.tar.bz2 zoiper zoiper-cp-init-script.sh
mv zoiper.tar.bz2 ../..
mv target/zoiper.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
