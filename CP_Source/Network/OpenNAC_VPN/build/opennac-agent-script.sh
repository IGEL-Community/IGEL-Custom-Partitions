#!/bin/bash
FILENAME_PARTS_DELIMITER=-
INSTALLATION_PACKAGE_NAME_FILE_PATH=/tmp/agentInstallationPackageFileName
ERROR_FILENAME="The file does not contain the correct name format, it must be downloaded and executed without changing the name offered by the opennac portal."

if [ -z "$0" ]; then
	echo $ERROR_FILENAME
	exit 1
fi
filename=$(basename $0)
echo "File name is "$filename""
countParts=$(($(echo "$filename" | grep -o "$FILENAME_PARTS_DELIMITER" | wc -l)+1))

if [ $countParts -ge 7 ]; then
	serverAddress=$(echo $filename | cut -d - -f7 | rev | cut -c 1- | rev | xxd -r -p)
	echo "Server is "$serverAddress""
else
	echo $ERROR_FILENAME
	exit 1
fi

#Install Osquery
export OSQUERY_KEY=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $OSQUERY_KEY
sudo add-apt-repository 'deb [arch=amd64] https://pkg.osquery.io/deb deb main'
sudo apt-get update
sudo apt-get -y install osquery=4.3.0-1.linux

configurationBitsHexa=$(echo $filename | cut -d $FILENAME_PARTS_DELIMITER -f6)
configurationBitsHexaLSB=$(echo $configurationBitsHexa | cut -c2)
configurationBitsHexaMSB=$(echo $configurationBitsHexa | cut -c1)
#If set to false, then taskbar only will be opened after installation of the package if autostart bit is set to 1.
#Now we configure ip from filename via taskbar so need to check if we really want to not open taskbar after installation.
openTaskbar=true
installOpenvpn=true
installWireguard=true
if [ "$configurationBitsHexaMSB$configurationBitsHexaLSB" != "$filename" ]
then
    configurationBitsLSB=$(echo "obase=2;$configurationBitsHexaLSB" | BC_LINE_LENGTH=9999 bc | awk '{ printf "%04d\n", $0 }' )

	autostart=$(echo $configurationBitsLSB | cut -c4)
	echo "autostart bit is " $autostart
	openvpn=$(echo $configurationBitsLSB | cut -c3)
	echo "openvpn bit is " $openvpn

	configurationBitsMSB=$(echo "scale=8;obase=2;$configurationBitsHexaMSB" | BC_LINE_LENGTH=9999 bc | awk '{ printf "%04d\n", $0 }' )

	wireguard=$(echo $configurationBitsMSB | cut -c3)
	echo "wireguard bit is " $wireguard

    if [ $autostart -eq 0 ]
    then
        openTaskbar=false
    else
        openTaskbar=true
    fi

    if [ $openvpn -eq 0 ]
    then
        installOpenvpn=false
    fi

    if [ $wireguard -eq 0 ]
    then
        installWireguard=false
    fi
fi

if [ "$installOpenvpn" = true ]
then
    #Install OpenVpn
	echo "Installing OpenVPN..."
	sudo apt -y install openvpn
fi

if [ "$installWireguard" = true ]
then
    #Install WireGuard
	echo "Installing WireGuard..."
	sudo add-apt-repository ppa:wireguard/wireguard
	sudo apt -y install wireguard
fi

#Install linux OpenNAC Agent
wget --content-disposition $serverAddress/agent/download?type=linux --no-check-certificate --user-agent="Mozilla/5.0"
agentPackageFileName=$(ls *.deb -rt | grep opennac-agent | tail -n 1)
echo $agentPackageFileName > $INSTALLATION_PACKAGE_NAME_FILE_PATH
sudo dpkg -i $agentPackageFileName
. /home/$(whoami)/.bashrc
if [ "$openTaskbar" = true ]
then
	gtk-launch opennacagent &> /dev/null ; disown -a
fi