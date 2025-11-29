# zenity-system-utilities-toolkit

Zenity System Utility Toolkit 🚀

Welcome to the Zenity System Utility Toolkit! This project brings together a collection of powerful shell scripts, designed to help you manage and automate key system tasks on Linux-based systems. Leveraging the power of Zenity, a GUI toolkit for shell scripts, this toolkit makes managing system utilities easier and more user-friendly.

# 🔥 Key Features
We used OS -: RHEL 9.6
you can modify the above project as per the disctridution 
This toolkit includes a range of scripts that address common administrative tasks and system health monitoring, all with easy-to-use graphical interfaces powered by Zenity. Here's a list of the essential scripts included in the toolkit:

01_scheduled_backup.sh – Automate system backups with scheduled intervals.

03_view_system_logs.sh – Quickly view your system logs in a user-friendly window.

04_configure_static_ip.sh – Set up and configure static IP addresses for your network interfaces.

05_firewall_rules.sh – Simplify firewall configuration with an easy-to-use interface.

07_system_health_report.sh – Get a detailed health report of your system’s performance.

08_monitor_disk_io.sh – Monitor disk I/O and performance in real-time.

09_service_manager.sh – Start, stop, and manage system services with Zenity.

11_check_failed_logins.sh – View failed login attempts and security breaches.

12_track_network_bandwidth.sh – Track and display network bandwidth usage.

13_backup_database.sh – Easily backup databases with a few clicks.

14_restore_database.sh – Restore database backups effortlessly.

15_user_permission_manager.sh – Manage user permissions and group assignments.

16_usb_activity_logger.sh – Log USB activities and detect device connections.

17_process_priority_manager.sh – Change process priorities for better system resource management.

18_schedule_system_updates.sh – Automate system updates and patches with custom schedules.

19_encrypted_folder_creator.sh – Create encrypted folders to secure sensitive data.

20_system_audit_log.sh – Generate a detailed audit log of system activities.

21_nagios_monitor_manager.sh – Manage Nagios monitoring configurations.

22_user_management.sh – Add, modify, or delete users on your system with ease.

# 🛠 How To Use

To get started, simply download or clone this repository, and then use the main script to access and run all the toolkit scripts through a graphical interface. Here’s how you can set it up:

# 🚀 Step-by-Step Guide

Clone the Repository:

Clone the repository to your local machine using the following command:

git clone https://github.com/yourusername/zenity_advanced_toolkit.git


Navigate to the Project Directory:

Change into the directory where the scripts are located:

cd zenity_advanced_toolkit


Make Scripts Executable:

Give execute permissions to all the scripts:

chmod +x *.sh


Run the Main Script:

Now, run the main_script.sh to launch the main interface. This script will present a simple GUI (built with Zenity) that allows you to easily choose and execute any of the available tools.

./main_script.sh


You'll see a Zenity window pop up where you can select the task you want to perform. Whether it's backing up your data, monitoring system health, or adjusting firewall rules, everything is just a few clicks away.

# 🎨 Zenity Interface

The Zenity-based graphical interface makes the entire toolkit intuitive and beginner-friendly. You no longer need to rely solely on command-line inputs—simply choose the task you want to perform, and the script takes care of the rest.

# 💡 Example: Running a Scheduled Backup

Let’s say you want to schedule a backup using 01_scheduled_backup.sh:

Select Scheduled Backup from the Zenity menu.

Set your backup parameters (e.g., backup location, frequency).

Click “Start” and your backup will run automatically on the schedule you set!

# ⚡️ Additional Features

Automated Backups: Set it and forget it! Automate system backups, database backups, and more.

System Monitoring: Track system health, disk I/O, and network bandwidth in real-time.

Security: Protect your system with firewall configurations, failed login detection, and encrypted folders.

Ease of Use: Access all utilities from one place through the main script, reducing the need for complex command-line invocations.

# 📜 Project Structure

Here’s how the project is organized:
── main_script.sh (in this dir differnt taks are mentioned and using zenity dialog box as the user try to run the like bash main_script.sh so it show that)
zenity_advanced_toolkit/ (under this all taks are come and it is connect with main_script.sh))
├── 01_scheduled_backup.sh
├── 03_view_system_logs.sh
├── 04_configure_static_ip.sh
├── 05_firewall_rules.sh
├── 07_system_health_report.sh
├── 08_monitor_disk_io.sh
├── 09_service_manager.sh
├── 11_check_failed_logins.sh
├── 12_track_network_bandwidth.sh
├── 13_backup_database.sh
├── 14_restore_database.sh
├── 15_user_permission_manager.sh
├── 16_usb_activity_logger.sh
├── 17_process_priority_manager.sh
├── 18_schedule_system_updates.sh
├── 19_encrypted_folder_creator.sh
├── 20_system_audit_log.sh
├── 21_nagios_monitor_manager.sh
├── 22_user_management.sh


# 📝 Contributions

Contributions are welcome! If you have a new idea, a feature request, or want to improve an existing script, feel free to open an issue or submit a pull request.

# 🚨 Requirements

Linux-based OS (Ubuntu, RHEL 9.6 , OopenSUSE 15 leap  etc.)

Zenity (for the GUI interface)

You can install Zenity using your package manager if it’s not already installed:

sudo apt-get install zenity    # On Debian/Ubuntu-based systems
sudo yum install zenity        # On RedHat/CentOS-based systems

# 🌟 Conclusion

The Zenity System Utility Toolkit is a powerful, user-friendly collection of shell scripts that simplifies the task of managing and automating system administration on Linux. With its easy-to-use graphical interface, even beginners can handle advanced tasks like backups, system monitoring, and network management.

# Download the toolkit, try it out, and make your system management a breeze! 🌟
