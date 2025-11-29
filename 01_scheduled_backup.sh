#!/bin/bash

# Define log file location
LOG_FILE="/tmp/backup_script.log"

# 1. Select the source folder and backup destination
folder=$(zenity --file-selection --directory --title="Select Folder to Backup")
backup_dir=$(zenity --file-selection --directory --title="Select Backup Destination")

# 2. Check if both selections were made
if [ -n "$folder" ] && [ -n "$backup_dir" ]; then
    
    # 3. Get the cron schedule from the user
    schedule=$(zenity --entry \
        --title="Schedule Backup" \
        --text="Enter cron schedule (e.g., 0 2 * * * for 2:00 AM daily):" \
        --entry-text="0 2 * * *"
    )

    if [ -n "$schedule" ]; then
        
        # 4. Define the backup command using rsync for efficient, incremental backups
        # rsync options:
        # -a (archive mode: preserves permissions, ownership, timestamps, etc.)
        # -v (verbose output)
        # --delete (deletes files in destination that no longer exist in source)
        # --log-file (writes rsync activity to a log file)
        # --exclude (can be added here to skip large, unnecessary folders like Trash or Cache)
        # Trailing slash on $folder is crucial for rsync to copy contents, not the folder itself.
        # NOTE: rsync will create a sub-folder inside $backup_dir with the source name, which is good practice.
        BACKUP_CMD="/usr/bin/rsync -av --delete \"$folder/\" \"$backup_dir/$(basename "$folder")\" >> $LOG_FILE 2>&1"
        
        # 5. Full crontab entry
        CRON_JOB="$schedule $BACKUP_CMD"
        
        # 6. Add the job to the user's crontab safely
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        
        # 7. Success message
        zenity --info --title="Success" --text="✅ Backup scheduled successfully for folder: **$folder**\n\nCron Job Added:\n**$CRON_JOB**\n\n(It uses rsync for efficiency and logs to $LOG_FILE.)"
        
    else
        # 8. Error if schedule is missing
        zenity --error --title="Error" --text="❌ Backup not scheduled. Cron schedule was not entered."
    fi
else
    # 9. Error if folder or destination is missing
    zenity --error --title="Error" --text="❌ Backup not scheduled. Source folder or backup destination missing."
fi
