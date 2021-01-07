#!/bin/bash
set -e

if lsusb | grep -qi yubikey; then
    echo found
    lsusb -d 0x1050:
    echo attempting to renew
    /home/pi/scripts/renew_key.exp
    sudo shutdown -h now
else
    echo no yubikey found exiting cleanly
    exit 0
fi
