#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for Datto RMM Agent
## Development machine (Ubuntu 18.04)

#https://rmm.datto.com/help/en/Content/4WEBPORTAL/Devices/ServersLaptopsDesktops/Linux/InstallLinux.htm
#sudo wget -O setup.sh [the web address of the Linux Agent from your site]

# In order to get the web address of the Agent, navigate to the site you want
# to add the device to > click New Device > select Linux > right-click the
# download link and copy the link address.

##############################################################
# Start - From Datto RMM Agent setup.sh
##############################################################
PROJECTNAME=CentraStage

TAR=/bin/tar
TAIL=/usr/bin/tail
GREP=/bin/grep

# Some useful functions
LOGFILE=$HOME/Downloads/linuxagentinstall.log

log() {
echo $1
echo $1 >>$LOGFILE
}
##############################################################
# End - From Datto RMM Agent setup.sh
##############################################################

if ! compgen -G "$HOME/Downloads/setup.sh" > /dev/null; then
  echo "***********"
  echo "Obtain the setup.sh file and save into $HOME/Downloads and re-run this script"
  echo ""
  echo "https://rmm.datto.com/help/en/Content/4WEBPORTAL/Devices/ServersLaptopsDesktops/Linux/InstallLinux.htm"
  echo ""
  echo "In order to get the web address of the Agent, navigate to the site you want"
  echo "to add the device to > click New Device > select Linux > right-click the"
  echo "download link and copy the link address."
  echo ""
  exit 1
fi

##############################################################
# Start - From Datto RMM Agent setup.sh
##############################################################
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > /dev/null
sudo sh -c 'echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list'
##############################################################
# End - From Datto RMM Agent setup.sh
##############################################################
sudo apt-get update
sudo apt install unzip -y

MISSING_LIBS="binfmt-support build-essential ca-certificates-mono cli-common dpkg-dev fakeroot g++ g++-7 javascript-common libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libfakeroot libgdiplus libgif7 libjs-xmlextras libmono-2.0-1 libmono-2.0-dev libmono-accessibility4.0-cil libmono-cairo4.0-cil libmono-cecil-private-cil libmono-cecil-vb0.9-cil libmono-cil-dev libmono-codecontracts4.0-cil libmono-compilerservices-symbolwriter4.0-cil libmono-corlib4.5-cil libmono-cscompmgd0.0-cil libmono-csharp4.0c-cil libmono-custommarshalers4.0-cil libmono-data-tds4.0-cil libmono-db2-1.0-cil libmono-debugger-soft4.0a-cil libmono-http4.0-cil libmono-i18n-cjk4.0-cil libmono-i18n-mideast4.0-cil libmono-i18n-other4.0-cil libmono-i18n-rare4.0-cil libmono-i18n-west4.0-cil libmono-i18n4.0-all libmono-i18n4.0-cil libmono-ldap4.0-cil libmono-management4.0-cil libmono-messaging-rabbitmq4.0-cil libmono-messaging4.0-cil libmono-microsoft-build-engine4.0-cil libmono-microsoft-build-framework4.0-cil libmono-microsoft-build-tasks-v4.0-4.0-cil libmono-microsoft-build-utilities-v4.0-4.0-cil libmono-microsoft-build4.0-cil libmono-microsoft-csharp4.0-cil libmono-microsoft-visualbasic10.0-cil libmono-microsoft-visualc10.0-cil libmono-microsoft-web-infrastructure1.0-cil libmono-oracle4.0-cil libmono-parallel4.0-cil libmono-peapi4.0a-cil libmono-posix4.0-cil libmono-profiler libmono-rabbitmq4.0-cil libmono-relaxng4.0-cil libmono-security4.0-cil libmono-sharpzip4.84-cil libmono-simd4.0-cil libmono-smdiagnostics0.0-cil libmono-sqlite4.0-cil libmono-system-componentmodel-composition4.0-cil libmono-system-componentmodel-dataannotations4.0-cil libmono-system-configuration-install4.0-cil libmono-system-configuration4.0-cil libmono-system-core4.0-cil libmono-system-data-datasetextensions4.0-cil libmono-system-data-entity4.0-cil libmono-system-data-linq4.0-cil libmono-system-data-services-client4.0-cil libmono-system-data-services4.0-cil libmono-system-data4.0-cil libmono-system-deployment4.0-cil libmono-system-design4.0-cil libmono-system-drawing-design4.0-cil libmono-system-drawing4.0-cil libmono-system-dynamic4.0-cil libmono-system-enterpriseservices4.0-cil libmono-system-identitymodel-selectors4.0-cil libmono-system-identitymodel4.0-cil libmono-system-io-compression-filesystem4.0-cil libmono-system-io-compression4.0-cil libmono-system-json-microsoft4.0-cil libmono-system-json4.0-cil libmono-system-ldap-protocols4.0-cil libmono-system-ldap4.0-cil libmono-system-management4.0-cil libmono-system-messaging4.0-cil libmono-system-net-http-formatting4.0-cil libmono-system-net-http-webrequest4.0-cil libmono-system-net-http4.0-cil libmono-system-net4.0-cil libmono-system-numerics-vectors4.0-cil libmono-system-numerics4.0-cil libmono-system-reactive-core2.2-cil libmono-system-reactive-debugger2.2-cil libmono-system-reactive-experimental2.2-cil libmono-system-reactive-interfaces2.2-cil libmono-system-reactive-linq2.2-cil libmono-system-reactive-observable-aliases0.0-cil libmono-system-reactive-platformservices2.2-cil libmono-system-reactive-providers2.2-cil libmono-system-reactive-runtime-remoting2.2-cil libmono-system-reactive-windows-forms2.2-cil libmono-system-reactive-windows-threading2.2-cil libmono-system-reflection-context4.0-cil libmono-system-runtime-caching4.0-cil libmono-system-runtime-durableinstancing4.0-cil libmono-system-runtime-interopservices-runtimeinformation4.0-cil libmono-system-runtime-serialization-formatters-soap4.0-cil libmono-system-runtime-serialization4.0-cil libmono-system-runtime4.0-cil libmono-system-security4.0-cil libmono-system-servicemodel-activation4.0-cil libmono-system-servicemodel-discovery4.0-cil libmono-system-servicemodel-internals0.0-cil libmono-system-servicemodel-routing4.0-cil libmono-system-servicemodel-web4.0-cil libmono-system-servicemodel4.0a-cil libmono-system-serviceprocess4.0-cil libmono-system-threading-tasks-dataflow4.0-cil libmono-system-transactions4.0-cil libmono-system-web-abstractions4.0-cil libmono-system-web-applicationservices4.0-cil libmono-system-web-dynamicdata4.0-cil libmono-system-web-extensions-design4.0-cil libmono-system-web-extensions4.0-cil libmono-system-web-http-selfhost4.0-cil libmono-system-web-http-webhost4.0-cil libmono-system-web-http4.0-cil libmono-system-web-mobile4.0-cil libmono-system-web-mvc3.0-cil libmono-system-web-razor2.0-cil libmono-system-web-regularexpressions4.0-cil libmono-system-web-routing4.0-cil libmono-system-web-services4.0-cil libmono-system-web-webpages-deployment2.0-cil libmono-system-web-webpages-razor2.0-cil libmono-system-web-webpages2.0-cil libmono-system-web4.0-cil libmono-system-windows-forms-datavisualization4.0a-cil libmono-system-windows-forms4.0-cil libmono-system-windows4.0-cil libmono-system-workflow-activities4.0-cil libmono-system-workflow-componentmodel4.0-cil libmono-system-workflow-runtime4.0-cil libmono-system-xaml4.0-cil libmono-system-xml-linq4.0-cil libmono-system-xml-serialization4.0-cil libmono-system-xml4.0-cil libmono-system4.0-cil libmono-tasklets4.0-cil libmono-webbrowser4.0-cil libmono-webmatrix-data4.0-cil libmono-windowsbase4.0-cil libmono-xbuild-tasks4.0-cil libmonoboehm-2.0-1 libmonosgen-2.0-1 libmonosgen-2.0-dev libnunit-cil-dev libnunit-console-runner2.6.3-cil libnunit-core-interfaces2.6.3-cil libnunit-core2.6.3-cil libnunit-framework2.6.3-cil libnunit-mocks2.6.3-cil libnunit-util2.6.3-cil libstdc++-7-dev mono-4.0-gac mono-4.0-service mono-complete mono-csharp-shell mono-devel mono-gac mono-jay mono-mcs mono-runtime mono-runtime-common mono-runtime-sgen mono-utils mono-vbnc mono-xbuild mono-xsp4 mono-xsp4-base monodoc-base monodoc-http monodoc-manual pkg-config"

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/datto

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/datto
done

##############################################################
# Start - From Datto RMM Agent setup.sh
##############################################################
TEMPDIR=/tmp/LinuxAgentSetup
if [ -d $TEMPDIR ] ; then
	rm -fR $TEMPDIR
fi

mkdir $TEMPDIR

TEMPARCHIVE=$TEMPDIR/agent.tgz

MATCH=$($GREP --text --line-number '^LINUX_AGENT_BINARY_DATA:$' $HOME/Downloads/setup.sh | cut -d ':' -f 1)
BINARY_START=$((MATCH + 1))
$TAIL -n +$BINARY_START $HOME/Downloads/setup.sh >$TEMPARCHIVE

CURRDIR=`pwd`
cd $TEMPDIR
$TAR -xzvf $TEMPARCHIVE

if [ ! -d InstallRoot ] ; then
	log "Wrong archive"
	exit 1
fi
cd InstallRoot
INSTALLROOTDIR=`pwd`
cd fs
log "Copying binaries"
#cp -fR * /
CPDIR=$CURRDIR/custom/datto
cp -fR * $CPDIR
log "Setting snmp.dll symlink"
cd $CPDIR/opt/$PROJECTNAME
ln -s snmp.dll Snmp.dll
log "Binaries have been copied"
log "Setting some persmissions"
#chown -R root $CPDIR/opt/$PROJECTNAME
chmod a+rx $CPDIR/opt/$PROJECTNAME/agent.sh
chmod a+rx $CPDIR/opt/$PROJECTNAME/restart_cag
chmod a+rx $CPDIR/opt/$PROJECTNAME/uninst.exe

log "Copying startup scripts"
cd $INSTALLROOTDIR/startup/systemd

log "Installing for systemd-like distros"
mkdir -p $CPDIR/etc/systemd/system/
cp ./etc/systemd/system/cag.service $CPDIR/etc/systemd/system/
chmod 664 $CPDIR/etc/systemd/system/cag.service

log "Copying restart_cag to /opt/$PROJECTNAME/restart_cag"
cp ./restart_cag $CPDIR/opt/$PROJECTNAME/restart_cag
log "Setting execute permissions to restart_cag"
chmod a+rx $CPDIR/opt/$PROJECTNAME/restart_cag

cd $CURRDIR

log "Removing installation files"
rm -fR $TEMPDIR
##############################################################
# END - From Datto RMM Agent setup.sh
##############################################################

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.07.100_usr_lib.txt custom/datto/usr/lib
./clean_cp_usr_share.sh 11.07.100_usr_share.txt custom/datto/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

# copy libc
#cp /lib/x86_64-linux-gnu/libc.so.6 custom/datto/usr/lib/libc.so

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/Datto_RMM_Agent.zip

unzip Datto_RMM_Agent.zip -d custom
mv custom/target/build/datto-cp-init-script.sh custom

cd custom

# new build process into zip file
tar cvjf target/datto.tar.bz2 datto datto-cp-init-script.sh
zip -g ../Datto_RMM_Agent.zip target/datto.tar.bz2 target/datto.inf
zip -d ../Datto_RMM_Agent.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../Datto_RMM_Agent.zip ../../Datto_RMM_Agent-1.1.1_igel01.zip

cd ../..
rm -rf build_tar
