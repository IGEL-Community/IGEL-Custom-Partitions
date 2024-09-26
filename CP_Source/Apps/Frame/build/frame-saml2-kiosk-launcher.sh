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
# The following command line arguments must be set:
# Frame application version, valid values are: 'v6' and 'v7'
# Example 1: frame-sat-kiosk-launcher.sh v6
# Example 2: frame-sat-kiosk-launcher.sh v7
#
# Visit Frame's documentation at https://docs.frame.nutanix.com
#
# Updated August 13, 2024
#

logMessage() {
    local TODAY=$(date +"%F")
    echo "[Frame][$(date)]: $1" >> "/userhome/.frame/log-$TODAY.log"
}

# Check if all the required variables are set correctly
if [ -z "${FRAME_LAUNCH_URL}" ]; then
    echo "Please fill the FRAME_LAUNCH_URL environment variable."
    exit 1
fi

# Check if all required command line arguments are set correctly
if [ $# -eq 0 ]; then
    logMessage "Script is started with 0 arguments! Argument arg1 should have application version set. Please check Frame documentation!"
    exit 1
fi

# Setup Logging directory
if [ ! -e /userhome/.frame ]; then
    mkdir -p /userhome/.frame/
fi

# Check for another instance is running
if [[ $(pgrep -f "$0") != "$$" ]]; then
    logMessage "Process already running. Exiting."
    exit 1
fi

# Variables 
FRAME_APP_VERSION="${1,,}" # Read first argument and convert it to lowercase
FRAME_CACHE_PATHS=("/custom/frame/userhome/.config/Frame/Cache" "/custom/frame/userhome/.config/Frame/Cookies" "/custom/frame/userhome/.config/Frame/Local Storage")
FRAME_APP_PATH="/custom/frame/usr/bin/frame"

# Check Frame App version
case $FRAME_APP_VERSION in
    "v6" | "v7")
        logMessage "Script is working with Frame App version: $FRAME_APP_VERSION"
        ;;
    *)
        logMessage "Script is working with version: '$FRAME_APP_VERSION' that's invalid or unknown! Script will exit now."
        exit 1
        ;;
esac

# Check if the legacy Frame App version is installed
if [ "$FRAME_APP_VERSION" = "v6" ]; then
    logMessage "Legacy Frame App installed."
    FRAME_APP_PATH="/custom/frame/usr/bin/nutanix-frame/Frame"
    FRAME_CACHE_PATHS=("/custom/frame/userhome/.Nutanix/Frame/cache")
fi

launchFrame() {
    # Clear cache from previous session
    for path in "${FRAME_CACHE_PATHS[@]}"; do
        rm -Rf "$path"
    done

    # Run Frame App in kiosk mode, auto-arrange displays if more than one monitor attached, using FRAME_LAUNCH_URL
    if [ "$FRAME_APP_VERSION" = "v7" ]; then
        "$FRAME_APP_PATH" -- --full-screen --start-session-in-full-screen=on --startup-url="$FRAME_LAUNCH_URL" &
        logMessage "App is launched. Result: $?"
    else
        "$FRAME_APP_PATH" --kiosk --displays-auto-arrange --url="$FRAME_LAUNCH_URL" &
        logMessage "App is launched. Result: $?"
    fi
}

monitorFrameApp() {
    echo "Monitoring Frame App..."
    while true; do
        if [[ $(ps -ef | grep "$FRAME_APP_PATH" | grep -v grep | wc -l) -ne 0 ]]; then
            echo "App is running."
        else
            echo "App isn't running!"
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
