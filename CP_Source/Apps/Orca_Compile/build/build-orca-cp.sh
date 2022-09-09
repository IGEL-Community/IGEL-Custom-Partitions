#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Orca Screen Reader
## Development machine (Ubuntu 18.04)
MISSING_LIBS="asterisk-espeak brltty-espeak dconf-gsettings-backend emacspeak emacspeak-espeak-server espeak espeak-data espeak-ng espeak-ng-data espeak-ng-espeak espeakedit espeakup gespeaker gir1.2-atspi-2.0 gir1.2-glib-2.0 gir1.2-gtk-3.0 gir1.2-pango-1.0 gir1.2-wnck-3.0 gsettings-backend gsettings-desktop-schemas gstreamer1.0-espeak libao4 libatk-adaptor libatk-bridge2.0-0 libatspi2.0-0 libbrlapi0.6 libdotconf0 libespeak-ng-libespeak1 libespeak-ng1 libespeak1 liblouis14 libltdl7 libpcaudio0 libperlspeak-perl libportaudio2 libpulse0 libsndfile1 libsonic0 libspeechd2 pkg-config pypy-py python-espeak python-glade2 python-gtk2 python-gtk2-doc python-gtkspellcheck python-gtkspellcheck-doc python-py python-pyatspi python-strongwind python3-brlapi python3-cairo python3-espeak python3-gi python3-gtkspellcheck python3-louis python3-py python3-pyatspi python3-speechd python3-xdg speech-dispatcher speech-dispatcher-audio-plugins speech-dispatcher-espeak speech-dispatcher-espeak-ng speechd-up stardict-plugin-espeak xbrlapi"

sudo apt install unzip -y

sudo apt install -y autoconf automake autopoint build-essential libcurl4-openssl-dev libsqlite3-dev pkg-config git curl libnotify-dev yelp-tools pkg-config python-gi-dev python-glade2 python-gobject-2-dev python-gtk2 python-gtk2-dbg python-gtk2-dev python-gtk2-doc python-gtkspellcheck python-gtkspellcheck-doc python3-gtkspellcheck gir1.2-atspi-2.0 libatspi2.0-0 libatspi2.0-dev python3-pyatspi python-pyatspi python-strongwind libatk-bridge2.0-0 libatk-bridge2.0-dev

mkdir -p build_tar/compile

# START build Orca
cd build_tar/compile
git clone https://github.com/GNOME/orca.git
cd orca
ORCA_BUILD_PATH=/custom/orca/usr
sudo mkdir -p $ORCA_BUILD_PATH
./autogen.sh --prefix=$ORCA_BUILD_PATH && make && make install
cd ../../..
# END build Orca

cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/orca

# START copy Orca build
mkdir -p custom/orca/usr/bin
cp -R $ORCA_BUILD_PATH/bin/* custom/orca/usr/bin
mkdir -p custom/orca/usr/lib
cp -R $ORCA_BUILD_PATH/lib/* custom/orca/usr/lib
mkdir -p custom/orca/usr/share
cp -R $ORCA_BUILD_PATH/share/* custom/orca/usr/share
mkdir -p custom/orca/etc
cp -R $ORCA_BUILD_PATH/etc/* custom/orca/etc
# END copy Orca build

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/orca
done


echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.07.100_usr_lib.txt custom/orca/usr/lib
./clean_cp_usr_share.sh 11.07.100_usr_share.txt custom/orca/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Orca_Compile.zip

unzip Orca_Compile.zip -d custom

mv custom/target/build/orca-cp-init-script.sh custom

cd custom

# edit inf file for version number
VERSION=$(grep "^VERSION = " $ORCA_BUILD_PATH/Makefile | cut -d " " -f 3)
#echo "Version is: " ${VERSION}
sed -i "/^version=/c version=\"${VERSION}\"" target/orca.inf
#echo "orca.inf file is:"
#cat target/orca.inf

# new build process into zip file
tar cvjf target/orca.tar.bz2 orca orca-cp-init-script.sh
zip -g ../Orca_Compile.zip target/orca.tar.bz2 target/orca.inf
zip -d ../Orca_Compile.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Orca_Compile.zip ../../Orca_Compile-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
