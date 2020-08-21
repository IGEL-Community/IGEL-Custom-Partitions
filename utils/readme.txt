How-to use custom partition
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

2. Check the accessibility of the data using Internet browser. (e.g: https://<ums_server>:8443/ums_filetransfer/cpname.inf

3. Import the profile (profiles.zip) into the UMS via: "System->Import->Import Profiles". The imported profile should now appear in UMS under Profiles.

4. Edit the profile and adopt the settings according to your environment under System->Firmware Customization->Custom Partition->Download
	a. https://<ums_server>:8443/ums_filetransfer/<cpname>.inf
	b. Username: <ums-username>
	c. Password: <ums-password>

5. Assign the profile and files to IGEL device(s).

6. In some cases it is required to restart the TC after deployment of the CP.
