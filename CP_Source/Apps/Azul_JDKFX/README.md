# Azul Zulu JDK FX (16 March)

|  CP Information |            |
|-----------------|-------------|
| Package | Azule Zulu JDK FX - [Current Version](https://www.azul.com/downloads/zulu-community/?os=ubuntu&package=jdk-fx) <br /><br /> An open source implementation of Java JDK FX. |
| Script Name | [jdkfx-cp-init-script.sh](build/jdkfx-cp-init-script.sh) |
| CP Mount Path | /custom/jdkfx |
| CP Size |500M |
| IGEL OS Version (min) | 11.05.133 |
| Path to Executable | /custom/jdkfx/usr/lib/jvm/zulu-fx-11-amd64/bin/java <br /><br/> /custom/jdkfx/usr/lib/jvm/zulu-fx-8-amd64/bin/java |
| Packaging Notes | See build script for details |
| Package automation | [build-jdkfx-cp.sh](build/build-jdkfx-cp.sh) |

**NOTE: Set JAVA_HOME and PATH**

Version 8.XX
```
eval JAVA_HOME=/usr/lib/jvm/zulu-fx-8-amd64 PATH=/usr/lib/jvm/zulu-fx-8-amd64/bin:$PATH java -version
openjdk version "1.8.0_282"
OpenJDK Runtime Environment (Zulu 8.52.0.23-CA-linux64) (build 1.8.0_282-b08)
OpenJDK 64-Bit Server VM (Zulu 8.52.0.23-CA-linux64) (build 25.282-b08, mixed mode)
  ```

Version 11.XX
```  
eval JAVA_HOME=/usr/lib/jvm/zulu-fx-11-amd64 PATH=/usr/lib/jvm/zulu-fx-11-amd64/bin:$PATH java -version
openjdk version "11.0.10" 2021-01-19 LTS
OpenJDK Runtime Environment Zulu11.45+27-CA (build 11.0.10+9-LTS)
OpenJDK 64-Bit Server VM Zulu11.45+27-CA (build 11.0.10+9-LTS, mixed mode)
  ```
