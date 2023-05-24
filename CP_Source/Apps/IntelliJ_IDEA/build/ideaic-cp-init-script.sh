#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-ideaic_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/ideaic"

# userhome
#IDEAIC_CONFIG="/userhome/.config/JetBrains"
IDEAIC_CONFIG="/userhome/.config"
#IDEAIC_CACHE1="/userhome/.local/share/JetBrains"
IDEAIC_CACHE1="/userhome/.local/share"
#IDEAIC_CACHE2="/userhome/.cache/JetBrains"
IDEAIC_CACHE2="/userhome/.cache"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  # Initial permissions
  mkdir -p /userhome/.local | $LOGGER
  chown -R user:users /userhome/.local | $LOGGER
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

  # basic persistency
  chown -R user:users "${CP}${IDEAIC_CONFIG}"
  chown -R user:users "${CP}${IDEAIC_CACHE1}"
  chown -R user:users "${CP}${IDEAIC_CACHE2}"

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
