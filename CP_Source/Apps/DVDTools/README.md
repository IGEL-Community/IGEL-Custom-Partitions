# DVDTools (DRAFT Testing of Package)

|  CP Information |            |
|--------------------|------------|
| Package | [DVDTools ](https://help.ubuntu.com/community/CdDvd/Burning) <br /><br /> See section: **Command Line (Terminal)**
| Script Name | [dvdtools-cp-init-script.sh](dvdtools-cp-init-script.sh) |
| CP Mount Path | /custom/dvdtools |
| CP Size | 600M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> dvdtools.inf | [INFO] <br /> [PART] <br /> file="dvdtools.tar.bz2" <br /> version="1.0" <br /> size="600M" <br /> name="dvdtools" <br /> minfw="11.04.240" |
| Path to Executable | N/A |
| Path to Icon | N/A |
| Download package and missing libraries | apt-get download wodim <br /> apt-get download dvd+rw-tools <br /> apt-get download genisoimage <br /> apt-get download growisofs |
| Packaging Notes | Create folder: **dvdtools** <br /><br /> dpkg -x <package/lib> custom/dvdtools |
| Package automation | [build-dvdtools-cp.sh](build-dvdtools-cp.sh) |

**Determine device name (typical name: /dev/sr0)**

```{lshw -C disk}
lshw -C disk
   ```
