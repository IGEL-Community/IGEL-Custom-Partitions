#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for HP ZCentral
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain latest package and save into Downloads
if ! compgen -G "$HOME/Downloads/ZCentral_RB_*.tar.gz" > /dev/null; then
  echo "***********"
  echo "Obtain latest .tar.gz package, save into $HOME/Downloads and re-run this script "
  echo "***********"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/hpzcentral

mkdir tmp
cd tmp
tar xvf $HOME/Downloads/ZCentral_RB_*.tar.gz
cd ..

dpkg -x tmp/ubuntu/receiver/rgreceiver_*.deb custom/hpzcentral

mv custom/hpzcentral/usr/share/applications/ custom/hpzcentral/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/HP_ZCentral.zip

unzip HP_ZCentral.zip -d custom
mkdir -p custom/hpzcentral/config/bin
mkdir -p custom/hpzcentral/lib/systemd/system
mv custom/target/hpzcentral_cp_apparmor_reload custom/hpzcentral/config/bin
mv custom/target/igel-hpzcentral-cp-apparmor-reload.service custom/hpzcentral/lib/systemd/system/
mv custom/target/hpzcentral-cp-init-script.sh custom

cd custom

tar cvjf hpzcentral.tar.bz2 hpzcentral hpzcentral-cp-init-script.sh
mv hpzcentral.tar.bz2 ../..
mv target/hpzcentral.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
