# Enable WI-FI on newer MacBook Pro (28 June)

|  CP Information |            |
|--------------------|------------|
| Package | macbookwifi 1.03 |
| Script Name | [macbookwifi-cp-init-script.sh](macbookwifi-cp-init-script.sh) |
| CP Mount Path | /custom/macbookwifi |
| CP Size | 10M |
| IGEL OS Version (min) | 11.05.133 |
| Metadata File <br /> macbookwifi.inf | [INFO] <br /> [PART] <br /> file="macbookwifi_igel.tar.bz2" <br /> version="1.03" <br /> size="10M" <br /> minfw="11.05.133" |
| Path to Executable | N/A |
| Path to Icon | N/A |
| Missing Libraries | N/A |
| Packaging Notes | This CP activates the iNet Wireless Daemon (IWD) in place of wpa_supplicant. <br /> <br /> To use IWD: <br /> <br /> 1.	Assign the attached profile to a device and let the settings take effect. <br /> 2.	Reboot the device |
| Determine wifi firmware for MacBook | Note: Command to collect files from MacBook <br /> <br /> ioreg \-l \| grep "C-4364" \| grep "RequestedFile" <br /><br /> Output from MacBook <br /><br /> "RequestedFiles" = ({"Firmware"="C-4364__s-B2/maui.trx","TxCap"="C-4364__s-B2/maui-X0.txcb","Regulatory"="C-4364__s-B2/maui-X0.clmb","NVRAM"="C-4364__s-B2/P-maui-X0_M-HRPN_V-u__m-7.5.txt"}) <br /><br /> Files located here: /usr/share/firmware/wifi |
| Location to get firmware files | The files can be pulled from the following site: <br /><br /> wget https://packages.aunali1.com/apple/wifi-fw/18G2022/C-4364__s-B2/maui.trx <br /> wget https://packages.aunali1.com/apple/wifi-fw/18G2022/C-4364__s-B2/maui-X0.txcb <br /> wget https://packages.aunali1.com/apple/wifi-fw/18G2022/C-4364__s-B2/maui-X0.clmb <br /> wget https://packages.aunali1.com/apple/wifi-fw/18G2022/C-4364__s-B2/P-maui-X0_M-HRPN_V-u__m-7.5.txt
| Firmware file mapping | maui.trx /lib/firmware/brcm/brcmfmac4364-pcie.bin <br /> maui-X0.clmb /lib/firmware/brcm/brcmfmac4364-pcie.clm_blob <br /> P-maui-X0_M-HRPN_V-u__m-7.5.txt /lib/firmware/brcm/brcmfmac4364-pcie.Apple\ Inc.-MacBookPro15,2.txt <br /> maui-X0.txcb /lib/firmware/brcm/brcmfmac4364-pcie.txt |
