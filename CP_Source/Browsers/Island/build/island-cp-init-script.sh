#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-island_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/island"

# user directories
ISLAND_USER_CONFIG="/userhome/.config/island"

#mimeapps
ISLAND_MIMEAPPS_DIR="/userhome/.local/share/applications"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  if [ ! -d "${ISLAND_MIMEAPPS_DIR}" ]; then
    mkdir -p "${ISLAND_MIMEAPPS_DIR}"
    chown -R user:users "${ISLAND_MIMEAPPS_DIR}/.."
  fi
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

  # fix permissions
  chmod 4755 "$CP/opt/island/island-browser/chrome-sandbox"

  # basic persistency
  chown -R user:users "${CP}/userhome"

  # after CP installation run wm_postsetup to activate mimetypes for SSO
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
