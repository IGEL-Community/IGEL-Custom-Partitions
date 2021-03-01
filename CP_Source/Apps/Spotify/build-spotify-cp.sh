#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Spotify
## Development machine (Ubuntu 18.04)
sudo apt install curl -y
sudo apt install unzip -y
sudo curl https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list'
sudo apt-get update

mkdir build_tar
cd build_tar

apt-get download spotify-client
apt-get download gconf-service
apt-get download gconf-service-backend
apt-get download gconf2-common
apt-get download i965-va-driver
apt-get download libaacs0
apt-get download libavcodec57
apt-get download libavformat57
apt-get download libavutil55
apt-get download libbdplus0
apt-get download libbluray2
apt-get download libchromaprint1
apt-get download libcrystalhd3
apt-get download libgconf-2-4
apt-get download libgme0
apt-get download libgsm1
apt-get download libopenjp2-7
apt-get download libopenmpt0
apt-get download libshine3
apt-get download libsnappy1v5
apt-get download libsoxr0
apt-get download libssh-gcrypt-4
apt-get download libswresample2
apt-get download libva-drm2
apt-get download libva-x11-2
apt-get download libva2
apt-get download libvdpau1
apt-get download libx264-152
apt-get download libx265-146
apt-get download libxvidcore4
apt-get download libzvbi-common
apt-get download libzvbi0
apt-get download mesa-va-drivers
apt-get download mesa-vdpau-drivers
apt-get download va-driver-all
apt-get download vdpau-driver-all

mkdir -p custom/spotify

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/spotify
done

mkdir -p custom/spotify/userhome/.config/spotify

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Spotify.zip

unzip Spotify.zip -d custom
mv custom/target/spotify-cp-init-script.sh custom

cd custom

tar cvjf spotify.tar.bz2 spotify spotify-cp-init-script.sh
mv spotify.tar.bz2 ../..
mv target/spotify.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
