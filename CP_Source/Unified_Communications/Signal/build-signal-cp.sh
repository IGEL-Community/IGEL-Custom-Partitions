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

mkdir build_tar
cd build_tar

apt-get download signal-desktop
apt-get download libappindicator1
apt-get download libindicator7

mkdir -p custom/signal

dpkg -x signal-desktop* custom/signal
dpkg -x libappindicator1* custom/signal
dpkg -x libindicator7* custom/signal

mv custom/signal/usr/share/applications/ custom/signal/usr/share/applications.mime

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
mv custom/target/signal_cp_apparmor_reload custom/signal/config/bin
mv custom/target/igel-signal-cp-apparmor-reload.service custom/signal/lib/systemd/system/
mv custom/target/signal-cp-init-script.sh custom

cd custom

tar cvjf signal.tar.bz2 signal signal-cp-init-script.sh
mv signal.tar.bz2 ../..
mv target/signal.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
