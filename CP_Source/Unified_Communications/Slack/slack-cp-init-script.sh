#! /bin/bash

ACTION="custompart-slack_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/slack"

# persistent login and history
USER_CONFIG="/userhome/.config/Slack"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  chmod -R go+rx "${CP}"
  if [ -L ${USER_CONFIG} ]; then
	  unlink ${USER_CONFIG}
  fi
  if [ -d ${USER_CONFIG} ]; then
	  rm -rf ${USER_CONFIG}
  fi
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

  # fix permissions
  chmod 4755 "$CP/usr/lib/slack/chrome-sandbox"

	# basic persistency
  if [ -d "${CP}${USER_CONFIG}" ]; then
    chown -R user:users "${CP}${USER_CONFIG}"
  fi

  # Add apparmor profile to trust Slack in Firefox to make SSO possible
  # We do this by a systemd service to run the reconfiguration
  # surely after apparmor.service!!!
  systemctl --no-block start igel-slack-cp-apparmor-reload.service

  # after CP installation run wm_postsetup to activate slack.desktop mimetypes for SSO
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
