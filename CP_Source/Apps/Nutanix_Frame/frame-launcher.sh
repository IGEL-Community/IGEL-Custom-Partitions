#!/bin/bash

# Check if all the required envs are set correctly
if [ -z "${FRAME_CLIENT_ID}" ] || [ -z "${FRAME_CLIENT_SECRET}" ] || [ -z "${FRAME_ANONYMOUS_PROVIDER_NAME}" ] || [ -z "${FRAME_ORGANIZATION_ID}" ] || [ -z "${FRAME_EMAIL_DOMAIN}" ]; then
    echo "Nutanix XI Frame: Please fill FRAME_CLIENT_ID, FRAME_CLIENT_SECRET, FRAME_EMAIL_DOMAIN, FRAME_ORGANIZATION_ID and FRAME_ANONYMOUS_PROVIDER_NAME environment variables"
    exit 1
else

    case $FRAME_ENV in

    production | "")
        echo "Nutanix XI Frame: Configured environment is: production"
        cpanel_api="https://cpanel-backend-prod.frame.nutanix.com/api/graphql"
        cpanel_gateway_api="https://api.console.nutanix.com/v1/organizations/${FRAME_ORGANIZATION_ID}/secure-anonymous/${FRAME_ANONYMOUS_PROVIDER_NAME}/tokens"
        frame_url="https://console.nutanix.com"
        ;;

    staging)
        echo "Nutanix XI Frame: Configured environment is: staging"
        cpanel_api="https://cpanel-backend-staging.staging.frame.nutanix.com/api/graphql"
        cpanel_gateway_api="https://api.staging.frame.nutanix.com/v1/organizations/${FRAME_ORGANIZATION_ID}/secure-anonymous/${FRAME_ANONYMOUS_PROVIDER_NAME}/tokens"
        frame_url="https://frame.staging.nutanix.com"
        ;;

    *)
        echo "Nutanix XI Frame: FRAME_ENV variable doesn't match any of the known environments: $FRAME_ENV"
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

    # Crete email address for anonymous user from baseboard serial number and env:FRAME_EMAIL_DOMAIN - e.g. ITC00152278@nutanix.com
    serial=$(dmidecode -s baseboard-serial-number)
    email="ITC${serial}@${FRAME_EMAIL_DOMAIN}"

    # Include optional params such as first_name, last_name, email_domain, email or metadata
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
        "terminalShortcuts": false,
        "enableQuickLaunch": false,
        "__typename": "UserPreferences"
        },
    "query": "mutation SetUserPreferencesMutation($desktopAutoLaunch: Boolean!, $terminalShortcuts: Boolean!, $enableQuickLaunch: Boolean!) { setUserPreferences(desktopAutoLaunch: $desktopAutoLaunch, terminalShortcuts: $terminalShortcuts, enableQuickLaunch: $enableQuickLaunch) { id } }"
    }'
    result="$(wget -q -O - $cpanel_api \
        --post-data "$request_body" \
        --header="Authorization: Bearer $token" \
        --header="Content-Type: application/json")"

}
runFrame() {
    # Clear cache from previous session
    rm -Rf .Nutanix/Frame/cache/

    # Run Frame terminal
    /custom/frame/usr/lib/frame/Frame --kiosk --force-gpu --url="$frame_url/#token=$token"
}

# Obtain anonymous token
getToken

# Confirm that token is obtained succefully
if [ -z "$token" ]; then
    echo "Nutanix XI Frame: Unable to obtain anonymous token. Exiting"
    exit 1

else
    # Once we get the token we'll try to set autolaunch and enter the session
    setAutoLaunch
    runFrame
fi
