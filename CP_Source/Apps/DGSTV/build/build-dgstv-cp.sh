#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for DGSTV
## Development machine (Ubuntu 18.04)
# https://vwest.com/
#Grab Current Linux Test
#wget https://vwest.com/Downloads/dgstv.test.tar.gz

#Run Application
#cd DGSTV/bin
#mono --gc=sgen DGSTV.exe

sudo apt install unzip -y
sudo apt-get update

MISSING_LIBS="binfmt-support build-essential ca-certificates-mono cli-common dpkg-dev fakeroot g++ g++-7 javascript-common libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libfakeroot libgdiplus libgif7 libjs-xmlextras libmono-2.0-1 libmono-2.0-dev libmono-accessibility4.0-cil libmono-cairo4.0-cil libmono-cecil-private-cil libmono-cecil-vb0.9-cil libmono-cil-dev libmono-codecontracts4.0-cil libmono-compilerservices-symbolwriter4.0-cil libmono-corlib4.5-cil libmono-cscompmgd0.0-cil libmono-csharp4.0c-cil libmono-custommarshalers4.0-cil libmono-data-tds4.0-cil libmono-db2-1.0-cil libmono-debugger-soft4.0a-cil libmono-http4.0-cil libmono-i18n-cjk4.0-cil libmono-i18n-mideast4.0-cil libmono-i18n-other4.0-cil libmono-i18n-rare4.0-cil libmono-i18n-west4.0-cil libmono-i18n4.0-all libmono-i18n4.0-cil libmono-ldap4.0-cil libmono-management4.0-cil libmono-messaging-rabbitmq4.0-cil libmono-messaging4.0-cil libmono-microsoft-build-engine4.0-cil libmono-microsoft-build-framework4.0-cil libmono-microsoft-build-tasks-v4.0-4.0-cil libmono-microsoft-build-utilities-v4.0-4.0-cil libmono-microsoft-build4.0-cil libmono-microsoft-csharp4.0-cil libmono-microsoft-visualbasic10.0-cil libmono-microsoft-visualc10.0-cil libmono-microsoft-web-infrastructure1.0-cil libmono-oracle4.0-cil libmono-parallel4.0-cil libmono-peapi4.0a-cil libmono-posix4.0-cil libmono-profiler libmono-rabbitmq4.0-cil libmono-relaxng4.0-cil libmono-security4.0-cil libmono-sharpzip4.84-cil libmono-simd4.0-cil libmono-smdiagnostics0.0-cil libmono-sqlite4.0-cil libmono-system-componentmodel-composition4.0-cil libmono-system-componentmodel-dataannotations4.0-cil libmono-system-configuration-install4.0-cil libmono-system-configuration4.0-cil libmono-system-core4.0-cil libmono-system-data-datasetextensions4.0-cil libmono-system-data-entity4.0-cil libmono-system-data-linq4.0-cil libmono-system-data-services-client4.0-cil libmono-system-data-services4.0-cil libmono-system-data4.0-cil libmono-system-deployment4.0-cil libmono-system-design4.0-cil libmono-system-drawing-design4.0-cil libmono-system-drawing4.0-cil libmono-system-dynamic4.0-cil libmono-system-enterpriseservices4.0-cil libmono-system-identitymodel-selectors4.0-cil libmono-system-identitymodel4.0-cil libmono-system-io-compression-filesystem4.0-cil libmono-system-io-compression4.0-cil libmono-system-json-microsoft4.0-cil libmono-system-json4.0-cil libmono-system-ldap-protocols4.0-cil libmono-system-ldap4.0-cil libmono-system-management4.0-cil libmono-system-messaging4.0-cil libmono-system-net-http-formatting4.0-cil libmono-system-net-http-webrequest4.0-cil libmono-system-net-http4.0-cil libmono-system-net4.0-cil libmono-system-numerics-vectors4.0-cil libmono-system-numerics4.0-cil libmono-system-reactive-core2.2-cil libmono-system-reactive-debugger2.2-cil libmono-system-reactive-experimental2.2-cil libmono-system-reactive-interfaces2.2-cil libmono-system-reactive-linq2.2-cil libmono-system-reactive-observable-aliases0.0-cil libmono-system-reactive-platformservices2.2-cil libmono-system-reactive-providers2.2-cil libmono-system-reactive-runtime-remoting2.2-cil libmono-system-reactive-windows-forms2.2-cil libmono-system-reactive-windows-threading2.2-cil libmono-system-reflection-context4.0-cil libmono-system-runtime-caching4.0-cil libmono-system-runtime-durableinstancing4.0-cil libmono-system-runtime-interopservices-runtimeinformation4.0-cil libmono-system-runtime-serialization-formatters-soap4.0-cil libmono-system-runtime-serialization4.0-cil libmono-system-runtime4.0-cil libmono-system-security4.0-cil libmono-system-servicemodel-activation4.0-cil libmono-system-servicemodel-discovery4.0-cil libmono-system-servicemodel-internals0.0-cil libmono-system-servicemodel-routing4.0-cil libmono-system-servicemodel-web4.0-cil libmono-system-servicemodel4.0a-cil libmono-system-serviceprocess4.0-cil libmono-system-threading-tasks-dataflow4.0-cil libmono-system-transactions4.0-cil libmono-system-web-abstractions4.0-cil libmono-system-web-applicationservices4.0-cil libmono-system-web-dynamicdata4.0-cil libmono-system-web-extensions-design4.0-cil libmono-system-web-extensions4.0-cil libmono-system-web-http-selfhost4.0-cil libmono-system-web-http-webhost4.0-cil libmono-system-web-http4.0-cil libmono-system-web-mobile4.0-cil libmono-system-web-mvc3.0-cil libmono-system-web-razor2.0-cil libmono-system-web-regularexpressions4.0-cil libmono-system-web-routing4.0-cil libmono-system-web-services4.0-cil libmono-system-web-webpages-deployment2.0-cil libmono-system-web-webpages-razor2.0-cil libmono-system-web-webpages2.0-cil libmono-system-web4.0-cil libmono-system-windows-forms-datavisualization4.0a-cil libmono-system-windows-forms4.0-cil libmono-system-windows4.0-cil libmono-system-workflow-activities4.0-cil libmono-system-workflow-componentmodel4.0-cil libmono-system-workflow-runtime4.0-cil libmono-system-xaml4.0-cil libmono-system-xml-linq4.0-cil libmono-system-xml-serialization4.0-cil libmono-system-xml4.0-cil libmono-system4.0-cil libmono-tasklets4.0-cil libmono-webbrowser4.0-cil libmono-webmatrix-data4.0-cil libmono-windowsbase4.0-cil libmono-xbuild-tasks4.0-cil libmonoboehm-2.0-1 libmonosgen-2.0-1 libmonosgen-2.0-dev libnunit-cil-dev libnunit-console-runner2.6.3-cil libnunit-core-interfaces2.6.3-cil libnunit-core2.6.3-cil libnunit-framework2.6.3-cil libnunit-mocks2.6.3-cil libnunit-util2.6.3-cil libstdc++-7-dev mono-4.0-gac mono-4.0-service mono-complete mono-csharp-shell mono-devel mono-gac mono-jay mono-mcs mono-runtime mono-runtime-common mono-runtime-sgen mono-utils mono-vbnc mono-xbuild mono-xsp4 mono-xsp4-base monodoc-base monodoc-http monodoc-manual pkg-config"

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/dgstv

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/dgstv
done

mkdir -p custom/dgstv/usr/local
wget https://vwest.com/Downloads/dgstv.test.tar.gz
tar xvf dgstv.test.tar.gz --directory custom/dgstv/usr/local

echo "+++++++=======  STARTING CLEAN of USR =======+++++++"
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_lib.sh
chmod a+x clean_cp_usr_lib.sh
wget https://raw.githubusercontent.com/IGEL-Community/IGEL-Custom-Partitions/master/utils/igelos_usr/clean_cp_usr_share.sh
chmod a+x clean_cp_usr_share.sh
./clean_cp_usr_lib.sh 11.05.133_usr_lib.txt custom/dgstv/usr/lib
./clean_cp_usr_share.sh 11.05.133_usr_share.txt custom/dgstv/usr/share
echo "+++++++=======  DONE CLEAN of USR =======+++++++"

# copy libc
cp /lib/x86_64-linux-gnu/libc.so.6 custom/dgstv/usr/lib/libc.so

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/DGSTV.zip

unzip DGSTV.zip -d custom
mv custom/target/build/dgstv-cp-init-script.sh custom

cd custom

# new build process into zip file
tar cvjf target/dgstv.tar.bz2 dgstv dgstv-cp-init-script.sh
zip -g ../DGSTV.zip target/dgstv.tar.bz2 target/dgstv.inf
zip -d ../DGSTV.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../DGSTV.zip ../../DGSTV-1.1.1_igel01.zip

cd ../..
rm -rf build_tar
