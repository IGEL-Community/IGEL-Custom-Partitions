# IntelliJ IDEA IC (24 May)

|  CP Information |            |
|-----------------|-------------|
| Package | [IntelliJ IDEA IC](https://www.jetbrains.com/idea/) – the Leading Java and Kotlin IDE.  The IDE that makes development a more productive and enjoyable experience |
| Script Name | [ideaic-cp-init-script.sh](build/ideaic-cp-init-script.sh) |
| CP Mount Path | /custom/ideaic |
| CP Size |5000M |
| IGEL OS Version (min) | 11.08.330 |
| Path to Executable | /custom/ideaic/usr/local/idea-IC-`version`/bin/idea.sh |
| Packaging Notes | See build script for details |
| Package automation | [build-ideaic-cp.sh](build/build-ideaic-cp.sh) |

-----

-----

```
IntelliJ IDEA

INSTALLATION INSTRUCTIONS
===============================================================================

  1. Unpack the IntelliJ IDEA distribution archive that you downloaded
     where you wish to install the program. We will refer to this
     location as your {installation home}.

  2. To start the application, open a console, cd into "{installation home}/bin" and type:

       ./idea.sh

     This will initialize various configuration files in the configuration directory:
     ~/.config/JetBrains/IdeaIC2023.1.

  3. [OPTIONAL] Add "{installation home}/bin" to your PATH environment
     variable so that you can start IntelliJ IDEA from any directory.

  4. [OPTIONAL] To adjust the value of the JVM heap size, create a file idea.vmoptions
     (or idea64.vmoptions if using a 64-bit JDK) in the configuration directory
     and set the -Xms and -Xmx parameters. To see how to do this,
     you can reference the vmoptions file under "{installation home}/bin" as a model
     but do not modify it, add your options to the new file.

  [OPTIONAL] Change the location of the "config" and "system" directories
  ------------------------------------------------------------------------------

  By default, IntelliJ IDEA stores all your settings in the
  ~/.config/JetBrains/IdeaIC2023.1 directory
  and uses ~/.local/share/JetBrains/IdeaIC2023.1 as a data cache.
  To change the location of these directories:

  1. Open a console and cd into ~/.config/JetBrains/IdeaIC2023.1

  2. Create a file idea.properties and set the idea.system.path and idea.config.path variables, for example:

     idea.system.path=~/custom/system
     idea.config.path=~/custom/config

  NOTE: Store the data cache ("system" directory) on a disk with at least 1 GB of free space.
  ```