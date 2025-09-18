#!/bin/bash

# Fetch and display IGEL OS versions, download, unpack, patch ISO, write to USB

# Install curl if not installed
if [ ! -f /usr/bin/curl ]; then
  sudo apt install curl -y
fi

RELEASE_URL="https://igel-community.github.io/IGEL-Docs-v02/Docs/ReleaseNotes/04-OS12/"
DOWNLOAD_BASE_URL="https://igeldownloadprod-bydsc8hmbsaegvdy.a01.azurefd.net/files/IGEL_OS_12/OSC"

echo "Fetching available IGEL OS versions..."
AVAILABLE_VERSIONS=$(curl -s "$RELEASE_URL" | grep -oP '(?<=<li><a href="readme)[^"]+' | grep -oP '[0-9]+\.[0-9]+\.[0-9]+')

if [ -z "$AVAILABLE_VERSIONS" ]; then
  echo "No versions found. Exiting."
  exit 1
fi

# Display list of versions
echo -e "\n***********"
echo "Available IGEL OS Versions:"
echo "***********"
mapfile -t VERSION_ARRAY <<< "$AVAILABLE_VERSIONS"
for i in "${!VERSION_ARRAY[@]}"; do
  echo "$((i+1)). ${VERSION_ARRAY[$i]}"
done

# Ask for version selection
echo -e "\n***********"
read -p "Enter the number of the IGEL OS version to download (default is 1): " VERSION_NUMBER
VERSION_NUMBER="${VERSION_NUMBER:-1}"

SELECTED_VERSION="${VERSION_ARRAY[$((VERSION_NUMBER-1))]}"

if [ -z "$SELECTED_VERSION" ]; then
  echo "Invalid selection. Exiting."
  exit 1
fi

OUTPUT_DIR="$HOME/Downloads/IGEL_OS_$SELECTED_VERSION"
mkdir -p "$OUTPUT_DIR"

DOWNLOAD_URL="${DOWNLOAD_BASE_URL}/osc-${SELECTED_VERSION}.zip"
DOWNLOAD_PATH="$OUTPUT_DIR/osc-${SELECTED_VERSION}.zip"

# Download zip if not already present
if [ -f "$DOWNLOAD_PATH" ]; then
  echo "osc-${SELECTED_VERSION}.zip already exists. Skipping download."
else
  echo "Downloading $SELECTED_VERSION from $DOWNLOAD_URL..."
  curl -o "$DOWNLOAD_PATH" "$DOWNLOAD_URL"
  [[ -f "$DOWNLOAD_PATH" ]] || { echo "Download failed. Exiting."; exit 1; }
  echo "Download complete."
fi

# Create ISO
ISO_IMAGE_NAME="OSC_${SELECTED_VERSION}.unattended.iso"
ISO_IMAGE_PATH="$OUTPUT_DIR/$ISO_IMAGE_NAME"

if [ -f "$ISO_IMAGE_PATH" ]; then
  echo "ISO already exists: $ISO_IMAGE_PATH"
else
  echo "Creating unattended ISO..."
  sudo apt install unzip syslinux-utils genisoimage -y

  WORK_DIR="$OUTPUT_DIR/build_tar"
  mkdir -p "$WORK_DIR/custom"
  cd "$WORK_DIR/custom"

  unzip "$DOWNLOAD_PATH"

  mkdir osciso
  sudo mount -o loop preparestick/osc*.iso osciso
  sudo mkdir newiso
  sudo cp -a osciso/. newiso
  sudo umount osciso
  rm -rf preparestick

  # Patch for unattended install
  if [ ! -f "newiso/boot/grub/igel-unattended.conf" ]; then
    echo "Adding unattended flag to igel.conf..."
    sudo sed -i '/splash=277/ s/$/ osc_unattended=true/' newiso/boot/grub/igel.conf
    sudo sed -i 's/^set timeout=.*/set timeout=2/' newiso/boot/grub/igel.conf
  else
    cd newiso/boot/grub
    sudo mv igel-unattended.conf igel.conf
    sudo mv igel-unattended.conf.sig igel.conf.sig
    cd ../../
  fi

  # Create ISO
  cd newiso

  sudo genisoimage -r -U -V 'IGEL_OSC_TO' \
    -o "../../../${ISO_IMAGE_NAME}" \
    -c boot/isolinux/boot.cat -b boot/isolinux/isolinux.bin \
    -boot-load-size 4 -boot-info-table -no-emul-boot \
    -eltorito-alt-boot -e igel_efi.img -no-emul-boot .
  sudo isohybrid --uefi "../../../${ISO_IMAGE_NAME}"
  
  cd ../..
  sudo rm -rf "$WORK_DIR"
  sudo chown "$(logname):$(logname)" "$ISO_IMAGE_PATH"
  chmod 644 "$ISO_IMAGE_PATH"

  echo -e "\n***********"
  echo "ISO Image created: $ISO_IMAGE_NAME"
  echo "***********"
fi

# Function to list USB drives
list_usb_devices() {
  echo -e "\n***********"
  echo "Available USB drives:"
  echo "***********"
  lsblk -d -n -o NAME,MODEL | grep -v -E '^loop|nvme' || return 1
}

# Prompt until USB devices are detected
while true; do
  USB_DEVICES=$(lsblk -d -n -o NAME,MODEL | grep -v -E '^loop|nvme')
  if [ -z "$USB_DEVICES" ]; then
    echo "No USB devices found. Connect a USB drive and press Enter."
    read
  else
    break
  fi
done

mapfile -t USB_ARRAY <<< "$USB_DEVICES"
for i in "${!USB_ARRAY[@]}"; do
  echo "$((i+1)). ${USB_ARRAY[$i]}"
done

read -p "Enter the number of the USB device to write to: " DEVICE_NUMBER
SELECTED_DEVICE=$(echo "${USB_ARRAY[$((DEVICE_NUMBER-1))]}" | awk '{print $1}')

if [ -z "$SELECTED_DEVICE" ]; then
  echo "Invalid USB selection. Exiting."
  exit 1
fi

USB_PATH="/dev/$SELECTED_DEVICE"

echo "Unmounting any mounted partitions on $USB_PATH..."
mount | grep "$USB_PATH" | awk '{print $1}' | xargs -r sudo umount

echo "Writing ISO to $USB_PATH..."
sudo dd if="$ISO_IMAGE_PATH" of="$USB_PATH" bs=4M status=progress && sync

echo -e "\n***********"
echo "ISO has been successfully written to $USB_PATH."
echo "You can now boot from this USB drive."
echo "***********"
