#!/bin/bash
# -----------------------------------------------------
# Task 9: Service Manager (RHEL 9.6 Compatible & Enhanced)
# Manages systemd services with robust feedback.
# -----------------------------------------------------

service=$(zenity --entry --title="Service Manager" --text="Enter service name (e.g. sshd, httpd):")

# Exit if service name is empty
if [ -z "$service" ]; then
    zenity --error --text="❌ Service name cannot be empty."
    exit 1
fi

action=$(zenity --list --title="Service Action for $service" \
    --column="Action" "Start" "Stop" "Restart" "Enable" "Disable" "Status")

# Exit if action is cancelled
if [ -z "$action" ]; then
    exit 0
fi

# Variable to hold the final result message
result_message=""

# --- Execute Action ---
case $action in
    "Start")
        sudo systemctl start "$service"
        if [ $? -eq 0 ]; then
            result_message="✅ Service **$service** started successfully."
        else
            result_message="❌ Failed to start service **$service**. Check service name or permissions."
        fi
        ;;
    "Stop")
        sudo systemctl stop "$service"
        if [ $? -eq 0 ]; then
            result_message="✅ Service **$service** stopped successfully."
        else
            result_message="❌ Failed to stop service **$service**."
        fi
        ;;
    "Restart")
        sudo systemctl restart "$service"
        if [ $? -eq 0 ]; then
            result_message="✅ Service **$service** restarted successfully."
        else
            result_message="❌ Failed to restart service **$service**."
        fi
        ;;
    "Enable")
        sudo systemctl enable "$service"
        if [ $? -eq 0 ]; then
            result_message="✅ Service **$service** enabled (set to start at boot)."
        else
            result_message="❌ Failed to enable service **$service**."
        fi
        ;;
    "Disable")
        sudo systemctl disable "$service"
        if [ $? -eq 0 ]; then
            result_message="✅ Service **$service** disabled (will NOT start at boot)."
        else
            result_message="❌ Failed to disable service **$service**."
        fi
        ;;
    "Status")
        # For 'Status', we show a detailed text box directly
        status_output=$(sudo systemctl status "$service" 2>&1)
        zenity --text-info --title="Status: $service" \
            --width=700 --height=400 \
            --filename=<(echo "$status_output")
        # Exit here since status is handled differently
        exit 0 
        ;;
esac

# --- Display Final Result (Only for Start, Stop, Restart, Enable, Disable) ---
zenity --info --title="Action Result" --text="$result_message"
