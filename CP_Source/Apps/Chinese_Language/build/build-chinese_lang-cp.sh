#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine Ubuntu (OS11 = 18.04; OS12 = 20.04)
CP="chinese_lang"
ZIP_LOC="https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps"
ZIP_FILE="Chinese_Language"
FIX_MIME="TRUE"
CLEAN="TRUE"
OS11_CLEAN="11.08.230"
OS12_CLEAN="12.01.100"
USERHOME_FOLDERS="FALSE"
USERHOME_FOLDERS_DIRS=""
APPARMOR="FALSE"
GETVERSION_FILE="$HOME/Downloads/sogoupinyin_*_amd64.deb"
MISSING_LIBS_OS11="fcitx fcitx-bin fcitx-config-common fcitx-config-gtk fcitx-data fcitx-frontend-all fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-frontend-qt4 fcitx-frontend-qt5 fcitx-module-dbus fcitx-module-kimpanel fcitx-module-lua fcitx-module-x11 fcitx-modules fcitx-ui-classic libdouble-conversion1 libfcitx-config4 libfcitx-core0 libfcitx-gclient1 libfcitx-qt5-1 libfcitx-utils0 libgettextpo0 liblua5.2-0 libmng2 libmysqlclient20 libpresage-data libpresage1v5 libqt4-dbus libqt4-declarative libqt4-network libqt4-script libqt4-sql libqt4-sql-mysql libqt4-xml libqt4-xmlpatterns libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libqtcore4 libqtdbus4 libqtgui4 libtinyxml2.6.2v5 libxcb-xinerama0 mysql-common presage qdbus qt-at-spi qt5-gtk-platformtheme qtchooser qtcore4-l10n qttranslations5-l10n"
MISSING_LIBS_OS12="fcitx fcitx-bin fcitx-config-common fcitx-config-gtk fcitx-data fcitx-frontend-all fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-frontend-qt4 fcitx-frontend-qt5 fcitx-module-dbus fcitx-module-kimpanel fcitx-module-lua fcitx-module-x11 fcitx-modules fcitx-ui-classic libdouble-conversion1 libfcitx-config4 libfcitx-core0 libfcitx-gclient1 libfcitx-qt5-1 libfcitx-utils0 libgettextpo0 liblua5.2-0 libmng2 libmysqlclient20 libpresage-data libpresage1v5 libqt4-dbus libqt4-declarative libqt4-network libqt4-script libqt4-sql libqt4-sql-mysql libqt4-xml libqt4-xmlpatterns libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libqtcore4 libqtdbus4 libqtgui4 libtinyxml2.6.2v5 libxcb-xinerama0 mysql-common presage qdbus qt-at-spi qt5-gtk-platformtheme qtchooser qtcore4-l10n qttranslations5-l10n"

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
  echo "Obtain Chinese Language tools X86_64, save into $HOME/Downloads and re-run this script "
  echo "https://shurufa-sogou-com.translate.goog/linux?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=en&_x_tr_hist=true"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

cp ${GETVERSION_FILE} .

mkdir -p custom/${CP}/opt

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/${CP}
done

if [ "${FIX_MIME}" = "TRUE" ]; then
  mv custom/${CP}/usr/share/applications/ custom/${CP}/usr/share/applications.mime
fi

if [ -d custom/${CP}/opt/sogoupinyin/files/lib/qt5 ] ; then
  mv custom/${CP}/opt/sogoupinyin/files/lib/qt5 custom/${CP}/opt/sogoupinyin/files/lib/qt5.bak
fi
if [ -f custom/${CP}/opt/sogoupinyin/files/bin/qt.conf ] ; then
  mv custom/${CP}/opt/sogoupinyin/files/bin/qt.conf custom/${CP}/opt/sogoupinyin/files/bin/qt.conf.bak
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
mv ../${ZIP_FILE}.zip ../../${ZIP_FILE}-${VERSION}_${IGELOS_ID}_igel01.zip

cd ../..
rm -rf build_tar
