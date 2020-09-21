# ConnectWise Control (ScreenConnect)

|  CP Information |            |
|-----------------|------------|
| Package | ScreenConnect 20.1.29489.7513 |
| Script Name | [screenconnect-cp-init-script.sh](screenconnect-cp-init-script.sh) |
| CP Mount Path | /custom/screenconnect |
| CP Size | 200M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> screenconnect_20.1.29489.7513.inf | [INFO] <br /> [PART] <br /> file=screenconnect_20.1.29489.7513_igel1.tar.bz2 <br /> version="20.1.29489.7513" <br /> size="200M" <br /> minfw="11.03.110" |
| Path to Executable | N/A -- Runs as a service |
| Path to Icon | N/A -- Runs as a service |
| Missing Libraries | None |
| Packaging notes | On your Ubuntu packaging system: <br /> - Download stable release of ScreenConnect for Linux [ScreenConnect Download](https://www.connectwise.com/software/control/download) <br /> - Follow steps to install [Install ConnectWise Control On-Premise on Linux](https://docs.connectwise.com/ConnectWise_Control_Documentation/On-premises/Get_started_with_ConnectWise_Control_On-Premise/Install_ConnectWise_Control_On-Premise/Install_ConnectWise_Control_On-Premise_on_Linux) <br /> - Copy /opt/screenconnect into screenconnect custom partition folder (path should look like screenconnect/opt/screenconnect) <br /> - Un-Tar [file that includes etc files](screenconnect_20.1.29489.7513_etc_igel1.tar.bz2) into screenconnect/etc<br /> - Tar up package (tar cvjf screenconnect_\<version\>_igel1.tar.bz2 screenconnect-cp-init-script.sh screenconnect)|

**Customization**: Replaced /etc/init.d with systemd / systemctl for starting and stopping ScreenConnect service (/etc/systemd/system/screenconnect.service):<br /><br />

```{/etc/systemd/system/screenconnect.service}
[Unit]
Description=ConnectWise Control (ScreenConnect) Remote Control
After=network-online.target
Documentation=https://docs.connectwise.com/ConnectWise_Control_Documentation/On-premises/Get_started_with_ConnectWise_Control_On-Premise/Install_ConnectWise_Control_On-Premise/Install_ConnectWise_Control_On-Premise_on_Linux

[Service]
ExecStart=/opt/screenconnect/App_Runtime/bin/mono /opt/screenconnect/Bin/ScreenConnect.Service.exe startservices 7
ExecStop=/bin/kill -s QUIT $MAINPID

[Install]
WantedBy=multi-user.target
  ```
**After Install**: A reboot is required before using. <br />
**After Reboot**: To access ScreenConnect installation, open browser and connect to: <br /><br />

```{Access ScreenConnect installation}
http://localhost:8040/Host
  ```
