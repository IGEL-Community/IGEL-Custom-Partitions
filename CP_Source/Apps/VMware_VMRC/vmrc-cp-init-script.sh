#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-vmrc_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/vmrc"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  chmod a+x ${CP}/VMware-Remote-Console-12.0.0-17287072.x86_64.bundle
  ${CP}/VMware-Remote-Console-12.0.0-17287072.x86_64.bundle --eulas-agreed --required --console | $LOGGER
  cp /usr/share/applications/vmware-vmrc.desktop /usr/share/applications.mime/vmware-vmrc.desktop

  # after CP installation run wm_postsetup to activate mimetypes for SSO
  if [ -d /run/user/777 ]; then
    wm_postsetup
    # delay the CP ready notification
    sleep 3
  fi

;;
stop)
  # nothing to unlink
  echo "Nothing to unlink" | $LOGGER

;;
esac

echo "Finished" | $LOGGER

exit 0
