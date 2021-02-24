# Keyfactor-CAgent (DRAFT build for testing)

|  CP Information |            |
|--------------------|------------|
| Package | [C-Agent for use with Keyfactor Platform](https://github.com/Keyfactor/Keyfactor-CAgent) - Current Version <br /><br /> [Orchestrate any key, any certificate, anywhere](https://www.keyfactor.com/) |
| Script Name | [keyfactor-cp-init-script.sh](keyfactor-cp-init-script.sh) |
| CP Mount Path | /custom/keyfactor |
| CP Size | 20M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> keyfactor.inf | [INFO] <br /> [PART] <br /> file="keyfactor.tar.bz2" <br /> version="2.5" <br /> size="20M" <br /> name="keyfactor" <br /> minfw="11.04.240" |
| Path to Executable | /custom/keyfactor/etc/keyfactor/agent |
| Path to Icon | N/A |
| Download package and missing libraries | sudo apt install -y build-essential git libcurl4-gnutls-dev curl libssl-dev <br /> git clone https://github.com/Keyfactor/Keyfactor-CAgent.git <br /> cd Keyfactor-CAgent <br /> make clean <br /> make opentest -j1 |
| Packaging Notes | Create folder: **keyfactor** <br /><br /> Move contents from build into CP folder |
| Package automation | [build-keyfactor-cp.sh](build-keyfactor-cp.sh) <br /><br /> Tested with 2.5 |
