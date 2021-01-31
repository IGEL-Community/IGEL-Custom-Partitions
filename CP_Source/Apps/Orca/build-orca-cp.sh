#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Orca
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

mkdir build_tar
cd build_tar

apt-get download orca
apt-get download gir1.2-wnck-3.0

apt-get download python3-brlapi
apt-get download libbrlapi0.6

apt-get download python3-cairo

apt-get download python3-louis
apt-get download liblouis14

apt-get download python3-pyatspi
apt-get download gir1.2-atspi-2.0
apt-get download libatk-adaptor

apt-get download python3-speechd

apt-get download speech-dispatcher
apt-get download python3-xdg

apt-get download libao4
apt-get download libdotconf0
apt-get download libltdl7
apt-get download libpulse0
apt-get download libsndfile1
apt-get download libspeechd2
apt-get download speech-dispatcher-audio-plugins

mkdir -p custom/orca

dpkg -x orca_* custom/orca
dpkg -x gir1.2-wnck-* custom/orca

dpkg -x python3-brlapi_* custom/orca
dpkg -x libbrlapi0.6_* custom/orca

dpkg -x python3-cairo_* custom/orca

dpkg -x python3-louis_* custom/orca
dpkg -x liblouis14_* custom/orca

dpkg -x python3-pyatspi_* custom/orca
dpkg -x gir1.2-atspi-* custom/orca
dpkg -x libatk-adaptor_* custom/orca

dpkg -x python3-speechd_* custom/orca
dpkg -x python3-xdg_* custom/orca

dpkg -x speech-dispatcher_* custom/orca

dpkg -x libao4_* custom/orca
dpkg -x libdotconf0_* custom/orca
dpkg -x libltdl7_* custom/orca
dpkg -x libpulse0_* custom/orca
dpkg -x libsndfile1_* custom/orca
dpkg -x libspeechd2_* custom/orca
dpkg -x speech-dispatcher-audio-plugins_* custom/orca

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Orca.zip

unzip Orca.zip -d custom
mv custom/target/orca-cp-init-script.sh custom
mkdir -p custom/orca/etc/systemd/system
mv custom/target/speech-dispatcher.service custom/orca/etc/systemd/system

cd custom

tar cvjf orca.tar.bz2 orca orca-cp-init-script.sh
mv orca.tar.bz2 ../..
mv target/orca.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
