#!/bin/sh

ACTION="custompart-magnus_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/magnus"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
	# Initial permissions
	chown -R 0:0 "${CP}" | $LOGGER
	chmod 755 "${MP}" | $LOGGER
	#
	# NOTE: Copy used instead of symbolic links since links do not work as well as copying .desktop files.
	cp "$CP/usr/share/applications/magnus.desktop" /usr/share/applications/ 2>/dev/null
	cp "$CP/usr/share/applications/magnus.desktop" /usr/share/applications.mime/ 2>/dev/null

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

;;
reset)
		killall -9 magnus
		sleep 2
;;
stop)
  killall -9 magnus
  sleep 2
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
