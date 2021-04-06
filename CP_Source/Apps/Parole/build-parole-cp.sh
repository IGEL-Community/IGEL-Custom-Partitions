#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for parole
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

sudo apt install -y build-essential git libcurl4-gnutls-dev curl automake autoconf libtool cmake pkg-config xfce4-dev-tools gtk-doc-tools libdbus-glib-1-2 libdbus-glib-1-dev libxfce4util-dev libxfconf-0-dev libxfce4ui-2-dev libqt5gstreamer-1.0-0 gir1.2-gstreamer-1.0 gstreamer1.0-tools libgstreamer1.0-dev gnome-video-effects-dev libgstreamer-plugins-base1.0-dev libnotify-dev

sudo apt-get update

mkdir build_tar
cd build_tar

git clone https://gitlab.xfce.org/apps/parole.git
cd parole
./autogen.sh
make
sudo make install
cd ..

find /usr/local | grep -i parole | while read LINE
do
  if [ -e "${LINE}" ]; then
    tar vrf tmp_parole.tar "${LINE}"
  fi
done

apt-get download libxfconf-0-2

mkdir -p custom/parole

tar xvf tmp_parole.tar --directory custom/parole

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/parole
done

#mv custom/parole/usr/share/applications/ custom/parole/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Parole.zip

unzip Parole.zip -d custom
#mkdir -p custom/parole/config/bin
#mkdir -p custom/parole/lib/systemd/system
#mv custom/target/parole_cp_apparmor_reload custom/parole/config/bin
#mv custom/target/igel-parole-cp-apparmor-reload.service custom/parole/lib/systemd/system/
mv custom/target/parole-cp-init-script.sh custom

cd custom

tar cvjf parole.tar.bz2 parole parole-cp-init-script.sh
mv parole.tar.bz2 ../..
mv target/parole.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
