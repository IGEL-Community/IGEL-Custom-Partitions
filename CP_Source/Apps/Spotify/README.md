# Spotify (DRAFT Package for Testing)

|  CP Information |            |
|--------------------|------------|
| Package | Spotify - [Current Version](https://www.spotify.com/us/download/linux/) |
| Script Name | [spotify-cp-init-script.sh](spotify-cp-init-script.sh) |
| CP Mount Path | /custom/spotify |
| CP Size | 800M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> spotify.inf | [INFO] <br /> [PART] <br /> file="spotify.tar.bz2" <br /> version="1.1.42.622" <br /> size="800M" <br /> name="spotify" <br /> minfw="11.04.240" |
| Path to Executable | /custom/spotify/usr/bin/spotify |
| Path to Icon | /custom/spotify/usr/share/spotify/icons/spotify-linux-256.png |
| Missing Libraries | See build script for details |
| Download package and missing library | See build script for details |
| Packaging Notes | Create folder: **spotify** <br /><br /> dpkg -x <package/lib> custom/spotify |
| Package automation | [build-spotify-cp.sh](build-spotify-cp.sh) <br /><br /> Tested with 1.1.42.622 |
