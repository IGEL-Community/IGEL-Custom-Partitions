#!/bin/bash

#set -x
#trap read debug

# Creating an IGELOS CP for Linphone
## Development machine (Ubuntu 18.04)
# sudo apt install curl -y
# sudo apt install unzip -y

# Linphone download URL base
BASEURL="https://www.linphone.org/releases/linux/app/"


# Final package destination
BASEDIR=$PWD

mkdir -p build_tar/linphone

cd build_tar/linphone

echo $PWD

# Download latest AppImage
APPIMAGEVERSIONS=`wget -O - $BASEURL 2>/dev/null | sed -E 's/^.*href/href/; s/>.*//' | grep AppImage | awk -F"=" '{print $2}' | tr -d \" `

APPIMAGE=`echo $APPIMAGEVERSIONS | awk '{print $NF}'`

APPIMAGEFULLVERSION=`echo $APPIMAGE | cut -d. -f 1-3`
APPIMAGEVERSION=` echo $APPIMAGE  | cut -d- -f 2 | cut -d. -f 1-3`


echo "downloading $BASEURL$APPIMAGE"

# download AppImage
wget $BASEURL$APPIMAGE

# chmod a+x

chmod a+x $APPIMAGE


# executing AppImage
# Next version?: change to mount -o loop ....
./$APPIMAGE 2>&1 >/dev/null & 

# wait for Linphone to start

while [ `ps ax | grep AppRun.wrapped | grep -v grep | wc -l` -lt 1 ]
do
    echo "."
    sleep 1
done

echo "Linphone started, proceding.............."

#where is it mounted under /tmp ?
APPTEMPDIR=`mount | grep Lin | awk '{print $3}'`

# get current dir 
CPDIR=$PWD

# copy it to the CP
(cd $APPTEMPDIR;cp -r -p * $CPDIR)

# killall instances
killall AppRun.wrapped

rm -f $APPIMAGE 

# comment one line in usr/share/linphone/linphonerc-factory to disable download messages for the CP

sed -i '/^version_check_url_root.*$/s/^/#/' usr/share/linphone/linphonerc-factory

# config files directories will be build in Profile Desktop-final (CP or wfs)

# one directory down
cd .. 

#get the files from github
wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Linphone.zip
unzip Linphone.zip

# no custompart-linphone needed
tar -cjf linphone.tar.bz2 linphone 

# generate linphone.inf with 
cat << EOF > linphone.inf
[INFO]
[PART]
file="linphone.tar.bz2"
version="${APPIMAGEVERSION}_igel1"
size="300M"
name="$APPIMAGEFULLVERSION"
minfw="11.03.110"
EOF



mkdir -p $APPIMAGEFULLVERSION/igel
mkdir -p $APPIMAGEFULLVERSION/target

cp *.xml $APPIMAGEFULLVERSION/igel
cp *.inf *.tar.bz2 $APPIMAGEFULLVERSION/target
cp *.txt  $APPIMAGEFULLVERSION/

# cp *.inf *.tar.bz2 $BASEDIR
# cp *.xml $BASEDIR

zip -r $BASEDIR/$APPIMAGEFULLVERSION.zip $APPIMAGEFULLVERSION

cd $BASEDIR
rm -rf build_tar