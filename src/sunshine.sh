#!/usr/bin/env bash

# set -e

# Find niri socket and export NIRI_SOCKET
NIRI_SOCKET_PATH=$(ls /run/user/1000/niri.*.sock 2>/dev/null | head -n 1)

if [[ -z "$NIRI_SOCKET_PATH" ]]; then
  echo "Error: No niri socket found in /run/user/1000"
  exit 1
fi

export NIRI_SOCKET="$NIRI_SOCKET_PATH"

case "$1" in
  start)
    pkill steam 2> /dev/null || true
    niri msg output "DP-1" on
    niri msg output "DP-3" off
    niri msg output "HDMI-A-1" off
    # sudo -u logan setsid gamescope -e -W 3840 -H 2160 --fullscreen --expose-wayland steam 
    # sleep 2 && sudo -u logan steam steam://open/bigpicture
    ;;
  stop)
    niri msg output "DP-1" off
    niri msg output "DP-3" on
    niri msg output "HDMI-A-1" on
    sudo -u logan steam -shutdown
    ;;
  *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac
