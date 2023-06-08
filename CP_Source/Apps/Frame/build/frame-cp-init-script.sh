#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-frame_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/frame"

# config directory
USER_CONFIG="/userhome/.Nutanix"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  # check for old folders / links and remove
  if [ -L ${USER_CONFIG} ]; then
    unlink ${USER_CONFIG}
  fi
  if [ -d ${USER_CONFIG} ]; then
    rm -rf ${USER_CONFIG}
  fi
  # Initial permissions
  chown -R root:root "${CP}" | $LOGGER
  # Linking files and folders on proper path
  find ${CP} -printf "/%P\n" | while read DEST
  do
    if [ ! -z "${DEST}" -a ! -e "${DEST}" ]; then
      # Remove the last slash, if it is a dir
      [ -d $DEST ] && DEST=${DEST%/} | $LOGGER
      if [ ! -z "${DEST}" ]; then
        ln -sv "${CP}/${DEST}" "${DEST}" | $LOGGER
      fi
    fi
  done

  # basic persistency
  if [ -d "${CP}${USER_CONFIG}" ]; then
    chown -R user:users "${CP}${USER_CONFIG}"
  fi

;;
stop)
# Unlinking files and folders on proper path
find ${CP} -printf "/%P\n" | while read DEST
do
  if [ -L "${DEST}" ]; then
    unlink $DEST | $LOGGER
  fi
done

;;
esac

echo "Finished" | $LOGGER

exit 0
