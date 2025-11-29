#!/bin/bash
db_user=$(zenity --entry --text="Enter MySQL username:")
db_name=$(zenity --entry --text="Enter database name:")
backup_dir=$(zenity --file-selection --directory --title="Select Backup Folder")

if [ -n "$db_user" ] && [ -n "$db_name" ]; then
	    mysqldump -u "$db_user" -p "$db_name" > "$backup_dir/${db_name}_backup.sql"
	        zenity --info --text="Database $db_name backed up successfully."
	else
		    zenity --error --text="Missing inputs."
fi
