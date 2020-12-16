#! /bin/bash

ACTION="custompart-slack_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/slack"

# wfs for persistent login and history
WFS="/wfs/user/.config/Slack"

# Slack directory
PRO_DIR="/userhome/.config/Slack"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  chmod -R go+rx "${CP}"
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

  # Check if old files in /wfs need to be removed
  if [ -d "${WFS}" ]; then
    if [ -L "${PRO_DIR}" ]; then
      unlink "${PRO_DIR}"
    fi
    rm -rf "${WFS}"
  fi

  # Linking profile directory from /userhome to /wfs/user
  mkdir -p "${WFS}"
  chown -R user:users "${WFS}"

  ln -sv "${WFS}" "${PRO_DIR}" | $LOGGER

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

  # add /usr/lib/slack to ld_library
  echo "${CP}/usr/lib/slack" > /etc/ld.so.conf.d/slack.conf
  echo "${CP}/usr/lib/slack/swiftshader" >> /etc/ld.so.conf.d/slack.conf
  ldconfig
;;
stop)
  # unlink linked files
  find ${CP} | while read LINE
  do
    DEST=$(echo -n "${LINE}" | sed -e "s|${CP}||g")
    unlink $DEST | $LOGGER
  done

  # remove zoom.conf because it is not needed anymore
  rm /etc/ld.so.conf.d/slack.conf
;;
esac

echo "Finished" | $LOGGER

exit 0
