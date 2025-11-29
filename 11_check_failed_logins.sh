#!/bin/bash
#
# Script: faillock_manager.sh
# Description: View REAL failed login attempts using faillock (RHEL 9.x compatible)
#

# -------------------------------
# Check Zenity
# -------------------------------
if ! command -v zenity &> /dev/null; then
	    echo "Zenity is not installed. Install using: sudo dnf install zenity"
	        exit 1
fi

# -------------------------------
# Function: Run faillock safely
# -------------------------------
run_faillock() {
	    local CMD="$1"
	        local TEMPFILE=$(mktemp)

		    # Save faillock output to temporary file
		        sudo bash -c "$CMD" > "$TEMPFILE" 2>&1

			    # Display in Zenity
			        zenity --text-info \
					        --width=900 --height=500 \
						        --title="faillock Output" \
							        --filename="$TEMPFILE"

				    rm -f "$TEMPFILE"
			    }

		    # -------------------------------
		    # Main Menu
		    # -------------------------------
		    while true; do
			        choice=$(zenity --list \
					        --title="Failed Login Manager (faillock)" \
						        --column="Select" \
							        "1. View ALL failed login attempts" \
								        "2. View failed attempts for a USER" \
									        "3. Reset failed attempts for a USER" \
										        "4. Exit" \
											        --width=500 --height=300)

				    case "$choice" in

					            "1. View ALL failed login attempts")
							                run_faillock "faillock --all"
									            ;;

										            "2. View failed attempts for a USER")
												                USER=$(zenity --entry --title="Enter Username" --text="Enter username:")
														            [ -z "$USER" ] && zenity --error --text="Username cannot be empty!" && continue
															                run_faillock "faillock --user $USER"
																	            ;;

																		            "3. Reset failed attempts for a USER")
																				                USER=$(zenity --entry --title="Reset User" --text="Enter username to reset:")
																						            [ -z "$USER" ] && zenity --error --text="Username cannot be empty!" && continue
																							                sudo faillock --user "$USER" --reset && \
																										                zenity --info --text="Failed attempts reset for $USER" || \
																												                zenity --error --text="Failed to reset. Check username."
																									            ;;

																										            "4. Exit")
																												                exit 0
																														            ;;
																															            *)
																																	                exit 0
																																			            ;;
																																				        esac
																																				done

