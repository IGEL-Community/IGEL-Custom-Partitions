#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-linphone_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/linphone"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  ln -sv /custom/linphone/userhome/.config/linphone /userhome/.config/linphone
  mkdir -p /userhome/Documents
  chown -R user:users /userhome/Documents
  ln -sv /custom/linphone/userhome/Documents/linphone /userhome/Documents/linphone
  mkdir -p /userhome/.local/share
  chown -R user:users /userhome/.local/share
  ln -sv /custom/linphone/userhome/.local/share/linphone /userhome/.local/share/linphone

  chown -R user:users /custom/linphone/userhome

;;
stop)
  # unlink linked files
  echo "nothing to do"

;;
esac

echo "Finished" | $LOGGER

exit 0
