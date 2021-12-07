#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for CrowdStrike Falcon
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain latest package and save into Downloads
# Download App for Linux (Debian)
# https://www.crowdstrike.com/blog/tech-center/install-falcon-sensor-for-linux
# falcon-sensor_6.33.0-13003_amd64.deb
if ! compgen -G "$HOME/Downloads/falcon-sensor_*_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://www.crowdstrike.com/blog/tech-center/install-falcon-sensor-for-linux"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/falcon

dpkg -x $HOME/Downloads/falcon-sensor_*_amd64.deb custom/falcon

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/CrowdStrike_Falcon.zip

unzip CrowdStrike_Falcon.zip -d custom
mv custom/target/build/falcon-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/falcon-sensor_*_amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/falcon.inf
#echo "falcon.inf file is:"
#cat target/falcon.inf

# new build process into zip file
tar cvjf target/falcon.tar.bz2 falcon falcon-cp-init-script.sh
zip -g ../CrowdStrike_Falcon.zip target/falcon.tar.bz2 target/falcon.inf
zip -d ../CrowdStrike_Falcon.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../CrowdStrike_Falcon.zip ../../CrowdStrike_Falcon-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
