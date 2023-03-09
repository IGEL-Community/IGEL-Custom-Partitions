#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for expect
## Development machine (Ubuntu 18.04)
MISSING_LIBS="expect tcl-expect"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/expect

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/expect
done

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Expect.zip

unzip Expect.zip -d custom
mv custom/target/build/expect-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../expect_*amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/expect.inf
#echo "expect.inf file is:"
#cat target/expect.inf

# new build process into zip file
tar cvjf target/expect.tar.bz2 expect expect-cp-init-script.sh
zip -g ../Expect.zip target/expect.tar.bz2 target/expect.inf
zip -d ../Expect.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Expect.zip ../../Expect-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
