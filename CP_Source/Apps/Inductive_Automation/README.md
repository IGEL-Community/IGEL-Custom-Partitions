# Inductive Automation Perspective Workstation (27 May)

|  CP Information |            |
|-----------------|------------|
| Package | [Inductive Automation Perspective Workstation](https://inductiveautomation.com/ignition/) <br /><br /> Ignition is server software that acts as the hub for everything on your plant floor for total system integration. No matter what brand, model, or platform, it talks to your plant-floor equipment just as naturally as it talks to SQL databases, seamlessly bridging the gap between production and IT. |
| Script Name | [pw-cp-init-script.sh](pw-cp-init-script.sh) |
| CP Mount Path | /custom/pw |
| CP Size | 400M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> pw.inf | [INFO] <br /> [PART] <br /> file="pw.tar.bz2" <br /> version="1.1.5" <br /> size="400M" <br /> minfw="11.04.240" |
| Path to Executable | /custom/perspectiveworkstation/app/perspectiveworkstation.sh |
| Path to Icon | /custom/perspectiveworkstation/app/launcher.png |
| Packaging Notes | Details can be found in the build script [build-pw-cp.sh](build-pw-cp.sh) |
| Package automation | [build-pw-cp.sh](build-pw-cp.sh) |
