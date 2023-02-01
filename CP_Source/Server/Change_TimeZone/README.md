# Chane TimeZone

|  CP Information | **NOTE:** This is not a CP. It is a profile with an embedded command.            |
|--------------------|------------|
| Package | change timezone 1.01 |
| IGEL OS Version (min) | 11.07.100 |
| Notes | Profile deploys a script that will allow the user to change the TimeZone that their device is currently in. |

-----
```bash
#!/bin/bash
#set -x
#trap read debug
#Allows a user to change the timezone of their device

#every other item on list is skipped. The sed command will add a line between each
NEW_TZ=$(timedatectl list-timezones | sed 's/^/FALSE \n/'| zenity --width=400 --height=400 --list --checklist --title="TimeZones" --column="Select One" --column="TimeZones" | cut -f 1 -d '|')

echo "TimeZone:" $NEW_TZ

if [ "$NEW_TZ" = "" ]; then
  echo "No TZ entered"
else
  pkexec --user root timedatectl set-timezone $NEW_TZ
fi
  ```
