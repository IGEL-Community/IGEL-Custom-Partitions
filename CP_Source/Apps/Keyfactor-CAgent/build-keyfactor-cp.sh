#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Keyfactor-CAgent
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

#sudo apt install -y build-essential git libcurl4-gnutls-dev curl libssl-dev automake autoconf libtool
sudo apt install -y build-essential git libcurl4-gnutls-dev curl libssl-dev

mkdir build_tar
cd build_tar

git clone https://github.com/Keyfactor/Keyfactor-CAgent.git
cd Keyfactor-CAgent
make clean
make opentest -j1

cd ..

mkdir -p custom/keyfactor/etc/keyfactor

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Keyfactor-CAgent.zip

unzip Keyfactor-CAgent.zip -d custom
mv custom/target/keyfactor-cp-init-script.sh custom
mv Keyfactor-CAgent/agent custom/keyfactor/etc/keyfactor
mv Keyfactor-CAgent/config.json custom/keyfactor/etc/keyfactor
mv custom/target/config.json custom/keyfactor/etc/keyfactor/config_new.json
mkdir -p custom/keyfactor/userhome/keyfactor
mv Keyfactor-CAgent/certs custom/keyfactor/userhome/keyfactor

cd custom

tar cvjf keyfactor.tar.bz2 keyfactor keyfactor-cp-init-script.sh
mv keyfactor.tar.bz2 ../..
mv target/keyfactor.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
