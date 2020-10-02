# Work from Home: Add all network printers


|  CP Information | **NOTE:** This is not a CP. It is a profile with an embedded script.            |
|--------------------|------------|
| Package | wfh-add-network-printers 1.03 |
| Script Name | /bin/igel_create_network_printers.sh |
| IGEL OS Version (min) | 11.3.110 |
| Notes | Sample proof of concept to dynamically add network printers found after reboot to be “wifiprinter\<number\>” <br /><br /> Limited error checking – Just to show the art of the possible… <br /><br /> Profile (requires a reboot once profile is applied) that will find all network printers (/usr/lib/cups/backend/snmp) and configure them with CUPS IPP driver.<br /><br /> See -- https://www.cups.org/doc/admin.html#MODELS |
| [Add-Network-Printer-IPP-profile.xml](Add-Network-Printer-IPP-profile.xml) | Version 1 uses the full path from snmp |
| [Add-Network-Printer-IPP-profile-v2.xml](Add-Network-Printer-IPP-profile-v2.xml) | Version 2 uses just the printer name / ip address and appends ipp/print |
| [Add-Network-Printer-IPP-profile-v2-Citrix.xml](Add-Network-Printer-IPP-profile-v2-Citrix.xml) | Version 2 Citrix adds to Version 2 (above) the printers to Citrix wfclient.ini (ClientPrinterList) as noted [here](https://docs.citrix.com/en-us/citrix-workspace-app-for-linux/configure-xenapp.html). |

Here is output from /usr/lib/cups/backend/snmp for my network printer (Brother MFC-L2750DW)

 ```{snmp}
/usr/lib/cups/backend/snmp
  ```

network lpd://BRWB068E696FC10/BINARY_P1 "Brother MFC-L2750DW series" "Brother MFC-L2750DW series" "MFG:Brother;CMD:PJL,PCL,PCLXL,URF;MDL:MFC-L2750DW series;CLS:PRINTER;CID:Brother Laser Type1;URF:W8,CP1,IS4-1,MT1-3-4-5-8,OB10,PQ3-4-5,RS300-600-1200,V1.4,DM1;" “"

Command to add above printer:

```{lpadmin}
lpadmin -p wifiprinter1 -E -v ipp://BRWB068E696FC10/BINARY_P1 -m everywhere && lpoptions -d wifiprinter1
  ```

or (v2)

```{lpadmin v2}
lpadmin -p wifiprinter1 -E -v ipp://BRWB068E696FC10/ipp/print -m everywhere && lpoptions -d wifiprinter1
  ```

***
**Debugging CUPS IPP**  

The following command, ipptool, can be used to query printer attributes.

```{ipptool}
ipptool -tv ipp://BRWB068E696FC10/ipp/print get-printer-attributes.test | head -10
  ```
Output from ipptool:  

```{ipptool output}
"/usr/share/cups/ipptool/get-printer-attributes.test":
    Get-Printer-Attributes:
        attributes-charset (charset) = utf-8
        attributes-natural-language (naturalLanguage) = en
        printer-uri (uri) = ipp://BRWB068E696FC10:631/ipp/print
    Get printer attributes using Get-Printer-Attributes                  [PASS]
        RECEIVED: 8650 bytes in response
        status-code = successful-ok (successful-ok)
  ```
***
Printing with CUPS and IPP (Internet Printing Protocol) allows for finding and printing to networked and USB printers without using vendor specific software.

https://www.pwg.org/ipp/everywhere.html

CUPS has printing APIs to allow applications to easily provide options via IPP. Most printers sold since 2010 support IPP printing with standard file formats and can be used without printer drivers or PPD files.

https://www.cups.org/blog/2018-06-06-demystifying-cups-development.html

***
**Citrix Notes**

https://docs.citrix.com/en-us/citrix-virtual-apps-desktops/printing.html

https://docs.citrix.com/en-us/citrix-virtual-apps-desktops/printing/printing-configuration-example.html

https://docs.citrix.com/en-us/citrix-workspace-app-for-linux/configure-xenapp.html

Use of the Citrix Universal printer driver ensures that all printers connected to a client can also be used from a virtual desktop or application session without integrating a new printer driver in the data center.

**Auto-created client printers and Citrix Universal printer driver**

For home offices where users work on non-standard workstations and use non-managed print devices, the simplest approach is to use auto-created client printers and the Universal printer driver.

**Deployment summary**

In summary, the sample deployment is configured as follows:

* No printer drivers are installed on Multi-session OS machines. Only the Citrix Universal printer driver is used. Fallback to native printing and the automatic installation of printer drivers are disabled.

**Auto-create client printers**

This setting specifies the client printers that are auto-created. This setting overrides default client printer auto-creation settings.

By default, all client printers are auto-created.

This setting takes effect only if the Client printer redirection setting is present and set to Allowed.

When adding this setting to a policy, select an option:

* Auto-create all client printers automatically creates all printers on a user device.
* Auto-create the client’s default printer only automatically creates only the printer selected as the default printer on the user device.

***
IGEL Profile: System > Firmware Customization > Custom Commands > Network > Final network command
![alt text](wfhanp01.png "IGEL Profile")

CUPS Web Interface (IGEL OS): Printers
![alt text](wfhanp02.png "CUPS Printers")

CUPS Web Interface (IGEL OS): wifiprinter1
![alt text](wfhanp03.png "wifiprinter1")
