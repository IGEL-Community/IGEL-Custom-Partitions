#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Magnus
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y
echo "******************************************************************** "
echo "***** Adding respitory for Magnus (this can take some time)... ***** "
sudo add-apt-repository ppa:flexiondotorg/magnus
echo "***** DONE: Added respitory for Magnus.                        ***** "
echo "******************************************************************** "
sudo apt-get update

mkdir build_tar
cd build_tar

apt-get download magnus
apt-get download gir1.2-keybinder-3.0
apt-get download libkeybinder-3.0-0
apt-get download python3-setproctitle

mkdir -p custom/magnus

dpkg -x magnus* custom/magnus
dpkg -x gir1* custom/magnus
dpkg -x libkey* custom/magnus
dpkg -x python* custom/magnus

mv custom/magnus/usr/share/applications/ custom/magnus/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Tools_Drivers/Magnus_Screen_Magnifier.zip

unzip Magnus_Screen_Magnifier.zip -d custom
mkdir -p custom/magnus/config/bin
mkdir -p custom/magnus/lib/systemd/system
mv custom/target/magnus_cp_apparmor_reload custom/magnus/config/bin
mv custom/target/igel-magnus-cp-apparmor-reload.service custom/magnus/lib/systemd/system/
mv custom/target/magnus-cp-init-script.sh custom

cd custom

tar cvjf magnus.tar.bz2 magnus magnus-cp-init-script.sh
mv magnus.tar.bz2 ../..
mv target/magnus.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
