#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-pcmanfm_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/pcmanfm"

# config directory
USER_CONFIG="/userhome/.config/pcmanfm"
USER_TRASH="/userhome/.local/share/Trash"
USER_BOOKMARKS="/userhome/.gtk-bookmarks"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  if [ -L ${USER_CONFIG} ]; then
    unlink ${USER_CONFIG}
  fi
  if [ -d ${USER_CONFIG} ]; then
    rm -rf ${USER_CONFIG}
  fi
  if [ -L ${USER_TRASH} ]; then
    unlink ${USER_TRASH}
  fi
  if [ -d ${USER_TRASH} ]; then
    rm -rf ${USER_TRASH}
  fi
  if [ -L ${USER_BOOKMARKS} ]; then
    unlink ${USER_BOOKMARKS}
  fi
  if [ -f ${USER_BOOKMARKS} ]; then
    rm -f ${USER_BOOKMARKS}
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

  # comment out to NOT allow opening of terminal window
  ln -s /usr/bin/xfce4-terminal /usr/bin/x-terminal-emulator

  # basic persistency
  if [ -d "${CP}${USER_CONFIG}" ]; then
    chown -R user:users "${CP}${USER_CONFIG}"
  fi
  if [ -d "${CP}${USER_TRASH}" ]; then
    chown -R user:users "${CP}${USER_TRASH}"
  fi
  if [ -f "${CP}${USER_BOOKMARKS}" ]; then
    chown user:users "${CP}${USER_BOOKMARKS}"
  fi

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
