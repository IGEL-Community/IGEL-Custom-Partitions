#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Orca
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

mkdir build_tar
cd build_tar

apt-get download orca
apt-get download gir1.2-wnck-3.0
apt-get download python3-brlapi
apt-get download python3-cairo
apt-get download python3-louis
apt-get download python3-pyatspi
apt-get download python3-speechd
apt-get download speech-dispatcher


mkdir -p custom/orca

dpkg -x orca_* custom/orca
dpkg -x gir1.2-wnck-* custom/orca
dpkg -x python3-brlapi_* custom/orca
dpkg -x python3-cairo_* custom/orca
dpkg -x python3-louis_* custom/orca
dpkg -x python3-pyatspi_* custom/orca
dpkg -x python3-speechd_* custom/orca
dpkg -x speech-dispatcher_* custom/orca

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Orca.zip

unzip Orca.zip -d custom
mv custom/target/orca-cp-init-script.sh custom

cd custom

tar cvjf orca.tar.bz2 orca orca-cp-init-script.sh
mv orca.tar.bz2 ../..
mv target/orca.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
