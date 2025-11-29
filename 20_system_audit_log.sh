#!/bin/bash
report="/tmp/system_audit_$(date +%F).txt"

{
	    echo "=== SECURITY AUDIT REPORT ==="
	        echo "Date: $(date)"
		    echo "Logged-in Users:"
		        who
			    echo ""
			        echo "Open Ports:"
				    sudo netstat -tuln
				        echo ""
					    echo "Sudo Users:"
					        grep '^sudo:.*$' /etc/group
						    echo ""
						        echo "Recent Logins:"
							    last | head -n 10
						    } > "$report"

					    zenity --text-info --title="System Audit Report" --filename="$report"
