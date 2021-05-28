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

# Install vmrc on Ubuntu 18.04 System BUT do not run
# Check that vmrc is installed
if ! compgen -G "/usr/bin/vmrc" > /dev/null; then
  echo "***********"
  echo "Install vmrc on this Ubuntu 18.04 system"
  echo "sudo $HOME/Downloads/VMware-Remote-Console*.x86_64.bundle"
  echo "***********"
  echo "Re-run this script after vmrc application install completes"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

#
# Pull the vmrc files and create tar file
# NOTE:  Pulls all changed files in the last 5 minutes
#
sudo find /usr/bin -type l -mmin -5 -print0 | xargs -0 tar cf vmrc.tar
sudo find /usr/bin -type f -mmin -5 -print0 | xargs -0 tar rf vmrc.tar
sudo find /usr/share/icons/hicolor -type f ! -name "*.cache" -mmin -5 -print0 | xargs -0 tar rf vmrc.tar
sudo find /usr/lib/python3 -type f -mmin -5 -print0 | xargs -0 tar rf vmrc.tar

TAR_FILES="/usr/lib/vmware /usr/share/applications/vmware-vmrc.desktop /usr/share/appdata/vmware-vmrc.appdata.xml /etc/init.d/vmware-USBArbitrator /etc/vmware"
sudo tar rf vmrc.tar ${TAR_FILES}

MISSING_LIBS="libaio1"

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/vmrc

tar xvf vmrc.tar --directory custom/vmrc

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/vmrc
done


mv custom/vmrc/usr/share/applications/ custom/vmrc/usr/share/applications.mime

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
