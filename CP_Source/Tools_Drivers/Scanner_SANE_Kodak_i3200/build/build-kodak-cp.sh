#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Kodak SANE Drivers
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# LinuxSoftware_i3000_v5.7.3.x86_64.deb.tar.gz
if ! compgen -G "$HOME/Downloads/LinuxSoftware_i3000_*.x86_64.deb.tar.gz" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://support.alarisworld.com/en-us/i3200-scanner#Software"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/kodak
mkdir -p custom/tmp

tar xvf $HOME/Downloads/LinuxSoftware_i3000_*.x86_64.deb.tar.gz
dpkg -x kodak_i3000-*.amd64.deb custom/tmp

mkdir -p custom/kodak/usr/lib/x86_64-linux-gnu/sane
cp custom/tmp/usr/lib/sane/* custom/kodak/usr/lib/x86_64-linux-gnu/sane

mkdir -p custom/kodak/etc/sane.d
cp custom/tmp/etc/sane.d/* custom/kodak/etc/sane.d

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Tools_Drivers/Scanner_SANE_Kodak_i3200.zip

unzip Scanner_SANE_Kodak_i3200.zip -d custom
mv custom/target/build/kodak-cp-init-script.sh custom


cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../kodak_i3000-*.amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/kodak.inf
#echo "kodak.inf file is:"
#cat target/kodak.inf

# new build process into zip file
tar cvjf target/kodak.tar.bz2 kodak kodak-cp-init-script.sh
zip -g ../kodak.zip target/kodak.tar.bz2 target/kodak.inf
zip -d ../Scanner_SANE_Kodak_i3200.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Scanner_SANE_Kodak_i3200.zip ../../Scanner_SANE_Kodak_i3200-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
