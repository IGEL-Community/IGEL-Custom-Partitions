#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine Ubuntu (OS11.08 = 18.04; OS11.09 = 22.04; OS12 = 20.04)
CP="pcmanfm"
ZIP_LOC="https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps"
ZIP_FILE="PCManFM"
FIX_MIME="TRUE"
CLEAN="TRUE"
OS11_CLEAN1108="11.08.440"
OS11_CLEAN1109="11.09.260"
OS12_CLEAN="12.3.2"
USERHOME_FOLDERS="TRUE"
USERHOME_FOLDERS_DIRS=("custom/${CP}/userhome/.config/pcmanfm" "custom/${CP}/userhome/.local/share/Trash")
APPARMOR="FALSE"
GETVERSION_FILE="../../${CP}_*amd64.deb"
MISSING_LIBS_OS1108="libfm-data libfm-extra4 libfm-gtk-data libfm-gtk4 libfm-modules libfm4 libmenu-cache-bin libmenu-cache3 lxde-icon-theme lxmenu-data pcmanfm"
MISSING_LIBS_OS1109="libfm-data libfm-extra4 libfm-gtk-data libfm-gtk4 libfm-modules libfm4 libmenu-cache-bin libmenu-cache3 lxmenu-data pcmanfm"
MISSING_LIBS_OS12="libfm-data libfm-extra4 libfm-gtk-data libfm-gtk4 libfm-modules libfm4 libmenu-cache-bin libmenu-cache3 lxmenu-data pcmanfm"

VERSION_ID=$(grep "^VERSION_ID" /etc/os-release | cut -d "\"" -f 2)

if [ "${VERSION_ID}" = "18.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS1108}"
  IGELOS_ID="OS11"
  IGELOS_ID_VER="OS1108"
  OS11_CLEAN="${OS11_CLEAN1108}"
elif [ "${VERSION_ID}" = "22.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS1109}"
  IGELOS_ID="OS11"
  IGELOS_ID_VER="OS1109"
  OS11_CLEAN="${OS11_CLEAN1109}"
elif [ "${VERSION_ID}" = "20.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS12}"
  IGELOS_ID="OS12"
  IGELOS_ID_VER="OS12"
else
  echo "Not a valid Ubuntu OS release. pre OS11.09 needs 18.04 (bionic), OS11.09+ needed 22.04 (jammy), and OS12 needs 20.04 (focal)."
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/${CP}

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/${CP}
done

if [ "${FIX_MIME}" = "TRUE" ] && [ "${IGELOS_ID}" = "OS11" ]; then
  sudo mv custom/${CP}/usr/share/applications/ custom/${CP}/usr/share/applications.mime
fi

if [ "${USERHOME_FOLDERS}" = "TRUE" ]; then
  for folder in "${USERHOME_FOLDERS_DIRS[@]}"; do
    mkdir -p "$folder"
  done
fi

touch custom/${CP}/userhome/.gtk-bookmarks


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
chmod a+x custom/${CP}-cp-init-script.sh

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ${GETVERSION_FILE}
tar xf control.tar.* ./control
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/${CP}.inf
#echo "${CP}.inf file is:"
#cat target/${CP}.inf

# new build process into zip file
sudo tar cvjf target/${CP}.tar.bz2 ${CP} ${CP}-cp-init-script.sh
zip -g ../${ZIP_FILE}.zip target/${CP}.tar.bz2 target/${CP}.inf
zip -d ../${ZIP_FILE}.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../${ZIP_FILE}.zip ../../${ZIP_FILE}-${VERSION}_${IGELOS_ID_VER}_igel01.zip

cd ../..
sudo rm -rf build_tar