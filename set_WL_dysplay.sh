#!/bin/bash

# Find the Wayland display dynamically
WAYLAND_DISPLAY_PATH=$(ls /run/user/$(id -u)/wayland-* 2>/dev/null | head -n 1)

# Check if the display exists
if [ -n "$WAYLAND_DISPLAY_PATH" ]; then
  # Extract the display name (e.g., wayland-0, wayland-1)
  export WAYLAND_DISPLAY=$(basename "$WAYLAND_DISPLAY_PATH")
  echo "WAYLAND_DISPLAY set to $WAYLAND_DISPLAY"
else
  echo "Error: No Wayland display found in /run/user/$(id -u)/"
  exit 1
fi
