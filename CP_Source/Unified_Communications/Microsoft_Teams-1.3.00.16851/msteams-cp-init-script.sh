#!/bin/bash
#set -x
#trap read debug

ACTION="custompart-teams_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/msteams"

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

	# Linking /userhome/.config/Microsoft/Micrsoft Teams to /wfs/user/.config/Microsoft/Micrsoft Teams for some basic persistency
	mkdir -p "${WFS}"
	chown -R user:users "${WFS}"
	mkdir -p "${TEAMS}"
	chown -R user:users "${TEAMS}"

	ln -sv "${WFS}" "${TEAMS}/Microsoft Teams" | $LOGGER

	# add /usr/share/teams to ld_library
	# add /usr/share/teams/swiftshader to ld_library
	echo "${CP}/usr/share/teams" > /etc/ld.so.conf.d/msteams.conf
	echo "${CP}/usr/share/teams/swiftshader" >> /etc/ld.so.conf.d/msteams.conf
	ldconfig

	# fix mime types
	sed -i -e '/\[Added Associations]/i x-scheme-handler/msteams=teams.desktop;' /usr/share/applications/defaults.list 2>/dev/null
	sed -i -e '/\[Added Associations]/i x-scheme-handler/msteams=teams.desktop;' /usr/share/applications/mimeapps.list 2>/dev/null
	echo "x-scheme-handler/msteams=teams.desktop;" >> /usr/share/applications/defaults.list 2>/dev/null
	echo "x-scheme-handler/msteams=teams.desktop;" >> /usr/share/applications/mimeapps.list 2>/dev/null
	update-mime-database /usr/share/mime

	# Add Apparmor Exceptions
	sed -i -e '/\  # Addons/i \  \# MS Teams' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
	sed -i -e '/\  # Addons/i \  \/{@{igelmnt},}usr/bin/teams Pixr,' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
	sed -i -e '/\  # Addons/i \  \/{@{igelmnt},}usr/bin/nohup Pixr,' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
	sed -i -e '/\  # Addons/i \  \/custom/msteams/** Pixr,' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
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

	# Remove /userhome/.config/Microsoft/Microsoft Teams to /wfs/user/.config/Microsoft/Microsoft Teams for some basic persistency
	rm -rf "${WFS}"
	rm -rf "${TEAMS}/Microsoft Teams"

	# remove msteams.conf because it is not needed anymore
	rm /etc/ld.so.conf.d/msteams.conf

;;
esac

echo "Finished" | $LOGGER

exit 0
