# Magnus Screen Magnifier

|  CP Information |            |
|----------------|--------------|
| Package | Magnus 1.0.2 |
| Script Name | [magnus-cp-init-script.sh](magnus-cp-init-script.sh) |
| CP Mount Path | /custom/magnus |
| CP Size | 10M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> magnus-1.0.2-1.inf | [INFO] <br /> [PART] <br /> file="magnus_amd64_1.0.2-1.tar.bz2" <br /> version="1.0.2-1" <br /> size="10M" <br /> name="magnus" <br /> minfw="11.03.110" |
| Path to Executable | /usr/bin/magnus |
| Path to Icon | applications-other |
| Missing Libraries | gir1.2-keybinder-3.0 <br /> libkeybinder-3.0-0 <br /> python3-setproctitle |
| Packaging notes | On your Linux CP build system (Ubuntu 18.04 Desktop) <br /> <br /> sudo add-apt-repository ppa:flexiondotorg/magnus <br /> cd ~/Downloads (temp folder) <br /> mkdir magnus <br /> apt download magnus gir1.2-keybinder-3.0 libkeybinder-3.0-0 python3-setproctitle <br /> <br /> For each package, extract into magnus folder: <br /> dpkg -x \<package\>.deb magnus |
