#!/bin/bash
# commands to link ~/.config/linphone and ~/.local/linphone to the CP

mkdir -p /custom/linphone/Documents/linphone/captures
mkdir -p /custom/linphone/userhome/.config/linphone
mkdir -p /custom/linphone/userhome/.local/share/linphone/logs
chown -R user:users /custom/linphone
ln -sv /custom/linphone/userhome/Documents/linphone /userhome/Documents/linphone
ln -sv /custom/linphone/userhome/.config/linphone /userhome/.config/linphone
ln -sv /custom/linphone/userhome/.local/share/linphone /userhome/.local/share/linphone