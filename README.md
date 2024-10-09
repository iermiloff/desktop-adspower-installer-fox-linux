# Automated Desktop and AdsPower Installer for Linux VPS

This script automates the setup of a desktop environment and AdsPower on your Linux VPS, making it easy to manage multiple bots or nodes. All you need to do is provide a non-root username and password for your remote desktop connection, and the script will handle the rest.

## AdsPower Registration (Referral)

If you’re looking to manage multiple browser profiles effortlessly, AdsPower is the perfect tool for you. Follow these steps to register:

### Step 1: Open AdsPower

Click the link below to start the registration process:

[**AdsPower Registration Link**](https://share.adspower.net/3wadZL) or https://share.adspower.net/3wadZL

### Step 2: Begin Registration

Once the page opens, you’ll see the AdsPower sign-up form. Click on the **“Sign Up”** button to create your account.

### Step 3: Fill in Your Details

Complete the registration form with the following information:

- **Email:** Enter your active email address.
- **Password:** Choose a strong password for your account.
- **Referral Code:** `3wadZL`

Agree to the terms and conditions and proceed.

### Step 4: Verify Your Email

After submitting the registration form, AdsPower will send a verification email to the address you provided. Open the email and click the verification link to activate your account.

## How to Use the Installer Script

1. **Log into your VPS via SSH** using a terminal application like Putty or Termius.
2. Run the following commands to start the installation process:

    ```bash
    sudo apt update
    sudo apt install curl
    curl -O https://raw.githubusercontent.com/juliwicks/desktop-adspower-installer-fox-linux/refs/heads/main/nodebot_installer.sh && chmod +x nodebot_installer.sh && ./nodebot_installer.sh
    ```

3. When prompted, **enter the username and password** you’d like to use for your remote desktop connection. Avoid using the root username for security reasons.
4. The script will install the desktop environment and AdsPower. Simply wait until everything is fully installed.

## Accessing Your VPS Desktop

1. After installation, open **Remote Desktop Connection** on your PC.
2. Enter your **VPS address** and connect.
3. Input the **username and password** you provided during the setup.
4. Once connected, you can access **AdsPower Global** on your Linux VPS.

## Notes

- Make sure your VPS has sufficient resources (RAM, CPU, etc.) to handle multiple bot or node instances.
- For security, avoid using the root account for your desktop connection.

## Disclaimer

By following this guide, you acknowledge that the author is not responsible for any errors, omissions, or damages resulting from the use or inability to use the information provided. This includes, but is not limited to, any potential harm to your software, hardware, data, or other property.

## Credits

Script created by **Nodebot (Juliwicks)** to automate multi-purpose setups for bot farming and node operation.
