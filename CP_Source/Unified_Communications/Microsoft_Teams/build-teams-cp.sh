#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Microsoft Teams
## Development machine (Ubuntu 18.04)
sudo apt install curl -y
sudo apt install unzip -y
sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
sudo apt-get update

mkdir build_tar
cd build_tar

apt-get download teams
apt-get download libgnome-keyring0

mkdir -p custom/teams

dpkg -x teams_* custom/teams
dpkg -x libg* custom/teams

mv custom/teams/usr/share/applications/ custom/teams/usr/share/applications.mime

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Unified_Communications/Microsoft_Teams.zip

unzip Microsoft_Teams.zip -d custom
mkdir -p custom/teams/config/bin
mkdir -p custom/teams/lib/systemd/system
mv custom/target/teams_cp_apparmor_reload custom/teams/config/bin
mv custom/target/igel-teams-cp-apparmor-reload.service custom/teams/lib/systemd/system/
mv custom/target/teams-cp-init-script.sh custom

cd custom

tar cvjf teams.tar.bz2 teams teams-cp-init-script.sh
mv teams.tar.bz2 ../..
mv target/teams.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
