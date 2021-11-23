#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for BeyondTrust Bomgar
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# bomgar-scc-*.desktop
#Dertermine bomgar installation file name
BOMGARDESKTOP=$(ls $HOME/Downloads | grep bomgar-scc)
if ! compgen -G "$HOME/Downloads/${BOMGARDESKTOP}" > /dev/null; then
  echo "***********"
  echo "Obtain latest Bomgar package, save into $HOME/Downloads and re-run this script "
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/bomgar
cp $HOME/Downloads/${BOMGARDESKTOP} custom/bombar

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/BeyondTrust_Bomgar.zip

unzip BeyondTrust_Bomgar.zip -d custom
mv custom/target/bomgar-cp-init-script.sh custom

cd custom

tar cvjf bomgar.tar.bz2 bomgar bomgar-cp-init-script.sh
mv bomgar.tar.bz2 ../..
mv target/bomgar.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
