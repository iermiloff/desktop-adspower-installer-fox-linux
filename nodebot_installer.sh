#!/bin/bash

# Define color codes
INFO='\033[0;36m'  # Cyan
BANNER='\033[0;35m' # Magenta
WARNING='\033[0;33m'
ERROR='\033[0;31m'
SUCCESS='\033[0;32m'
NC='\033[0m' # No Color

# Display the banner
echo -e "${BANNER}"
echo "___________________________________________________________________________"
echo "   ________                 __      __                                    "
echo "   \______ \   ____   _____|  | ___/  |_  ____ ______                      "
echo "    |    |  \_/ __ \ /  ___/  |/ /\   __\/  _ \\____ \                     "
echo "    |    \`   \  ___/ \___ \|    <  |  | (  <_> )  |_> >                    "
echo "   /_______  /\___  >____  >__|_ \ |__|  \____/|   __/                     "
echo "           \/     \/     \/     \/             |__|                        "
echo "     ____       _____       .___     __________                            "
echo "    /  _ \     /  _  \    __| _/_____\______   \______  _  __ ___________  "
echo "    >  _ </\  /  /_\  \  / __ |/  ___/|     ___/  _ \ \/ \/ // __ \_  __ \ "
echo "   /  <_\ \/ /    |    \/ /_/ |\___ \ |    |  (  <_> )     /\  ___/|  | \/ "
echo "   \_____\ \ \____|__  /\____ /____  >|____|   \____/ \/\_/  \___  >__|    "
echo "          \/         \/      \/    \/                            \/        "
echo "   .___                 __         .__  .__                               "
echo "   |   | ____   _______/  |______  |  | |  |   ___________                 "
echo "   |   |/    \ /  ___/\   __\__  \ |  | |  | _/ __ \_  __ \                "
echo "   |   |   |  \\___ \  |  |  / __ \|  |_|  |_\  ___/|  | \/                "
echo "   |___|___|  /____  > |__| (____  /____/____/\___  >__|                   "
echo "            \/     \/            \/               \/                       "
echo "___________________________________________________________________________"
echo "                     Script by NodeBot (Juliwicks)                         "
echo "___________________________________________________________________________"
echo -e "${NC}"
echo "Welcome to the NodeBot setup script by Juliwicks!"
echo "This script will install and configure XFCE, XRDP, and AdsPower."

# Update System
echo "Updating the system..."
apt update -y && apt upgrade -y

# Install Dependencies
echo "Installing required dependencies..."
apt install -y curl gdebi-core

# AdsPower Installation
echo "Downloading and installing AdsPower..."
wget https://download.adspower.com/download/AdsPower_linux64.deb
gdebi --non-interactive AdsPower_linux64.deb
rm AdsPower_linux64.deb
ln -s /opt/ads_power/AdsPower /home/$USER/Desktop/AdsPower
chown $USER:$USER /home/$USER/Desktop/AdsPower

# XFCE and XRDP Installation
echo "Installing XFCE and XRDP..."
apt install -y xfce4 xfce4-goodies xrdp

# Configure XRDP
echo "Configuring XRDP to use XFCE..."
echo "xfce4-session" > /etc/skel/.xsession
sed -i 's/^exec/#exec/' /etc/xrdp/startwm.sh
echo "startxfce4" >> /etc/xrdp/startwm.sh
systemctl enable xrdp

# User and Password Handling
read -p "Enter a username for XRDP login: " XRDP_USER
adduser $XRDP_USER
echo "User $XRDP_USER created successfully!"

# XRDP Resolution and Color Depth Configuration
echo "Configuring XRDP resolution and color depth..."
read -p "Enter desired screen width (e.g., 1600): " xres
read -p "Enter desired screen height (e.g., 900): " yres
read -p "Enter desired color depth (e.g., 24): " max_bpp

sed -i "/^max_bpp=/c\max_bpp=$max_bpp" /etc/xrdp/xrdp.ini
sed -i "/^xrdp1=/a\xres=$xres\nyres=$yres" /etc/xrdp/xrdp.ini

# Final Reboot Step
IP_ADDR=$(hostname -I | awk '{print $1}')
echo "Setup complete!"
echo "--------------------------------------"
echo "Connection Details:"
echo "Server IP Address: $IP_ADDR"
echo "Username: $XRDP_USER"
echo "Password: [Set during user creation]"
echo "--------------------------------------"
echo "Rebooting the system now..."
reboot

