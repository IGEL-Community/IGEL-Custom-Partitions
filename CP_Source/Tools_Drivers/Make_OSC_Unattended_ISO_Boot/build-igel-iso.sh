#!/bin/bash
#set -x
#trap read debug

# Creating an silent install ISO image
## Development machine (Ubuntu 18.04)
# Obtain latest IGEL OS ISO Image
#https://www.igel.com/software-downloads/
if ! compgen -G "$HOME/Downloads/[oO][sS][cC][-_]*.zip" > /dev/null; then
  echo "***********"
  echo "Obtain latest IGEL OS OSC zip file, save into $HOME/Downloads and re-run this script "
  echo "# https://www.igel.com/software-downloads/"
  echo "***********"
  exit 1
fi

ISO_VER=`basename ~/Downloads/[oO][sS][cC][-_]*.zip | cut -b 5-13`
ISO_IMAGE_NAME="OSC_${ISO_VER}.unattended.iso"

sudo apt install unzip -y
sudo apt install syslinux-utils -y
sudo apt install genisoimage -y

mkdir build_tar
cd build_tar

mkdir custom
cd custom
unzip $HOME/Downloads/[oO][sS][cC][-_]*.zip

mkdir osciso
sudo mount -oloop preparestick/osc*.iso osciso

sudo mkdir newiso
sudo cp -a osciso/./ newiso

sudo umount osciso
rm -rf preparestick

sudo sed -i -e "s/timeout=30/timeout=10/" newiso/boot/grub/igel.conf
sudo sed -i -e "s/default=0/default=1/" newiso/boot/grub/igel.conf
sudo sed -i -e "s/Verbose Installation + Recovery/Installation (Unattended)/" newiso/boot/grub/igel.conf
sudo sed -i -e "s/bzImage igel_syslog=verbose/bzImage quiet osc_unattended=true igel_syslog=quiet/" newiso/boot/grub/igel.conf
#sudo sed -i -e '/Failsafe Installation/i menuentry "Shutdown" { halt }' newiso/boot/grub/igel.conf

cd newiso

#W/O EFI
#sudo genisoimage -r -U -V 'IGEL_OSC_TO' \
  #-o ../../../${ISO_IMAGE_NAME} \
  #-c boot/isolinux/boot.cat -b boot/isolinux/isolinux.bin \
  #-no-emul-boot -boot-load-size 4 -boot-info-table \
  #-no-emul-boot .
#sudo isohybrid ../../../${ISO_IMAGE_NAME}

#W EFI
sudo genisoimage -r -U -V 'IGEL_OSC_TO' \
  -o ../../../${ISO_IMAGE_NAME} \
  -c boot/isolinux/boot.cat -b boot/isolinux/isolinux.bin \
  -boot-load-size 4 -boot-info-table -no-emul-boot \
  -eltorito-alt-boot -e igel_efi.img -no-emul-boot .
sudo isohybrid --uefi ../../../${ISO_IMAGE_NAME}

cd ../../..
sudo rm -rf build_tar
