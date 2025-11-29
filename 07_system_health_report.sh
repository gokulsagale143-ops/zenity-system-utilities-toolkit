#!/bin/bash
# -----------------------------------------------------
# Task 7: Generate System Health Report (Optimized)
# -----------------------------------------------------

# Define the temporary report file path
report="/tmp/system_health_$(date +%F).txt"

# --- 1. Gather System Data into the Report File ---
{
    echo "===== SYSTEM HEALTH REPORT ====="
    echo "Hostname: $(hostname)"
    echo "Date: $(date)"
    echo "Uptime: $(uptime)"
    
    echo ""
    echo "===== DISK USAGE ====="
    df -h
    
    echo ""
    echo "===== MEMORY USAGE ====="
    free -h
    
    echo ""
    echo "===== CPU LOAD (Top 10 Processes) ====="
    top -bn1 | head -n 10
} > "$report"

# --- 2. Display Report and Clean Up ---
if [ -f "$report" ]; then
    zenity --text-info --title="System Health Report" --width=700 --height=500 --filename="$report"
else
    zenity --error --text="❌ Failed to generate the system health report file."
fi

# Clean up the temporary file
rm -f "$report"
