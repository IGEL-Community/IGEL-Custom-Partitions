#!/bin/bash

# This script is designed to support a specific end user workflow and assumes a particular Frame configuration.
#
# The following end user experience workflow is supported with this script:
#
#   1. Frame app's cache is wiped to ensure a fresh session and authentication.
#   2. Frame app is Launched in Kiosk Mode with multiple monitor support, presenting IDP's login screen.
#   3. After logging in, end users will be taken by Frame App directly to the desktop or application (depends on the Launch Link configuration).
#   4. When a Frame session starts, the remote desktop will be in full-screen mode.
#   5. When end users disconnects by action or inactivity timeout, they'll see an option to resume their session for the duration of the account/launchpad's configured idle timeout.
#   6. When a user quits the session or shuts down windows, they'll be logged out and redirected to the IDP's initial login page.
#   7. Starting a new session from scratch if Frame app is closed can be done by launching the Frame icon on the IGEL Desktop.
#
# Frame configuration assumptions:
#
#   1. Published Launchpad.
#   2. Configured IDP with associated roles/permissions allowing Launchpad access to the FRAME_LAUNCH_URL provided.
#   3. Frame Launch Link with additional "Quit and log out" url parameter`&qlo=1`.
#
# The Frame account production workload VMs can be joined to a Windows domain, if desired.
#
# The following environment variables must be configured in the environment for this script to work.
#
# FRAME_LAUNCH_URL - obtained from Dashboard > Launchpad > Advanced Integrations for the Launch Link. The FRAME_LAUNCH_URL could have a Launchpad URL.
#
# Visit Frame's documentation at https://docs.frame.nutanix.com
#
# Updated August 10, 2022
#

# Check if all the required variables are set correctly
if [ -z "${FRAME_LAUNCH_URL}" ] ; then
    echo "Please fill the FRAME_LAUNCH_URL environment variable."
    exit 1
fi

### Frame Functions

# Setup Logging directory
if [ ! -e /userhome/.frame ]; then
    mkdir /userhome/.frame/
fi

logMessage() {
    local TODAY=$(date +"%F")
    echo "[Frame][$(date)]: $1" >> "/userhome/.frame/log-$TODAY.log"
}

# Check for another instance is running.
if [[ `pgrep -f $0` != "$$" ]]; then
    logMessage "Process already running. Exiting."
    exit 1
fi

launchFrame() {
    # Clear cache from previous session
    rm -Rf /custom/frame/userhome/.Nutanix/Frame/cache

    # Run Frame App in kiosk mode, auto-arrange displays if more than one monitor attached, using FRAME_LAUNCH_URL
    /custom/frame/usr/bin/nutanix-frame/Frame --kiosk --displays-auto-arrange --url="$FRAME_LAUNCH_URL" &
}

monitorFrameApp() {

    echo "Monitoring Frame App..."
    while true 
    do
        if [[ $(ps -ef | grep -c "/custom/frame/usr/bin/nutanix-frame/Frame") -ne 1 ]]; then
            echo "App is running."
        else
            echo "App isn't running! :)"
            launchFrame
        fi

        sleep 3
    done
}

### Begin!

logMessage "Process started."

# Launch Frame App
launchFrame

# Wait for Frame app to start then monitor the process.
sleep 3
monitorFrameApp
