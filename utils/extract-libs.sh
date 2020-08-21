#!/bin/bash
#set -x
#trap read debug

#
# Extract Shared Libraries into Custom Partition
#

#
# Variables
#
# Missing Library folder
# Custom Partition folder

MISSING="missing"
CP_FOLDER="zoom"

#
# For each library in misssging folder, extract into CP folder
#

for file in $MISSING/*; do
  echo "$file:$CP_FOLDER"
  dpkg -x "$file" $CP_FOLDER
done
