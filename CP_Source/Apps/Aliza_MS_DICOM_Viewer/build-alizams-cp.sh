#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Aliza
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://github.com/AlizaMedicalImaging/AlizaMS/releases
if ! compgen -G "$HOME/Downloads/alizams-*_linux.tar.gz" > /dev/null; then
  echo "***********"
  echo "Obtain latest alizams-*_linux.tar.gz package, save into $HOME/Downloads and re-run this script "
  echo "https://github.com/AlizaMedicalImaging/AlizaMS/releases"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/alizams/usr/local

cd custom/alizams/usr/local
tar xvf $HOME/Downloads/alizams-*_linux.tar.gz
#mv alizams-*_linux/* ../alizams
cd ../..
mkdir -p usr/share/applications.mime
mkdir -p usr/share/icons
mv usr/local/alizams-*_linux usr/local/alizams
cp -r usr/local/alizams/install_menu/icons/* usr/share/icons

# Create MimeType file
cat << EOF >> usr/share/applications.mime/alizams.desktop
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=AlizaMS
GenericName=AlizaMS
Comment=Medical Imaging
Exec="/custom/alizams/usr/local/alizams/alizams.sh" %F
Icon=alizams
Terminal=false
Categories=Graphics;
StartupNotify=false
MimeType=application/dicom;
EOF

cd ../..

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Aliza_MS_DICOM_Viewer.zip

unzip Aliza_MS_DICOM_Viewer.zip -d custom
mv custom/target/alizams-cp-init-script.sh custom

cd custom

tar cvjf alizams.tar.bz2 alizams alizams-cp-init-script.sh
mv alizams.tar.bz2 ../..
mv target/alizams.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
