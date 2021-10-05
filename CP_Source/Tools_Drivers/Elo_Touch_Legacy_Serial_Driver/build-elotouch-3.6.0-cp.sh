#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Elo Touch Legacy Serial Driver
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://www.elotouch.com/support/downloads#/category/346LYmeuAUEI4Qa0sSyiSa/os/5hkYjkrw08oU08oCwCeSKq/legacy/current
# https://touch-base.com/oem/microchip/
# https://assets.ctfassets.net/of6pv6scuh5x/1AwnATTxBXY5oXcJTKE98n/eec3391b18701ce04c064b8931a0a9e2/SW602833_Elo_Linux_Serial_Driver_v3.6.0_x86_64.tgz
if ! compgen -G "$HOME/Downloads/SW*_Elo_Linux_Serial_Driver*_x86_64.tgz" > /dev/null; then
  echo "***********"
  echo "Obtain latest SW*_Elo_Linux_Serial_Driver*_x86_64.tgz package, save into $HOME/Downloads and re-run this script "
  echo "https://www.elotouch.com/support/downloads#/category/346LYmeuAUEI4Qa0sSyiSa/os/5hkYjkrw08oU08oCwCeSKq/legacy/current"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/elotouch
mkdir -p custom/elotouch/etc/opt/elo-ser

tar xvf $HOME/Downloads/SW*_Elo_Linux_Serial_Driver*_x86_64.tgz
cp -r ./bin-serial/*  custom/elotouch/etc/opt/elo-ser
cp custom/elotouch/etc/opt/elo-ser/loadEloSerial.sh custom/elotouch/etc/opt/elo-ser/loadEloSerial.sh.orig

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Tools_Drivers/Elo_Touch_Legacy_Serial_Driver.zip

unzip Elo_Touch_Legacy_Serial_Driver -d custom
mv custom/target/elotouch-cp-init-script.sh custom
mv custom/target/igel_start_elo_service.sh custom/elotouch/etc/opt/elo-ser

chmod -R 777 custom/elotouch/etc/opt/elo-ser
chmod -R 444 custom/elotouch/etc/opt/elo-ser/*.txt

cd custom

tar cvjf elotouch-3.6.0.tar.bz2 elotouch elotouch-cp-init-script.sh
mv elotouch-3.6.0.tar.bz2 ../..
mv target/elotouch-3.6.0.inf ../..
mv igel/*3.6.0.xml ../..

cd ../..
rm -rf build_tar
