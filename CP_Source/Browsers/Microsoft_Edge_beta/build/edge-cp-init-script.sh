#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-edge_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/edge"

# user directories
EDGE_USER_CONFIG="/userhome/.config/microsoft-edge-beta"

#mimeapps
EDGE_MIMEAPPS_DIR="/userhome/.local/share/applications"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  if [ ! -d "${EDGE_MIMEAPPS_DIR}" ]; then
    mkdir -p "${EDGE_MIMEAPPS_DIR}"
    chown -R user:users "${EDGE_MIMEAPPS_DIR}/.."
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
  chmod 4755 "$CP/opt/microsoft/msedge-beta/msedge-sandbox"

  # basic persistency
  chown -R user:users "${CP}/userhome"

  # Add apparmor profile to trust in Firefox to make SSO possible
  # We do this by a systemd service to run the reconfiguration
  # surely after apparmor.service!!!
  systemctl --no-block start igel-edge-cp-apparmor-reload.service

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
