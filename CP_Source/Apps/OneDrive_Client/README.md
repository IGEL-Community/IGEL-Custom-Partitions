# OneDrive Client (17 August)

|  CP Information |            |
|--------------------|------------|
| Package | [OneDrive Client for Linux](https://github.com/abraunegg/onedrive) is a free Microsoft OneDrive Client which supports OneDrive Personal, OneDrive for Business, OneDrive for Office365 and SharePoint. |
| Script Name | [onedrive-cp-init-script.sh](build/onedrive-cp-init-script.sh) |
| CP Mount Path | /custom/onedrive |
| Packaging Notes | See build script |
| Package automation | [build-onedrive-cp.sh](build/build-onedrive-cp.sh) |

-----

# Details on Usage: [Usage](https://github.com/abraunegg/onedrive/blob/master/docs/USAGE.md)

-----

## CONFIGURATION

The build process for CP copies the default config file into user home directory.

```
mkdir -p ~/.config/onedrive
cp @DOCDIR@/config ~/.config/onedrive/config
  ```

For the supported options see the usage link above for list of  command  line  options for the availability of a configuration key.

Pattern  are  case  insensitive.  * and ? wildcards characters are supported.  Use | to separate multiple patterns. After changing the filters (skip_file or skip_dir in your configs)  you must execute onedrive --synchronize --resync.

## FIRST RUN

After installing the application you must run it at least once from the terminal to authorize it.

You will be asked to open a specific link using your web browser  where you  will have to login into your Microsoft Account and give the application the permission to access your files. After  giving  the  permission, you will be redirected to a blank page. Copy the URI of the blank page into the application.

## Performing a selective sync via 'sync_list' file

[Selective sync](https://github.com/abraunegg/onedrive/blob/master/docs/USAGE.md#performing-a-selective-sync-via-sync_list-file) allows you to sync only specific files and directories. To enable selective sync create a file named `sync_list` in your application configuration directory (default is `~/.config/onedrive`). Each line of the file represents a relative path from your `sync_dir`. All files and directories not matching any line of the file will be skipped during all operations.

## SYSTEMD INTEGRATION

**NOTE:** This is configured into the profile to enable and start onedrive service.

Service files are installed into user and system directories.

### OneDrive service running as root user

To enable this mode, run as root user

```
systemctl enable onedrive
systemctl start onedrive
  ```

### OneDrive service running as root user for a non-root user

This mode allows starting  the  OneDrive  service  automatically with system start for multiple users. For each <username> run:

```
systemctl enable onedrive@<username>
systemctl start onedrive@<username>
  ```

### OneDrive service running as non-root user

In  this mode the service will be started when the user logs in. Run as user

```
systemctl --user enable onedrive
systemctl --user start onedrive
  ```

## LOGGING OUTPUT

When running onedrive all actions can be logged to a separate log file. This  can  be  enabled by using the --enable-logging flag.  By default, log files will be written to /var/log/onedrive.

All logfiles will be in the format  of  %username%.onedrive.log,  where %username% represents the user who ran the client.
