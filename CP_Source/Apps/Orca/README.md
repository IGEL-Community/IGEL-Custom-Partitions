# Orca Screen Reader (DRAFT Testing of Package)

|  CP Information |            |
|--------------------|------------|
| Package | [Orca Screen Reader](https://wiki.gnome.org/action/show/Projects/Orca?action=show&redirect=Orca) - Current Version <br /><br /> Orca is a free, open source, flexible, and extensible screen reader that provides access to the graphical desktop via user-customizable combinations of speech and/or braille. |
| Script Name | [orca-cp-init-script.sh](orca-cp-init-script.sh) |
| CP Mount Path | /custom/orca |
| CP Size | 20M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> orca.inf | [INFO] <br /> [PART] <br /> file="orca.tar.bz2" <br /> version="3.28.0" <br /> size="20M" <br /> name="orca" <br /> minfw="11.04.240" |
| Path to Executable | /custom/orca/usr/bin/orca |
| Path to Icon | /custom/orca/usr/share/icons/hicolor/48x48/apps/orca.png |
| Missing Libraries | gir1.2-wnck-3.0 <br /> python3-brlapi <br /> python3-cairo <br /> python3-louis <br /> python3-pyatspi <br /> python3-speechd <br /> speech-dispatcher |
| Download package and missing library | apt-get download orca <br /> apt-get download gir1.2-wnck-3.0 <br /> apt-get download python3-brlapi <br /> apt-get download python3-cairo <br /> apt-get download python3-louis <br /> apt-get download python3-pyatspi <br /> apt-get download python3-speechd <br /> apt-get download speech-dispatcher |
| Packaging Notes | Create folder: **orca** <br /><br /> dpkg -x <package/lib> custom/orca |
| Package automation | [build-orca-cp.sh](build-orca-cp.sh) <br /><br /> Tested with 3.28.0 |
