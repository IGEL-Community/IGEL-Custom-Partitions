#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-spinoco_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/spinoco"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  ln -sv /custom/spinoco/userhome/.config/Spinoco /userhome/.config/Spinoco

  chown -R user:users /custom/spinoco/userhome

;;
stop)
  # unlink linked files
  echo "nothing to do"

;;
esac

echo "Finished" | $LOGGER

exit 0
