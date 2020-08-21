#!/bin/sh

ACTION="custompart-zoom_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/zoom"

# wfs for persistent login and history
WFS="/wfs/user/.zoom/data"

# .zoom directory
ZOOM="/userhome/.zoom/"

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
	cp "$CP/usr/share/applications/Zoom.desktop" /usr/share/applications/ 2>/dev/null
	cp "$CP/usr/share/applications/Zoom.desktop" /usr/share/applications.mime/ 2>/dev/null

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

	# Linking /userhome/.zoom/data to /wfs/user/.zoom/data for some basic persistency
	mkdir -p ${WFS}
	chown -R user:users ${WFS}
	mkdir -p ${ZOOM}/data
	chown -R user:users ${ZOOM}/data
	mkdir -p ${ZOOM}/data/VirtualBkgnd_Custom
	chown -R user:users ${ZOOM}/data/VirtualBkgnd_Custom
	mkdir -p ${ZOOM}/data/VirtualBkgnd_Default
	chown -R user:users ${ZOOM}/data/VirtualBkgnd_Default

	ln -sv ${WFS}/zoomus.db ${ZOOM}/data/zoomus.db | $LOGGER
	ln -sv ${WFS}/zoommeeting.db ${ZOOM}/data/zoommeeting.db | $LOGGER
	ln -sv ${WFS}/VirtualBkgnd_Custom ${ZOOM}/data/ | $LOGGER
	ln -sv ${WFS}/VirtualBkgnd_Default ${ZOOM}/data/ | $LOGGER

  chown user:users /wfs/user/.zoom
  ln -sv /wfs/user/.zoom/zoomus.conf /userhome/.config/zoomus.conf | $LOGGER

  # remove all com.zoom.ipc* files from /wfs/user/.zoom/data - might cause issues when updating zoom
  rm ${WFS}/com.zoom.ipc*

	# add /opt/zoom to ld_library
	echo "${CP}/opt/zoom" > /etc/ld.so.conf.d/zoom.conf
	ldconfig

	${MP}/zoom_postinst | $LOGGER

	# fix mime types
	sed -i -e '/\[Added Associations]/i x-scheme-handler/zoommtg=zoom.desktop;' /usr/share/applications/mimeapps.list 2>/dev/null
	sed -i -e '/\[Added Associations]/i x-scheme-handler/zoomus=zoom.desktop;' /usr/share/applications/mimeapps.list 2>/dev/null
	sed -i -e '/\[Added Associations]/i x-scheme-handler/tel=zoom.desktop;' /usr/share/applications/mimeapps.list 2>/dev/null
	sed -i -e '/\[Added Associations]/i x-scheme-handler/callto=zoom.desktop;' /usr/share/applications/mimeapps.list 2>/dev/null
	sed -i -e '/\[Added Associations]/i x-scheme-handler/zoomphonecall=zoom.desktop;' /usr/share/applications/mimeapps.list 2>/dev/null
	sed -i -e '/\[Added Associations]/i application/x-zoom=zoom.desktop;' /usr/share/applications/mimeapps.list 2>/dev/null
	echo "x-scheme-handler/zoommtg=zoom.desktop;" >> /usr/share/applications/mimeapps.list 2>/dev/null
	echo "x-scheme-handler/zoomus=zoom.desktop;" >> /usr/share/applications/mimeapps.list 2>/dev/null
	echo "x-scheme-handler/tel=zoom.desktop;" >> /usr/share/applications/mimeapps.list 2>/dev/null
	echo "x-scheme-handler/callto=zoom.desktop;" >> /usr/share/applications/mimeapps.list 2>/dev/null
	echo "x-scheme-handler/zoomphonecall=zoom.desktop;" >> /usr/share/applications/mimeapps.list 2>/dev/null
	echo "application/x-zoom=zoom.desktop;" >> /usr/share/applications/mimeapps.list 2>/dev/null

	#Add Apparmor Exceptions
	sed -i -e '/\  # Addons/i \  \# Zoom Video COnferencing' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
	sed -i -e '/\  # Addons/i \  \/{@{igelmnt},}usr/bin/zoom Pixr,' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
	sed -i -e '/\  # Addons/i \  \/custom/zoom/** Pixr,' /etc/apparmor.d/usr.bin.firefox 2>/dev/null
	/etc/init.d/apparmor restart

	# update MIME Desktop Database
	update-desktop-database
	# update MIME database (/usr/share/mime/packages)
	update-mime-database /usr/share/mime

;;
reset)
		killall -9 zoom
		sleep 2
;;
stop)
  killall -9 zoom
  sleep 2
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
