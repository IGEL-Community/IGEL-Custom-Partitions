#!/bin/sh

ACTION="custompart-bomgar_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/bomgar/"

# set permissions on bomgar folder
chmod 777 $CP

#Dertermine bomgar installation file name
BOMGARDESKTOP=$(ls $CP | grep bomgar-scc)

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

# find bomgar persistent directory if already installed
BOMGARPERSIST=$(ls -a /custom/bomgar/userhome/ | grep .bomgar)

# find bomgar installation ID
BOMGARINSTID=$(ls -a /userhome/ | grep .bomgar)

echo "Starting" | $LOGGER

case "$1" in
init)
   if [ -f $CP"InstallTimeStamp.log" ]
   then
      # killall bomgar processes
	  killall /userhome/$BOMGARPERSIST/bomgar-scc
	  rm /userhome/$BOMGARPERSIST
      #symlink custom partition data directory to /userhome/
      ln -s $MP/bomgar/userhome/$BOMGARPERSIST /userhome/$BOMGARPERSIST

      #launch bomgar
      su user -c "/userhome/$BOMGARPERSIST/start_pinned &"
      echo "Finished" | $LOGGER
      exit 0
   else
      echo "Installed on "`date` >>  $CP"InstallTimeStamp.log"
      #Copy bomgar desktop file to application directory
      #cp -a $CP$BOMGARDESKTOP /usr/share/applications

      #Run bomgar installer as user
      chmod 777 $CP$BOMGARDESKTOP
      su user -c "bash $CP$BOMGARDESKTOP"

      #Wait for Bomgar install to finish and get directory name as BOMGARINSTID
      BOMGARINSTID=
      while [ -z "$BOMGARINSTID" ]
         do
         BOMGARINSTID=$(ls -a /userhome/ | grep .bomgar)
         sleep 10
      done

    #Create directory and copy data to custom partition directory for peristence of install.
    mkdir -p $CP"userhome/"
    cp -r /userhome/$BOMGARINSTID $CP"userhome/"

    #Set owner on directory to user
    chown -R user:users $CP
    rm /usr/share/applications/$BOMGARDESKTOP

    # reboot system
    igel_reboot_required

    fi

;;
stop)
	# killall bomgar processes
	killall /userhome/$BOMGARPERSIST/bomgar-scc
	rm /userhome/$BOMGARPERSIST
	rm -rf /userhome/$BOMGARPERSIST

;;
start)
    #symlink custom partition data directory to /userhome/
    ln -s $MP/bomgar/userhome/$BOMGARPERSIST /userhome/$BOMGARPERSIST

    #launch bomgar
    /userhome/$BOMGARPERSIST/start_pinned &

;;
esac
echo "Finished" | $LOGGER

exit 0
