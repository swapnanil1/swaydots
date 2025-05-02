#!/bin/bash

# Check if playerctl is available and a player is running
if ! command -v playerctl &> /dev/null || ! playerctl status &> /dev/null; then
    # No playerctl or no player active
    printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' "" "No player active" "stopped"
    exit 0
fi

PLAYER_STATUS=$(playerctl status)
ICON=""
TOOLTIP_TEXT=""

# Determine Icon based on status
if [[ "$PLAYER_STATUS" == "Playing" ]]; then
    ICON=""
elif [[ "$PLAYER_STATUS" == "Paused" ]]; then
    ICON=""
else # Includes "Stopped" and potentially others
    ICON=""
    PLAYER_STATUS="Stopped" # Normalize to Stopped
fi

# Get Metadata for Tooltip (handle cases where metadata might be unavailable)
TITLE=$(playerctl metadata --format '{{title}}' 2>/dev/null || echo "Unknown Title")
ARTIST=$(playerctl metadata --format '{{artist}}' 2>/dev/null || echo "Unknown Artist")
PLAYER=$(playerctl metadata --format '{{playerName}}' 2>/dev/null || echo "Unknown Player")

# Construct Tooltip
if [[ "$PLAYER_STATUS" == "Stopped" ]]; then
    TOOLTIP_TEXT="Player stopped"
elif [[ "$TITLE" == "Unknown Title" && "$ARTIST" == "Unknown Artist" ]]; then
     TOOLTIP_TEXT="Player: $PLAYER | Status: $PLAYER_STATUS" # Fallback if no metadata
else
    TOOLTIP_TEXT="Player: $PLAYER | $TITLE - $ARTIST"
fi


# Output JSON for Waybar
printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' \
       "$ICON" \
       "$TOOLTIP_TEXT" \
       "$(echo $PLAYER_STATUS | tr '[:upper:]' '[:lower:]')" # Use lowercase status (playing, paused, stopped) as class
