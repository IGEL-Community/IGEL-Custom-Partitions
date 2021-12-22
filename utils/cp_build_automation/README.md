# CP Build Automation (22 December)

The following script can be used to automate the build of multiple Custom Partitions

[build-cps.sh](build-cps.sh)

The script has several sections:

Initialization with a mounted filesystem to Master CP Server (MASTER_FOLDER):
```
BASE_FOLDER="auto-build-cps"
MASTER_FOLDER="/media/sf_IGEL-Images/igel-packages/${BASE_FOLDER}"
MASTER_FOLDER_ZIP="${MASTER_FOLDER}/zip_files"
MASTER_FOLDER_LOGS="${MASTER_FOLDER}/zip_files_logs"

if [ ! -d $HOME/Downloads/${BASE_FOLDER} ]; then
  mkdir -p $HOME/Downloads/${BASE_FOLDER}
fi
cd $HOME/Downloads/${BASE_FOLDER}

LOG_NAME="${BASE_FOLDER}_log_$(date +%Y%m%d%H%M).txt"
LOG_NAME_STDERR="${BASE_FOLDER}_stderr_$(date +%Y%m%d%H%M).txt"
   ```

wget to download builders:

  ```
# wget build scripts

#Microsoft Edge
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Browsers/Microsoft_Edge_stable/build/build-edge_stable-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
#Microsoft Teams
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Unified_Communications/Microsoft_Teams/build/build-teams-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
#Zoom
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Unified_Communications/Zoom_new_build_testing/build/build-zoom-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
#Webex -- also need to get the Webex deb file
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Unified_Communications/Webex/build/build-webex-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
if ! compgen -G "$HOME/Downloads/Webex*.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://www.webex.com/downloads.html"
  echo "***********"
  exit 1
fi
   ```

Loop to build each Custom Partition and copy up to Master CP Server **if** it is a new version.
```
find . -type f -name "build-*.sh" | while read LINE
do
  echo "*************************************"
  echo "*** RUNNNING ${LINE}..."
  echo "*************************************"
  time ./${LINE} 2>>$LOG_NAME_STDERR >> $LOG_NAME
  CP_VER="$(ls *.zip)"
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
   ```

Copy the log files to Master CP Server (MASTER_FOLDER_LOGS):
```
#copy log files
if [ ! -d ${MASTER_FOLDER_LOGS} ]; then
  mkdir -p ${MASTER_FOLDER_LOGS}
fi
cp ${LOG_NAME} ${MASTER_FOLDER_LOGS}
cp ${LOG_NAME_STDERR} ${MASTER_FOLDER_LOGS}
   ```
