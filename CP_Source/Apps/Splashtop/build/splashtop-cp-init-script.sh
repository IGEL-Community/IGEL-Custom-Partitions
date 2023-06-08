#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-splashtop_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/splashtop"

# userhome
USER_CONFIG="/userhome/.config/foobar"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  # START From postinst
  if [ ! -d "${CP}/opt/splashtop-business/config/" ]; then
	  mkdir -p ${CP}/opt/splashtop-business/config/
  fi
  if [ ! -d "${CP}/opt/splashtop-business/dump/" ]; then
	  mkdir -p ${CP}/opt/splashtop-business/dump/
  fi
  if [ ! -d "${CP}/opt/splashtop-business/log/" ]; then
	  mkdir -p ${CP}/opt/splashtop-business/log/
  fi
  chmod a=rwx ${CP}/opt/splashtop-business/config
  chmod a=rwx ${CP}/opt/splashtop-business/
  chmod a=rwx ${CP}/opt/splashtop-business/log
  # END From postinst
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
  chown -R user:users "${CP}${USER_CONFIG}"

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
