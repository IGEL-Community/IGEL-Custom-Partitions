#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Jitsi Desktop
## Development machine (Ubuntu 18.04)
#https://desktop.jitsi.org/Main/Download
#jitsi_2.10.5550-1_amd64.deb
if ! compgen -G "$HOME/Downloads/jitsi_*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://desktop.jitsi.org/Main/Download"
  echo "***********"
  exit 1
fi

sudo apt install curl -y
sudo apt install unzip -y
sudo curl https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/" > /etc/apt/sources.list.d/jitsi-stable.list'
sudo apt-get update

MISSING_LIBS="libappindicator1 jitsi-archive-keyring"


mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/jitsi

dpkg -x $HOME/Downloads/jitsi_*.deb custom/jitsi

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/jitsi
done

mv custom/jitsi/usr/share/applications/ custom/jitsi/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Jitsi_Desktop.zip

unzip Jitsi_Desktop.zip -d custom
mkdir -p custom/jitsi/config/bin
mkdir -p custom/jitsi/lib/systemd/system
mv custom/target/jitsi_cp_apparmor_reload custom/jitsi/config/bin
mv custom/target/igel-jitsi-cp-apparmor-reload.service custom/jitsi/lib/systemd/system/
mv custom/target/jitsi-cp-init-script.sh custom

cd custom

tar cvjf jitsi.tar.bz2 jitsi jitsi-cp-init-script.sh
mv jitsi.tar.bz2 ../..
mv target/jitsi.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
