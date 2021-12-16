#!/bin/bash
#set -x
#trap read debug

randHex() {
	local numBytes="$1"; shift

	{ cat /dev/urandom | LC_ALL=C tr -d -c '[:digit:]abcdef' | head "-c$(($numBytes * 2))"; } 2>/dev/null
}

addGeneratedSessionIdIfNecessary() {
	local clientLaunchParameters="$1"; shift

	if ! echo "$clientLaunchParameters" | grep s=; then
		clientLaunchParameters="${clientLaunchParameters}&s=$(randHex 4)-$(randHex 2)-$(randHex 2)-$(randHex 2)-$(randHex 6)"
	fi

	echo "$clientLaunchParameters"
}

mergeClientLaunchParameters() {
	local oldClientLaunchParameters="$1"; shift
	local newClientLaunchParameters="$1"; shift

	newClientLaunchParameters="$(echo "$newClientLaunchParameters" | sed 's/?//g')"

	IFS='&'

	for keyValuePair in $newClientLaunchParameters; do
		key="$(echo "$keyValuePair" | grep -o '[^=]*=')"
		oldClientLaunchParameters="$(echo "$oldClientLaunchParameters" | sed "s/${key}[^&]*//g")"
	done

	for keyValuePair in $newClientLaunchParameters; do
		oldClientLaunchParameters="${oldClientLaunchParameters}&$keyValuePair"
	done

	unset IFS

	echo "$oldClientLaunchParameters" | sed 's/\&\&*/\&/g' | sed 's/^\&//' | sed 's/?\&/?/'
}

# Creating an IGELOS CP for ConnectWise Control Client
## Development machine (Ubuntu 18.04)
sudo apt install unzip -y

# Obtain latest package and save into Downloads
# Download App for Linux (Debian)
# https://docs.connectwise.com/ConnectWise_Control_Documentation/Get_started/Host_page/Build_an_access_agent_installer
# ConnectWiseControl.ClientSetup.deb
if ! compgen -G "$HOME/Downloads/ConnectWiseControl.ClientSetup.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest agent, save into $HOME/Downloads and re-run this script "
  echo "https://docs.connectwise.com/ConnectWise_Control_Documentation/Get_started/Host_page/Build_an_access_agent_installer"
  exit 1
fi

mkdir build_tar
cd build_tar

mkdir -p custom/cwc_client

dpkg -x $HOME/Downloads/ConnectWiseControl.ClientSetup.deb custom/cwc_client

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/ConnectWise_Control_Client.zip

unzip ConnectWise_Control_Client.zip -d custom
mv custom/target/build/cwc_client-cp-init-script.sh custom

cd custom

# edit inf file for version number
# create ClientLaunchParameters.txt
mkdir getversion
cd getversion
ar -x $HOME/Downloads/ConnectWiseControl.ClientSetup.deb
#tar xf control.tar.* ./control
tar xf control.tar.* control postinst
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
clientLaunchParametersFilePath=cwc_client$(grep "^clientLaunchParametersFilePath" postinst | cut -d "'" -f 2)
newClientLaunchParameters=$(grep "^newClientLaunchParameters" postinst | cut -d "'" -f 2)
clientLaunchParameters="$(addGeneratedSessionIdIfNecessary "$newClientLaunchParameters")"
clientLaunchParameters="$(mergeClientLaunchParameters "$clientLaunchParameters" 'e=Access')"
cd ..
echo "$clientLaunchParameters" > "$clientLaunchParametersFilePath"
sed -i "/^version=/c version=\"${VERSION}\"" target/cwc_client.inf
#echo "cwc_client.inf file is:"
#cat target/cwc_client.inf

# new build process into zip file
tar cvjf target/cwc_client.tar.bz2 cwc_client cwc_client-cp-init-script.sh
zip -g ../ConnectWise_Control_Client.zip target/cwc_client.tar.bz2 target/cwc_client.inf
zip -d ../ConnectWise_Control_Client.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../ConnectWise_Control_Client.zip ../../ConnectWise_Control_Client-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
