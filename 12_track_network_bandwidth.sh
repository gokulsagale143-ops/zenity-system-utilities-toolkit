#!/bin/bash
if command -v ifstat >/dev/null; then
	    zenity --text-info --title="Network Bandwidth Monitor" --filename=<(ifstat -t 1 10)
    else
	        zenity --error --text="ifstat not installed. Install with: sudo apt install ifstat"
fi
