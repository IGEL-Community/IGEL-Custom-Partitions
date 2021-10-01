# Remove duplicate items from CP based on IGEL OS version for /usr/lib and /usr/share

Add the following code to build script **AFTER** all packages / libraries have been extracted.

  ```
  echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
  wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
  chmod a+x clean_cp_usr_lib.sh
  wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
  chmod a+x clean_cp_usr_share.sh
  ./clean_cp_usr_lib.sh [IGELOS_VERSION]_usr_lib.txt custom/[PACKAGE_NAME]/usr/lib
  ./clean_cp_usr_share.sh [IGELOS_VERSION]_usr_share.txt custom/[PACKAGE_NAME]/usr/share
  echo "+++++++=======  DONE CLEAN of USR =======+++++++"
  ```

Where:

- [PACKAGE_NAME] is the application to be packaged
- [IGELOS_VERSION] is the IGEL OS version to build for. These files are maintained in this folder. They can also be created by running the following two scripts on IGEL OS system:

  - get_igel_usr_lib.sh
  - get_igel_usr_share.sh
