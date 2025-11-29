#!/bin/bash
# -----------------------------------------------------
# Task 4: Configure Static IP (Primary and Secondary)
# Fixes CIDR/Mask issue and adds secondary IP support.
# -----------------------------------------------------

# Function to convert subnet mask (e.g., 255.255.255.0) to CIDR prefix (e.g., /24)
mask2cidr() {
    # Taken from a common bash function for mask to CIDR conversion
    local i mask ipdec cidr
    ipdec=$(echo "$1" | tr . ' ' | awk '{
        for (i=1; i<=4; i++) {
            sum += $i * (256^(4-i));
        }
        print sum
    }')
    
    # Calculate CIDR prefix
    cidr=0
    i=0
    while [ $i -lt 32 ]; do
        if [ $((ipdec & 1)) -eq 1 ]; then
            cidr=$((cidr + 1))
        fi
        ipdec=$((ipdec >> 1))
        i=$((i + 1))
    done
    echo "/$cidr"
}

# --- Zenity Prompts for Network Configuration ---
iface=$(zenity --entry --text="Enter network interface (e.g. eth0 or enp0s3):")
primary_ip=$(zenity --entry --text="Enter PRIMARY static IP (e.g. 192.168.1.100):")
mask=$(zenity --entry --text="Enter subnet mask (e.g. 255.255.255.0):")
gateway=$(zenity --entry --text="Enter gateway (e.g. 192.168.1.1):")
secondary_ip=$(zenity --entry --text="Enter SECONDARY IP (optional, e.g. 192.168.1.101):")

# --- Validation and Execution ---
if [ -z "$iface" ] || [ -z "$primary_ip" ] || [ -z "$mask" ]; then
    zenity --error --text="❌ Missing essential information (Interface, Primary IP, or Mask)."
    exit 1
fi

# Convert mask to CIDR prefix
cidr_prefix=$(mask2cidr "$mask")

# Combine primary IP with CIDR prefix
primary_cidr="${primary_ip}${cidr_prefix}"

# Prepare the full list of addresses
if [ -n "$secondary_ip" ]; then
    full_address_list="${primary_cidr},${secondary_ip}${cidr_prefix}"
    message="Primary: $primary_ip\nSecondary: $secondary_ip"
else
    full_address_list="$primary_cidr"
    message="Primary: $primary_ip"
fi

# --- nmcli Commands ---
# 1. Modify the connection with new addresses and settings
sudo nmcli con mod "$iface" \
    ipv4.addresses "$full_address_list" \
    ipv4.gateway "$gateway" \
    ipv4.method manual

# 2. Bring the connection up to apply changes
sudo nmcli con up "$iface"

# Check if nmcli command was successful
if [ $? -eq 0 ]; then
    zenity --info --text="✅ Static IP configured successfully.\nInterface: $iface\n$message\nGateway: $gateway"
else
    zenity --error --text="❌ Failed to configure static IP. Check interface name and run 'nmcli con show' to verify existing connections."
fi
