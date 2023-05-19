#!/bin/sh

ACTION="custompart-ibscan_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/ibscan"

# set permissions on bomgar folder
chmod 777 $CP

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  # Initial permissions
  chown -R root:root "${CP}" | $LOGGER

  bash ${CP}/opt/IBScanUltimate_x64_3.9.2/install/install-IBScanUltimate.sh
  # systemctl commands moved to Setup > System > Firmware Customization > Custom Commands > Desktop > Final desktop command
  #systemctl enable ${CP}/etc/systemd/system/DeviceService.service
  #systemctl start DeviceService.service
  find ${CP} -name "*.sh" -exec chmod a+x {} \;

;;
stop)
  systemctl start DeviceService.service

;;
esac
echo "Finished" | $LOGGER

exit 0
