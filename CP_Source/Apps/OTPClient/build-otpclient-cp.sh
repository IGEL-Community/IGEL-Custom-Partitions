#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for otpclient
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

#sudo apt install -y build-essential git libcurl4-gnutls-dev curl libssl-dev automake autoconf libtool
sudo apt install -y build-essential git libcurl4-gnutls-dev curl libssl-dev automake autoconf libtool cmake pkg-config libgcrypt20-dev libpng-dev libzip-dev libjansson-dev libzbar-dev libgtk-3-dev
sudo apt-get update

mkdir build_tar
cd build_tar

git clone https://github.com/paolostivanin/libbaseencode.git
cd libbaseencode
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ../
make
sudo make install
cd ../..

git clone https://github.com/paolostivanin/libcotp.git
cd libcotp
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ../
make
sudo make install
cd ../..

git clone https://github.com/paolostivanin/OTPClient.git
cd OTPClient
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo make install
cd ../..

#find . -name install_manifest.txt -exec cat {} \; | while read LINE
#do
  #if [ -e "${LINE}" ]; then
    #tar vrf tmp_otpclient.tar "${LINE}"
  #fi
#done

for build_component in $(find . -name install_manifest.txt); do
  while IFS= read -r line || [ "$line" ]; do
    tar vrf tmp_otpclient.tar -r "$line"
  done < $build_component
done

#missing file
tar vrf tmp_otpclient.tar /usr/lib/x86_64-linux-gnu/libbaseencode.so.1.0.*
tar vrf tmp_otpclient.tar /usr/bin/otpclient

apt-get download libzbar0
apt-get download libzip4

mkdir -p custom/otpclient

tar xvf tmp_otpclient.tar --directory custom/otpclient

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/otpclient
done

mv custom/otpclient/usr/share/applications/ custom/otpclient/usr/share/applications.mime

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/otpclient/userhome/.config
mkdir -p custom/otpclient/userhome/otpclient
#touch custom/otpclient/userhome/otpclient/NewDatabase.enc

# Create otpclient.cfg -- move this into init script for non-persistency
cat << EOF >> custom/otpclient/userhome/.config/otpclient.cfg
[config]
column_id=0
sort_order=0
window_width=500
window_height=300
db_path=/userhome/otpclient/NewDatabase.enc
EOF

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/OTPClient.zip

unzip OTPClient.zip -d custom
mkdir -p custom/otpclient/config/bin
mkdir -p custom/otpclient/lib/systemd/system
mv custom/target/otpclient_cp_apparmor_reload custom/otpclient/config/bin
mv custom/target/igel-otpclient-cp-apparmor-reload.service custom/otpclient/lib/systemd/system/
mv custom/target/otpclient-cp-init-script.sh custom

cd custom

tar cvjf otpclient.tar.bz2 otpclient otpclient-cp-init-script.sh
mv otpclient.tar.bz2 ../..
mv target/otpclient.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
