#!/bin/bash

#
# Collect /usr/share files for an IGEL OS version
#

VERSION=$(cat /etc/os-release | grep VERSION= | cut -d "\"" -f 2)

cd /usr/share
find . -type f | sort > /tmp/${VERSION}_usr_share.txt
