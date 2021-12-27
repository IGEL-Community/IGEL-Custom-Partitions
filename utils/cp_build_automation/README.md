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

# prep BASE_FOLDER
if [ ! -d $HOME/Downloads/${BASE_FOLDER} ]; then
  mkdir -p $HOME/Downloads/${BASE_FOLDER}
else
  rm -rf "$HOME/Downloads/${BASE_FOLDER}/*"
fi
cd $HOME/Downloads/${BASE_FOLDER}

LOG_NAME="${BASE_FOLDER}_log_$(date +%Y%m%d%H%M).txt"
LOG_NAME_STDERR="${BASE_FOLDER}_stderr_$(date +%Y%m%d%H%M).txt"
   ```

wget to download builders:

  ```
# wget build scripts
echo "************************************" | tee -a $LOG_NAME
echo "*** DOWNLOADING Build Scripts...***" | tee -a $LOG_NAME
echo "************************************" | tee -a $LOG_NAME

#Microsoft Edge Stable
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Browsers/Microsoft_Edge_stable/build/build-edge_stable-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
#Microsoft Edge Beta
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Browsers/Microsoft_Edge_beta/build/build-edge-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
#Microsoft Teams
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Unified_Communications/Microsoft_Teams/build/build-teams-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
#Zoom
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/CP_Source/Unified_Communications/Zoom/build/build-zoom-cp.sh 2>>$LOG_NAME_STDERR >> $LOG_NAME
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

Sample output from a build run:

```
$ time ./build-cps.sh 2>&1 | tee -a /tmp/build_log.txt
************************************
*** BUILDING Custom Partitions...***
************************************
-rwxrwxr-x 1 igelums igelums 2331 Dec 22 14:27 build-edge_stable-cp.sh
-rwxrwxr-x 1 igelums igelums 1834 Dec 22 14:27 build-teams-cp.sh
-rwxrwxr-x 1 igelums igelums 2333 Dec 22 14:27 build-webex-cp.sh
-rwxrwxr-x 1 igelums igelums 1949 Dec 22 14:27 build-zoom-cp.sh
*************************************
*** RUNNNING ./build-edge_stable-cp.sh...
*************************************

real	0m55.812s
user	0m49.541s
sys	0m2.758s
*************************************
*** BUILT Microsoft_Edge_stable-96.0.1054.62-1_igel01.zip ***
***********************
*** SAME Version *** Microsoft_Edge_stable-96.0.1054.62-1_igel01.zip
***********************
*************************************
*** RUNNNING ./build-zoom-cp.sh...
*************************************

real	0m30.322s
user	0m26.782s
sys	0m1.334s
*************************************
*** BUILT Zoom-5.9.0.1273_igel01.zip ***
***********************
*** SAME Version *** Zoom-5.9.0.1273_igel01.zip
***********************
*************************************
*** RUNNNING ./build-teams-cp.sh...
*************************************

real	0m44.224s
user	0m39.502s
sys	0m2.641s
*************************************
*** BUILT Microsoft_Teams-1.4.00.26453_igel01.zip ***
***********************
*** NEW Version ***>> Microsoft_Teams-1.4.00.26453_igel01.zip
***********************
*************************************
*** RUNNNING ./build-webex-cp.sh...
*************************************

real	1m58.784s
user	1m49.566s
sys	0m5.645s
*************************************
*** BUILT Webex-41.12.0.20899_igel01.zip ***
***********************
*** SAME Version *** Webex-41.12.0.20899_igel01.zip
***********************

real	4m10.435s
user	3m45.442s
sys	0m12.501s
   ```
