#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Orca
## Development machine (Ubuntu 18.04)
MISSING_LIBS="asterisk-espeak brltty-espeak dconf-gsettings-backend emacspeak emacspeak-espeak-server espeak espeak-data espeakedit espeak-ng espeak-ng-data espeak-ng-espeak espeakup gespeaker gir1.2-atspi-2.0 gir1.2-glib-2.0 gir1.2-gtk-3.0 gir1.2-pango-1.0 gir1.2-wnck-3.0 gsettings-backend gsettings-desktop-schemas gstreamer1.0-espeak libao4 libatk-adaptor libbrlapi0.6 libdotconf0 libespeak1 libespeak-dev libespeak-ng1 libespeak-ng-dev libespeak-ng-libespeak1 libespeak-ng-libespeak-dev liblouis14 libltdl7 libpcaudio0 libperlspeak-perl libportaudio2 libpulse0 libsndfile1 libsonic0 libspeechd2 orca pypy-py python3-brlapi python3-cairo python3-espeak python3-gi python3-louis python3-py python3-pyatspi python3-speechd python3-xdg python-espeak python-py speech-dispatcher speech-dispatcher-audio-plugins speech-dispatcher-espeak speech-dispatcher-espeak-ng speechd-up stardict-plugin-espeak xbrlapi"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/orca

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/orca
done

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/orca/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/orca/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Orca.zip

unzip Orca.zip -d custom

mv custom/target/build/orca-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../orca_*.deb
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/orca.inf
#echo "orca.inf file is:"
#cat target/orca.inf

# new build process into zip file
tar cvjf target/orca.tar.bz2 orca orca-cp-init-script.sh
zip -g ../Orca.zip target/orca.tar.bz2 target/orca.inf
zip -d ../Orca.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Orca.zip ../../Orca-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
