#!/bin/bash
#set -x
#trap read debug

# Creating an silent install ISO image
## Development machine (Ubuntu 18.04)
# Obtain latest IGEL OS ISO Image
#https://www.igel.com/software-downloads/workspace-edition/
if ! compgen -G "$HOME/Downloads/OSC_*.zip" > /dev/null; then
  echo "***********"
  echo "Obtain latest IGEL OS OSC zip file, save into $HOME/Downloads and re-run this script "
  echo "#https://www.igel.com/software-downloads/workspace-edition/"
  echo "***********"
  exit 1
fi

ISO_VER=`basename ~/Downloads/OSC_*.zip | cut -b 5-13`
ISO_IMAGE_NAME="OSC_${ISO_VER}.unattended.iso"

sudo apt install unzip -y
sudo apt install xorriso -y

mkdir build_tar
cd build_tar

mkdir custom
cd custom
unzip $HOME/Downloads/OSC_*.zip

mkdir osciso
sudo mount -oloop OSC*/osc*.iso osciso

mkdir newiso
cp -a osciso/./ newiso

sudo umount osciso
rm -rf OSC_*

sed -i -e "s/timeout=30/timeout=10/" newiso/boot/grub/igel.conf
sed -i -e "s/default=0/default=1/" newiso/boot/grub/igel.conf
sed -i -e "s/Verbose Installation + Recovery/Installation (Unattended)/" newiso/boot/grub/igel.conf
sed -i -e "s/bzImage igel_syslog=verbose/bzImage quiet osc_unattended=true igel_syslog=quiet/" newiso/boot/grub/igel.conf

cd newiso

sudo xorriso -as mkisofs -isohybrid-mbr boot/isolinux/isohdpfx.bin \
  -c boot/isolinux/boot.cat -b boot/isolinux/isolinux.bin \
  -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot \
  -e igel_efi.img -no-emul-boot -isohybrid-gpt-basdat -o ../../../${ISO_IMAGE_NAME} .

cd ../../..
rm -rf build_tar
