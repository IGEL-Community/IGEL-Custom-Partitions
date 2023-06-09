#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine Ubuntu (OS11 = 18.04; OS12 = 20.04)
CP="dwspectrum"
ZIP_LOC="https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps"
ZIP_FILE="DW_Spectrum"
FIX_MIME="TRUE"
CLEAN="TRUE"
OS11_CLEAN="11.08.230"
OS12_CLEAN="12.01.100"
USERHOME_FOLDERS="TRUE"
USERHOME_FOLDERS_DIRS=("custom/${CP}/userhome/.config/nx_ini" "custom/${CP}/userhome/.config/Digital Watchdog")
APPARMOR="FALSE"
GETVERSION_FILE="dwspectrum-client-*-linux_x64.deb"
MISSING_LIBS_OS11="libopenal-data libopenal1 libsndio6.1 libxcb-xinerama0"

MISSING_LIBS_OS12=""

VERSION_ID=$(grep "^VERSION_ID" /etc/os-release | cut -d "\"" -f 2)

if [ "${VERSION_ID}" = "18.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS11}"
  IGELOS_ID="OS11"
elif [ "${VERSION_ID}" = "20.04" ]; then
  echo "Not ready for OS 12 build"
  exit 1
  MISSING_LIBS="${MISSING_LIBS_OS12}"
  IGELOS_ID="OS12"
else
  echo "Not a valid Ubuntu OS release. OS11 needs 18.04 (bionic) and OS12 needs 20.04 (focal)."
  exit 1
fi

sudo apt install unzip -y

# START - Get the latest version of installer
if ! compgen -G "$HOME/Downloads/$GETVERSION_FILE" > /dev/null; then
  echo "***********"
  echo "Obtain latest DW Spectrum client install for Linux .tar.gz package, save into $HOME/Downloads and re-run this script "
  echo "https://dwspectrum.digital-watchdog.com/download/linux"
  echo "***********"
  exit 1
fi
# END - Get the latest version of installer

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

# START extract package
cp $HOME/Downloads/$GETVERSION_FILE .
# END extract package

mkdir -p custom/${CP}

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/${CP}
done

if [ "${FIX_MIME}" = "TRUE" ]; then
  mv custom/${CP}/usr/share/applications/ custom/${CP}/usr/share/applications.mime
fi

if [ "${USERHOME_FOLDERS}" = "TRUE" ]; then
  for folder in "${USERHOME_FOLDERS_DIRS[@]}"; do
    mkdir -p "$folder"
  done
fi

if [ "${CLEAN}" = "TRUE" ]; then
  echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
  wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
  chmod a+x clean_cp_usr_lib.sh
  wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
  chmod a+x clean_cp_usr_share.sh
  if [ "${IGELOS_ID}" = "OS11" ]; then
    ./clean_cp_usr_lib.sh ${OS11_CLEAN}_usr_lib.txt custom/${CP}/usr/lib
    ./clean_cp_usr_share.sh ${OS11_CLEAN}_usr_share.txt custom/${CP}/usr/share
  else
    ./clean_cp_usr_lib.sh ${OS12_CLEAN}_usr_lib.txt custom/${CP}/usr/lib
    ./clean_cp_usr_share.sh ${OS12_CLEAN}_usr_share.txt custom/${CP}/usr/share
  fi
  echo "+++++++=======  DONE CLEAN of USR =======+++++++"
fi

wget ${ZIP_LOC}/${ZIP_FILE}.zip

unzip ${ZIP_FILE}.zip -d custom

if [ "${APPARMOR}" = "TRUE" ]; then
  mkdir -p custom/${CP}/config/bin
  mkdir -p custom/${CP}/lib/systemd/system
  mv custom/target/build/${CP}_cp_apparmor_reload custom/${CP}/config/bin
  mv custom/target/build/igel-${CP}-cp-apparmor-reload.service custom/${CP}/lib/systemd/system/
fi
mv custom/target/build/${CP}-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../${GETVERSION_FILE}
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/${CP}.inf
#echo "${CP}.inf file is:"
#cat target/${CP}.inf

# new build process into zip file
tar cvjf target/${CP}.tar.bz2 ${CP} ${CP}-cp-init-script.sh
zip -g ../${ZIP_FILE}.zip target/${CP}.tar.bz2 target/${CP}.inf
zip -d ../${ZIP_FILE}.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../${ZIP_FILE}.zip ../../${ZIP_FILE}-${VERSION}_${IGELOS_ID}_igel01.zip

cd ../..
rm -rf build_tar
