#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-libreoffice_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/libreoffice"

# Teams directory
LIBREOFFICE="/userhome/.config/libreoffice"
LIBREOFFICE_DOCS="/userhome/Documents"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  if [ -L ${LIBREOFFICE} ]; then
    unlink ${LIBREOFFICE}
  fi
  if [ -d ${LIBREOFFICE} ]; then
    rm -rf ${LIBREOFFICE}
  fi
  if [ -L ${LIBREOFFICE_DOCS} ]; then
    unlink ${LIBREOFFICE_DOCS}
  fi
  if [ -d ${LIBREOFFICE_DOCS} ]; then
    rm -rf ${LIBREOFFICE_DOCS}
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
  chown -R user:users "${CP}${LIBREOFFICE}"
  chown -R user:users "${CP}${LIBREOFFICE_DOCS}"

# /usr/local/bin/libreoffice
  LO_PROG=$(basename /usr/local/bin/libreoffice*)
  ln -s /usr/local/bin/${LO_PROG} /usr/sbin/${LO_PROG}

  # Add apparmor profile to trust in Firefox to make SSO possible
  # We do this by a systemd service to run the reconfiguration
  # surely after apparmor.service!!!
  systemctl --no-block start igel-libreoffice-cp-apparmor-reload.service

  # after CP installation run wm_postsetup to activate libreoffice.desktop mimetypes for SSO
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
