#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine Ubuntu (OS11.09+ = 22.04; OS12 = 20.04)
CP="island"
ZIP_LOC="https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Browsers"
ZIP_FILE="Island"
FIX_MIME="TRUE"
CLEAN="FALSE"
OS11_CLEAN="11.09.150"
OS12_CLEAN="12.2.2"
USERHOME_FOLDERS="TRUE"
USERHOME_FOLDERS_DIRS="custom/island/userhome/.config/island custom/island/userhome/.local/share/applications"
APPARMOR="FALSE"
GETVERSION_FILE="${HOME}/Downloads/"
MISSING_LIBS_OS11=""
MISSING_LIBS_OS12=""

VERSION_ID=$(grep "^VERSION_ID" /etc/os-release | cut -d "\"" -f 2)

if [ "${VERSION_ID}" = "18.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS11}"
  IGELOS_ID="OS11"
elif [ "${VERSION_ID}" = "22.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS11}"
  IGELOS_ID="OS11"
elif [ "${VERSION_ID}" = "20.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS12}"
  IGELOS_ID="OS12"
else
  echo "Not a valid Ubuntu OS release. OS11.09+ needs 22.04 (jammy) and OS12 needs 20.04 (focal)."
  exit 1
fi

# Obtain latest package and save into Downloads
# Download Latest Island App for Linux (Debian)
islandPackage=$(compgen -G "$HOME/Downloads/island-*.deb"; compgen -G "$HOME/Downloads/Island-*.deb" | head -n 1)

if [ -z "$islandPackage" ]; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://download.island.io/"
  exit 1
fi

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/${CP}

# start extract island
dpkg -x "$islandPackage" custom/island
# end extract island

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/${CP}
done

if [ "${FIX_MIME}" = "TRUE" ]; then
  mv custom/${CP}/usr/share/applications/ custom/${CP}/usr/share/applications.mime
fi

if [ "${USERHOME_FOLDERS}" = "TRUE" ]; then
  for folder in $USERHOME_FOLDERS_DIRS; do
    mkdir -p $folder
  done
  touch custom/island/userhome/.local/share/applications/mimeapps.list
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
ar -x "$islandPackage"
tar xf control.tar.* ./control ./postinst
VERSION=$(grep Version control | cut -d " " -f 2)
# copy postinst to CP
mv postinst ../${CP}/opt/island/island-browser/igel_postinst.sh
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
