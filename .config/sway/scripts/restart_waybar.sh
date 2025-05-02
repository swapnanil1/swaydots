#!/bin/bash

# Terminate already running bar instances
# Use pkill to send SIGTERM (15) to all waybar processes
# -x ensures only processes named exactly "waybar" are matched
pkill -x waybar

# Wait a tiny bit for the process(es) to terminate. Adjust sleep time if needed.
sleep 0.2

# Launch Waybar, using default config location ~/.config/waybar/config
# The '&' runs it in the background
waybar &

# Send a notification indicating Waybar has been restarted
# Requires libnotify or a similar notification daemon (like Dunst) to be running
# Using dunstify might be more specific if you know dunst is running:
# dunstify -a "Sway" -i information-symbolic -t 2000 "Waybar Restarted"
# Otherwise, notify-send is more generic:
notify-send "Waybar" "Waybar Restarted" -i information-symbolic -t 2000 # Standard icon, 2 sec timeout

exit 0
