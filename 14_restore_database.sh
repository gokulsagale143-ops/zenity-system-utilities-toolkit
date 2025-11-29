#!/bin/bash
db_user=$(zenity --entry --text="Enter MySQL username:")
db_name=$(zenity --entry --text="Enter database name to restore:")
backup_file=$(zenity --file-selection --title="Select Backup SQL File")

if [ -f "$backup_file" ]; then
	    mysql -u "$db_user" -p "$db_name" < "$backup_file"
	        zenity --info --text="Database restored successfully."
	else
		    zenity --error --text="File not found."
fi
