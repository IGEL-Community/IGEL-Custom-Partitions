#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-perspectiveworkstation_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/perspectiveworkstation"

# config directory
USER_CONFIG="/userhome/.ignition"

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

  chmod -R 777 ${CP}

  # basic persistency
  if [ -d "${CP}${USER_CONFIG}" ]; then
    chown -R user:users "${CP}${USER_CONFIG}"
    ln -s ${CP}${USER_CONFIG} ${USER_CONFIG}
  fi

;;
stop)
  # unlink linked files
  echo "Nothing to unlink" | $LOGGER

;;
esac

echo "Finished" | $LOGGER

exit 0
