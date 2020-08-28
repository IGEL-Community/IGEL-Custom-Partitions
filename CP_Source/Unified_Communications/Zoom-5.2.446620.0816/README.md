# Zoom

|  CP Information |            |
|---------------------|------------|
| Package | Zoom 5.2.446620.0816 <br /> [Download Zoom](https://zoom.us/download?os=linux)|
| Script Name | [zoom-cp-init-script.sh](zoom-cp-init-script.sh) |
| CP Mount Path | /custom/zoom |
| CP Size | 200M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> zoom-5.2.446620.0816.inf | [INFO] <br /> [PART] <br /> file="zoom_amd64_5.2.446620.0816.tar.bz2" <br /> version="5.2.446620.0816" <br /> size="200M" <br /> minfw="11.03.110" |
| Path to Executable | /custom/zoom/usr/bin/zoom |
| Path to Icon | /custom/zoom/usr/share/pixmaps/Zoom.png |
| Missing Libraries | [libxcb-xtest0](https://packages.ubuntu.com/bionic/amd64/libxcb-xtest0) |
| Packaging Notes | The init script needs additional files to configure AppArmor: <br /><br /> /custom/zoom/config/bin/[zoom_cp_apparmor_reload](zoom_cp_apparmor_reload) <br /> /custom/zoom/lib/systemd/system/[igel-zoom-cp-apparmor-reload.service](igel-zoom-cp-apparmor-reload.service)
