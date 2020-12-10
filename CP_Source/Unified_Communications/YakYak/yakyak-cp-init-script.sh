#!/bin/bash
#set -x
#trap read debug

ACTION="custompart-yakyak_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/yakyak"

# wfs for persistent login and history
WFS="/wfs/user/.config/yakyak"

# Profile directory
PRO_DIR="/userhome/.config/yakyak"

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

  # fix permissions
  chmod 4755 "$CP/usr/lib/yakyak/chrome-sandbox"

	# Linking profile directory from /userhome to /wfs/user
	mkdir -p "${WFS}"
	chown -R user:users "${WFS}"
	#mkdir -p "${PRO_DIR}"
	#chown -R user:users "${PRO_DIR}"
	rm -rf "${PRO_DIR}"

	ln -sv "${WFS}" "${PRO_DIR}" | $LOGGER

	# Add apparmor profile to trust YakYak in Firefox to make SSO possible
	# We do this by a systemd service to run the reconfiguration
	# surely after apparmor.service!!!
	systemctl --no-block start igel-yakyak-cp-apparmor-reload.service

	# after CP installation run wm_postsetup to activate yakyak.desktop mimetypes for SSO
	if [ -d /run/user/777 ]; then
		wm_postsetup
		# delay the CP ready notification
		sleep 3
	fi

;;
stop)
	# unlink linked files
	find ${CP} | while read LINE
        do
                DEST=$(echo -n "${LINE}" | sed -e "s|${CP}||g")
		unlink $DEST | $LOGGER
	done

	# Remote Linking profile directory from /userhome to /wfs/user
	rm -rf "${WFS}"
	rm -rf "${PRO_DIR}"

;;
esac

echo "Finished" | $LOGGER

exit 0
