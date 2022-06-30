#!/bin/bash

# This script implements a specific end user experience workflow and assumes a particular Frame configuration.
#
# The following end user experience workflow is supported with this script:
#
#   1. End users do not need to authenticate to a SAML2-based identity provider (using the Frame Secure Anonymous Token (SAT) mechanism).
#   2. User cache is removed prior to start of Frame App to ensure no user preference settings have persisted since the prior use of Frame App.
#   3. Frame App will launch in "kiosk mode".
#   4. End users will be taken by Frame App straight to the desktop or application.
#   5. When a Frame session starts, the remote desktop will be in full-screen mode.
#   6. When end users disconnect or closes session, end users are returned to the Launchpad designated by the Frame Customer Administrator (SAT Permission).
#
# Frame configuration assumptions:
#
#   1. API Provider at the Organization entity
#   2. Secure Anonymous Provider at the Organization entity granting a role of Launchpad user for a specific Launchpad in a Frame account (under the Organization entity).
#
# Updated June 29, 2022

# Check if all the required envs are set correctly
if [ -z "${FRAME_CLIENT_ID}" ] || [ -z "${FRAME_CLIENT_SECRET}" ] || [ -z "${FRAME_ANONYMOUS_PROVIDER_NAME}" ] || [ -z "${FRAME_ORGANIZATION_ID}" ] || [ -z "${FRAME_EMAIL_DOMAIN}" ]; then
    echo "Nutanix Frame: Please fill FRAME_CLIENT_ID, FRAME_CLIENT_SECRET, FRAME_EMAIL_DOMAIN, FRAME_ORGANIZATION_ID and FRAME_ANONYMOUS_PROVIDER_NAME environment variables"
    exit 1
else

    case $FRAME_ENV in

    production | "")
        echo "Nutanix Frame: Configured environment is: production"
        cpanel_api="https://cpanel-backend-prod.frame.nutanix.com/api/graphql"
        cpanel_gateway_api="https://api.console.nutanix.com/v1/organizations/${FRAME_ORGANIZATION_ID}/secure-anonymous/${FRAME_ANONYMOUS_PROVIDER_NAME}/tokens"
        frame_url="https://console.nutanix.com"
        ;;

    staging)
        echo "Nutanix Frame: Configured environment is: staging"
        cpanel_api="https://cpanel-backend-staging.staging.frame.nutanix.com/api/graphql"
        cpanel_gateway_api="https://api.staging.frame.nutanix.com/v1/organizations/${FRAME_ORGANIZATION_ID}/secure-anonymous/${FRAME_ANONYMOUS_PROVIDER_NAME}/tokens"
        frame_url="https://frame.staging.nutanix.com"
        ;;

    *)
        echo "Nutanix Frame: FRAME_ENV variable doesn't match any of the known environments: $FRAME_ENV"
        exit 1
        ;;
    esac
fi

getToken() {

    # Create signature
    timestamp=$(date +%s)
    to_sign="$timestamp$FRAME_CLIENT_ID"
    signature=$(echo -n "$to_sign" |
        openssl dgst -sha256 -hmac "$FRAME_CLIENT_SECRET" |
        sed 's/^.* //')

    # Create an email address for anonymous user from baseboard serial number and env:FRAME_EMAIL_DOMAIN - e.g. ITC00152278@nutanix.com. Value must be in an email format.
    # Specific pattern defined by the customer for use in activity reports and custom Frame Guest Agent pre-session scripts.
    serial=$(dmidecode -s baseboard-serial-number)
    email="ITC${serial}@${FRAME_EMAIL_DOMAIN}"

    # Include optional parameter values such as first_name, last_name, email_domain, email or metadata which will be shown in Frame Dashboard and User Activity and Session Trail reports.
    # Refer to https://docs.frame.nutanix.com/frame-apis/sat-api.html#anonymous-token-parameters for details.
    local request_body='{
        "metadata": {
            "should_accept_tos": false
        },
        "email": "'$email'"
    }'

    # Make request
    result="$(wget -q -S -O - $cpanel_gateway_api \
        --post-data "$request_body" \
        --header="X-Frame-ClientId:$FRAME_CLIENT_ID" \
        --header="X-Frame-Timestamp:$timestamp" \
        --header="X-Frame-Signature:$signature" \
        --header="Content-Type: application/json")"

    # Remove "" from token
    token=$(echo "$result" | tr -d '"')
}
setAutoLaunch() {
    # Enable auto-launch desktop
    local request_body='{
    "operationName": "SetUserPreferencesMutation",
    "variables": {
        "desktopAutoLaunch": true,
        "enableQuickLaunch": false,
        "__typename": "UserPreferences"
        },
    "query": "mutation SetUserPreferencesMutation($desktopAutoLaunch: Boolean!, $enableQuickLaunch: Boolean!) { setUserPreferences(desktopAutoLaunch: $desktopAutoLaunch, enableQuickLaunch: $enableQuickLaunch) { id } }"
    }'
    result="$(wget -q -O - $cpanel_api \
        --post-data "$request_body" \
        --header="Authorization: Bearer $token" \
        --header="Content-Type: application/json")"

}
runFrame() {
    # Clear cache from the previous use of Frame App
    rm -Rf /custom/frame/userhome/.Nutanix/Frame/cache

    # Run Frame App in kiosk mode (--kiosk), full screen when in a Frame session (--displays-auto-arrange), and start at the specified URL (--url) with a Secure Anonymous Token.
    /custom/frame/usr/bin/nutanix-frame/Frame --kiosk --displays-auto-arrange --url="$frame_url/#token=$token"
}

# Obtain Secure Anonymous Token from Frame Control Plane
getToken

# Confirm that token is obtained succefully
if [ -z "$token" ]; then
    echo "Nutanix Frame: Unable to obtain anonymous token. Exiting"
    exit 1

else
    # Once we get the token, set autolaunch, start up Frame App, and enter the session.
    setAutoLaunch
    runFrame
fi
