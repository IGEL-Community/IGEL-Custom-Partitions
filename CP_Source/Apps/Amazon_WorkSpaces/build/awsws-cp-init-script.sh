#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-awsws_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/awsws"

# user directories
AWS_USER_CONFIG="/userhome/.config/WorkSpaces"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  if [ ! -d /userhome/.local/share ]; then
    mkdir -p /userhome/.local/share
    chown -R user:users /userhome/.local/share
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

  # basic persistency
  chown -R user:users "${CP}/userhome"

  # after CP installation run wm_postsetup to activate mimetypes
  if [ -d /run/user/777 ]; then
    wm_postsetup
    # delay the CP ready notification
    sleep 3
  fi

  ${MP}/awsws_igel_postinst.sh configure

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
