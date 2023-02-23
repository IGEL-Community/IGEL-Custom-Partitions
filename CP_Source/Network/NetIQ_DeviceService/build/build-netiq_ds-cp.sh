#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for NetIQ Device Service
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://www.netiq.com/documentation/advanced-authentication-64/device-service-installation/data/installing_device_service_for_linux.html
DEB_FILE="$HOME/Downloads/naaf-deviceservice-debian-linux64-release-*.deb"
if ! compgen -G "${DEB_FILE}" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://www.netiq.com/documentation/advanced-authentication-64/device-service-installation/data/installing_device_service_for_linux.html"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

CP_PATH=custom/netiq_ds

mkdir -p "${CP_PATH}"
mkdir -p "${CP_PATH}"/var/lib/deviceservice
chmod 700 "${CP_PATH}"/var/lib/deviceservice
mkdir -p "${CP_PATH}"/opt/NetIQ/Logging/Logs

dpkg -x "${DEB_FILE}" custom/netiq_ds

# Edit below for your config.properties
cat << 'EOF' > "${CP_PATH}"/opt/NetIQ/DeviceService/config.properties
#General
host.ports=8440;8441;8442
 
#PKI plugin
pki.vendorModule=auto
 
#Card plugin
card.omnikeyEnabled=false
card.rfideasEnabled=true
card.smarfidEnabled=false
card.desfireEnabled=false
card.forceVirtualChannels=true
 
#Face plugin
video.checkByBlinking=true
video.blinkThreshold=0.20
video.blinkFrames=2
video.blinkCount=3
EOF

#Enable debug logging
cat << 'EOF' > "${CP_PATH}"/opt/NetIQ/Logging/config.properties
logEnabled=True
EOF

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Network/NetIQ_DeviceService.zip

unzip NetIQ_DeviceService.zip -d custom
mv custom/target/build/netiq_ds-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x "${DEB_FILE}"
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/netiq_ds.inf
#echo "netiq_ds.inf file is:"
#cat target/netiq_ds.inf

# new build process into zip file
tar cvjf target/netiq_ds.tar.bz2 netiq_ds netiq_ds-cp-init-script.sh
zip -g ../NetIQ_DeviceService.zip target/netiq_ds.tar.bz2 target/netiq_ds.inf
zip -d ../NetIQ_DeviceService.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../NetIQ_DeviceService.zip ../../NetIQ_DeviceService-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
