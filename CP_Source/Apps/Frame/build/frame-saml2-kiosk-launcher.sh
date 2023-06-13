#!/bin/bash

# This script is designed to support a specific end user workflow and assumes a particular Frame configuration.
#
# The following end user experience workflow is supported with this script:
#
#   1. Frame App's cache is wiped to ensure a fresh session and authentication.
#   2. Frame App is launched in Kiosk Mode with multiple monitor support, presenting a third-party identity provider's login screen.
#   3. After logging in, end users will be taken by Frame App directly to the desktop or application (depends on the Launch Link configuration).
#   4. When a Frame session starts, the remote desktop will be in full-screen mode.
#   5. When end users disconnects by action or inactivity timeout, they'll see an option to resume their session for the duration of the account/Launchpad's configured idle timeout.
#   6. When a user quits the session or shuts down windows, they'll be logged out and redirected to the identity provider's initial login page.
#   7. If Frame App is closed, user can start a new session by launching Frame App with the Frame icon on the IGEL Desktop.
#
# Frame configuration assumptions:
#
#   1. Published Launchpad.
#   2. Configured identity provider with associated roles/permissions allowing user access to the FRAME_LAUNCH_URL provided.
#   3. Frame Launch Link with additional "Quit and log out" url parameter`&qlo=1`.
#
# The Frame account production workload VMs can be joined to a Windows domain, if desired.
#
# The following environment variables must be configured in the environment for this script to work.
#
# FRAME_LAUNCH_URL - obtained from Dashboard > Launchpad > Advanced Integrations for the Launch Link. The FRAME_LAUNCH_URL could be a Launchpad URL.
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

# Cache path based on Frame App version
LEGACY_FRAME_CACHE_PATH="/custom/frame/userhome/.Nutanix/Frame/cache"
FRAME_CACHE_PATH="/custom/frame/userhome/.config/Frame/Cache /custom/frame/userhome/.config/Frame/Cookies /custom/frame/userhome/.config/Frame/Local Storage"

# Frame App path and CLI separator
FRAME_APP_PATH="/custom/frame/usr/bin/frame"
LEGACY_FRAMEAPP=false

# Check if the legacy Frame App version is installed
if [ -x "/custom/frame/usr/bin/nutanix-frame/Frame" ]; then
    logMessage "Legacy Frame App installed."
    FRAME_APP_PATH="/custom/frame/usr/bin/nutanix-frame/Frame"
    LEGACY_FRAMEAPP=true
fi

launchFrame() {
    # Clear cache from previous session based on the Frame App version
    cache_path="$FRAME_CACHE_PATH"
    if [ "$FRAME_APP_PATH" = "/custom/frame/usr/bin/nutanix-frame/Frame" ]; then
        cache_path="$LEGACY_FRAME_CACHE_PATH"
    fi
    rm -Rf "$cache_path"

    # Run Frame App in kiosk mode, auto-arrange displays if more than one monitor attached, using FRAME_LAUNCH_URL with Secure Anonymous Token
    if [ -n "$LEGACY_FRAMEAPP" ]; then
        "$FRAME_APP_PATH" -- --kiosk --displays-auto-arrange --url="$FRAME_LAUNCH_URL#token=$token" &
    else
        "$FRAME_APP_PATH" --kiosk --displays-auto-arrange --url="$FRAME_LAUNCH_URL#token=$token" &
    fi
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
