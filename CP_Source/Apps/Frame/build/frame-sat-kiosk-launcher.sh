#!/bin/bash

# This script is designed to support a specific end user workflow and assumes a particular Frame configuration.
#
# The following end user experience workflow is supported with this script:
#
#   1. End users will not authenticate to a SAML2-based identity provider (this script uses the Frame Secure Anonymous Token (SAT) functionality).
#   2. User cache is removed prior to start of Frame App to ensure no user preference settings have persisted since the prior use of Frame App.
#   3. Frame App will launch in "kiosk mode" (full screen).
#   4. End users will be taken by Frame App directly to the desktop or application (depends on the Launch Link configuration).
#   5. When a Frame session starts, the remote desktop will be in full-screen mode.
#   6. When end users disconnect or close their session, Frame App will be restarted with a new SAT token.
#
# Frame configuration assumptions:
#
#   1. API Provider at the Organization entity
#   2. Secure Anonymous Token Provider at the Account entity granting a role of Launchpad User for a specific Launchpad in a Frame account (under the Organization entity).
#   3. Frame Launch Link is used, rather than a Launchpad URL to support automatic start of the user's session (bypassing a Launchpad).
#
# The Frame account production workload VMs can be joined to a Windows domain, if desired.
#
# The following environment variables must be configured in the environment for this script to work.
#
# FRAME_CLIENT_ID - obtained from the API provider when a set of API credentials are created.
# FRAME_CLIENT_SECRET - obtained from the API provider when a set of API credentials are created.
# FRAME_SAT_URL - URL obtainable from the Playground (e.g., https://api.console.nutanix.com/v1/accounts/XXXXXXXX-XXXX-XXXX-XXXX-31d09e2881cd/secure-anonymous/secure-anon-XXXXXXXX-XXXX-XXXX-XXXX-c5e2dc93df1e/tokens).
# FRAME_ACCOUNT_ID - obtainable from the FRAME_SAT_URL if the SAT Provider was created on the Frame Account.
# FRAME_EMAIL_DOMAIN - email domain name used to create the anonymous user email addresses that will be visible in the Session Trail.
# FRAME_LAUNCH_URL - obtained from Dashboard > Launchpad > Advanced Integrations for the Launch Link. The FRAME_LAUNCH_URL could have a Launchpad URL.
# FRAME_TERMINAL_CONFIG_ID - obtainable from the Launch Link URL.
# FRAME_LOGOUT_URL - Optional but recommended. Any accessible URL that you'd like your users to be redirected to if they log out for any reason.
# SESSION_RETRY_DURATION_MINUTES - Optional. Default os 10 minutes. If a session cannot be started within this timeframe, this script will start over and try again.
#
# Visit Frame's documentation at https://docs.fra.me

# Updated June 21st, 2023
#

# Check if all the required variables are set correctly
if [ -z "${FRAME_CLIENT_ID}" ] || [ -z "${FRAME_CLIENT_SECRET}" ] || [ -z "${FRAME_SAT_URL}" ] || [ -z "${FRAME_ACCOUNT_ID}" ] || [ -z "${FRAME_EMAIL_DOMAIN}" ] || [ -z "${FRAME_LAUNCH_URL}" ] || [ -z "${FRAME_TERMINAL_CONFIG_ID}" ]; then
    echo "Please fill FRAME_CLIENT_ID, FRAME_CLIENT_SECRET, FRAME_SAT_URL, FRAME_ACCOUNT_ID, FRAME_EMAIL_DOMAIN, FRAME_LAUNCH_URL, and FRAME_TERMINAL_CONFIG_ID environment variables"
    exit 1
fi

# Script Variables
FRAME_GRAPHQL_URL="https://api.console.nutanix.com/api/graphql"
FRAME_API_URL="https://api.console.nutanix.com/v1/"
OPEN_SESSION_STATES=("init" "reserved" "open")
FRAME_POLLING_INTERVAL_SECONDS=10
FRAME_SESSION_ID=""

### Frame Functions

# Setup Logging directory
if [ ! -e /userhome/.frame ]; then
    mkdir /userhome/.frame/
fi

logMessage() {
    local TODAY=$(date +"%F")
    echo "[Frame][$(date)]: $1" >>"/userhome/.frame/log-$TODAY.log"
}

handleWgetStatus() {
    case $1 in
    1)
        logMessage "Generic failure to make request."
        ;;

    2)
        logMessage "Error parsing reqeust."
        ;;

    3)
        logMessage "File I/O error."
        ;;

    4)
        logMessage "Network failure when trying to make a request."
        ;;

    5)
        logMessage "Response: SSL verification failure."
        ;;

    6)
        logMessage "Response: Unauthorized."
        ;;

    7)
        logMessage "Protocol error."
        ;;

    8)
        logMessage "Response: Error from server."
        ;;
    *)
        logMessage "Unexpected status code: $1"
        ;;
    esac
}

# Check for another instance is running.
if [[ $(pgrep -f $0) != "$$" ]]; then
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

# Does a passed session state match any of the "open" session states?
isSessionOpen() {
    if printf '%s\0' "${OPEN_SESSION_STATES[@]}" | grep -Fxqz "$1"; then
        sessionStatus=0
    else
        logMessage "Session status is not open."
        sessionStatus=1
    fi
}

# Enable Desktop "autoLaunch" user preference
setAutoLaunch() {
    local request_body='{"operationName":"SetUserPreferencesMutation","variables":{"__typename":"UserPreferences","desktopAutoLaunch":true,"enableQuickLaunch":false},"query":"mutation SetUserPreferencesMutation($desktopAutoLaunch: Boolean!, $enableQuickLaunch: Boolean!) {\n  setUserPreferences(desktopAutoLaunch: $desktopAutoLaunch, enableQuickLaunch: $enableQuickLaunch) {\n   id\n   preferences {\n     ...PreferencesPanelFragment\n     __typename\n   }\n   __typename\n  }\n}\n\nfragment StorageStatus on StorageStatus {\n  isAttached\n  type\n  __typename\n}\n\nfragment PreferencesPanelFragment on UserPreferences {\n  desktopAutoLaunch\n  enableQuickLaunch\n  __typename\n}\n"}'

    # Make request
    local result="$(wget -q -O - $FRAME_GRAPHQL_URL \
        --post-data "$request_body" \
        --header="Authorization: Bearer $token" \
        --header="Content-Type: application/json")"
    handleWgetStatus $?
}

# Create signature to use in headers
getSignature() {
    timestamp=$(date +%s)
    to_sign="$timestamp$FRAME_CLIENT_ID"
    signature=$(echo -n "$to_sign" |
        openssl dgst -sha256 -hmac "$FRAME_CLIENT_SECRET" |
        sed 's/^.* //')
}

getToken() {
    logMessage "Getting new token..."
    getSignature

    # Set a value for what will be in the "First Name" associated with the session.
    # Use device serial number
    #serial=$(dmidecode -s baseboard-serial-number)
    # Use the network name
    serial="$HOSTNAME"

    # Create unique email address for anonymous user using a random number generator
    randomId=$(openssl rand -hex 21)
    email="${randomId}@${FRAME_EMAIL_DOMAIN}"

    # If provided, specify logout URL in metadata
    if [ -n "$FRAME_LOGOUT_URL" ]; then
        metadata=",\"metadata\":{\"should_accept_tos\":false,\"frame_logout_url\":\"$FRAME_LOGOUT_URL\"}"
    else
        metadata=",\"metadata\":{\"should_accept_tos\":false}"
    fi

    # Include optional params such as first_name, last_name, email_domain, email and/or metadata
    local request_body='{
        "email": "'$email'",
        "first_name": "'$serial'",
        "last_name": "User"
	'$metadata'
    }'

    # Make request
    local result="$(wget -q -S -O - $FRAME_SAT_URL \
        --post-data "$request_body" \
        --header="X-Frame-ClientId:$FRAME_CLIENT_ID" \
        --header="X-Frame-Timestamp:$timestamp" \
        --header="X-Frame-Signature:$signature" \
        --header="Content-Type: application/json")"
    handleWgetStatus $?

    # Remove "" from token
    token=$(echo "$result" | tr -d '"')

    # set autoLaunch:true (Desktop Launchpad user preference) - relevant if Launchpad URL is used and want user to go directly into a desktop session
    setAutoLaunch
}

# Query Frame for an active session based on the generated token.
queryActiveSession() {
    local request_body='{
        "operationName":"ActiveSessionQuery",
        "variables":{
            "terminalConfigurationId":"'"$FRAME_TERMINAL_CONFIG_ID"'"
        },
        "query":"query ActiveSessionQuery($terminalConfigurationId: ID!) {\n  activeSession(terminalConfigurationId: $terminalConfigurationId) {\n   id\n   state\n   userId: userUuid\n   __typename\n  }\n}\n"
    }'

    activeSessionResponse="$(wget -q -O - $FRAME_GRAPHQL_URL \
        --post-data "$request_body" \
        --header="Authorization: Bearer $token" \
        --header="Content-Type: application/json")"
    handleWgetStatus $?

}

# Poll Frame until an active session is found and a Session ID can be set.
pollSessionId() {
    logMessage "Checking for active session... $FRAME_SESSION_ID"

    local elapsedSeconds=0
    local retryDurationMinutes=${SESSION_RETRY_DURATION_MINUTES:-10} # retry for 10 minutes by default
    local maxElapsedSeconds=$((retryDurationMinutes * 60))           # Convert minutes to seconds

    while [ -z "$FRAME_SESSION_ID" ]; do
        logMessage "Checking for active session... $FRAME_SESSION_ID"
        queryActiveSession
        # Response Example:
        # {"data":{"activeSession":{"__typename":"Session","id":"gateway-prod.KR5LDopQG8MzV136","state":"RESERVED","userId":"84c661ab-60ab-43e0-b7bd-3fa44d49ce05"}}}
        # Closed example: {"data":{"activeSession":null}}
        local sessionId="$(echo $activeSessionResponse | grep -o '"id":"[^"]*' | grep -o '[^"]*$')"

        if [ "$sessionId" != "" ]; then
            logMessage "Session ID is: $sessionId"
            FRAME_SESSION_ID="$sessionId"
        fi

        sleep 2
        elapsedSeconds=$((elapsedSeconds + 2)) # Increment the elapsed seconds by the sleep duration

        # Check if the elapsed time has reached the maximum allowed based on the retry duration.
        if [ $elapsedSeconds -ge $maxElapsedSeconds ]; then
            logMessage "Session Start Timeout reached. Restarting Frame Wrapper..."
            keep_token=true
            quitAndRestartWrapper
            break
        fi

        retryCounter=$((retryCounter + 1))
    done
}

# Query Frame for the status of a specific session based on Session ID.
querySessionStatus() {
    getSignature

    # Make request
    sessionStateResponse="$(wget -q -O - $FRAME_API_URL/accounts/$FRAME_ACCOUNT_ID/sessions/$FRAME_SESSION_ID \
        --header="X-Frame-ClientId:$FRAME_CLIENT_ID" \
        --header="X-Frame-Timestamp:$timestamp" \
        --header="X-Frame-Signature:$signature")"
    handleWgetStatus $?

    logMessage "Session State response: $sessionStateResponse"
    sessionState="$(echo $sessionStateResponse | grep -o '"state":"[^"]*' | grep -o '[^"]*$')"
    isSessionOpen $sessionState
}

# Poll Frame to keep tabs on the session. If the session closes, restart Frame App.
pollSessionStatus() {
    logMessage "Polling session status..."

    # Query the session's status
    querySessionStatus
    logMessage "Sesssion state: [$sessionStatus] $sessionState"

    while [ "$sessionStatus" -eq 0 ]; do
        # Make more requests...
        querySessionStatus
        logMessage "Sesssion state: [$sessionStatus] $sessionState"

        sleep $FRAME_POLLING_INTERVAL_SECONDS
    done

    # Session closed or otherwise? Time to restart!
    if [ "$sessionStatus" -eq 1 ]; then
        quitAndRestartWrapper
        keep_token=false
    fi
}

isTokenExpiring() {
    JWT_TOKEN=$1

    # Split the JWT into header, payload, and signature
    JWT_PAYLOAD=$(echo $JWT_TOKEN | cut -d "." -f 2 | tr '-_' '/+')

    # Add required padding
    padding=$(echo $JWT_PAYLOAD | awk '{print (4 - length % 4) % 4}')
    pad=$(printf %${padding}s)
    JWT_PAYLOAD=${JWT_PAYLOAD}${pad// /=}

    # Base64 decode and get 'exp' field
    JWT_EXPIRY=$(echo $JWT_PAYLOAD | base64 --decode | sed -n 's/.*"exp":[ ]*\([0-9]*\).*/\1/p')

    # Get current time and add 15 minutes (900 seconds)
    CURRENT_TIME_PLUS_15=$(($(date +%s) + 900))

    if [[ "$CURRENT_TIME_PLUS_15" -gt "$JWT_EXPIRY" ]]; then
        # Token will expire in less than 15 minutes
        return 0
    else
        # Token will not expire in less than 15 minutes
        return 1
    fi
}

# Clean session and token details.
quitAndRestartWrapper() {
    unset FRAME_SESSION_ID token sessionStatus
    logMessage "Quitting Frame Wrapper."

    # Close Frame App:
    kill -9 $(ps aux | grep 'Frame' | awk '{print $2}') &

    logMessage "Frame Wrapper closed. Re-launching..."
    sleep 3

    # Reuse or get a new token
    if isTokenExpiring "$token" && [ "$keep_token" = true ]; then
        logMessage "Token is about to expire, regenerating..."
        getToken
    else
        logMessage "Token is still valid for the next 15 minutes. Keeping existing token from failed session attempt."
    fi

    # Start a fresh session
    launchFrame
    sleep 3

    # See how things go :)
    monitorSession
}

launchFrame() {
    # Clear cache from previous session based on the Frame App version
    cache_path="$FRAME_CACHE_PATH"
    if [ "$FRAME_APP_PATH" = "/custom/frame/usr/bin/nutanix-frame/Frame" ]; then
        cache_path="$LEGACY_FRAME_CACHE_PATH"
    fi
    rm -Rf "$cache_path"

    # Run Frame App in kiosk mode, auto-arrange displays if more than one monitor attached, using FRAME_LAUNCH_URL with Secure Anonymous Token
    if [ -n "$LEGACY_FRAMEAPP" ]; then
        "$FRAME_APP_PATH" "$FRAME_APP_CLI_SEPARATOR" --kiosk --displays-auto-arrange --url="$FRAME_LAUNCH_URL#token=$token" &
    else
        "$FRAME_APP_PATH" --kiosk --displays-auto-arrange --url="$FRAME_LAUNCH_URL#token=$token" &
    fi
}

# Wait for a Session ID and monitor a session's status and handle continued UX after a session has closed.
monitorSession() {
    pollSessionId
    logMessage "Done polling session id. $FRAME_SESSION_ID"

    if [ -z ${FRAME_SESSION_ID+X} ]; then
        logMessage "Session ID not found..."
    else
        pollSessionStatus
    fi
}

### Begin!

logMessage "Process started."

# Obtain Secure Anonymous Token
getToken

# Confirm that token is obtained succefully
if [ -z "$token" ]; then
    logMessage "Unable to obtain anonymous token. Exiting"

    # Graceful wait before exiting; IGEL OS will restart this
    # script immediately; this timeout is a small buffer between
    # token requests.
    sleep 5
    exit 1
else
    # Launch Frame App with our new token
    launchFrame

    # Give some time for the UI to load...
    sleep 2

    # Monitor session for token and handle re-launching.
    monitorSession
fi
