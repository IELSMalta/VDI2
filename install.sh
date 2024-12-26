#!/bin/bash

# Update package lists
sudo apt update

# Install all required software in one command
sudo apt install -y \
    pipewire \
    pipewire-audio-client-libraries \
    pipewire-pulse \
    wireplumber \
    libspa-0.2-bluetooth \
    pavucontrol \
    alsa-utils \
    sway \
    freerdp2-wayland \
    wayvnc

# Export the necessary environment variable for systemd user services
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus

# Enable and start PipeWire services for the user
systemctl --user enable pipewire wireplumber pipewire-pulse
systemctl --user start pipewire wireplumber pipewire-pulse

# Disable and stop PulseAudio
systemctl --user mask pulseaudio
systemctl --user stop pulseaudio

# Create Sway configuration directory and file
mkdir -p /home/vdi/.config/sway
mv /home/vdi/vdi2/config /home/vdi/.config/sway

# Edit getty@tty1.service to enable autologin
sudo systemctl edit getty@tty1.service <<EOL
# Added configuration
[Service]

ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin vdi %I $TERM

Type=idle
EOL

# Add auto sway to .bash_profile for user vdi
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && sway --' >> /home/vdi/.bash_profile

# Confirm installation success
if [ $? -eq 0 ]; then
    echo "Installation completed successfully."
else
    echo "An error occurred during the installation. Please check the output for details."
    exit 1
fi
