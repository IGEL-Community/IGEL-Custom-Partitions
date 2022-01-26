#!/bin/bash
#set -x
#trap read debug

#Tanium Client - Needs to be root to run

CLIENTDIR="/opt/Tanium/TaniumClient"
PUBKEY="/opt/Tanium/TaniumClient/tanium.pub"
INITFILE="/opt/Tanium/TaniumClient/tanium-init.dat"

$CLIENTDIR/TaniumClient config set Version $(customparam get TANIUM_VERSION)
$CLIENTDIR/TaniumClient config set ServerName $(customparam get TANIUM_SERVERNAME)
$CLIENTDIR/TaniumClient config set ServerPort $(customparam get TANIUM_SERVERPORT)
$CLIENTDIR/TaniumClient config set LogVerbosityLevel $(customparam get TANIUM_LOGVERBOSITYLEVEL)

systemctl enable /custom/tanium/lib/systemd/system/taniumclient.service
systemctl start taniumclient.service
