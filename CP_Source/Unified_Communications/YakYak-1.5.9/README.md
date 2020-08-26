# YakYak

|  CP Information |            |
|-----------------|------------|
| Package | YakYak 1.5.9 |
| Script Name | [yakyak-cp-init-script.sh](yakyak-cp-init-script.sh) |
| CP Mount Path | /custom/yakyak |
| CP Size | 350M |
| IGEL OS Version (min) | 11.3.110 |
| Metadata File <br /> yakyak-1.5.9.inf | [INFO] <br /> [PART] <br /> file="yakyak_amd64_1.5.9.tar.bz2" <br /> version="1.5.9" <br /> size="350M" <br /> minfw="11.03.110" |
| Path to Executable | /custom/yakyak/usr/bin/yakyak |
| Path to Icon | /custom/yakyak/usr/share/icons/hicolor/128x128/apps/yakyak.png |
| Missing Libraries | None |
| Packaging notes | On your Ubuntu packaging system: <br /> - Download YakYak for Linux (Download .deb (64 bit)) [YakYak Download](https://github.com/yakyak/yakyak/releases/latest) <br /> - Extract YakYak into folder "yakyak" (dpkg -x yakyak-version.deb yakyak) <br /> - mkdir -p yakyak/usr/bin <br /> - cd yakyak/usr/bin <br /> - ln -s ../../opt/yakyak/yakyak yakyak <br /> - Copy yakyak init script <br /> - Tar up package (tar cvjf yakyak_amd64_version.tar.bz2 yakyak-init-script yakyak)|
