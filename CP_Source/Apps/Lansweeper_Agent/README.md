# Lansweeper Agent (15 May) 

-----

**NOTE:** Builder works for OS11 (build with Ubuntu 18.04 - bionic) and **pending** OS12 (build with Ubuntu 20.04 - focal)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [Lansweeper Agent](https://community.lansweeper.com/t5/scanning-your-network/installing-lsagent-on-a-linux-computer/ta-p/64469)
| Script Name | [lsagent-cp-init-script.sh](build/lsagent-cp-init-script.sh) |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-lsagent-cp.sh](build/build-lsagent-cp.sh) |

-----

**NOTE:**

- Edit the builder and change the key for your environment `LANSWEEPER_AUTHENTICATION_KEY="4c2db649-014a-41f5-a01d-08950d7af"`
- [Installing LsAgent on a Linux computer](https://community.lansweeper.com/t5/scanning-your-network/installing-lsagent-on-a-linux-computer/ta-p/64469) provides details on how to obtain key
- The key can be found in stored in /custom/lsagent/opt/LansweeperAgent/LsAgent.ini as `AgentKey=4c2db649-014a-41f5-a01d-08950d7af`