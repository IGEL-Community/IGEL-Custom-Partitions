#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-pascom_Client_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/pascom_Client"

# Teams directory
PASCOM="/userhome/.local/share/AppRun"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  # Initial permissions
  chown -R root:root "${CP}" | $LOGGER
# basic persistency
  ln -sv "${CP}${PASCOM}" "${PASCOM}"
  chown -R user:users "${CP}${PASCOM}"

;;
stop)

;;
esac

echo "Finished" | $LOGGER

exit 0
