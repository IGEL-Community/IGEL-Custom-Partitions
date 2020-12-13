How-to use Zoom Conferencing custom partition
====================================================
General
-------
IGEL custom partitions are delivered as a zip archive. The archive has the following content:
-igel : folder containing UMS profiles
-target : folder containing Custom Partition (inf and tar.bz2 files)
-disclaimer.txt : disclaimer note
-readme.txt: Short Installation guide

Steps to deploy the Custom Partition
------------------------------------
1. Copy the contents of the folder target into the ums_filetransfer folder on the UMS Server (e.g C:\Program Files (x86)\IGEL\RemoteManager\rmguiserver\webapps\ums_filetransfer)

1.1 Optional: Check the accessibility of the data using Internet browser. (e.g: https://igelrmserver:8443/ums_filetransfer/cpname.inf
    If you have set the DNS A record igermserver you're good to go otherwise change this to your UMS Server

2. Import the profile from the folder igel/ (*.xml) into the UMS via: "System->Import->Import Profiles". The imported profile should now appear in UMS under Profiles.

3. Edit the profile and adopt the settings according to your environment under System->Firmware Customization->Custom Partition->Download
	a. https://<ums_server>:8443/ums_filetransfer/linphone.inf
	b. Username: <ums-username> 
	c. Password: <ums-password>
	(please do not change the init and stop scripts)

4. Assign the profile and files to IGEL device(s).

5. In some cases it is required to restart the TC after deployment of the CP.
