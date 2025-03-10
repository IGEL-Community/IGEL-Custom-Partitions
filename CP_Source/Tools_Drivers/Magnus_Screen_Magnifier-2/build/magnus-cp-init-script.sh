#!/bin/sh

ACTION="custompart-magnus_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/magnus"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
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

;;
stop)
  killall -9 magnus
  sleep 2
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
