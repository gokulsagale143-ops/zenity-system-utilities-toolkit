#!/bin/bash
# -----------------------------------------------------------
# Nagios Core & Plugins FAST Automated Installer
# Optimized for parallel compilation and streamlined package installation.
# SELinux steps are excluded per previous request.
# -----------------------------------------------------------

set -e # Exit immediately if a command exits with a non-zero status.

NAGIOS_USER="nagiosadmin"
INSTALL_DIR="/usr/local/nagios"

# Determine number of CPU cores for parallel compilation, defaulting to 4
N_JOBS=$(nproc 2>/dev/null || echo 4)
echo "Using $N_JOBS jobs for compilation (make -j $N_JOBS)."

# --- Zenity Input Functions (Unchanged) ---

get_user_info() {
    local title="Nagios Installation Setup"
    local text="Please enter the **IP Address** of this server and the desired **Password** for the Nagios Web Interface.

The script will automatically use the username: **$NAGIOS_USER**."
    
    INPUT=$(zenity --forms --title="$title" --text="$text" \
        --add-entry="Server IP Address (e.g., 192.168.1.10):" \
        --add-password="Nagios Web Password:" \
        2>/dev/null)
    
    if [ $? -ne 0 ]; then
        echo "Installation cancelled by user."
        exit 1
    fi
    
    IFS='|' read -r SERVER_IP NAGIOS_PASSWORD <<< "$INPUT"
    
    if [ -z "$SERVER_IP" ] || [ -z "$NAGIOS_PASSWORD" ]; then
        zenity --error --text="IP Address and Password cannot be empty." 2>/dev/null
        exit 1
    fi
    
    if ! [[ $SERVER_IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        zenity --error --text="Invalid IP Address format." 2>/dev/null
        exit 1
    fi
    
    zenity --info --title="Confirmation" --text="Settings Confirmed:
    - **Nagios URL**: http://$SERVER_IP/nagios
    - **Admin Username**: $NAGIOS_USER

    Click OK to start the optimized installation." 2>/dev/null
}

# --- Core Installation Functions (Optimized) ---

install_prerequisites() {
    zenity --info --title="1. Installing ALL Prerequisites" --text="Installing core packages, development tools (for compilation), and monitoring dependencies (for plugins) in a single step using **dnf**..." 2>/dev/null
    
    # --- Install EPEL and enable optional repos first ---
    cd /tmp
    # Determine OS version for EPEL package URL
    if grep -q "release 9" /etc/redhat-release || grep -q "CentOS Stream 9" /etc/os-release; then
        dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
        dnf config-manager --set-enabled crb
    else
        dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
        subscription-manager repos --enable=rhel-8-server-optional-rpms || true # Ignore error if not RHEL
    fi

    if grep -q "Oracle Linux" /etc/os-release; then
        dnf install -y dnf-utils
        dnf config-manager --enable ol8_optional_latest ol9_optional_latest || true
    fi

    # --- Combined Package Installation (Core + Plugins + Dependencies) ---
    # Core: httpd, php, postfix, wget, gd-devel, openssl-devel
    # Compilation: gcc, glibc, glibc-common, make, gettext, automake, autoconf
    # Plugins/SNMP: net-snmp, net-snmp-utils, perl-Net-SNMP, perl, s-nail (RHEL 9)
    
    DNF_PACKAGES="httpd php postfix wget gd-devel openssl-devel \
                  gcc glibc glibc-common make gettext automake autoconf \
                  net-snmp net-snmp-utils perl-Net-SNMP perl"
    
    # Add s-nail for RHEL 9/CentOS 9 if needed
    if grep -q "release 9" /etc/redhat-release || grep -q "CentOS Stream 9" /etc/os-release; then
        DNF_PACKAGES="$DNF_PACKAGES s-nail"
    fi

    dnf install -y $DNF_PACKAGES
    dnf update -y
    
    echo "All prerequisites installed."
}

download_nagios_core() {
    zenity --info --title="2. Downloading Nagios Core Source" --text="Downloading the latest stable version of Nagios Core..." 2>/dev/null
    cd /tmp
    NAGIOS_URL=$(wget -q -O - https://api.github.com/repos/NagiosEnterprises/nagioscore/releases/latest | grep '"browser_download_url":' | grep -o 'https://[^"]*')
    wget --output-document="nagioscore.tar.gz" "$NAGIOS_URL"
    tar xzf nagioscore.tar.gz
    NAGIOS_DIR=$(tar tzf nagioscore.tar.gz | head -1 | cut -f1 -d"/")
    cd "$NAGIOS_DIR"
    echo "Nagios Core downloaded and extracted."
}

compile_and_install_core() {
    zenity --info --title="3. Compiling and Installing Nagios Core (Parallel)" --text="Configuring, and compiling Nagios Core using **make -j $N_JOBS** for speed. This step is much faster." 2>/dev/null
    
    ./configure
    make all -j $N_JOBS
    
    # Installation Steps
    make install-groups-users
    usermod -a -G nagios apache
    make install
    make install-daemoninit
    systemctl enable httpd.service
    make install-commandmode
    make install-config
    make install-webconf
    
    echo "Nagios Core compiled and installed."
}

# --- Plugins Installation Functions (Optimized) ---

download_plugins() {
    zenity --info --title="4. Downloading Nagios Plugins Source" --text="Downloading the latest stable version of Nagios Plugins..." 2>/dev/null
    cd /tmp
    PLUGINS_URL=$(wget -q -O - https://api.github.com/repos/nagios-plugins/nagios-plugins/releases/latest | grep '"browser_download_url":' | grep -o 'https://[^"]*')
    wget --output-document="nagios-plugins.tar.gz" "$PLUGINS_URL"
    tar zxf nagios-plugins.tar.gz
    PLUGINS_DIR=$(tar tzf nagios-plugins.tar.gz | head -1 | cut -f1 -d"/")
    cd "$PLUGINS_DIR"
    echo "Nagios Plugins downloaded and extracted."
}

compile_and_install_plugins() {
    zenity --info --title="5. Compiling and Installing Nagios Plugins (Parallel)" --text="Compiling and installing Nagios Plugins using **make -j $N_JOBS** for speed. This is the final step." 2>/dev/null
    
    ./configure
    make -j $N_JOBS
    make install
    
    echo "Nagios Plugins compiled and installed."
}

# --- Configuration & Services (Unchanged) ---

configure_nagios_admin() {
    zenity --info --title="6. Setting up Admin User" --text="Creating the Nagios web administration user: **$NAGIOS_USER**." 2>/dev/null
    (echo "$NAGIOS_PASSWORD"; echo "$NAGIOS_PASSWORD") | htpasswd -c -i $INSTALL_DIR/etc/htpasswd.users $NAGIOS_USER
    echo "Nagios admin user ($NAGIOS_USER) created."
}

configure_firewall() {
    zenity --info --title="7. Configuring Firewall" --text="Adding permanent and temporary exceptions for HTTP (port 80)." 2>/dev/null
    if systemctl is-active --quiet firewalld; then
        firewall-cmd --zone=public --add-port=80/tcp
        firewall-cmd --zone=public --add-port=80/tcp --permanent
        echo "Firewall configured for port 80."
    else
        echo "FirewallD is not running. Skipping firewall configuration."
    fi
}

start_services() {
    zenity --info --title="8. Starting Services" --text="Starting Apache (httpd) and the Nagios service." 2>/dev/null
    systemctl start httpd.service
    systemctl start nagios.service
    systemctl restart nagios.service
    echo "Services started."
}

# --- Main Execution ---

main() {
    get_user_info

    install_prerequisites # Now installs ALL dependencies for Core AND Plugins in one go.
    
    download_nagios_core
    compile_and_install_core # Optimized with make -j
    
    download_plugins
    compile_and_install_plugins # Optimized with make -j
    
    configure_firewall
    configure_nagios_admin
    start_services
    
    NAGIOS_URL="http://$SERVER_IP/nagios"
    zenity --info --title="✅ Installation Complete!" --text="Nagios Core and Plugins are successfully installed and optimized.

**To log in:**
- Open your browser to: **$NAGIOS_URL**
- **Username**: $NAGIOS_USER
- **Password**: The password you provided.

Attempting to open the browser now..." 2>/dev/null
    
    if command -v xdg-open &> /dev/null; then
        xdg-open "$NAGIOS_URL" &
    else
        zenity --warning --text="Could not automatically open the browser. Please manually navigate to: $NAGIOS_URL" 2>/dev/null
    fi
}

main
