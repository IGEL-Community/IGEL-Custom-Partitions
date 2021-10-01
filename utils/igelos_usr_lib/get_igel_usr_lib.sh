#!/bin/bash

#
# Collect /usr/lib files for an IGEL OS version
#

VERSION=$(cat /etc/os-release | grep VERSION= | cut -d "\"" -f 2)

cd /usr/lib
find . -type f | sort > /tmp/${VERSION}_usr_lib.txt
