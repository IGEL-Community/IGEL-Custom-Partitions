#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine Ubuntu (OS11 = 18.04; OS12 = 20.04)
CP="lsagent"
ZIP_LOC="https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps"
ZIP_FILE="Lansweeper_Agent"
LANSWEEPER_AUTHENTICATION_KEY="4c2db649-014a-41f5-a01d-08950d7af"
FIX_MIME="FALSE"
CLEAN="FALSE"
OS11_CLEAN="11.08.230"
OS12_CLEAN="12.01.100"
USERHOME_FOLDERS="FALSE"
USERHOME_FOLDERS_DIRS=""
APPARMOR="FALSE"
GETVERSION_FILE="$HOME/Downloads/LsAgent-linux.run"
MISSING_LIBS_OS11=""
MISSING_LIBS_OS12=""

VERSION_ID=$(grep "^VERSION_ID" /etc/os-release | cut -d "\"" -f 2)

if [ "${VERSION_ID}" = "18.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS11}"
  IGELOS_ID="OS11"
elif [ "${VERSION_ID}" = "20.04" ]; then
  MISSING_LIBS="${MISSING_LIBS_OS12}"
  IGELOS_ID="OS12"
  echo "Builder has not been updated for OS12"
  exit 1
else
  echo "Not a valid Ubuntu OS release. OS11 needs 18.04 (bionic) and OS12 needs 20.04 (focal)."
  exit 1
fi

if ! compgen -G "${GETVERSION_FILE}" > /dev/null; then
  echo "***********"
  echo "Obtain Lansweeper Agent (Linux version) 64bit, save into $HOME/Downloads and re-run this script "
  echo "https://www.lansweeper.com/download/lsagent"
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

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/${CP}
done

#START setup
# file listing before install
pushd .
cd /
sudo sh -c 'find bin etc home lib opt sbin usr var | sort > /tmp/find_root_listing1.txt'
popd

# do install
chmod a+x ${GETVERSION_FILE}
${GETVERSION_FILE} --agentkey ${LANSWEEPER_AUTHENTICATION_KEY} --mode unattended

# file listing after install
pushd .
cd /
sudo sh -c 'find bin etc home lib opt sbin usr var | sort > /tmp/find_root_listing2.txt'
popd

# tar file of the new files
pushd .
cd /
sudo sh -c 'comm -1 -3 /tmp/find_root_listing1.txt /tmp/find_root_listing2.txt | xargs tar -cjvf /tmp/newfiles.tar.bz2'
popd

# untar files into CP
sudo tar xvf /tmp/newfiles.tar.bz2 --directory custom/${CP}
#END setup

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
chmod a+x custom/${CP}-cp-init-script.sh

cd custom

# edit inf file for version number
#ftspr-2.9.0.0-x86_64.tar.gz
VERSION=$({GETVERSION_FILE} --version | cut -f 2)
#echo "Version is: " ${VERSION}
sed -i "/^version=/c version=\"${VERSION}\"" target/${CP}.inf
#echo "${CP}.inf file is:"
#cat target/${CP}.inf

# new build process into zip file
sudo tar cvjf target/${CP}.tar.bz2 ${CP} ${CP}-cp-init-script.sh
zip -g ../${ZIP_FILE}.zip target/${CP}.tar.bz2 target/${CP}.inf
zip -d ../${ZIP_FILE}.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../${ZIP_FILE}.zip ../../${ZIP_FILE}-${VERSION}_${IGELOS_ID}_igel01.zip

cd ../..
rm -rf build_tar
