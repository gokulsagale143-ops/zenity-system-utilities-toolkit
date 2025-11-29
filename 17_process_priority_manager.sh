#!/bin/bash

# Ask user for PID
pid=$(zenity --entry --text="Enter Process ID (PID):")

# If PID provided
if [ -n "$pid" ]; then

	    # Get OLD PRIORITY from 'top -b -n1'
	        old_pr=$(top -b -n1 -p "$pid" | awk 'NR>7 {print $3}')

		    # If no process found
		        if [ -z "$old_pr" ]; then
				        zenity --error --text="No such PID found in system."
					        exit 1
						    fi

						        # Set real-time priority = 1 (highest RT)
							    sudo chrt -r -p 1 "$pid"

							        # Get NEW PRIORITY from top again
								    new_pr=$(top -b -n1 -p "$pid" | awk 'NR>7 {print $3}')

								        # Show result
									    zenity --info --text="Real-Time Priority Updated!
									        
									    Old Priority (PR): $old_pr
									    New Priority (PR): $new_pr
									    PID: $pid
									    "
fi

