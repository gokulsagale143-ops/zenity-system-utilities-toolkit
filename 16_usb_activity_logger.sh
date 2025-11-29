#!/bin/bash
zenity --text-info --title="USB Activity" --width=600 --height=400 \
	    --filename=<(sudo udevadm monitor --subsystem-match=usb)
