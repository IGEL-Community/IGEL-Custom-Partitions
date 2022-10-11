#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-forticlient_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/forticlient"

# config directory
USER_CONFIG1="/userhome/.config/FortiClient"
USER_CONFIG2="/userhome/.pki"

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

  # basic persistency
  if [ -d "${CP}${USER_CONFIG1}" ]; then
    chown -R user:users "${CP}${USER_CONFIG1}"
  fi
  if [ -d "${CP}${USER_CONFIG2}" ]; then
    chown -R user:users "${CP}${USER_CONFIG2}"
  fi

  # after CP installation run wm_postsetup to activate mimetypes
  if [ -d /run/user/777 ]; then
    wm_postsetup
    # delay the CP ready notification
    sleep 3
  fi

  ldconfig

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
