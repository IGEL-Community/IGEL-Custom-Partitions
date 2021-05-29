#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for vmrc
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://www.vmware.com/
if ! compgen -G "$HOME/Downloads/VMware-Remote-Console*.x86_64.bundle" > /dev/null; then
  echo "***********"
  echo "Obtain latest VMware-Remote-Console*.x86_64.bundle package, save into $HOME/Downloads and re-run this script "
  echo "https://www.vmware.com/"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

MISSING_LIBS="libaio1"

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/vmrc/tmp

cp $HOME/Downloads/VMware-Remote-Console*.x86_64.bundle custom/vmrc/tmp

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/vmrc
done

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/VMware_VMRC.zip

unzip VMware_VMRC.zip -d custom
mv custom/target/vmrc-cp-init-script.sh custom

cd custom

tar cvjf vmrc.tar.bz2 vmrc vmrc-cp-init-script.sh
mv vmrc.tar.bz2 ../..
mv target/vmrc.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
