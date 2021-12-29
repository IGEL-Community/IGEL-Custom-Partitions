#!/bin/bash
#set -x
#trap read debug

#
# Sample workflow to build multiple CPs on Ubuntu 18.04 VM
#
# time ./build-cps.sh 2>&1 | tee -a /tmp/build_log.txt

BASE_FOLDER="auto-build-cps"
MASTER_FOLDER="/media/sf_IGEL-Images/igel-packages/${BASE_FOLDER}"
MASTER_FOLDER_ZIP="${MASTER_FOLDER}/zip_files"
MASTER_FOLDER_LOGS="${MASTER_FOLDER}/zip_files_logs"

# prep BASE_FOLDER
if [ ! -d $HOME/Downloads/${BASE_FOLDER} ]; then
  mkdir -p $HOME/Downloads/${BASE_FOLDER}
else
  rm -rf $HOME/Downloads/${BASE_FOLDER}/*
fi
cd $HOME/Downloads/${BASE_FOLDER}

LOG_NAME="${BASE_FOLDER}_log_$(date +%Y%m%d%H%M).txt"
LOG_NAME_STDERR="${BASE_FOLDER}_stderr_$(date +%Y%m%d%H%M).txt"

# wget build scripts
echo "************************************" | tee -a $LOG_NAME
echo "*** DOWNLOADING Build Scripts...***" | tee -a $LOG_NAME
echo "************************************" | tee -a $LOG_NAME

#Nutanix Frame
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Apps/Nutanix_Frame/build/build-frame-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
if ! compgen -G "$HOME/Downloads/Frame-*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://portal.nutanix.com/page/downloads?product=xiframe"
  #exit 1
  while ! compgen -G "$HOME/Downloads/Frame-*.deb" > /dev/null; do
    sleep 5
  done
  sleep 10
fi
#Webex -- also need to get the Webex deb file
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Unified_Communications/Webex/build/build-webex-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
if ! compgen -G "$HOME/Downloads/Webex*.deb" > /dev/null; then
  echo ""
  echo "***********"
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  #echo "https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb"
  echo "https://www.webex.com/downloads.html"
  echo "***********"
  #exit 1
  while ! compgen -G "$HOME/Downloads/Webex*.deb" > /dev/null; do
    sleep 5
  done
  sleep 10
fi
#Microsoft Edge Stable
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Browsers/Microsoft_Edge_stable/build/build-edge_stable-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
#Microsoft Edge Beta
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Browsers/Microsoft_Edge_beta/build/build-edge-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
#Chrome
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Browsers/Google_Chrome/build/build-chrome-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
#Microsoft Teams
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Unified_Communications/Microsoft_Teams/build/build-teams-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
#Zoom
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Unified_Communications/Zoom/build/build-zoom-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME

chmod a+x *.sh

echo "" | tee -a $LOG_NAME
echo "************************************" | tee -a $LOG_NAME
echo "*** BUILDING Custom Partitions...***" | tee -a $LOG_NAME
echo "************************************" | tee -a $LOG_NAME

sudo ls -l build*.sh

find . -type f -name "build-*.sh" | while read LINE
do
  echo "" | tee -a $LOG_NAME
  echo "*************************************"
  echo "*** RUNNNING ${LINE}..."
  echo "*************************************"
  time ./${LINE} 2>>$LOG_NAME_STDERR >> $LOG_NAME
  CP_VER="$(ls *.zip)"
  echo "" | tee -a $LOG_NAME
  echo "*************************************"
  echo "*** BUILT ${CP_VER} ***" | tee -a $LOG_NAME
  echo "***********************" | tee -a $LOG_NAME
  if [ ! -e ${MASTER_FOLDER_ZIP}/${CP_VER} ]; then
    echo "*** NEW Version ***>> ${CP_VER}" | tee -a $LOG_NAME
    mv ${CP_VER} ${MASTER_FOLDER_ZIP}
  else
    echo "*** SAME Version *** ${CP_VER}" | tee -a $LOG_NAME
    rm ${CP_VER}
  fi
  echo "***********************" | tee -a $LOG_NAME
done

#copy log files
if [ ! -d ${MASTER_FOLDER_LOGS} ]; then
  mkdir -p ${MASTER_FOLDER_LOGS}
fi
cp ${LOG_NAME} ${MASTER_FOLDER_LOGS}
cp ${LOG_NAME_STDERR} ${MASTER_FOLDER_LOGS}
