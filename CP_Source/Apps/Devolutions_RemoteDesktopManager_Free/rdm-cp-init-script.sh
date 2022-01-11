#! /bin/bash
#set -x
#tread read debug

ACTION="custompart-rdm_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/rdm"

# wfs for persistent login and history
WFS="/wfs/user/.rdm"

# .rdm directory
RDM="/userhome/.rdm"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
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

  # Linking most important files in /userhome/.rdm to /wfs/user/.rdm for some basic persistency
  if [ ! -d ${WFS} ]; then
     mkdir -p ${WFS}
  fi
  chown -R user:users ${WFS}

  runuser -l user -c "ln -sv ${WFS} ${RDM}" | $LOGGER

  # postinstall .mono new-certs trust
  if [ ! -d "/usr/share/.mono/new-certs/Trust" ]; then
  	mkdir -p /usr/share/.mono/new-certs/Trust
  	for f in /etc/ssl/certs/*.crt ; do cp $f /usr/share/.mono/new-certs/Trust/$(openssl x509 -noout -hash -in $f).0 ; done
  fi

  # Add apparmor profile to trust RDM in Firefox to make SSO possible
  # We do this by a systemd service to run the reconfiguration
  # surely after apparmor.service!!!
  systemctl --no-block start igel-rdm-cp-apparmor-reload.service

  # after CP installation run wm_postsetup to activate RDM.desktop mimetypes for SSO
  if [ -d /run/user/777 ]; then
    wm_postsetup
    # delay the CP ready notification
    sleep 3
  fi

  # add rdm libs to ld_library
  echo "${CP}/usr/lib/devolutions/RemoteDesktopManager.Free" > /etc/ld.so.conf.d/rdm.conf
  echo "${CP}/usr/lib/devolutions/RemoteDesktopManager.Free/lib" > /etc/ld.so.conf.d/rdm.conf
  ldconfig
;;
stop)
  # unlink linked files
  find ${CP} | while read LINE
  do
    DEST=$(echo -n "${LINE}" | sed -e "s|${CP}||g")
    unlink $DEST | $LOGGER
  done

  # remove rdm.conf because it is not needed anymore
  rm /etc/ld.so.conf.d/rdm.conf
;;
esac

echo "Finished" | $LOGGER

exit 0
