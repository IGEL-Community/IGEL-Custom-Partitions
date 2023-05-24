#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
#https://www.jetbrains.com/idea/download/#section=linux
#Community Edition The IDE for pure Java and Kotlin development
#ideaIC-2023.1.2.tar.gz
FILE_NAME="ideaIC-*.tar.gz"
if ! compgen -G "$HOME/Downloads/$FILE_NAME" > /dev/null; then
  echo "***********"
  echo "Obtain latest Community Edition .tar.gz package, save into $HOME/Downloads and re-run this script "
  echo "https://www.jetbrains.com/idea/download/#section=linux"
  echo "***********"
  exit 1
fi

sudo apt install unzip -y

mkdir build_tar
cd build_tar

mkdir -p custom/ideaic/usr/local
mkdir -p custom/ideaic/userhome/.config/JetBrains
mkdir -p custom/ideaic/userhome/.local/share/JetBrains

tar xvf $HOME/Downloads/$FILE_NAME --directory=custom/ideaic/usr/local

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/IntelliJ_IDEA.zip

unzip IntelliJ_IDEA.zip -d custom
mv custom/target/build/ideaic-cp-init-script.sh custom

cd custom

# edit inf file for version number
VERSION=$(ls $HOME/Downloads/$FILE_NAME | cut -d "-" -f 2 | rev | cut -c 8- | rev)
#echo "Version is: " ${VERSION}
sed -i "/^version=/c version=\"${VERSION}\"" target/ideaic.inf
#echo "ideaic.inf file is:"
#cat target/ideaic.inf

# new build process into zip file
tar cvjf target/ideaic.tar.bz2 ideaic ideaic-cp-init-script.sh
zip -g ../IntelliJ_IDEA.zip target/ideaic.tar.bz2 target/ideaic.inf
zip -d ../IntelliJ_IDEA.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../IntelliJ_IDEA.zip ../../IntelliJ_IDEA-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
