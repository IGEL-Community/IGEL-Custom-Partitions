# Pulse Secure VPN (DRAFT Package for Testing)

|  CP Information |            |
|------------------|------------|
| Package | [Pulse Secure VPN](https://my.pulsesecure.net/) |
| Script Name | [pulse-cp-init-script.sh](pulse-cp-init-script.sh) |
| CP Mount Path | /custom/pulse |
| CP Size | 100M |
| IGEL OS Version (min) | 11.05.133 |
| Metadata File <br /> pulse.inf | [INFO] <br /> [PART] <br /> file="pulse.tar.bz2" <br /> version="9.1.R12" <br /> size="100M" <br /> name="pulse" <br /> minfw="11.05.133" |
| Path to Executable | /custom/pulse/opt/pulsesecure/bin/pulseUI |
| Path to Icon | /custom/pulse/opt/pulsesecure/resource/pulse.png |
| Packing Notes | See build script for details |
| Package automation | [build-pulse-cp.sh](build-pulse-cp.sh) <br /><br /> Tested with 9.1.R12 |
