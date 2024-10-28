#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for ThousandEyes Enterprise Agent
## Development machine (Ubuntu 18.04)

# https://docs.thousandeyes.com/product-documentation/global-vantage-points/enterprise-agents/installing/enterprise-agent-deployment-using-linux-package-method
# https://downloads.thousandeyes.com/agent/install_thousandeyes.sh

DEBIAN_REPOSITORY="https://apt.thousandeyes.com"
DEBIAN_PUBLIC_KEY_FILE="thousandeyes-apt-key.pub"
PACKAGE_NAME="te-agent"

PUBLIC_KEY="-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.11 (GNU/Linux)

mQENBFApO8oBCACxHESumhIcqUTvpIA+q9yIWQQL2nE1twF1T92xIJ9kgOF/5ali
iEqtNm0Vm2lpZy/LBcTG/UJY5rsKZVVWaepzXsNABeqzEE8t1CMGJ3hqtaZu59nd
VglzwuNuNL+qTjtgX3taPQrO9SQNwMq7lpQeTgBKAM8PjjKMdjezHl2rdtEdG2Km
VtN9qYDmb4ysCwq+ifCwOsZ4AM97r1M1+KwjNIa9EqA86qBixp2WqxaZ0ba4S3TG
wxwEa9Zcm+OXYKcU3TBug+S1OMp14E3PlfSCuS1T7xvbV0KgQRSOsMgPYQLcvw8u
r/uyONvdrx2+/oKrnd/ePZu2ha83msqOR+3vABEBAAG0KVRob3VzYW5kRXllcyA8
YnVpbGR1c2VyQHRob3VzYW5kZXllcy5jb20+iQE4BBMBAgAiBQJQKTvKAhsDBgsJ
CAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDJmhX1vnGJAKdFB/44WXjZvtirSNzn
Z9vDdxk/zXiWCyR/19znf+piIYCbRBqtoVGRxsxMS0FFHZZ4W6SlieklWJX3WShh
/17EaxC596Aegp4MuwTTQ3hMdEtyB1hDd1e1XQUQULaW/0+4u+dD9n6pHYnKF4Zx
DOQhJ5uXgKTaGZ5Z01JG92R9FxQJMre4j2N4F+EYd6pR9Cr2eBk5CVdnvw8njSak
PhmtmIjhf9faCsWf+mJGQuYggSKk8DJcobIjT3TqLoUlRYwhre1cnB/0mGTph/P1
xFCSpCMGU51jwpyUy1t2bHYeSVAba4PNqOOlITwRfDkKQxB9frI8ycGyx2S+eKFD
Qty56ztU
=p3tN
-----END PGP PUBLIC KEY BLOCK-----"

#sudo curl https://repo.fortinet.com/repo/6.4/ubuntu/DEB-GPG-KEY | sudo apt-key add -
echo "$PUBLIC_KEY" > ${DEBIAN_PUBLIC_KEY_FILE}
sudo cat $DEBIAN_PUBLIC_KEY_FILE | sudo apt-key add -
#sudo sh -c 'echo "deb [arch=amd64] https://repo.fortinet.com/repo/6.4/ubuntu/ /bionic multiverse" > /etc/apt/sources.list.d/fortinet-stable.list'
#sudo sh -c 'echo "deb [arch=amd64] https://apt.thousandeyes.com bionic main" > /etc/apt/sources.list.d/thousandeyes.list'
sudo sh -c 'echo "deb [arch=amd64] https://apt.thousandeyes.com jammy main" > /etc/apt/sources.list.d/thousandeyes.list'
sudo apt-get update
rm -f $DEBIAN_PUBLIC_KEY_FILE

#MISSING_LIBS="${PACKAGE_NAME} libapr1 libaprutil1 libosip2-11 libssh2-1"
MISSING_LIBS="${PACKAGE_NAME} libapr1 libaprutil1 libssh2-1"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/thousandeyes

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/thousandeyes
done

cp custom/thousandeyes/etc/te-agent.cfg.sample custom/thousandeyes/etc/te-agent.cfg

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.10.150_usr_lib.txt custom/thousandeyes/usr/lib
./clean_cp_usr_share.sh 11.10.150_usr_share.txt custom/thousandeyes/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/ThousandEyes.zip

unzip ThousandEyes.zip -d custom
mv custom/target/build/thousandeyes-cp-init-script.sh custom

cd custom

# edit inf file for version number
mkdir getversion
cd getversion
ar -x ../../te-agent_*.deb
tar xf control.tar.*
VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
cd ..
sed -i "/^version=/c version=\"${VERSION}\"" target/thousandeyes.inf
#echo "thousandeyes.inf file is:"
#cat target/thousandeyes.inf

# new build process into zip file
tar cvjf target/thousandeyes.tar.bz2 thousandeyes thousandeyes-cp-init-script.sh
zip -g ../ThousandEyes.zip target/thousandeyes.tar.bz2 target/thousandeyes.inf
zip -d ../ThousandEyes.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../ThousandEyes.zip ../../ThousandEyes-${VERSION}_igel01.zip

cd ../..
rm -rf build_tar
