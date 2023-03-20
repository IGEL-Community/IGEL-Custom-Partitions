#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine Ubuntu (OS11 = 18.04; OS12 = 20.04)
CP="libreoffice"
ZIP_LOC="https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Office"
ZIP_FILE="LibreOffice"
FIX_MIME="TRUE"
CLEAN="FALSE"
OS11_CLEAN="11.07.100"
OS12_CLEAN="12.01.100"
USERHOME_FOLDERS="TRUE"
USERHOME_FOLDERS_DIRS="custom/libreoffice/userhome/.config/libreoffice custom/libreoffice/userhome/Documents"
APPARMOR="TRUE"
GETVERSION_FILE="../../LibreOffice_*/DEBS/libreoffice*-base_*.deb"
MISSING_LIBS_OS11=""
MISSING_LIBS_OS12=""

VERSION_ID=$(grep "^VERSION_ID" /etc/os-release | cut -d "\"" -f 2)

if [ "${VERSION_ID}" = "18.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS11}"
  IGELOS_ID="OS11"
elif [ "${VERSION_ID}" = "20.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS12}"
  IGELOS_ID="OS12"
else
  echo "Not a valid Ubuntu OS release. OS11 needs 18.04 (bionic) and OS12 needs 20.04 (focal)."
  exit 1
fi

if ! compgen -G "$HOME/Downloads/LibreOffice_*_Linux_x86-64_deb.tar.gz" > /dev/null; then
  echo "***********"
  echo "Obtain latest Linux (64-bit) (deb) package, save into $HOME/Downloads and re-run this script "
  echo "https://www.libreoffice.org/download/download/?type=deb-x86_64"
  echo "***********"
  exit 1
fi
if ! compgen -G "$HOME/Downloads/LibreOffice_*_Linux_x86-64_deb_helppack_*.tar.gz" > /dev/null; then
  echo "***********"
  echo "Help for offline use"
  echo "Obtain latest Linux (64-bit) (deb) package, save into $HOME/Downloads and re-run this script "
  echo "https://www.libreoffice.org/download/download/?type=deb-x86_64"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/${CP}

tar zxvf $HOME/Downloads/LibreOffice_*_Linux_x86-64_deb.tar.gz
LIBREOFFICEDIR="LibreOffice_*_Linux_x86-64_deb/DEBS"
find ${LIBREOFFICEDIR} -type f | while read LINE
do
  dpkg -x "${LINE}" custom/libreoffice
done

tar zxvf $HOME/Downloads/LibreOffice_*_Linux_x86-64_deb_helppack_*.tar.gz
dpkg -x LibreOffice_*_Linux_x86-64_deb_helppack_*/DEBS/lib*.deb custom/libreoffice

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
ar -x ${GETVERSION_FILE}
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
