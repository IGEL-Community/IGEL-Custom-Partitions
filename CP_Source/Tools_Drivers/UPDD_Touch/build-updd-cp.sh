#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for UPDD Touch Driver
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://touch-base.com/oem/microchip/
if ! compgen -G "$HOME/Downloads/linux_x64_gcc_*.tgz" > /dev/null; then
  echo "***********"
  echo "Obtain latest linux_x64_gcc_*.tgz package, save into $HOME/Downloads and re-run this script "
  echo "https://touch-base.com/oem/microchip/"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/updd

# http://support.touch-base.com/Documentation/50372/Installation
mkdir installer
cd installer
tar xvzf $HOME/Downloads/linux_x64_gcc_*.tgz
sudo ./install
cd ..

#tar cvf ../after_install.tar /opt/updd /etc/systemd/system/updd.* /etc/xdg/autostart/updd_*
sudo tar cvf after_install.tar /opt/updd /etc/xdg/autostart/updd_*

cd custom/updd
sudo tar xvf ../../after_install.tar

cd ../..

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Tools_Drivers/UPDD_Touch.zip

unzip UPDD_Touch.zip -d custom
mv custom/target/updd-cp-init-script.sh custom

cd custom

sudo tar cvjf updd.tar.bz2 updd updd-cp-init-script.sh
mv updd.tar.bz2 ../..
mv target/updd.inf ../..
mv igel/*.xml ../..

cd ../..
sudo rm -rf build_tar
