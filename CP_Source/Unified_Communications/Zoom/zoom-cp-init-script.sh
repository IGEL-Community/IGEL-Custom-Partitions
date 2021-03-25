#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-zoom_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/zoom"

# config directory
USER_CONFIG="/userhome"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  # check for old folders / links and remove
  if [ -d /wfs/user/.zoom ]; then
    rm -rf /wfs/user/.zoom
  fi
  if [ -L /userhome/.zoom ]; then
    unlink /userhome/.zoom
  fi
  if [ -d /userhome/.zoom ]; then
    rm -rf /userhome/.zoom
  fi
  if [ -L /userhome/.config/zoomus.conf ]; then
    unlink /userhome/.config/zoomus.conf
  fi
  if [ -f /userhome/.config/zoomus.conf ]; then
    rm -f /userhome/.config/zoomus.conf
  fi

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
  if [ -d "${CP}${USER_CONFIG}" ]; then
    chown -R user:users "${CP}${USER_CONFIG}"
  fi

  # Add apparmor profile to trust in Firefox to make SSO possible
  # We do this by a systemd service to run the reconfiguration
  # surely after apparmor.service!!!
  systemctl --no-block start igel-zoom-cp-apparmor-reload.service

  # after CP installation run wm_postsetup to activate mimetypes for SSO
  if [ -d /run/user/777 ]; then
    wm_postsetup
    # delay the CP ready notification
    sleep 3
  fi

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
