#! /bin/bash
#set -x
#tread read debug

ACTION="custompart-waykclient_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/waykclient"

# wfs for persistent login and history
WFS="/wfs/user/.config/Wayk"

# .waykclient directory
RDM="/userhome/.config/Wayk"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
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

  # Linking most important files in /userhome/.waykclient to /wfs/user/.waykclient for some basic persistency
  if [ ! -d ${WFS} ]; then
     mkdir -p ${WFS}
  fi
  chown -R user:users ${WFS}

  runuser -l user -c "ln -sv ${WFS} ${RDM}" | $LOGGER

  # Add apparmor profile to trust RDM in Firefox to make SSO possible
  # We do this by a systemd service to run the reconfiguration
  # surely after apparmor.service!!!
  systemctl --no-block start igel-waykclient-cp-apparmor-reload.service

  # after CP installation run wm_postsetup to activate RDM.desktop mimetypes for SSO
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
