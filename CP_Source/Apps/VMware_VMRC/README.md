# VMware Remote Console (VMRC) (DRAFT Package for Testing)

|  CP Information |            |
|------------------|------------|
| Package | [VMware Remote Console - vmrc](https://docs.vmware.com/en/VMware-Remote-Console/index.html) <br /><br /> VMware Remote Console provides client device connection and console access to virtual machines on a remote host. |
| Script Name | [vmrc-cp-init-script.sh](vmrc-cp-init-script.sh) |
| CP Mount Path | /custom/vmrc |
| CP Size | 300M |
| IGEL OS Version (min) | 11.04.240 |
| Metadata File <br /> vmrc.inf | [INFO] <br /> [PART] <br /> file="vmrc.tar.bz2" <br /> version="12.0.0" <br /> size="300M" <br /> name="vmrc" <br /> minfw="11.04.240" |
| Path to Executable | /usr/bin/vmrc |
| Path to Icon | /usr/share/icons/hicolor/48x48/apps/vmware-vmrc.png |
| Packing Notes | See build script for details |
| Package automation | [build-vmrc-cp.sh](build-vmrc-cp.sh) <br /><br /> Tested with 12.0.0 |

**Note**

[Access vSphere Virtual Machines with VMware Remote Console](https://docs.vmware.com/en/VMware-Remote-Console/12.0/com.vmware.vmrc.vsphere.doc/GUID-703AA27D-1AF3-4067-BE5E-99C3D0032F38.html)

The profile link does the following items are root:

```
/custom/vmrc/tmp/VMware-Remote-Console-12.0.0-17287072.x86_64.bundle --eulas-agreed --required --console
cp /usr/share/applications/vmware-vmrc.desktop /usr/share/applications.mime/vmware-vmrc.desktop
/custom/vmrc-cp-init-script.sh init
  ```
