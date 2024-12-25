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

# Configure XRDP to use XFCE
echo -e "${INFO}Configuring XRDP to use XFCE desktop...${NC}"
echo "xfce4-session" | tee ~/.xsession > /dev/null

# Configure XRDP to use lower resolution and color depth
echo -e "${INFO}Configuring XRDP to use lower resolution and color depth...${NC}"
sudo sed -i 's/^#xserverbpp=24/xserverbpp=16/' /etc/xrdp/xrdp.ini
sudo sed -i '/\[xrdp1\]/a max_bpp=16\nxres=1024\nyres=768' /etc/xrdp/xrdp.ini
echo -e "${SUCCESS}XRDP configuration updated to use lower settings.${NC}"

# Restart XRDP service
echo -e "${INFO}Restarting XRDP service...${NC}"
sudo systemctl restart xrdp

# Enable XRDP service at startup
echo -e "${INFO}Enabling XRDP service at startup...${NC}"
sudo systemctl enable xrdp

# Ensure the Desktop directory exists
DESKTOP_DIR="/home/$USER/Desktop"
if [ ! -d "$DESKTOP_DIR" ]; then
    echo -e "${INFO}Desktop directory not found. Creating Desktop directory...${NC}"
    mkdir -p "$DESKTOP_DIR"
fi

# Install curl and gdebi for handling .deb files
echo -e "${INFO}Installing curl and gdebi for handling .deb files...${NC}"
sudo apt update && sudo apt install -y curl gdebi-core

# Download AdsPower .deb package
ADSP_VERSION="6.10.20"
ADSP_DEB="AdsPower-Global-${ADSP_VERSION}-x64.deb"
echo -e "${INFO}Downloading AdsPower package version ${ADSP_VERSION}...${NC}"
curl -O "https://version.adspower.net/software/linux-x64-global/${ADSP_DEB}"

# Install AdsPower using gdebi
echo -e "${INFO}Installing AdsPower version ${ADSP_VERSION} using gdebi...${NC}"
sudo gdebi -n "$ADSP_DEB"

# Clean up installation files
echo -e "${INFO}Cleaning up temporary files...${NC}"
rm -f "$ADSP_DEB"

# Get the server IP address
IP_ADDR=$(hostname -I | awk '{print $1}')

# Final message
echo -e "${SUCCESS}Installation complete. XFCE Desktop, XRDP, and AdsPower ${ADSP_VERSION} have been installed.${NC}"
echo -e "${INFO}You can now connect via Remote Desktop with the following details:${NC}"
echo -e "${INFO}IP ADDRESS: ${SUCCESS}$IP_ADDR${NC}"
echo -e "${INFO}USER: ${SUCCESS}$USER${NC}"

# Prompt for reboot
read -p "Reboot now to apply changes? (y/n): " REBOOT_CONFIRM
if [[ "$REBOOT_CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "${INFO}Rebooting system...${NC}"
    sudo reboot
else
    echo -e "${INFO}Reboot later to apply changes.${NC}"
fi

