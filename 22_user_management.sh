#!/bin/bash

# -------------------------------
# Zenity-based Linux User Creator
# Author: Gokul Sagale
# -------------------------------

# Must run as root
if [ "$EUID" -ne 0 ]; then
	    zenity --error --text="You must run this script as ROOT!"
	        exit 1
fi

# ---- Collect User Information ----
USERNAME=$(zenity --entry --title="Add User" --text="Enter Username:")
[ $? -ne 0 ] && exit 1

PASSWORD=$(zenity --password --title="Add User" --text="Enter Password:")
[ $? -ne 0 ] && exit 1

UID_VAL=$(zenity --entry --title="User ID (UID)" --text="Enter UID (Leave empty for automatic UID):")
[ $? -ne 0 ] && exit 1

GID_VAL=$(zenity --entry --title="Group ID (GID)" --text="Enter GID (Leave empty for default group):")
[ $? -ne 0 ] && exit 1

GECOS_FIELD=$(zenity --entry --title="User Information" --text="Enter User Info (GECOS):")
[ $? -ne 0 ] && exit 1

HOME_DIR=$(zenity --entry --title="Home Directory" --text="Enter Home Directory Path (Leave empty for /home/$USERNAME):")
[ $? -ne 0 ] && exit 1

LOGIN_SHELL=$(zenity --entry --title="Login Shell" --text="Enter Login Shell (e.g., /bin/bash):")
[ $? -ne 0 ] && exit 1


# ---- Build the useradd command ----
CMD="useradd"

[ ! -z "$UID_VAL" ] && CMD+=" -u $UID_VAL"
[ ! -z "$GID_VAL" ] && CMD+=" -g $GID_VAL"
[ ! -z "$GECOS_FIELD" ] && CMD+=" -c \"$GECOS_FIELD\""
[ ! -z "$HOME_DIR" ] && CMD+=" -d $HOME_DIR"
[ ! -z "$LOGIN_SHELL" ] && CMD+=" -s $LOGIN_SHELL"

CMD+=" $USERNAME"


# ---- Execute the command ----
eval $CMD

# Check success
if [ $? -ne 0 ]; then
	    zenity --error --text="Failed to create user!"
	        exit 1
fi

# ---- Set password ----
echo "$USERNAME:$PASSWORD" | chpasswd

zenity --info --text="User '$USERNAME' created successfully!

✔ Added to /etc/passwd  
✔ Password stored in /etc/shadow  
✔ Home directory created  
✔ Login shell set"

exit 0

