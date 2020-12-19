# Auto Screen Rotation

|  CP Information |            |
|--------------------|------------|
| Package | Auto Screen Rotation - Current Version <br /><br /> Uses iio-sensor-proxy (monitor-sensor) to monitor and trigger the rotation via xrandr rotate [normal \| inverted \| right \| left] |
| Script Name | [asr-cp-init-script.sh](asr-cp-init-script.sh) |
| CP Mount Path | /custom/asr |
| CP Size | 10M |
| IGEL OS Version (min) | 11.4.200 |
| Metadata File <br /> asr.inf | [INFO] <br /> [PART] <br /> file="asr.tar.bz2" <br /> version="1.01" <br /> size="10M" <br /> name="asr" <br /> minfw="11.04.200" |
| Path to Executable | /custom/asr/usr/bin/igel_asr.sh|
| Path to Icon | N/A |
| Missing Libraries | NONE |
| Download package | apt-get download iio-sensor-proxy |
| Packaging Notes | Create folder: **asr** <br /><br /> dpkg -x <package/lib> custom/asr |
| Package automation | [build-asr-cp.sh](build-asr-cp.sh) |
