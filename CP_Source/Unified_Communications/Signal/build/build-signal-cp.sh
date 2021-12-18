#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Signal
## Development machine (Ubuntu 18.04)
sudo apt install curl -y
sudo apt install unzip -y
sudo curl https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" > /etc/apt/sources.list.d/signal.list'
sudo apt-get update

MISSING_LIBS="signal-desktop libappindicator1 libindicator7"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/signal

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/signal
done

mv custom/signal/usr/share/applications/ custom/signal/usr/share/applications.mime

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/signal/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/signal/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/signal/userhome/.config/Signal

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Signal.zip

unzip Signal.zip -d custom
mkdir -p custom/signal/config/bin
mkdir -p custom/signal/lib/systemd/system
mv custom/target/build/signal_cp_apparmor_reload custom/signal/config/bin
mv custom/target/build/igel-signal-cp-apparmor-reload.service custom/signal/lib/systemd/system/
mv custom/target/build/signal-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../signal-*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/signal.inf
#echo "signal.inf file is:"
#cat target/signal.inf

# new build process into zip file
tar cvjf target/signal.tar.bz2 signal signal-cp-init-script.sh
zip -g ../Signal.zip target/signal.tar.bz2 target/signal.inf
zip -d ../Signal.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Signal.zip ../../Signal-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
