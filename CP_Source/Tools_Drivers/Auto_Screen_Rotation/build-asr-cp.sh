#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Auto Screen Rotation
## Development machine (Ubuntu 18.04)

mkdir build_tar
cd build_tar

apt-get download iio-sensor-proxy

mkdir -p custom/asr

dpkg -x iio-sensor-proxy* custom/asr

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Tools_Drivers/Auto_Screen_Rotation.zip

unzip Auto_Screen_Rotation.zip -d custom
mv custom/target/igel_asr.sh custom/asr/usr/bin/igel_asr.sh
mv custom/target/asr-cp-init-script.sh custom

cd custom

tar cvjf asr.tar.bz2 asr asr-cp-init-script.sh
mv asr.tar.bz2 ../..
mv target/asr.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
