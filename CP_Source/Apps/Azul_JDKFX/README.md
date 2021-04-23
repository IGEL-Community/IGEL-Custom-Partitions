# Azul Zulu JDK FX

|  CP Information |            |
|-----------------|-------------|
| Package | Azule Zulu JDK FX - [Current Version](https://www.azul.com/downloads/zulu-community/?os=ubuntu&package=jdk-fx) <br /><br /> An open source implementation of Java JDK FX. |
| Script Name | [jdkfx-cp-init-script.sh](jdkfx-cp-init-script.sh) |
| CP Mount Path | /custom/jdkfx |
| CP Size |400M |
| IGEL OS Version (min) | 11.04.240 |
| Metadata File <br /> jdkfx.inf | [INFO] <br /> [PART] <br /> file="jdkfx.tar.bz2" <br /> version="8.52.0.23" <br /> size="400M" <br /> name="jdkfx" <br /> minfw="11.04.240" |
| Path to Executable | /custom/jdkfx/usr/lib/jvm/zulu-fx-8-amd64/jre/bin/java |
| Path to Icon | N/A |
| Missing Libraries | None |
| Download package and missing library | See build script for details |
| Packaging Notes | See build script for details |
| Package automation | [build-jdkfx-cp.sh](build-jdkfx-cp.sh) <br /><br /> Tested with 1.8.4 |

**NOTE: Use update-jave-alternatives to change java version**

## NAME

update-java-alternatives - update alternatives for jre/sdk installations

## SYNOPSIS

```
update-java-alternatives [--jre] [--plugin] [-v|--verbose]
      -l|--list [<jname>]
      -s|--set <jname>
      -a|--auto
      -h|-?|--help
  ```

## DESCRIPTION

update-java-alternatives updates all alternatives belonging to one runtime or development kit for the Java language. A package does provide these information of it's alternatives in /usr/lib/jvm/.<jname>.jinfo.

update-java-alternatives updates all alternatives belonging to one runtime or development kit for the Java language. A package does provide these information of it's alternatives in /usr/lib/jvm/.<jname>.jinfo.
