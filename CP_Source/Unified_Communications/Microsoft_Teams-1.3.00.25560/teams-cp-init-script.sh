#! /bin/bash

ACTION="custompart-teams_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/teams"

# wfs for persistent login and history
WFS="/wfs/user/.config/Microsoft/Microsoft Teams"

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

  # Check if old files in /wfs need to be removed
  if [ -d "${WFS}" ]; then
    if [ -L "${TEAMS}/Microsoft Teams" ]; then
      unlink "${TEAMS}/Microsoft Teams"
    fi
    rm -rf "${WFS}"
  fi

# Linking /userhome/.config/Microsoft/Micrsoft Teams to /wfs/user/.config/Microsoft/Micrsoft Teams for some basic persistency
  mkdir -p "${WFS}"
  chown -R user:users "${WFS}"
  mkdir -p "${TEAMS}"
  chown -R user:users "${TEAMS}"

  ln -sv "${WFS}" "${TEAMS}/Microsoft Teams" | $LOGGER

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
  echo "${CP}/usr/share/teams" > /etc/ld.so.conf.d/teams.conf
  echo "${CP}/usr/share/swiftshader" >> /etc/ld.so.conf.d/teams.conf
  ldconfig
;;
stop)
  # unlink linked files
  find ${CP} | while read LINE
  do
    DEST=$(echo -n "${LINE}" | sed -e "s|${CP}||g")
    unlink $DEST | $LOGGER
  done

  # remove zoom.conf because it is not needed anymore
  rm /etc/ld.so.conf.d/teams.conf
;;
esac

echo "Finished" | $LOGGER

exit 0
