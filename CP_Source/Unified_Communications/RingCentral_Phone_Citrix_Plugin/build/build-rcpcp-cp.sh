#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine Ubuntu (OS11.09+ = 22.04; OS12 = 20.04)
CP="rcpcp"
ZIP_LOC="https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications"
ZIP_FILE="RingCentral_Phone_Citrix_Plugin"
FIX_MIME="FALSE"
CLEAN="FALSE"
OS11_CLEAN="11.10.210"
OS12_CLEAN="12.5.2"
USERHOME_FOLDERS="FALSE"
USERHOME_FOLDERS_DIRS="custom/${CP}/userhome/.local/share/workspacesclient"
APPARMOR="FALSE"
#https://downloads.ringcentral.com/sp/RingCentralCitrixPluginForLinux
GETVERSION_FILE_OS11="RingCentral-Phone-CitrixPlugin.deb"
GETVERSION_FILE_OS12="RingCentral-Phone-CitrixPlugin.deb"
WGET_URL="https://downloads.ringcentral.com/sp/RingCentralCitrixPluginForLinux"
MISSING_LIBS_OS11=""
MISSING_LIBS_OS12=""

VERSION_ID=$(grep "^VERSION_ID" /etc/os-release | cut -d "\"" -f 2)

if [ "${VERSION_ID}" = "22.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS11}"
  IGELOS_ID="OS1110"
  GETVERSION_FILE=${GETVERSION_FILE_OS11}
elif [ "${VERSION_ID}" = "20.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS12}"
  IGELOS_ID="OS12"
  GETVERSION_FILE=${GETVERSION_FILE_OS12}
else
  echo "Not a valid Ubuntu OS release. OS11.10+ needs 22.04 (jammy) and OS12 needs 20.04 (focal)."
  exit 1
fi

mkdir build_tar
cd build_tar

wget -O ${GETVERSION_FILE} ${GETVERSION_FILE}

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/${CP}

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
fi

if [ "${CLEAN}" = "TRUE" ]; then
  echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
  wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
  chmod a+x clean_cp_usr_lib.sh
  wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
  chmod a+x clean_cp_usr_share.sh
  if [ "${IGELOS_ID}" = "OS1110" ]; then
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
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
# move variables and citrix into CP
# . rcpcp_citrix and call citrix_reinstall
mv variables ../rcpcp_variables.sh
mv citrix ../rcpcp_citrix.sh
sed -i "/variables/c rcpcp_variables.sh"
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/${CP}.inf
#echo "${CP}.inf file is:"
#cat target/${CP}.inf

# new build process into zip file
tar cvjf target/${CP}.tar.bz2 ${CP} ${CP}-cp-init-script.sh rcpcp_variables.sh rcpcp_citrix.sh
zip -g ../${ZIP_FILE}.zip target/${CP}.tar.bz2 target/${CP}.inf
zip -d ../${ZIP_FILE}.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../${ZIP_FILE}.zip ../../${ZIP_FILE}-${VERSION}_${IGELOS_ID}_igel01.zip

cd ../..
rm -rf build_tar
