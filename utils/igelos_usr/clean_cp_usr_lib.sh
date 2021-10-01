#!/bin/bash
#set -x
#trap read debug

#
# Clean up duplicate /usr/lib files from CP
#
# Usage: clean_cp_usr_lib igel_usr_lib_file path_to_cp_usr_lib
#
# https://github.com/IGEL-Community/IGEL-Custom-Partitions/tree/master/utils/igelos_usr

if [ $# -ne 2 ]; then
    echo "You need to provide two arguments"
    echo "Usage: clean_cp_usr_lib igel_usr_lib_file path_to_cp_usr_lib"
    echo "igel_usr_lib_file: 11.05.133_usr_lib.txt"
    echo "https://github.com/IGEL-Community/IGEL-Custom-Partitions/tree/master/utils/igelos_usr"
    exit 1
fi

IGEL_USR_LIB_WGET="https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr"

IGEL_USR_LIB_FILE=$1
PATH_TO_CP_USR_LIB=$2

ORIG_DIR=$(pwd)
wget ${IGEL_USR_LIB_WGET}/${IGEL_USR_LIB_FILE}
pushd .
cd ${PATH_TO_CP_USR_LIB}
find . -type f | sort > /tmp/cp_usr_lib.txt

# find common files and remove them and empty directories from CP usr lib
comm -1 -2 ${ORIG_DIR}/${IGEL_USR_LIB_FILE} /tmp/cp_usr_lib.txt | xargs rm
find . -xtype l -exec rm {} \;
find . -type d -empty -delete
popd
