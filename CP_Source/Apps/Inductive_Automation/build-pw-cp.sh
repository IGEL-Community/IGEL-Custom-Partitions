#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for PerspectiveWorkstation
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
#https://inductiveautomation.com/downloads/
if ! compgen -G "$HOME/Downloads/perspectiveworkstation.tar.gz" > /dev/null; then
  echo "***********"
  echo "Obtain latest package, save into $HOME/Downloads and re-run this script "
  echo "#https://inductiveautomation.com/downloads/"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir custom
cd custom
tar xvf $HOME/Downloads/perspectiveworkstation.tar.gz
cd ..

############################################
# START: comment out for non-persistency!!!!
############################################

mkdir -p custom/perspectiveworkstation/userhome/.ignition

##########################################
# END: comment out for non-persistency!!!!
##########################################

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Inductive_Automation.zip

unzip Inductive_Automation.zip -d custom
mv custom/target/pw-cp-init-script.sh custom

cd custom

tar cvjf pw.tar.bz2 pw pw-cp-init-script.sh
mv pw.tar.bz2 ../..
mv target/pw.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
