# Training Videos

|  CP Information |            |
|--------------------|------------|
| Package | Training Videos - Template to build CP with training videos with profiles using thunar as file manager GUI and Google Chrome in kiosk mode. <br /><br /> Create trainingvideos.zip file with the videos to pull into CP. |
| Script Name | [trainingvideos-cp-init-script.sh](trainingvideos-cp-init-script.sh) |
| CP Mount Path | /custom/trainingvideos |
| CP Size | 1000M |
| IGEL OS Version (min) | 11.4.240 |
| Metadata File <br /> trainingvideos.inf | [INFO] <br /> [PART] <br /> file="trainingvideos.tar.bz2" <br /> version="1.0.0" <br /> size="1000M" <br /> name="trainingvideos" <br /> minfw="11.04.240" |
| thunar Path to Executable | thundar ~/trainingvideos |
| Google Chrome Path to Executable | google-chrome-stable --no-default-browser-check --kiosk ~/trainingvideos |
| Path to Icon | N/A |
| Package automation | [build-trainingvideos-cp.sh](build-trainingvideos-cp.sh) |

**Note:**

Here is link to [Google Chrome CP](https://github.com/IGEL-Community/IGEL-Custom-Partitions/tree/master/CP_Source/Browsers/Google_Chrome)
