#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for keepass
## Development machine (Ubuntu 18.04)
MISSING_LIBS="binfmt-support ca-certificates-mono cli-common keepass2 libgdiplus libgif7 libmono-accessibility4.0-cil libmono-corlib4.5-cil libmono-data-tds4.0-cil libmono-i18n-west4.0-cil libmono-i18n4.0-cil libmono-posix4.0-cil libmono-security4.0-cil libmono-system-configuration4.0-cil libmono-system-core4.0-cil libmono-system-data4.0-cil libmono-system-drawing4.0-cil libmono-system-enterpriseservices4.0-cil libmono-system-numerics4.0-cil libmono-system-runtime-serialization-formatters-soap4.0-cil libmono-system-security4.0-cil libmono-system-transactions4.0-cil libmono-system-windows-forms4.0-cil libmono-system-xml4.0-cil libmono-system4.0-cil libmono-webbrowser4.0-cil mono-4.0-gac mono-gac mono-runtime mono-runtime-common mono-runtime-sgen xsel"

sudo apt-add-repository ppa:jtaylor/keepass -y
#sudo apt-add-repository ppa:ubuntuhandbook1/keepass2 -y
sudo apt update -y

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/keepass

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/keepass
done

mv custom/keepass/usr/share/applications/ custom/keepass/usr/share/applications.mime
mkdir -p custom/keepass/userhome/.config/KeePass
mkdir -p custom/keepass/userhome/KeePassDB

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/KeePass.zip

unzip KeePass.zip -d custom
mkdir -p custom/keepass/config/bin
mkdir -p custom/keepass/lib/systemd/system
mv custom/target/keepass_cp_apparmor_reload custom/keepass/config/bin
mv custom/target/igel-keepass-cp-apparmor-reload.service custom/keepass/lib/systemd/system/
mv custom/target/keepass-cp-init-script.sh custom

cd custom

tar cvjf keepass.tar.bz2 keepass keepass-cp-init-script.sh
mv keepass.tar.bz2 ../..
mv target/keepass.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
