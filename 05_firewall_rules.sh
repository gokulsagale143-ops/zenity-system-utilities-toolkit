#!/bin/bash
# -----------------------------------------------------
# Task 5: Set Firewall Rules (firewall-cmd / RHEL 9.6)
# Uses firewall-cmd, the standard tool for RHEL 9.6.
# -----------------------------------------------------

# Check if firewalld is running before attempting any permanent changes
check_firewalld() {
    if ! command -v firewall-cmd >/dev/null; then
        zenity --error --text="❌ firewall-cmd not found. Ensure firewalld package is installed."
        exit 1
    fi
    if ! sudo systemctl is-active --quiet firewalld; then
        zenity --warning --text="⚠️ firewalld service is not active. The firewall must be enabled for commands to work."
    fi
}

# Zenity list dialog to select a firewall action
action=$(zenity --list --title="Firewall Manager (RHEL/firewalld)" \
    --text="Select a firewall task to perform:" \
    --column="Action" \
    "Enable Firewall Service" \
    "Disable Firewall Service" \
    "Allow Port (Permanent)" \
    "Deny Port (Permanent)" \
    "Show Status (Verbose)")

# Check if firewalld is available before running commands
check_firewalld

case $action in
    "Enable Firewall Service")
        sudo systemctl enable --now firewalld
        zenity --info --text="Firewall service enabled and started." 
        ;;
        
    "Disable Firewall Service")
        sudo systemctl stop firewalld
        sudo systemctl disable firewalld
        zenity --info --text="Firewall service disabled and stopped."
        ;;
        
    "Allow Port (Permanent)")
        # RHEL firewalld requires service name (like ssh) or port/protocol (like 80/tcp)
        port_or_service=$(zenity --entry --text="Enter port/protocol (e.g., 80/tcp) or service (e.g., http):")
        if [ -n "$port_or_service" ]; then
            sudo firewall-cmd --zone=public --add-port="$port_or_service" --permanent
            sudo firewall-cmd --reload
            zenity --info --text="Port/Service $port_or_service **permanently allowed** in the public zone."
        else
            zenity --error --text="Port/Service input was empty."
        fi
        ;;
        
    "Deny Port (Permanent)")
        # To 'Deny' a port, we use the remove-port command in firewalld
        port_or_service=$(zenity --entry --text="Enter port/protocol (e.g., 80/tcp) or service (e.g., http) to DENY (remove):")
        if [ -n "$port_or_service" ]; then
            sudo firewall-cmd --zone=public --remove-port="$port_or_service" --permanent
            sudo firewall-cmd --reload
            zenity --info --text="Port/Service $port_or_service **permanently denied** (removed) from the public zone."
        else
            zenity --error --text="Port/Service input was empty."
        fi
        ;;
        
    "Show Status (Verbose)") 
        status=$(sudo firewall-cmd --list-all)
        zenity --text-info --title="firewalld Status (Public Zone)" --width=600 --height=400 --filename=<(echo "$status") 
        ;;
        
esac
