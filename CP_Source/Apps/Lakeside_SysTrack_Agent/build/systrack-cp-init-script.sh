#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-systrack_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/systrack"

# Installer
INSTALL_PATH=${CP}/tmp
ZIP_FILE="SysTrack_*_Install_Linux.zip"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  # do initial install
  if [ ! -d ${CP}/var/opt/lsiagent ]; then
    pushd .
    # unzip ZIP_FILE
    cd ${INSTALL_PATH}
    unzip ${ZIP_FILE}
    # Patch SystemsManagementAgentLinux.sh
    sed -i "s|^AGENTDIR=|AGENTDIR=/custom/systrack|" SystemsManagementAgentLinux.sh
    sed -i "s|^AGENTOPT=|AGENTOPT=/custom/systrack|" SystemsManagementAgentLinux.sh
    sed -i "s/rm -rf \$EXTRACTDIR/#rm -rf \$EXTRACTDIR/g" SystemsManagementAgentLinux.sh
    sed -i "s/fnStartDaemon$/#fnStartDaemon/" SystemsManagementAgentLinux.sh
    # run install with profile environment variable for SysTrack Server
    mkdir -p ${CP}/etc/init.d
    mkdir -p /opt/lsiagent/bin
    /bin/bash ./SystemsManagementAgentLinux.sh install -m ${SYSTRACK_FQDN_SERVER} --config IGEL
    mv /etc/init.d/lsiagent ${CP}/etc/init.d
    mv /opt/lsiagent/bin/lsiagentd ${CP}/opt/lsiagent/bin
    rm -rf /opt/lsiagent
    popd
  fi
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
