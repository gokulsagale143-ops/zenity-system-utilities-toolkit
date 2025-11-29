#!/bin/bash
user=$(zenity --entry --text="Enter username:")
group=$(zenity --entry --text="Enter group name to add/remove:")
action=$(zenity --list --title="Permission Action" --column="Action" "Add to Group" "Remove from Group")

case $action in
	    "Add to Group") sudo usermod -aG "$group" "$user"; zenity --info --text="$user added to $group." ;;
	        "Remove from Group") sudo gpasswd -d "$user" "$group"; zenity --info --text="$user removed from $group." ;;
	esac
