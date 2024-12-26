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
    freerdp2-wayland

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
mkdir -p ~/.config/sway
cat <<EOL > ~/.config/sway/config
set \$mod Mod4
set \$left h
set \$down j
set \$up k
set \$right l
set \$term foot
set \$menu dmenu_path | dmenu | xargs swaymsg exec --
include /etc/sway/config-vars.d/*
output * bg /home/vdi/vdi2/wall.webp fill
bindsym \$mod+Return exec \$term
bindsym \$mod+Shift+q kill
bindsym \$mod+d exec \$menu
floating_modifier \$mod normal
bindsym \$mod+Shift+c reload
bindsym \$mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
bindsym \$mod+\$left focus left
bindsym \$mod+\$down focus down
bindsym \$mod+\$up focus up
bindsym \$mod+\$right focus right
bindsym \$mod+Left focus left
bindsym \$mod+Down focus down
bindsym \$mod+Up focus up
bindsym \$mod+Right focus right
bindsym \$mod+Shift+\$left move left
bindsym \$mod+Shift+\$down move down
bindsym \$mod+Shift+\$up move up
bindsym \$mod+Shift+\$right move right
bindsym \$mod+Shift+Left move left
bindsym \$mod+Shift+Down move down
bindsym \$mod+Shift+Up move up
bindsym \$mod+Shift+Right move right
bindsym \$mod+b splith
bindsym \$mod+v splitv
bindsym \$mod+s layout stacking
bindsym \$mod+w layout tabbed
bindsym \$mod+e layout toggle split
bindsym \$mod+f fullscreen
bindsym \$mod+Shift+space floating toggle
bindsym \$mod+space focus mode_toggle
bindsym \$mod+a focus parent
bindsym \$mod+Shift+minus move scratchpad
bindsym \$mod+minus scratchpad show
mode "resize" {
    bindsym \$left resize shrink width 10px
    bindsym \$down resize grow height 10px
    bindsym \$up resize shrink height 10px
    bindsym \$right resize grow width 10px
    bindsym Left resize shrink width 10px
    bindsym Down resize grow height 10px
    bindsym Up resize shrink height 10px
    bindsym Right resize grow width 10px
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym \$mod+r mode "resize"
include /etc/sway/config.d/*
exec bash /home/vdi2/rdp_connect.sh
EOL

# Confirm installation success
if [ $? -eq 0 ]; then
    echo "Installation completed successfully."
else
    echo "An error occurred during the installation. Please check the output for details."
    exit 1
fi
