#!/bin/bash
#set -x
#trap read debug

ACTION="custompart-slack_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/slack"

# wfs for persistent login and history
WFS="/wfs/user/.config/Slack"

# Profile directory
PRO_DIR="/userhome/.config/Slack"

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

	# Linking profile directory from /userhome to /wfs/user
	mkdir -p "${WFS}"
	chown -R user:users "${WFS}"
	#mkdir -p "${PRO_DIR}"
	#chown -R user:users "${PRO_DIR}"
	rm -rf "${PRO_DIR}"

	ln -sv "${WFS}" "${PRO_DIR}" | $LOGGER

	# fix mime types
	sed -i -e '/\[Added Associations]/i x-scheme-handler/slack=slack.desktop;' /usr/share/applications/defaults.list 2>/dev/null
	sed -i -e '/\[Added Associations]/i x-scheme-handler/slack=slack.desktop;' /usr/share/applications/mimeapps.list 2>/dev/null
	echo "x-scheme-handler/slack=slack.desktop;" >> /usr/share/applications/defaults.list 2>/dev/null
	echo "x-scheme-handler/slack=slack.desktop;" >> /usr/share/applications/mimeapps.list 2>/dev/null
	update-mime-database /usr/share/mime

	# Add Apparmor Exceptions
	sed -i -e '/\  # Addons/i \  \# Slack' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
	sed -i -e '/\  # Addons/i \  \/{@{igelmnt},}usr/bin/slack Pixr,' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
	sed -i -e '/\  # Addons/i \  \/{@{igelmnt},}usr/bin/nohup Pixr,' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
	sed -i -e '/\  # Addons/i \  \/custom/slack/** Pixr,' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
	sed -i -e '/\  # Addons/i \  \/bin/mkdir Pixr,' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
	sed -i -e '/\  # Addons/i \  \/bin/readlink Pixr,' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
	/etc/init.d/apparmor restart

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
