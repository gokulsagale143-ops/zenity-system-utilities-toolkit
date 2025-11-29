#!/bin/bash
# -----------------------------------------------------
# Simple Performance Monitor for Normal People
# Gathers key CPU, Disk, and Memory stats and summarizes them.
# -----------------------------------------------------

# --- 1. Check Dependencies (iostat for Disk Check) ---
if ! command -v iostat >/dev/null || ! command -v zenity >/dev/null; then
    zenity --error --text="❌ **Missing Dependencies!**\n\nEnsure 'sysstat' (for iostat) and 'zenity' are installed:\n\nsudo dnf install sysstat zenity"
    exit 1
fi

# --- 2. Gather Key Data ---

# Get %iowait (CPU waiting for disk) and %idle (CPU free) from the first iostat report
# The first report is the average since boot, useful for a quick check.
IOSTAT_OUTPUT=$(iostat -c 1 1 | awk '/^avg-cpu/ {print; getline; print}')
IOWAIT=$(echo "$IOSTAT_OUTPUT" | awk 'NR==2{print $4}')
IDLE=$(echo "$IOSTAT_OUTPUT" | awk 'NR==2{print $6}')

# Get Disk %util (How busy the main disk is)
# Focus on 'sda' (common primary drive) or 'dm-0' (common root logical volume)
DISK_UTIL=$(iostat -dxm 1 2 | tail -n +4 | awk '$1 ~ /sda|dm-0/ {print $NF}' | tail -1)
# Handle case where iostat fails to find sda/dm-0, or is too quick
if [[ -z "$DISK_UTIL" ]]; then
    DISK_UTIL=0
fi

# Get Memory Usage
MEM_FREE=$(free -h | awk '/Mem:/{print $4}')
MEM_TOTAL=$(free -h | awk '/Mem:/{print $2}')

# --- 3. Interpretation and Formatting (Color-Coded) ---

# --- CPU IOWAIT Check ---
if (( $(echo "$IOWAIT > 10" | bc -l) )); then
    CPU_IOWAIT_MSG="🔴 **HIGH ($IOWAIT%)** - The CPU is spending too much time waiting for the disk. This is a severe bottleneck."
elif (( $(echo "$IOWAIT > 3" | bc -l) )); then
    CPU_IOWAIT_MSG="🟠 **Moderate ($IOWAIT%)** - The CPU is sometimes waiting on the disk. Performance may slow down during heavy I/O."
else
    CPU_IOWAIT_MSG="🟢 **Excellent ($IOWAIT%)** - The CPU is rarely waiting on disk access. No I/O bottleneck detected."
fi

# --- DISK UTIL Check ---
if (( $(echo "$DISK_UTIL > 90" | bc -l) )); then
    DISK_UTIL_MSG="🔴 **MAXED OUT ($DISK_UTIL%)** - The disk is nearly $100\%$ busy. This is the main source of slowdowns."
elif (( $(echo "$DISK_UTIL > 50" | bc -l) )); then
    DISK_UTIL_MSG="🟠 **High ($DISK_UTIL%)** - The disk is working hard. Performance may feel sluggish."
else
    DISK_UTIL_MSG="🟢 **Low ($DISK_UTIL%)** - The disk has plenty of capacity remaining. Performance is good."
fi

# --- IDLE CPU Check ---
if (( $(echo "$IDLE < 10" | bc -l) )); then
    IDLE_MSG="🔴 **Low ($IDLE%)** - The CPU is almost constantly busy. The system will be unresponsive."
elif (( $(echo "$IDLE < 30" | bc -l) )); then
    IDLE_MSG="🟠 **Moderate ($IDLE%)** - The CPU is quite busy ($30-70\%$ used). System may slow down under load."
else
    IDLE_MSG="🟢 **High ($IDLE%)** - The CPU has lots of free time. The system is currently relaxed."
fi

# --- 4. Display Results with Zenity ---

REPORT_TEXT="### 📈 System Health Quick Check\n\nThis report focuses on the three main bottlenecks:\n\n* **CPU Disk Wait Time:** How much the CPU is held up by slow storage.\n    **Result:** ${CPU_IOWAIT_MSG}\n\n* **Primary Disk Load:** How busy your main hard drive/SSD is.\n    **Result:** ${DISK_UTIL_MSG}\n\n* **Overall CPU Free Time:** How much processing power is available.\n    **Result:** ${IDLE_MSG}\n\n---\n\n**RAM Status (Memory):**\nFree: **${MEM_FREE}** of **${MEM_TOTAL}** Total"

zenity --info --title="System Performance Summary" \
    --text="$REPORT_TEXT" \
    --width=500 --height=400
