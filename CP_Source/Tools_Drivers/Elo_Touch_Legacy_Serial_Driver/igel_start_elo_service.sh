#!/bin/bash

#
# Enable systemd for Elo Touch service
#
# TTY defined in IGEL Profile (XML)
#
# <instance classprefix="custom_partition.parameter%" serialnumber="-255b77b0:17b0a250ec2:-7ff7127.0.1.1">
#     <ivalue classname="custom_partition.parameter%.value" variableExpression="" variableSubstitutionActive="false">ttyS9</ivalue>
#     <ivalue classname="custom_partition.parameter%.name" variableExpression="" variableSubstitutionActive="false">TTY</ivalue>
# </instance>
#

cat /etc/opt/elo-ser/loadEloSerial.sh.orig | sed "s|ttyS0|$(customparam get TTY)|" > /etc/opt/elo-ser/loadEloSerial.sh
cp /etc/opt/elo-ser/eloser.service /etc/systemd/system/
systemctl enable eloser.service
systemctl start eloser.service
