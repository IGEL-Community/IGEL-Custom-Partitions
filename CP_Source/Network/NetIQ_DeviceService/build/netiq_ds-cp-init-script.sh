#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-netiq_ds_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/netiq_ds"

# install directory
installDirectory="/opt/NetIQ/DeviceService"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  # Initial permissions
  chown -R root:root "${CP}" | $LOGGER
  # Linking files and folders on proper path
  find ${CP} -printf "/%P\n" | while read DEST
  do
    if [ ! -z "${DEST}" -a ! -e "${DEST}" ]; then
      # Remove the last slash, if it is a dir
      [ -d $DEST ] && DEST=${DEST%/} | $LOGGER
      if [ ! -z "${DEST}" ]; then
        ln -sv "${CP}/${DEST}" "${DEST}" | $LOGGER
      fi
    fi
  done

  systemctl enable "${CP}"/opt/NetIQ/DeviceService/scripts/deviceservice.service
  systemctl start deviceservice.service

  mkdir -p "/usr/local/share/ca-certificates/"
  cp "$installDirectory/bin/rootCA.crt" "/usr/local/share/ca-certificates/"
  update-ca-certificates

  certificateFile="$installDirectory/bin/rootCA.crt"
  certificateName="NetIQ"
  nssPath="$installDirectory/scripts"
  firefox_certDir=/userhome/.mozilla/firefox/browser0
  chromium_certDir=/userhome/.config/chromium/.pki/nssdb

  #firefox cert
  #certutil -A -n "$certificateName" -t "CT,C,C" -i "$certificateFile" -d "sql:$firefox_certDir" | $LOGGER

  #chromium cert
  #certutil -A -n "$certificateName" -t "CT,C,C" -i "$certificateFile" -d "sql:$chromium_certDir" | $LOGGER

;;
stop)
  # Unlinking files and folders on proper path
  find ${CP} -printf "/%P\n" | while read DEST
  do
    if [ -L "${DEST}" ]; then
      unlink $DEST | $LOGGER
    fi
  done

;;
esac

echo "Finished" | $LOGGER

exit 0
