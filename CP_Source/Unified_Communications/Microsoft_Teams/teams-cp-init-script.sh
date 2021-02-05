#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-teams_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/teams"

# Teams directory
TEAMS="/userhome/.config/Microsoft"

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

  # basic persistency
  chown -R user:users "${CP}${TEAMS}"
  
  # add MIME type to /usr/share/applications/mimeapps.list
  echo "x-scheme-handler/msteams=teams.desktop" >> /usr/share/applications/mimeapps.list
  
  # Add apparmor profile to trust Teams in Firefox to make SSO possible
  # We do this by a systemd service to run the reconfiguration
  # surely after apparmor.service!!!
  systemctl --no-block start igel-teams-cp-apparmor-reload.service

  # after CP installation run wm_postsetup to activate teams.desktop mimetypes for SSO
  if [ -d /run/user/777 ]; then
    wm_postsetup
    # delay the CP ready notification
    sleep 3
  fi

  # add /opt/teams to ld_library
  #echo "${CP}/usr/share/teams" > /etc/ld.so.conf.d/teams.conf
  #echo "${CP}/usr/share/swiftshader" >> /etc/ld.so.conf.d/teams.conf
  #ldconfig
;;
stop)
  # unlink linked files
  find ${CP} | while read LINE
  do
    DEST=$(echo -n "${LINE}" | sed -e "s|${CP}||g")
    unlink $DEST | $LOGGER
  done

  # remove zoom.conf because it is not needed anymore
  #rm /etc/ld.so.conf.d/teams.conf
;;
esac

echo "Finished" | $LOGGER

exit 0
