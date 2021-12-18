#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Spotify
## Development machine (Ubuntu 18.04)
sudo apt install curl -y
sudo apt install unzip -y
sudo curl https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list'
sudo apt-get update

MISSING_LIBS="libatomic1 gconf-service gconf-service-backend gconf2-common i965-va-driver libaacs0 libavcodec57 libavformat57 libavutil55 libbdplus0 libbluray2 libchromaprint1 libcrystalhd3 libgconf-2-4 libgme0 libgsm1 libopenjp2-7 libopenmpt0 libshine3 libsnappy1v5 libsoxr0 libssh-gcrypt-4 libswresample2 libva-drm2 libva-x11-2 libva2 libvdpau1 libx264-152 libx265-146 libxvidcore4 libzvbi-common libzvbi0 mesa-va-drivers mesa-vdpau-drivers spotify-client va-driver-all vdpau-driver-all"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/spotify

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/spotify
done

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/spotify/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/spotify/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/spotify/userhome/.config/spotify

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Spotify.zip

unzip Spotify.zip -d custom
mv custom/target/build/spotify-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../spotify-*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/spotify.inf
#echo "spotify.inf file is:"
#cat target/spotify.inf

# new build process into zip file
tar cvjf target/spotify.tar.bz2 spotify spotify-cp-init-script.sh
zip -g ../Spotify.zip target/spotify.tar.bz2 target/spotify.inf
zip -d ../Spotify.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Spotify.zip ../../Spotify-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
