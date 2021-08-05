#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Inductive Automation Vision
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
if ! compgen -G "$HOME/Downloads/visionclientlauncher.tar.gz" > /dev/null; then
  echo "***********"
  echo "Obtain latest package, save into $HOME/Downloads and re-run this script "
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir custom
cd custom
tar xvf $HOME/Downloads/visionclientlauncher.tar.gz
cd ..

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/visionclientlauncher/userhome/.ignition

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Inductive_Automation_Vision.zip

unzip Inductive_Automation_Vision.zip -d custom
mv custom/target/iavision-cp-init-script.sh custom

cd custom

tar cvjf iavision.tar.bz2 visionclientlauncher iavision-cp-init-script.sh
mv iavision.tar.bz2 ../..
mv target/iavision.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
