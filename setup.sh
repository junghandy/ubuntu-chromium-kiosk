#!/bin/bash

# Setting hostname
sudo hostnamectl set-hostname ubuntu-kiosk

# Enabling auto-login to CLI
sudo systemctl set-default multi-user.target
sudo ln -fs /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo ln -fs /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty2.service
sudo ln -fs /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty3.service
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo mkdir -p /etc/systemd/system/getty@tty2.service.d
sudo mkdir -p /etc/systemd/system/getty@tty3.service.d
echo -e '[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin pi --noclear %I \$TERM\n' | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf
echo -e '[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin pi --noclear %I \$TERM\n' | sudo tee /etc/systemd/system/getty@tty2.service.d/autologin.conf
echo -e '[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin pi --noclear %I \$TERM\n' | sudo tee /etc/systemd/system/getty@tty3.service.d/autologin.conf

# Setup timezone
sudo dpkg-reconfigure tzdata

# Silencing console logins to avoid a brief flash of the console login before X comes up
# "perl" is more cross-platform than "sed -i"
# TODO: Replace with "sed -i"
sudo perl -i -p0e 's#--autologin pi#--skip-login --noissue --login-options \"-f pi\"#g' /etc/systemd/system/getty@tty1.service.d/autologin.conf

# Install packages
sudo apt-get update
sudo apt-get install -y vim matchbox-window-manager unclutter mailutils nitrogen jq chromium-browser xserver-xorg xinit rpd-plym-splash xdotool rng-tools xinput-calibrator cec-utils cron

# Copy the home folder contents
cp -rf ./home/* ~

# Setting the spash screen background
cp -f ~/background.png /usr/share/plymouth/themes/spinner/watermark.png

# Installing the default crontab
crontab ~/crontab.example