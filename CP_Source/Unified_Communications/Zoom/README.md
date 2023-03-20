# Zoom (20 March)

-----

**NOTE:** Builder works for OS11 (build with Ubuntu 18.04 - bionic) and OS12 (build with Ubuntu 20.04 - focal)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [Zoom - Current Version](https://support.zoom.us/hc/en-us/articles/205759689-New-Updates-for-Linux) |
| Script Name | [zoom-cp-init-script.sh](build/zoom-cp-init-script.sh) |
| Icon name | /custom/zoom/usr/share/pixmaps/Zoom.png |
| Command | /custom/zoom/usr/bin/zoom |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-zoom-cp.sh](build/build-zoom-cp.sh) |

-----

|  Customization | /userhome/.config/zoomus.conf and is symbolic linked (ln -s) to /custom/zoom/userhome/.config/zoomus.conf (allows for settings to be saved after reboot)|
|----------------|------------------------------|
| German Language | language=de |
| French Language | language=fr |

[Supported Zoom Languages](https://support.zoom.us/hc/en-us/articles/209982306-Change-your-language-on-Zoom)

[ISO 639-1 Language Codes](https://www.loc.gov/standards/iso639-2/php/code_list.php)

Sample for setting German language (reboot required after CP deployed)
![zoomus.conf language German](build/zoom-zoomus.conf-lang-german.png)

--------

## Pulseaudio Notes

To restart pulseaudio:

```bash
pulseaudio -k
   ```

Update the command in profile to restart pulseaudio as part of the command to start Zoom:

```bash
pulseaudio -k && zoom
   ```

--------

## Zoom Requirements

[Zoom Virtual Background system requirements](https://support.zoom.us/hc/en-us/articles/360043484511)

--------

## Zoom Linux (November 2022) - Retiring current key pair to sign Zoom desktop client

**Note: This is NOT an issue for Zoom CP on IGEL OS**

In [November 2022](https://support.zoom.us/hc/en-us/articles/9836712961165-Downloading-the-public-key-for-Linux), Zoom is retiring the current key pair used to sign the Zoom desktop client for Linux, which customers can use to validate the Zoom desktop client. Users must download the new public key before attempting to upgrade to version 5.12.6, otherwise they will be unable to install this update. Prior versions (before 5.12.6) will not be impacted.
