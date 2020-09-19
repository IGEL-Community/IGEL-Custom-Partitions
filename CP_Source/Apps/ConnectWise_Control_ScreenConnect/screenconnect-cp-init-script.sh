#! /bin/bash

ACTION="custompart-screenconnect_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/screenconnect"

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

  # add /opt/screenconnect/App_Runtime/lib to ld_library
  echo "${CP}/opt/screenconnect/App_Runtime/lib" > /etc/ld.so.conf.d/screenconnect.conf
  ldconfig

  systemctl daemon-reload
  systemctl enable screenconnect.service
  systemctl start screenconnect.service
;;
stop)
  sytemctl stop screenconnect.service
  # unlink linked files
  find ${CP} | while read LINE
  do
    DEST=$(echo -n "${LINE}" | sed -e "s|${CP}||g")
    unlink $DEST | $LOGGER
  done

  # remove screenconnect.conf because it is not needed anymore
  rm /etc/ld.so.conf.d/screenconnect.conf
;;
esac

echo "Finished" | $LOGGER

exit 0
