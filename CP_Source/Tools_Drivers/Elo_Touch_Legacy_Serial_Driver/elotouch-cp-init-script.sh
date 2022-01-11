#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-elotouch_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/elotouch"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
# Initial permissions
chown -R root:root "${CP}" | $LOGGER
# Linking files and folders on proper path
find ${CP} | while read LINE
do
  DEST=$(echo -n "${LINE}" | sed -e "s|${CP}||g")
  if [ ! -z "${DEST}" -a ! -e "${DEST}" ]; then
    # Remove the last slash, if it is a dir
    [ -d $LINE ] && DEST=$(echo "${DEST}" | sed -e "s/\/$//g") | $LOGGER
    if [ ! -z "${DEST}" ]; then
      ln -sv "${LINE}" "${DEST}" | $LOGGER
    fi
  fi
done

chmod -R 777 ${CP}/etc/opt/elo-ser
chmod -R 444 ${CP}/etc/opt/elo-ser/*.txt

;;
stop)
# unlink linked files
find ${CP} | while read LINE
do
  DEST=$(echo -n "${LINE}" | sed -e "s|${CP}||g")
  unlink $DEST | $LOGGER
done

;;
esac

echo "Finished" | $LOGGER

exit 0
