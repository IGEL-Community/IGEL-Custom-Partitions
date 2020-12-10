#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for YakYak
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain link to latest package and save into Downloads
# https://github.com/yakyak/yakyak/releases/latest
if ! compgen -G "$HOME/Downloads/yakyak-*linux-amd64.deb" > /dev/null; then
  echo "***********"
  echo "Download latest amd64.deb package and re-run this script "
  echo "https://github.com/yakyak/yakyak/releases/latest"
  echo "***********"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/yakyak

dpkg -x $HOME/Downloads/yakyak-*linux-amd64.deb custom/yakyak

mv custom/yakyak/usr/share/applications/ custom/yakyak/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/YakYak.zip

unzip YakYak.zip -d custom
mkdir -p custom/yakyak/config/bin
mkdir -p custom/yakyak/lib/systemd/system
mv custom/target/yakyak custom/yakyak/config/bin
mv custom/target/igel-yakyak-cp-apparmor-reload.service custom/yakyak/lib/systemd/system/
mv custom/target/yakyak-cp-init-script.sh custom

cd custom

tar cvjf yakyak.tar.bz2 yakyak yakyak-cp-init-script.sh
mv yakyak.tar.bz2 ../..
mv target/yakyak.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
