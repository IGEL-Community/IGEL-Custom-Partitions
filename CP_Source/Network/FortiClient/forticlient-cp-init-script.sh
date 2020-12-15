#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-forticlient_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/forticlient"

# wfs for persistent login and history
WFS="/wfs/user/.config/FortiClient"
WFS_ETC="/wfs/forticlient/etc/forticlient"
ETC_FORTICLIENT="/etc/forticlient"

# FORTICLIENT directory
FORTICLIENT="/userhome/.config/FortiClient"

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

  # Linking /etc/forticlient to /wfs/forticlient/etc/forticlient
  if [ -L "${ETC_FORTICLIENT}" ]; then
    unlink "${ETC_FORTICLIENT}"
  fi
  if [ ! -d "${WFS_ETC}" ]; then
    mkdir -p "${WFS_ETC}"
    cp -R "${CP}/etc/forticlient/*" "${WFS_ETC}"
  fi
  ln -sv "${WFS_ETC}" "${ETC_FORTICLIENT}" | $LOGGER

  # Linking /userhome/.config/FortiClient to /wfs/user/.config/FortiClient
  if [ ! -d "${WFS}" ]; then
    mkdir -p "${WFS}"
    chown -R user:users "${WFS}"
  fi
  if [ -d "${FORTICLIENT}" ]; then
    rm -rf "${FORTICLIENT}"
  fi
  ln -sv "${WFS}" "${FORTICLIENT}" | $LOGGER

  # Add apparmor profile to trust FortiClient in Firefox to make SSO possible
  # We do this by a systemd service to run the reconfiguration
  # surely after apparmor.service!!!
  systemctl --no-block start igel-forticlient-cp-apparmor-reload.service

  # after CP installation run wm_postsetup to activate forticlient.desktop mimetypes for SSO
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
