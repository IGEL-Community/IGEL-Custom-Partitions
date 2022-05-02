#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for SNMP
## Development machine (Ubuntu 18.04)

MISSING_LIBS="smistrip snmp snmp-mibs-downloader snmpd"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/snmp

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/snmp
done

# Start Edit to match required settings for snmp and snmpd configuration
sed -i "/^mibs/c #mibs" custom/snmp/etc/snmp/snmp.conf
sed -i "s/^#agentAddress udp:161/agentAddress udp:161/" custom/snmp/etc/snmp/snmpd.conf
# End Edit to match required settings for snmp and snmpd configuration

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Network/SNMP.zip

unzip SNMP.zip -d custom
mv custom/target/build/snmp-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../snmp_*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/snmp.inf
#echo "snmp.inf file is:"
#cat target/snmp.inf

# new build process into zip file
tar cvjf target/snmp.tar.bz2 snmp snmp-cp-init-script.sh
zip -g ../SNMP.zip target/snmp.tar.bz2 target/snmp.inf
zip -d ../SNMP.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../SNMP.zip ../../SNMP-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
