#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-f5vpn_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/f5vpn"

# userhome
VPN_CONFIG="/userhome/.F5Networks"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  #if [ -L ${USER_CONFIG} ]; then
    #unlink ${USER_CONFIG}
  #fi
  #if [ -d ${USER_CONFIG} ]; then
    #rm -rf ${USER_CONFIG}
  #fi
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

  # run postinst scripts
  /custom/f5vpn/usr/local/lib/F5Networks/postinst/f5cli_postinst.sh
  /custom/f5vpn/usr/local/lib/F5Networks/postinst/f5epi_postinst.sh
  /custom/f5vpn/usr/local/lib/F5Networks/postinst/f5vpn_postinst.sh

  # basic persistency
  #chown -R user:users "${CP}${USER_CONFIG}"
  chown -R user:users "${CP}${VPN_CONFIG}"

  # Add apparmor profile to trust in Firefox to make SSO possible
  # We do this by a systemd service to run the reconfiguration
  # surely after apparmor.service!!!
  systemctl --no-block start igel-f5vpn-cp-apparmor-reload.service  

  # after CP installation run wm_postsetup to activate mimetypes for SSO
  if [ -d /run/user/777 ]; then
    wm_postsetup
    # delay the CP ready notification
    sleep 3
  fi

  ldconfig

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
