# Netskope (20 November)

-----

**NOTE:** Builder works for OS11 (build with Ubuntu 18.04 - bionic) and **pending** OS12 (build with Ubuntu 20.04 - focal)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [Netskope](https://docs.netskope.com/en/netskope-help/netskope-client/netskope-client-supported-os-and-platform/) |
| Script Name | [netskope-cp-init-script.sh](build/netskope-cp-init-script.sh) |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-netskope-cp.sh](build/build-netskope-cp.sh) |

-----

**NOTE:** A reboot is required after CP deployed so that system (`stAgentSvca`) and user (`stAgentApp`) services are running. To check that they are running: `ps -ef | grep -i stagent`