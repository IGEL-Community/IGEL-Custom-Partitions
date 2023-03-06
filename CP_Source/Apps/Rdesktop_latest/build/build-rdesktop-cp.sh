#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for rdesktop
## Development machine (Ubuntu 18.04)
#https://github.com/rdesktop/rdesktop/releases/tag/v1.9.0
#https://github.com/rdesktop/rdesktop
#https://packages.debian.org/sid/amd64/rdesktop/download

sudo apt update -y

sudo apt install unzip -y

mkdir build_tar
cd build_tar

wget http://ftp.debian.org/debian/pool/main/r/rdesktop/rdesktop_1.9.0-2+b1_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/main/n/nettle/libhogweed6_3.7.3-1build2_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/main/n/nettle/libnettle8_3.7.3-1build2_amd64.deb

mkdir -p custom/rdesktop

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/rdesktop
done

mkdir -p custom/rdesktop/tmp
mv custom/rdesktop/usr/lib/x86_64-linux-gnu custom/rdesktop/tmp

# Edit below for your config.properties
cat << 'EOF' > custom/rdesktop/usr/bin/start_rdesktop.sh
#!/bash

export LD_LIBRARY_PATH=/tmp/x86_64-linux-gnu
exec /usr/bin/rdesktop "$@"
EOF

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Rdesktop_latest.zip

unzip Rdesktop_latest.zip -d custom
mv custom/target/build/rdesktop-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../rdesktop_*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/rdesktop.inf
#echo "rdesktop.inf file is:"
#cat target/rdesktop.inf

# new build process into zip file
tar cvjf target/rdesktop.tar.bz2 rdesktop rdesktop-cp-init-script.sh
zip -g ../Rdesktop_latest.zip target/rdesktop.tar.bz2 target/rdesktop.inf
zip -d ../Rdesktop_latest.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Rdesktop_latest.zip ../../Rdesktop_latest-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
