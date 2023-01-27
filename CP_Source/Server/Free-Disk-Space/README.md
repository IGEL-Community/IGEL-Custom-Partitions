# Free Disk Space

## This does not account for hidden partitions on IGEL OS that are not mounted during normal operation. The hidden partions contain the following:

* Compressed squashfs files
* Empty space to allow for IGEL OS updates to be deployed

Currently there is no good way to see these in the running operating system, but just keep in mind that IGEL OS will take up to 4GB during installation as long as it is available.

|  CP Information | **NOTE:** This is not a CP. It is a profile with an embedded command.            |
|--------------------|------------|
| Package | free-disk-space 1.01 |
| IGEL OS Version (min) | 11.07.100 |
| Notes | Free Disk Space is an IGEL OS custom command to report back the free disk space on device. This is stored in the UMS Structure Tag field. |

-----

**NOTE:** Two reboots (for profile and to run command).

-----

**/bin/igel_free_disk_space.sh**

```bash
#!/bin/bash
# Find and report free space on IGEL OS device
# This will be saved in UMS Structure Tag
# Based on note from Milan P on IGEL Community on Slack
# https://igelcommunity.slack.com/archives/C8GP9JHQE/p1671833360500039

#### A.  Overall space of main disk partition (only igf0) - bytes
a=$(lsblk -rb | grep -e "igf0" | cut -d" " -f4 | paste -s -d+ - | bc)

#### B.  Physical space used by all features and igf partitions (except igf0) - bytes
b=$(lsblk -rb | grep -e "igf[1-9].*" | cut -d" " -f4 | paste -s -d+ - | bc)

#### C.  Available physical space - MB
c=$(echo "($a-$b)/(1024*1024)" | bc)

echo $c
setparam system.remotemanager.ums_structure_tag FREE_DISK_SPACE_${c}MB
write_rmsettings
  ```
