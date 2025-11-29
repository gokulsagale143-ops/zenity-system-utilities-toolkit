#!/bin/bash
folder=$(zenity --entry --text="Enter folder name to encrypt:")
password=$(zenity --password --title="Enter Encryption Password")

if [ -n "$folder" ] && [ -n "$password" ]; then
	    mkdir "$folder"
	        zip -er "${folder}.zip" "$folder" <<< "$password"
		    zenity --info --text="Encrypted folder ${folder}.zip created."
fi
