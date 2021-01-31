# Orca Screen Reader (DRAFT Testing of Package)

|  CP Information |            |
|--------------------|------------|
| Package | [Orca Screen Reader](https://wiki.gnome.org/action/show/Projects/Orca?action=show&redirect=Orca) - Current Version <br /><br /> Orca is a free, open source, flexible, and extensible screen reader that provides access to the graphical desktop via user-customizable combinations of speech and/or braille. <br /><br /> [Orca Screen Reader Overview](https://techblog.wikimedia.org/2020/07/02/an-orca-screen-reader-tutorial/) |
| Script Name | [orca-cp-init-script.sh](orca-cp-init-script.sh) |
| CP Mount Path | /custom/orca |
| CP Size | 20M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> orca.inf | [INFO] <br /> [PART] <br /> file="orca.tar.bz2" <br /> version="3.28.0" <br /> size="20M" <br /> name="orca" <br /> minfw="11.04.240" |
| Path to Executable | /custom/orca/usr/bin/orca |
| Path to Icon | /custom/orca/usr/share/icons/hicolor/48x48/apps/orca.png |
| Download package and missing libraries | apt-get download orca <br /> apt-get download gir1.2-wnck-3.0 <br /> apt-get download python3-brlapi <br /> apt-get download libbrlapi0.6 <br /> apt-get download python3-cairo <br /> apt-get download python3-louis <br /> apt-get download liblouis14 <br /> apt-get download python3-pyatspi <br /> apt-get download gir1.2-atspi-2.0 <br /> apt-get download libatk-adaptor <br /> apt-get download python3-speechd <br /> apt-get download speech-dispatcher <br /> apt-get download python3-xdg <br /> apt-get download libao4 <br /> apt-get download libdotconf0 <br /> apt-get download libltdl7 <br /> apt-get download libpulse0 <br /> apt-get download libsndfile1 <br /> apt-get download libspeechd2 <br /> apt-get download speech-dispatcher-audio-plugins <br /> apt-get download espeak <br /> apt-get download libespeak1 <br /> apt-get download espeak-data <br /> apt-get download libportaudio2 <br /> apt-get download libsonic0 <br /> |
| Packaging Notes | Create folder: **orca** <br /><br /> dpkg -x <package/lib> custom/orca |
| Package automation | [build-orca-cp.sh](build-orca-cp.sh) <br /><br /> Tested with 3.28.0 |

**Customization**: Replaced /etc/init.d with systemd / systemctl for starting and stopping speech-dispatcher service (/etc/systemd/system/speech-dispatcher.service):<br /><br />

```{/etc/systemd/system/speech-dispatcher.service}
[Unit]
Description=Speech-Dispatcher
After=network-online.target
Documentation=https://github.com/brailcom/speechd

[Service]
ExecStart=/usr/bin/speech-dispatcher -d -t 300000
ExecStop=/bin/kill -s QUIT $MAINPID

[Install]
WantedBy=multi-user.target
  ```
**After Install**: A reboot is required before using. <br />

**Test espeak**

```{test espeak}
echo "Hello IGEL Community" | /usr/bin/espeak
  ```

**Configure spd-conf**  

```{configure spd-conf}
/usr/bin/spd-conf
  ```

**Test spd-say**

```{test spd-say}  
/usr/bin/spd-say "Hello IGEL Community"
  ```
