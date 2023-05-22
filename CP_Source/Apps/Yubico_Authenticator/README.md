# Yubico Authenticator (22 May)

-----

**NOTE:** Builder works for OS11 (build with Ubuntu 18.04 - bionic). OS12 not currently supported by automated builder.

-----

|  CP Information |            |
|-----------------|------------|
| Package | [Yubico Authenticator](https://developers.yubico.com/yubioath-flutter/) will work with any USB or NFC-enabled YubiKeys. The Yubico Authenticator securely generates a code used to verify your identity as you are logging into various services. No connectivity needed! |
| Script Name | [yubioath-cp-init-script.sh](build/yubioath-cp-init-script.sh) |
| Icon name | /custom/yubioath/usr/share/icons/hicolor/128x128/apps/yubioath.png |
| Command | /custom/yubioath/usr/bin/yubioath-gui |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-yubioath-cp.sh](build/build-yubioath-cp.sh) |
