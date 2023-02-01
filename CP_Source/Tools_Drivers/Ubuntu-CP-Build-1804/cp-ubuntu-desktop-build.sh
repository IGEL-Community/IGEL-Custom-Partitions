#!/bin/bash
# uncomment set and trap to trace execution
#set -x
#trap read debug

#
# Run this script after initial install
#
# If you try to run on an existing system, some of the commands,
# such as sed and cp, may not work as expected.
#
# This script will update and configure a FRESHLY installed version
# of Ubuntu Desktop 18.04 to be used as CP builder
#
# Items installed / configured include:
#
#  - Prepped for a VirtualBox install
#  - Time service (chrony)
#

#
# Ubuntu 18.04 Desktop with:
#
# Lastest update / upgrade
echo "******* Starting -- apt-get update / upgrade / dist-upgrade / autoremove"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get install build-essential gcc make perl dkms -y
sudo apt install apt-rdepends -y
sudo apt install gdebi -y
echo "******* Ending -- apt-get update / upgrade / dist-upgrade / autoremove"

#
# Time Service
#
echo "******* Starting -- apt install chrony"
sudo apt install chrony -y
echo "******* Ending -- apt install chrony"

#
# Basic utils
#
# Required if you are planning to install VirtualBox
# Ref: https://www.virtualbox.org
#
echo "After install, mount the VirutalBox guest additions and install"
echo "sudo ./VBoxLinuxAdditions.run"
echo "sudo vi /etc/group # add user to vbox group (vboxsf)"
