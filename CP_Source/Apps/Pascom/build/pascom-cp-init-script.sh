#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-pascom_Client_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/pascom_Client"

# Teams directory
PASCOM1="/userhome/.local/share/AppRun"
PASCOM2="/userhome/.local/share/pascom Client"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  # Initial permissions
  chown -R root:root "${CP}" | $LOGGER
# basic persistency
  ln -sv "${CP}${PASCOM1}" "${PASCOM1}"
  ln -sv "${CP}${PASCOM2}" "${PASCOM2}"
  chown -R user:users "${CP}${PASCOM1}"
  chown -R user:users "${CP}${PASCOM2}"

;;
stop)
  unlink "${PASCOM1}"
  unlink "${PASCOM2}"

;;
esac

echo "Finished" | $LOGGER

exit 0
