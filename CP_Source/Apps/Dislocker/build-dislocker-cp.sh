#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for dislocker
## Development machine (Ubuntu 18.04)
MISSING_LIBS="fonts-lato javascript-common libdislocker0.7 libjs-jquery libmbedcrypto1 libruby2.5 rake ruby ruby-did-you-mean ruby-minitest ruby-net-telnet ruby-power-assert ruby-test-unit ruby2.5 rubygems-integration"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

apt-get download dislocker

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/dislocker

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/dislocker
done

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Dislocker.zip

unzip Dislocker.zip -d custom
mv custom/target/dislocker-cp-init-script.sh custom

cd custom

tar cvjf dislocker.tar.bz2 dislocker dislocker-cp-init-script.sh
mv dislocker.tar.bz2 ../..
mv target/dislocker.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
