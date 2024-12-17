
# WireGuard (5 October)

|  CP Information | **NOTE:** This is not a CP. It is a profile with an embedded script.            |
|--------------------|------------|
| Package | [WireGuard VPN](https://www.wireguard.com/) <br /><br /> WireGuard VPN requires the exchange of public keys. This profile will copy the public key from the endpoint to UMS and store it in the **ums_structure_tag**. |

This profile creates the following files in the **/wfs/wireguard** folder:

- igel_wg_setup.sh (Main script)
- wg_clients.csv (Mapping for IGEL clients IPv4 or IPv6 to WireGuard defined addresses)
- wg0.conf (Template file)

and the following file:

- /bin/igel_wg_control.sh (Displays current state of WireGuard and allows user to change state on / off)

The **igel_wg_setup.sh** script will create the client's public / private keys, send the client's public key to the UMS (ums_structure_tag), update wg0.conf template file, copy these files to **/etc/wireguard**, and start WireGuard.

**NOTE:** Two reboots are needed after this profile is assigned.

-----

## Profile Environment Variables > Predefined

This profile has the following environment variables and is based on the following document: [Automate WireGuard installation on Linux with Bash Script](https://techviewleo.com/automate-wireguard-installation-on-linux/)

- WG_PUBLIC_ADDRESS <- WG server IP or DNS
- WG_PORT <- WG server port
- WG_PUBLIC_KEY <- WG server public key
- WG_PRESHARE_KEY <- Client preshared key configured in WG server
- WG_ALLOWED_IPS <- Allowed IPv4+IPv6 range for client access (predefined to allow all IPv4+IPv6)

Update the values for these environment variables based on the settings in your WireGuard server.

-----

## UMS Structure Tag holds WireGuard client public key

```bash linenums="1"
setparam system.remotemanager.ums_structure_tag CLIENT_PUBLIC_KEY
write_rmsettings
get system.remotemanager.ums_structure_tag
```

In the UMS, a view can be created to show the mapping of client machines to their WireGuard public key. This view can be exported to a file and added to the WireGuard server.

UMS View
![alt text](images/umsview.png "UMS View")

```bash linenums="1"
Name: WireGuard
Description: Wireguard
Rule: Structure tag is like (?i).*.*=
Query: umsStructuralTag ~ '(?i).*.*='
```

-----

## Mapping of IGEL clients to WireGuard defined addresses

**NOTE:** This is mandatory! IPv4 or IPv6 has to be the one configured o your WireGuard server.

Edit the profile (**System > Firmware Customization > Custom Commands > Network > Final Network Command**) to contain the mapping of clients (name of client) to WireGuard IPs. IPv4 or IPv6 can be used, insert IPv6 instead of predefined IPv4.

```bash linenums="1"
cat << 'EOF' > /wfs/wireguard/wg_clients.csv
ITC6845F1391E31,10.66.66.4/32
ITC0800270F8F75,10.66.66.5/32
ITC000C29A1EAF6,10.66.66.6/32
ITC000C29E8B942,10.66.66.7/32
EOF
```

-----

## Resolvconf not found

If using specific DNS servers, then enable `resolved.service` and `/usr/bin/resolvconf`.

```bash linenums="1"
systemctl enable systemd-resolved.service && ln -s /usr/bin/resolvectl /usr/bin/resolvconf
```

-----

## WireGuard vs. Tailscale

[Tailscale](https://github.com/IGEL-Community/IGEL-Custom-Partitions/tree/master/CP_Source/Network/Tailscale_VPN) is built on top of WireGuard and acts as a holder of public keys, network ports, and private IP addresses.

[Tailscale post on WireGuard](https://tailscale.com/compare/wireguard/)

-----

## WireGuard code in Profile (Sample)

- Added additional check to determine whether the client is on the internal network. If it is, nothing happens; if not, WireGuard is automatically started.

```bash linenums="1"
timeout 3 bash -c "</dev/tcp/172.29.30.240/8443" > /dev/null 2>&1
```

- Current code to add to profile:

```bash linenums="1"
mkdir -p /wfs/wireguard; chmod 700 /wfs/wireguard; cat << 'EOF' > /wfs/wireguard/igel_wg_setup.sh
ACTION="wireguard_setup_${1}"
WFS_WG=/wfs/wireguard
ETC_WG=/etc/wireguard

if [ ! -e ${WFS_WG}/privatekey ]; then
  wg genkey | tee ${WFS_WG}/privatekey | wg pubkey | tee ${WFS_WG}/publickey
  WG_PUBKEY=$(cat ${WFS_WG}/publickey)
  setparam system.remotemanager.ums_structure_tag ${WG_PUBKEY}
  write_rmsettings
fi

cp ${WFS_WG}/privatekey ${ETC_WG}/privatekey
cp ${WFS_WG}/publickey ${ETC_WG}/publickey
cp ${WFS_WG}/wg0.conf ${ETC_WG}/wg0.conf

HOSTNAME=$(hostname)
HOST_PRIVATEKEY=$(cat ${ETC_WG}/privatekey)

sed -i "s|CLIENT_PRIVATE_KEY|${HOST_PRIVATEKEY}|" ${ETC_WG}/wg0.conf
sed -i "s|WG_PUBLIC_KEY|${WG_PUBLIC_KEY}|" ${ETC_WG}/wg0.conf
sed -i "s|WG_PRESHARE_KEY|${WG_PRESHARE_KEY}|" ${ETC_WG}/wg0.conf
sed -i "s|WG_PUBLIC_ADDRESS|${WG_PUBLIC_ADDRESS}|" ${ETC_WG}/wg0.conf
sed -i "s|WG_PORT|${WG_PORT}|" ${ETC_WG}/wg0.conf
sed -i "s|WG_ALLOWED_IPS|${WG_ALLOWED_IPS}|" ${ETC_WG}/wg0.conf

cat ${WFS_WG}/wg_clients.csv| while read LINE
  do
    CURR_HOST=$(echo ${LINE} | awk --field-separator "," '{print $1}')
    if [ ${HOSTNAME} = ${CURR_HOST} ]; then
      CURR_HOST_ADDR=$(echo ${LINE} | awk --field-separator "," '{print $2}')
      sed -i "s|CURR_HOST_ADDR|${CURR_HOST_ADDR}|" ${ETC_WG}/wg0.conf
    fi
  done

chmod 400 /etc/wireguard/*
chmod 400 /wfs/wireguard/*
chmod 500 /wfs/wireguard/igel_wg_setup.sh
EOF

cat << 'EOF' > /wfs/wireguard/wg_clients.csv
ITC841B7795DB2F,10.0.0.2/32
EOF

cat << 'EOF' > /wfs/wireguard/wg0.conf
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY
Address = CURR_HOST_ADDR
[Peer]
PublicKey = WG_PUBLIC_KEY
PresharedKey = WG_PRESHARE_KEY
Endpoint = WG_PUBLIC_ADDRESS:WG_PORT
AllowedIPs = WG_ALLOWED_IPS
EOF

cat << 'EOF' > /bin/igel_wg_control.sh
#!/bin/bash
ACTION="WireGuard_Control"
LOGGER="logger -it ${ACTION}"

if [ -e /etc/wireguard/wg0.conf ]; then
  WG_UP=$(wg show | grep endpoint | wc -l)
else
  zenity --error --width=200 --height=100 --title="WireGuard VPN" --text="WireGuard VPN is NOT setup on this system."
  exit 1
fi

if [ $WG_UP -ge 1 ]; then
  # Verbindung ist aktiv -> Trennen anbieten
  zenity --question --width=200 --height=100 --title="WireGuard VPN ist aktiv!" --text="Verbindung trennen?" --ok-label="Nein" --cancel-label="Ja"
  RETURN_CODE=$?
  if [ $RETURN_CODE -eq 1 ]; then
    wg-quick down wg0
    zenity --info --width=200 --height=100 --title="WireGuard VPN" --text="WireGuard VPN wurde getrennt."
  fi
else
  zenity --question --width=200 --height=100 --title="WireGuard VPN ist deaktiviert!" --text="Verbindung aufbauen?" --ok-label="Nein" --cancel-label="Ja"
  RETURN_CODE=$?
  if [ $RETURN_CODE -eq 1 ]; then
    wg-quick up wg0
    zenity --info --width=200 --height=100 --title="WireGuard VPN" --text="WireGuard VPN ist jetzt aktiv."
  fi
fi
EOF

chmod 400 /wfs/wireguard/*
chmod 500 /wfs/wireguard/igel_wg_setup.sh
chmod a+x /bin/igel_wg_control.sh
/wfs/wireguard/igel_wg_setup.sh

timeout 3 bash -c "</dev/tcp/172.29.30.240/8443" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    exit 0
else
    if [ -e ${WG_CONF} ]; then
        wg-quick up wg0 > /dev/null 2>&1
    fi
fi
```

**NOTE:** Future items to be worked on include:

- Add notifications to confirm when the connection has been successfully established.
- Include a warning if the network isn’t connected, suggesting either a manual or automatic connection rebuild.
- Optimize the execution to ensure the script runs minimally – only once the setup has completed previously and then again only if changes are detected.
