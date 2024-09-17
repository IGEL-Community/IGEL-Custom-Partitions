#!/bin/bash
set -x
trap read debug

SERVICE_APPLICATION_PATH=/usr/local/ZohoAssist/Service/ZohoAssistURS
ZOHO_UNATTENDED_PATH=/usr/local/ZohoAssist/Service/ZohoAssistUnattended
SERVICE_SCRIPT_PATH=/usr/local/ZohoAssist/Service/ZohoAssistUrs
SYSTEMD_SCRIPT_PATH=/usr/local/ZohoAssist/Service/ZohoAssistUrs.service
SCREEN_SHARING_APPLICATION=/usr/local/ZohoAssist/bin/main
ANNOTATION=/usr/local/ZohoAssist/bin/Annotation
UI=/usr/local/ZohoAssist/bin/ZohoAssist
TRAY_ICON=/usr/local/ZohoAssist/bin/TrayIcon
TOOLS=/usr/local/ZohoAssist/bin/zsysmanager
ACTIVEDISPLAY=/usr/local/ZohoAssist/bin/activeDisplay

BIN_PATH=/usr/bin

serviceType=$(ls -al /proc/1/exe | awk -F' ' '{print $NF}' | awk -F'/' '{print $NF}')


main()
{
 enableExecutablePrivilege
 configureComputer
}

CreateLogsDir()
{
	if ! [ -d "/var/log/ZohoAssist" ]; then
		mkdir /var/log/ZohoAssist
	fi
}

enableExecutablePrivilege()
{
chmod +x $ZOHO_UNATTENDED_PATH
chmod +x $SERVICE_APPLICATION_PATH
chmod +x $SCREEN_SHARING_APPLICATION
chmod +x $ANNOTATION
chmod +x $UI
chmod +x $SERVICE_SCRIPT_PATH
chmod +x $TRAY_ICON
chmod +x /usr/local/ZohoAssist/bin/zwin
chmod +x /usr/local/ZohoAssist/Upgrader/ZohoAssistUpgrader	
chmod +x $TOOLS
chmod +x $ACTIVEDISPLAY
}


configureComputer() 
{

  if [ ! -f /custom/zohoassist/usr/local/ZohoAssist/igel_installed.txt ]; then
    touch /custom/zohoassist/usr/local/ZohoAssist/igel_installed.txt
    $ZOHO_UNATTENDED_PATH -stype "${serviceType}" -cmd "install"
    echo "application configured"
  fi

  CreateLogsDir
  createSymLinks
  updateCron 
  updateService
  su $(logname) bash -c `TrayIcon -p urs` & echo ""
}

createSymLinks()
{
ln -s $TRAY_ICON $BIN_PATH
ln -s /usr/local/ZohoAssist/bin/ZohoAssist.desktop /etc/xdg/autostart
cp /usr/local/ZohoAssist/Upgrader/zohoassist /etc/cron.d
}

updateService()
{
	if [ "systemd" == "${serviceType}" ]; then
		echo "installing systemctl service"
		cp $SYSTEMD_SCRIPT_PATH /etc/systemd/system/
		systemctl enable ZohoAssistUrs.service
		systemctl daemon-reload
		systemctl start ZohoAssistUrs.service
	elif [ "init" == "${serviceType}" ]; then
		echo "installing systemV service"
		serviceType="initv"
		ln -s $SERVICE_APPLICATION_PATH $BIN_PATH
		ln -s $SERVICE_SCRIPT_PATH /etc/init.d/
		update-rc.d ZohoAssistUrs defaults
		update-rc.d ZohoAssistUrs enable
		setsid $SERVICE_APPLICATION_PATH >/dev/null 2>&1 < /dev/null &
	fi
}

updateCron()
{
	echo "reloading cron"
	service cron reload
	
	if (systemctl -q is-enabled crond.service)
	then
	systemctl restart crond.service
	else
	systemctl restart cron.service
	fi
}


main $*
