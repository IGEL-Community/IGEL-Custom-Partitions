#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Training_Videos
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain zip file of training videos and save into Downloads
if ! compgen -G "$HOME/Downloads/trainingvideos.zip" > /dev/null; then
  echo "***********"
  echo "Obtain trainingvideos.zip file of training videos and save into Downloads"
  echo "***********"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/trainingvideos/userhome/trainingvideos

pushd .
cd custom/trainingvideos/userhome/trainingvideos

unzip $HOME/Downloads/trainingvideos.zip

popd

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Training_Videos.zip

unzip Training_Videos.zip -d custom
mv custom/target/trainingvideos-cp-init-script.sh custom

cd custom

tar cvjf trainingvideos.tar.bz2 trainingvideos trainingvideos-cp-init-script.sh
mv trainingvideos.tar.bz2 ../..
mv target/trainingvideos.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
