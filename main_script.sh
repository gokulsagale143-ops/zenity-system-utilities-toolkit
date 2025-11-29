#!/bin/bash
# -----------------------------------------------------
# Main Script for Zenity System Utilities Toolkit
# Author: Gokul Sagale (Modified to use zenity --entry)
# -----------------------------------------------------

# --- Define the List of Tasks (for display in the prompt) ---
TASK_LIST="
1: Create Scheduled Backups
3: View Real-Time System Logs
4: Configure Static IP
5: Set Firewall Rules (firewall)
7: Generate System Health Report
8: Monitor Disk I/O
9: Service Manager
11: Check Failed Login Attempts
12: Track Network Bandwidth
13: backup_database.sh
14: restore_database.sh
15: user_permission_manager.sh
16: usb_activity_logger.sh
17: process_priority_manager.sh
18: schedule_system_updates.sh
19: encrypted_folder_creator.sh
20: system_audit_log.sh
21: nagios_monitor_manager.sh
22: User Management System 
23: Exit Toolkit
"

# --- Main Zenity Input Dialog (Ask the user for their choice) ---
choice=$(zenity --entry \
	    --title="🧰 Zenity System Utilities Toolkit" \
	        --text="Enter the number of the task you need to execute (1-24):\n\n${TASK_LIST}" \
		    --entry-text="")

# If user closes the dialog or presses cancel
if [ $? -ne 0 ]; then
	    zenity --info --title="Exit" --text="Exiting Zenity System Utilities Toolkit. Goodbye 👋"
	        exit 0
fi

# --- Switch case for tasks ---
case $choice in
	    "1")  bash ./zenity_advanced_toolkit/01_scheduled_backup.sh ;;
	       # "2")  bash ./zenity_advanced_toolkit/02_cpu_temp_monitor.sh ;;
		    "3")  bash ./zenity_advanced_toolkit/03_view_system_logs.sh ;;
		        "4")  bash ./zenity_advanced_toolkit/04_configure_static_ip.sh ;;
			    "5")  bash ./zenity_advanced_toolkit/05_firewall_rules.sh ;;
			       # "6")  bash ./zenity_advanced_toolkit/06_check_internet_speed.sh ;;
				    "7")  bash ./zenity_advanced_toolkit/07_system_health_report.sh ;;
				        "8")  bash ./zenity_advanced_toolkit/08_monitor_disk_io.sh ;;
					    "9")  bash ./zenity_advanced_toolkit/09_service_manager.sh ;;
					      #  "10") bash ./zenity_advanced_toolkit/10_manage_startup_apps.sh ;;
						    "11") bash ./zenity_advanced_toolkit/11_check_failed_logins.sh ;;
						        "12") bash ./zenity_advanced_toolkit/12_track_network_bandwidth.sh ;;
							    "13")bash ./zenity_advanced_toolkit/13_backup_database.sh ;;
							    	"14")bash ./zenity_advanced_toolkit/14_restore_database.sh;;
							            "15")bash ./zenity_advanced_toolkit/15_user_permission_manager.sh ;;
									"16")bash ./zenity_advanced_toolkit/16_usb_activity_logger.sh ;;
								    	    "17")bash ./zenity_advanced_toolkit/17_process_priority_manager.sh ;;
							    			"18")bash ./zenity_advanced_toolkit/18_schedule_system_updates.sh ;;
							    			    "19")bash ./zenity_advanced_toolkit/19_encrypted_folder_creator.sh ;;
						    					"20")bash ./zenity_advanced_toolkit/20_system_audit_log.sh ;;
						    					  "21")bash ./zenity_advanced_toolkit/21_nagios_monitor_manager.sh ;;

					    						     "22")bash ./zenity_advanced_toolkit/22_user_management.sh ;;   			         
								
							        "23") zenity --info --title="Exit" --text="Exiting Zenity System Utilities Toolkit. Goodbye 👋" ; exit 0 ;;
								    *) zenity --error --title="Error" --text="Invalid choice: $choice. Please enter a number from 1 to 24." ;;
							    esac
