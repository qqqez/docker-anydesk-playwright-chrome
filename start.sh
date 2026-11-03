#!/bin/bash

# Xvfb
Xvfb :99 -screen 0 1920x1080x24 > /dev/null 2>&1 &

sleep 2
export DISPLAY=:99

# LXDE / Openbox
openbox > /dev/null 2>&1 &

# AnyDesk + password
anydesk --service > /dev/null 2>&1 &
sleep 3
echo "YourPassword123" | anydesk --set-password

# SSH
/usr/sbin/sshd -D
