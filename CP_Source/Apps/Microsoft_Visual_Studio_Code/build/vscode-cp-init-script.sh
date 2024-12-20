#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-vscode_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/vscode"

# Code directory
VSCODE_USERHOME="/userhome"
VSCODE_CONFIG="/userhome/.config/Code"
VSCODE="/userhome/.vscode"
VSCODE_DIR="/userhome/Code"
GIT_CONFIG="/userhome/.gitconfig"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  # Initial permissions
  chown -R root:root "${CP}" | $LOGGER
  # Linking files and folders on proper path
  find ${CP} -printf "/%P\n" | while read DEST
  do
    if [ ! -z "${DEST}" -a ! -e "${DEST}" ]; then
      # Remove the last slash, if it is a dir
      [ -d $DEST ] && DEST=${DEST%/} | $LOGGER
      if [ ! -z "${DEST}" ]; then
        ln -sv "${CP}/${DEST}" "${DEST}" | $LOGGER
      fi
    fi
  done

  # basic persistency
  chown -R user:users "${CP}${VSCODE_USERHOME}"
  chown -R user:users "${CP}${VSCODE_CONFIG}"
  chown -R user:users "${CP}${VSCODE}"
  chown -R user:users "${CP}${VSCODE_DIR}"
  chown -R user:users "${CP}${GIT_CONFIG}"

  # Add apparmor profile to trust in Firefox to make SSO possible
  # We do this by a systemd service to run the reconfiguration
  # surely after apparmor.service!!!
  systemctl --no-block start igel-vscode-cp-apparmor-reload.service

  # after CP installation run wm_postsetup to activate mimetypes
  if [ -d /run/user/777 ]; then
    wm_postsetup
    # delay the CP ready notification
    sleep 3
  fi

;;
stop)
  # Unlinking files and folders on proper path
  find ${CP} -printf "/%P\n" | while read DEST
  do
    if [ -L "${DEST}" ]; then
      unlink $DEST | $LOGGER
    fi
  done

;;
esac

echo "Finished" | $LOGGER

exit 0
