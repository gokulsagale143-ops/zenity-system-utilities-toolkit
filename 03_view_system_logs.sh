#!/bin/bash
#
# Script: 03_view_system_logs.sh
# Description: Provides a menu-driven interface to view common system logs
#              using 'journalctl' and 'dmesg'.
#
# Usage: Run with 'bash 03_view_system_logs.sh'

# --- Configuration ---
# Set the pager to 'less' and enable color output for better readability
export SYSTEMD_COLORS=true
export SYSTEMD_PAGER=less

# --- Functions ---

# Function to display the main menu
show_menu() {
    clear
    echo "=========================================="
    echo "       System Log Viewer Menu"
    echo "=========================================="
    echo "1) View Last 50 System Journal Entries (journalctl -n 50)"
    echo "2) View Logs Since Last Boot (journalctl -b)"
    echo "3) View Failed System Services (journalctl -p 3 -xb)"
    echo "4) View Kernel Ring Buffer Messages (dmesg)"
    echo "5) Follow System Journal in Real-Time (journalctl -f)"
    echo "Q) Exit Script"
    echo "=========================================="
    echo -n "Enter your choice: "
}

# Function to execute the chosen option
execute_choice() {
    case "$1" in
        1)
            echo "--- Last 50 System Journal Entries (journalctl -n 50) ---"
            journalctl -n 50
            ;;
        2)
            echo "--- Logs Since Last Boot (journalctl -b) ---"
            journalctl -b
            ;;
        3)
            echo "--- Failed System Services (journalctl -p 3 -xb) ---"
            # -p 3: errors only (priority level 3)
            # -x: add explanations
            # -b: current boot
            journalctl -p 3 -xb
            ;;
        4)
            echo "--- Kernel Ring Buffer Messages (dmesg) ---"
            # H: human readable, T: show time
            dmesg -H -T
            ;;
        5)
            echo "--- Following System Journal (Press Ctrl+C to stop) ---"
            journalctl -f
            ;;
        q|Q)
            echo "Exiting System Log Viewer. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Press [Enter] to continue..."
            ;;
    esac
}

# --- Main Logic ---

# Check if journalctl command exists (standard on Systemd systems)
if ! command -v journalctl &> /dev/null; then
    echo "Error: 'journalctl' command not found. This script requires a Systemd-based distribution."
    exit 1
fi

while true; do
    show_menu
    read -r choice
    if [[ "$choice" =~ ^[1-5Qq]$ ]]; then
        execute_choice "$choice"
        # Only pause if the command wasn't "Follow" (option 5) or "Quit"
        if [[ "$choice" != "5" && "$choice" != "q" && "$choice" != "Q" ]]; then
            echo
            echo "------------------------------------------"
            echo "Log view complete. Press [Enter] to return to the menu..."
            read -r
        fi
    else
        execute_choice "$choice"
        # Pause for invalid inputs
        if [[ "$choice" != "" ]]; then
             read -r
        fi
    fi
done

# End of script
