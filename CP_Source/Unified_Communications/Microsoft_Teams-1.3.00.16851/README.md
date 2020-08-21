# Microsoft Teams

|  CP Information |            |
|----------------|--------------|
| Package | Microsoft Teams 1.3.00.16851|
| Script Name | [msteams-cp-init-script.sh](msteams-cp-init-script.sh) |
| CP Mount Path | /custom/msteams |
| CP Size | 400M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> msteams-1.3.00.16851.inf | [INFO] <br /> [PART] <br /> file="msteams_amd64_1.3.00.16851.tar.bz2" <br /> version="1.3.00.16851" <br /> size="400M" <br /> minfw="11.03.110" |
| Path to Executable | /custom/msteams/usr/bin/teams |
| Path to Icon | /custom/msteams/usr/share/pixmaps/teams.png |
| Missing Libraries | libboost_filesystem.so.1.58.0 <br /> libboost_system.so.1.58.0 <br /> libcapnp-0.5.3.so <br /> libgnome-keyring.so.0 <br /> libkj-0.5.3.so <br /> libmirclient.so.9 <br /> libmircommon.so.7 <br /> libmircore.so.1 <br /> libmirprotobuf.so.3 <br /> libprotobuf-lite.so.9 |
| Packaging notes | There is a bug in sharing full screen. You need to move the following file: <br /> <br /> mv /custom/msteams/usr/share/teams/resources/app.asar.unpacked/node_modules/slimcore/bin/rect-overlay /custom/msteams/usr/share/teams/resources/app.asar.unpacked/node_modules/slimcore/bin/bad-rect-overlay |
