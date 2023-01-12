#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for PrinterLogic
## Development machine (Ubuntu 18.04)

# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://docs.printerlogic.com/1-Printerlogic/1-install-setup-upgrade/Client/Install/Ubuntu-Linux-Installation.htm
if ! compgen -G "$HOME/Downloads/printerinstallerclient_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest package, save into $HOME/Downloads and re-run this script "
  echo "https://docs.printerlogic.com/1-Printerlogic/1-install-setup-upgrade/Client/Install/Ubuntu-Linux-Installation.htm"
  echo "***********"
  exit 1
fi

MISSING_LIBS="libappindicator3-1"

sudo apt install unzip -y
sudo apt install gdebi -y

mkdir build_tar
cd build_tar

mkdir -p custom/printerlogic/etc/chromium-browser/native-messaging-hosts

# install printerlogic
sudo gdebi $HOME/Downloads/printerinstallerclient_amd64.deb --non-interactive

# collect the installed files
sudo cp /etc/chromium/native-messaging-hosts/com.printerlogic.host.native.client.json custom/printerlogic/etc/chromium-browser/native-messaging-hosts
TAR_FILES="/etc/pl_dir /etc/systemd/system/printer-installer-client.service /etc/sudoers.d/printerlogicidp /opt/PrinterInstallerClient /usr/bin/printer-installer-client /usr/lib/cups/backend/printerlogic /usr/lib/mozilla/native-messaging-hosts/com.printerlogic.host.native.client.json /usr/share/applications/printerlogicidp.desktop"
sudo tar cvf /tmp/printerlogic.tar ${TAR_FILES}

# missing libs
for lib in $MISSING_LIBS; do
  apt-get download $lib
done

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/printerlogic
done


# extract the files
cd custom/printerlogic
sudo tar xvf /tmp/printerlogic.tar
sudo mv usr/share/applications/ usr/share/applications.mime
cd ../..

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/PrinterLogic.zip

unzip PrinterLogic.zip -d custom
mv custom/target/build/printerlogic-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x $HOME/Downloads/printerinstallerclient_amd64.deb
tar xf control.tar.* ./control
VERSION=$(grep ^Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/printerlogic.inf
#echo "printerlogic.inf file is:"
#cat target/printerlogic.inf

# new build process into zip file
sudo tar cvjf target/printerlogic.tar.bz2 printerlogic printerlogic-cp-init-script.sh
zip -g ../PrinterLogic.zip target/printerlogic.tar.bz2 target/printerlogic.inf
zip -d ../PrinterLogic.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../PrinterLogic.zip ../../PrinterLogic-${VERSION}_igel01.zip

cd ../..
sudo rm -rf build_tar
