#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-dynamsoft_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/dynamsoft"

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

	/opt/dynamsoft/DynamsoftService/AutoStartMgr "/opt/dynamsoft/DynamsoftService/delete_all_cert&"
	chmod -R 777 ${CP}/opt/dynamsoft/DynamsoftService
	chmod -R 755 ${CP}/opt/dynamsoft/DynamsoftService/cert
	chmod 644 ${CP}/opt/dynamsoft/DynamsoftService/*.txt
	chmod 644 ${CP}/opt/dynamsoft/DynamsoftService/*.htm
	chmod 644 ${CP}/opt/dynamsoft/DynamsoftService/server.der
	chmod 777 ${CP}/usr/bin/igel_dynamsoft_autostart.sh

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
