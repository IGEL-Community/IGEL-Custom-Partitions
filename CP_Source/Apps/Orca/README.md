# Orca Screen Reader (Dev Testing) (16 Februrary)

|  CP Information |            |
|--------------------|------------|
| Package | [Orca Screen Reader](https://wiki.gnome.org/action/show/Projects/Orca?action=show&redirect=Orca) - Current Version <br /><br /> Orca is a free, open source, flexible, and extensible screen reader that provides access to the graphical desktop via user-customizable combinations of speech and/or braille. <br /><br /> [Orca Screen Reader Overview](https://techblog.wikimedia.org/2020/07/02/an-orca-screen-reader-tutorial/) |
| Script Name | [orca-cp-init-script.sh](orca-cp-init-script.sh) |
| CP Mount Path | /custom/orca |
| Packaging Notes | See build script |
| Package automation | [build-orca-cp.sh](build/build-orca-cp.sh) |

**Test espeak**

```{test espeak}
echo "Hello IGEL Community" | /usr/bin/espeak-ng
  ```

**Configure spd-conf**  

```{configure spd-conf}
/usr/bin/spd-conf
  ```

**Test spd-say**

```{test spd-say}  
/usr/bin/spd-say "Hello IGEL Community"
  ```

**Setup Orca**

```{setup orca}  
orca -s
  ```

**Command to start speech-dispatcher**

```{start}
/usr/bin/speech-dispatcher -d -t 300000
  ```
