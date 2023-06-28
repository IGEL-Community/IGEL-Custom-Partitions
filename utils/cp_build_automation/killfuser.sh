#!/bin/bash
#set -x
#trap read debug

#
# Finding owner / process for a locked file
sudo fuser -v /var/lib/dpkg/lock-frontend
