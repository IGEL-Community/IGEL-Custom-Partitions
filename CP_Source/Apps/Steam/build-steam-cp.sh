#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Steam
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb
if ! compgen -G "$HOME/Downloads/steam_latest.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb"
  echo "***********"
  exit 1
fi

sudo apt install curl -y
sudo apt install unzip -y

# Install Steam on Ubuntu 18.04 System BUT do not log in
# Check that Steam is installed
if ! compgen -G "$HOME/.local/share/Steam/bootstrap.tar.xz" > /dev/null; then
  echo "***********"
  echo "Install Steam on this Ubuntu 18.04 system"
  echo "sudo dpkg -i $HOME/Downloads/steam_latest.deb"
  echo "***********"
  echo "Application will be installed by running Steam desktop icon."
  echo "***********"
  echo "Re-run this script after Steam application install completes"
  echo "***********"
  exit 1
fi

mkdir build_tar
cd build_tar

apt-get download gcc-8-base:i386
apt-get download libatomic1:i386
apt-get download libbsd0:i386
apt-get download libc6:i386
apt-get download libdrm-amdgpu1:i386
apt-get download libdrm-intel1:i386
apt-get download libdrm-nouveau2:i386
apt-get download libdrm-radeon1:i386
apt-get download libdrm2:i386
apt-get download libedit2:i386
apt-get download libelf1:i386
apt-get download libexpat1:i386
apt-get download libffi6:i386
apt-get download libgcc1:i386
apt-get download libgl1:i386
apt-get download libgl1-mesa-dri:i386
apt-get download libglapi-mesa:i386
apt-get download libglvnd0:i386
apt-get download libglx-mesa0:i386
apt-get download libglx0:i386
apt-get download libllvm10:i386
apt-get download libpciaccess0:i386
apt-get download libsensors4:i386
apt-get download libstdc++6:i386
apt-get download libtinfo5:i386
apt-get download libx11-6:i386
apt-get download libx11-xcb1:i386
apt-get download libxau6:i386
apt-get download libxcb-dri2-0:i386
apt-get download libxcb-dri3-0:i386
apt-get download libxcb-glx0:i386
apt-get download libxcb-present0:i386
apt-get download libxcb-sync1:i386
apt-get download libxcb1:i386
apt-get download libxdamage1:i386
apt-get download libxdmcp6:i386
apt-get download libxext6:i386
apt-get download libxfixes3:i386
apt-get download libxshmfence1:i386
apt-get download libxxf86vm1:i386
apt-get download libzstd1:i386
apt-get download zlib1g:i386

mkdir -p custom/steam

dpkg -x $HOME/Downloads/steam_latest.deb custom/steam

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/steam
done

mv custom/steam/usr/share/applications/ custom/steam/usr/share/applications.mime
mkdir -p custom/steam/userhome/.local/share
cp -R $HOME/.local/share/Steam custom/steam/userhome/.local/share

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Steam.zip

unzip steam.zip -d custom
mv custom/target/steam-cp-init-script.sh custom

cd custom

tar cvjf steam.tar.bz2 steam steam-cp-init-script.sh
mv steam.tar.bz2 ../..
mv target/steam.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
