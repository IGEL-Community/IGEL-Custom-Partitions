#! /bin/bash
#set -x
#trap read debug

randHex() {
	local numBytes="$1"; shift

	{ cat /dev/urandom | LC_ALL=C tr -d -c '[:digit:]abcdef' | head "-c$(($numBytes * 2))"; } 2>/dev/null
}

addGeneratedSessionIdIfNecessary() {
	local clientLaunchParameters="$1"; shift

	if ! echo "$clientLaunchParameters" | grep s=; then
		clientLaunchParameters="${clientLaunchParameters}&s=$(randHex 4)-$(randHex 2)-$(randHex 2)-$(randHex 2)-$(randHex 6)"
	fi

	echo "$clientLaunchParameters"
}

mergeClientLaunchParameters() {
	local oldClientLaunchParameters="$1"; shift
	local newClientLaunchParameters="$1"; shift

	newClientLaunchParameters="$(echo "$newClientLaunchParameters" | sed 's/?//g')"

	IFS='&'

	for keyValuePair in $newClientLaunchParameters; do
		key="$(echo "$keyValuePair" | grep -o '[^=]*=')"
		oldClientLaunchParameters="$(echo "$oldClientLaunchParameters" | sed "s/${key}[^&]*//g")"
	done

	for keyValuePair in $newClientLaunchParameters; do
		oldClientLaunchParameters="${oldClientLaunchParameters}&$keyValuePair"
	done

	unset IFS

	echo "$oldClientLaunchParameters" | sed 's/\&\&*/\&/g' | sed 's/^\&//' | sed 's/?\&/?/'
}

ACTION="custompart-cwc_client_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/cwc_client"

postinst="path_to_postinst_file"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  clientLaunchParametersFilePath=${CP}/$(grep "^clientLaunchParametersFilePath" ${postinst} | cut -d "'" -f 2)
  if [ ! -e "${clientLaunchParametersFilePath}" ]; then
    newClientLaunchParameters=$(grep "^newClientLaunchParameters" ${postinst} | cut -d "'" -f 2)
    clientLaunchParameters="$(addGeneratedSessionIdIfNecessary "$newClientLaunchParameters")"
    clientLaunchParameters="$(mergeClientLaunchParameters "$clientLaunchParameters" 'e=Access')"
    echo "$clientLaunchParameters" > "$clientLaunchParametersFilePath"
  fi

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
