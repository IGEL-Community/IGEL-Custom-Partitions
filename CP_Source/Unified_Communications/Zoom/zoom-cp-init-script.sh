#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-zoom_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/zoom"

# wfs for persistent login and history
WFS="/wfs/user/.zoom"

# .zoom directory
ZOOM="/userhome/.zoom"

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
  if [ $(find "${WFS}/data" -name "*@xmpp.zoom.us*" | wc -l) != 0 ]; then
    # unlink /userhome/.zoom/data
    if [ -L "${ZOOM}/data" ]; then
      unlink "${ZOOM}/data"
    fi

    # cleanup /wfs/user/.zoom/data
    find  ${WFS}/data -mindepth 1 -maxdepth 1 -not -name *zoomus.db -and -not -name *zoommeeting.db -and -not -name *VirtualBkgnd_Default -and -not -name *VirtualBkgnd_Custom  | while read LINE
    do
      rm -rf ${LINE}
    done
  fi

  # Linking most important files in /userhome/.zoom to /wfs/user/.zoom for some basic persistency
  mkdir -p ${WFS}/data
  mkdir -p ${ZOOM}/data
  mkdir -p ${ZOOM}/data/VirtualBkgnd_Custom
  mkdir -p ${ZOOM}/data/VirtualBkgnd_Default
  touch ${WFS}/data/zoomus.db
  touch ${WFS}/data/zoommeeting.db
  touch ${WFS}/zoomus.conf
  chown -R user:users ${WFS}
  chown -R user:users ${ZOOM}

  runuser -l user -c "ln -sv ${WFS}/data/zoomus.db ${ZOOM}/data/zoomus.db" | $LOGGER
  runuser -l user -c "ln -sv ${WFS}/data/zoommeeting.db ${ZOOM}/data/zoommeeting.db" | $LOGGER
  runuser -l user -c "ln -sv ${WFS}/data/VirtualBkgnd_Custom ${ZOOM}/data/" | $LOGGER
  runuser -l user -c "ln -sv ${WFS}/data/VirtualBkgnd_Default ${ZOOM}/data/" | $LOGGER
  runuser -l user -c "ln -sv ${WFS}/zoomus.conf /userhome/.config/zoomus.conf" | $LOGGER

  # Add apparmor profile to trust Zoom in Firefox to make SSO possible
  # We do this by a systemd service to run the reconfiguration
  # surely after apparmor.service!!!
  systemctl --no-block start igel-zoom-cp-apparmor-reload.service

  # after CP installation run wm_postsetup to activate Zoom.desktop mimetypes for SSO
  if [ -d /run/user/777 ]; then
    wm_postsetup
    # delay the CP ready notification
    sleep 3
  fi

  # add /opt/zoom to ld_library
  echo "${CP}/opt/zoom" > /etc/ld.so.conf.d/zoom.conf
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
  rm /etc/ld.so.conf.d/zoom.conf
;;
esac

echo "Finished" | $LOGGER

exit 0
