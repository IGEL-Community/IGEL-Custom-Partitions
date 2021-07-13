# Enable WI-FI on newer MacBook Pro (13 July)

|  CP Information |            |
|------------------|------------|
| Package | macbookwifi 1.04 <br /><br /> Some addtional notes on getting WI-FI working on MacBooks <br /><br /> (https://wiki.t2linux.org/guides/wifi/#is-my-model-supported) <br /><br /> (https://github.com/AdityaGarg8/mbp-16.1-wifi-firmware)|
| Script Name | [macbookwifi-cp-init-script.sh](macbookwifi-cp-init-script.sh) |
| CP Mount Path | /custom/macbookwifi |
| CP Size | 10M |
| IGEL OS Version (min) | 11.05.133 |
| Metadata File <br /> macbookwifi.inf | [INFO] <br /> [PART] <br /> file="macbookwifi_igel.tar.bz2" <br /> version="1.04" <br /> size="10M" <br /> minfw="11.05.133" |
| Path to Executable | N/A |
| Path to Icon | N/A |
| Missing Libraries | N/A |
| Packaging Notes | This CP activates the iNet Wireless Daemon (IWD) in place of wpa_supplicant. <br /> <br /> To use IWD: <br /> <br /> 1.	Assign the attached profile to a device and let the settings take effect. <br /> 2.	Reboot the device |
| Determine correct tar.bz2 to use | The following MacBooks have already created tar.bz2 files: <br /><br /> MacBookPro15,2 (maui) <br /><br /> MacBookPro16,1 (bali) |
| Determine wifi firmware for MacBook | Note: Command to collect files from MacBook <br /> <br /> ioreg \-l \| grep "RequestedFile" |
| Determine MacBook product name | ioreg \-l \| grep product-name |
| MacBookPro15,2 - Output | ioreg \-l \| grep "RequestedFile" <br /><br /> Output from MacBook <br /><br /> "RequestedFiles" = ({"Firmware"="C-4364__s-B2/maui.trx","TxCap"="C-4364__s-B2/maui-X0.txcb","Regulatory"="C-4364__s-B2/maui-X0.clmb","NVRAM"="C-4364__s-B2/P-maui-X0_M-HRPN_V-u__m-7.5.txt"}) <br /><br /> Files located here: /usr/share/firmware/wifi <br /><br /> ioreg \-l \| grep product-name <br /><br /> Output from MacBook <br /><br /> "product-name" = <"MacBookPro15,2"> |
| MacBookPro15,2 - Location to get firmware files | The files can be pulled from the following site: <br /><br /> wget https://packages.aunali1.com/apple/wifi-fw/18G2022/C-4364__s-B2/maui.trx <br /> wget https://packages.aunali1.com/apple/wifi-fw/18G2022/C-4364__s-B2/maui-X0.txcb <br /> wget https://packages.aunali1.com/apple/wifi-fw/18G2022/C-4364__s-B2/maui-X0.clmb <br /> wget https://packages.aunali1.com/apple/wifi-fw/18G2022/C-4364__s-B2/P-maui-X0_M-HRPN_V-u__m-7.5.txt
| MacBookPro15,2 - Firmware file mapping | maui.trx /lib/firmware/brcm/brcmfmac4364-pcie.bin <br /> maui-X0.clmb /lib/firmware/brcm/brcmfmac4364-pcie.clm_blob <br /> P-maui-X0_M-HRPN_V-u__m-7.5.txt /lib/firmware/brcm/brcmfmac4364-pcie.Apple\ Inc.-MacBookPro15,2.txt <br /> maui-X0.txcb /lib/firmware/brcm/brcmfmac4364-pcie.txt |
| MacBookPro16,1 - Output | ioreg \-l \| grep "RequestedFile" <br /><br /> Output from MacBook <br /><br /> “RequestedFiles” = ({“Firmware”=“C-4364__s-B3/bali.trx”,“TxCap”=“C-4364__s-B3/bali-X0.txcb”,“Regulatory”=“C-4364__s-B3/bali-X0.clmb”,“NVRAM”=“C-4364__s-B3/P-bali-X0_M-HRPN_V-m__m-7.9.txt”}) <br /><br /> Files located here: /usr/share/firmware/wifi <br /><br /> ioreg \-l \| grep product-name <br /><br /> Output from MacBook <br /><br /> "product-name" = <"MacBookPro16,1"> |
| MacBookPro16,1 - Location to get firmware files | The files can be pulled from the following site: <br /><br /> https://github.com/AdityaGarg8/mbp-16.1-wifi-firmware |
| MacBookPro15,2 - Firmware file mapping | bali.trx /lib/firmware/brcm/brcmfmac4364-pcie.bin <br /> bali-X0.clmb /lib/firmware/brcm/brcmfmac4364-pcie.clm_blob <br /> P-bali-X0_M-HRPN_V-m__m-7.9.txt /lib/firmware/brcm/brcmfmac4364-pcie.Apple\ Inc.-MacBookPro16,1.txt <br /> bali-X0.txcb /lib/firmware/brcm/brcmfmac4364-pcie.txt |
