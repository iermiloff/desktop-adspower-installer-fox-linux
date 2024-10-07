#!/bin/bash

# Define color codes
INFO='\033[0;36m'  # Cyan
BANNER='\033[0;35m' # Magenta
WARNING='\033[0;33m'
ERROR='\033[0;31m'
SUCCESS='\033[0;32m'
NC='\033[0m' # No Color

# Display Banner
echo -e "${BANNER}"
echo "  _____            _    _                                    _     _____                            "
echo " |  __ \          | |  | |                 _        /\      | |   |  __ \                           "
echo " | |  | | ___  ___| | _| |_ ___  _ __    _| |_     /  \   __| |___| |__) |____      _____ _ __       "
echo " | |  | |/ _ \/ __| |/ / __/ _ \| '_ \  |_   _|   / /\ \ / _\` / __|  ___/ _ \ \ /\ / / _ \ '__|      "
echo " | |__| |  __/\__ \   <| || (_) | |_) |   |_|    / ____ \ (_| \__ \ |  | (_) \ V  V /  __/ |         "
echo " |_____/ \___||___/_|\_\\__\___/| .__/     _    /_/    \_\__,_|___/_|   \___/ \_/\_/ \___|_|         "
echo " |_   _|         | |      | | | | |       | |                                                        "
echo "   | |  _ __  ___| |_ __ _| | | |_| _ __  | |__  _   _                                               "
echo "   | | | '_ \/ __| __/ _\` | | |/ _ \ '__| | '_ \| | | |                                              "
echo "  _| |_| | | \__ \ || (_| | | |  __/ |    | |_) | |_| |                                              "
echo " |_____|_| |_|___/\__\__,_|_|_|\___|_|    |_.__/ \__, |                                              "
echo "                                                  __/ |                                              "
echo "  _   _           _      ____        _      __   |___/    _ _          _      _      __              "
echo " | \ | |         | |    |  _ \      | |    / /   | |     | (_)        (_)    | |     \ \             "
echo " |  \| | ___   __| | ___| |_) | ___ | |_  | |    | |_   _| |___      ___  ___| | _____| |            "
echo " | . \ |/ _ \ / _\` |/ _ \  _ < / _ \| __| | |_   | | | | | | \ \ /\ / / |/ __| |/ / __| |            "
echo " | |\  | (_) | (_| |  __/ |_) | (_) | |_  | | |__| | |_| | | |\ V  V /| | (__|   <\__ \ |            "
echo " |_| \_|\___/ \__,_|\___|____/ \___/ \__| | |\____/ \__,_|_|_| \_/\_/ |_|\___|_|\_\___/ |            "
echo "  ______ ______ ______ ______ ______ ______\_\____ ______ ______ ______ ______ ______ ______/_/____ "
echo " |______|______|______|______|______|______|______|______|______|______|______|______|______|______| "
echo -e "${NC}"

# Prompt for username and password
while true; do
    read -p "Enter the username for remote desktop: " USER
    if [[ "$USER" == "root" ]]; then
        echo -e "${ERROR}Error: 'root' cannot be used as the username. Please choose a different username.${NC}"
    elif [[ "$USER" =~ [^a-zA-Z0-9] ]]; then
        echo -e "${ERROR}Error: Username contains forbidden characters. Only alphanumeric characters are allowed.${NC}"
    else
        break
    fi
done

while true; do
    read -sp "Enter the password for $USER: " PASSWORD
    echo
    if [[ "$PASSWORD" =~ [^a-zA-Z0-9] ]]; then
        echo -e "${ERROR}Error: Password contains forbidden characters. Only alphanumeric characters are allowed.${NC}"
    else
        break
    fi
done

echo -e "${INFO}Updating package list...${NC}"
sudo apt update

echo -e "${INFO}Installing XFCE Desktop for lower resource usage...${NC}"
sudo apt install -y xfce4 xfce4-goodies

echo -e "${INFO}Installing XRDP for remote desktop...${NC}"
sudo apt install -y xrdp

echo -e "${INFO}Adding the user $USER with the specified password...${NC}"
sudo useradd -m -s /bin/bash $USER
echo "$USER:$PASSWORD" | sudo chpasswd

echo -e "${INFO}Adding $USER to the sudo group...${NC}"
sudo usermod -aG sudo $USER

echo -e "${INFO}Configuring XRDP to use XFCE desktop...${NC}"
echo "xfce4-session" > ~/.xsession

echo -e "${INFO}Configuring XRDP to use lower resolution by default...${NC}"
sudo sed -i 's/^#xserverbpp=24/xserverbpp=16/' /etc/xrdp/xrdp.ini
echo -e "${SUCCESS}XRDP configuration updated to use lower color depth.${NC}"

echo -e "${INFO}Limiting the resolution to a maximum (1280x720)...${NC}"
sudo sed -i '/\[xrdp1\]/a max_bpp=16\nxres=1280\nyres=720' /etc/xrdp/xrdp.ini
echo -e "${SUCCESS}XRDP configuration updated to use lower resolution (1280x720).${NC}"

echo -e "${INFO}Restarting XRDP service...${NC}"
sudo systemctl restart xrdp

echo -e "${INFO}Enabling XRDP service at startup...${NC}"
sudo systemctl enable xrdp

# Install AdsPower dependencies and AdsPower
echo -e "${INFO}Installing dependencies for AdsPower...${NC}"
sudo apt install -y wget

echo -e "${INFO}Downloading AdsPower installation script...${NC}"
wget https://release.adspower.net/linux/AdsPower_linux_x86_64.sh -O adspower_install.sh

echo -e "${INFO}Making the AdsPower script executable...${NC}"
chmod +x adspower_install.sh

echo -e "${INFO}Running AdsPower installation script...${NC}"
sudo ./adspower_install.sh

echo -e "${SUCCESS}Installation complete. XFCE Desktop, XRDP, and AdsPower have been installed.${NC}"
echo -e "${INFO}You can now connect via Remote Desktop with the user $USER.${NC}"
