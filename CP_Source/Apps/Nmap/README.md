# Nmap (17 July)

-----

**NOTE:** Builder works for OS11 (build with Ubuntu 18.04 - bionic) and OS12 (build with Ubuntu 20.04 - focal)

-----

|  CP Information |            |
|-----------------|------------|
| Package | [Nmap](https://nmap.org/) Network exploration tool and security / port scanner |
| Script Name | [nmap-cp-init-script.sh](build/nmap-cp-init-script.sh) |
| Icon name | /custom/splashtop/usr/share/pixmaps/logo_about_biz.png |
| Command OS 11 | /usr/bin/nmap |
| Command OS 12 | /usr/bin/nmap |
| Packaging Notes | Details can be found in the build script |
| Package automation | [build-nmap-cp.sh](build/build-nmap-cp.sh) |

-----

**Examples:**

- Quick scan:

```bash linenums="1"
nmap -T4 -F 10.0.0.0/24
```

- Intense scan:

```bash linenums="1"
nmap -T4 -A -v 10.0.0.0/24
```

- Intense scane, all TCP ports

```bash linenums="1"
nmap -p 1-65535 -T4 -A -v 10.0.0.0/24
```