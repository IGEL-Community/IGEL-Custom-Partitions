#! /bin/bash

ACTION="custompart-otpclient_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/otpclient"

# wfs for persistent login and history
WFS="/wfs/user/.config/otpclient.cfg"

# otpclient config
OTPCLIENT="/userhome/.config/otpclient.cfg"

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

  # Setup link to config file
  if [ ! -d $(dirname ${WFS}) ]; then
    mkdir $(dirname ${WFS})
  fi
  touch ${WFS}
  chown user:users ${WFS}
  runuser -l user -c "ln -sv ${WFS} ${OTPCLIENT}" | $LOGGER

  # Add apparmor profile to trust otpclient in Firefox to make SSO possible
  # We do this by a systemd service to run the reconfiguration
  # surely after apparmor.service!!!
  systemctl --no-block start igel-otpclient-cp-apparmor-reload.service

  # after CP installation run wm_postsetup to activate otpclient.desktop mimetypes for SSO
  if [ -d /run/user/777 ]; then
    wm_postsetup
    # delay the CP ready notification
    sleep 3
  fi

  # NOTE: No libraries to add to ld_library
;;
stop)
  # unlink linked files
  find ${CP} | while read LINE
  do
    DEST=$(echo -n "${LINE}" | sed -e "s|${CP}||g")
    unlink $DEST | $LOGGER
  done

  # NOTE: No libraries to remove
;;
esac

echo "Finished" | $LOGGER

exit 0
