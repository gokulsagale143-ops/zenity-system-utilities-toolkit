#!/bin/bash
time=$(zenity --entry --text="Enter time for daily updates (HH:MM):")
hour=$(echo "$time" | cut -d: -f1)
minute=$(echo "$time" | cut -d: -f2)

echo "$minute $hour * * * root apt update -y && apt upgrade -y" | sudo tee /etc/cron.d/system_auto_update
zenity --info --text="Automatic updates scheduled daily at $time."
