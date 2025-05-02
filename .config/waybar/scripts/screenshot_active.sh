#!/bin/bash

# Directory where screenshots will be saved
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
# Ensure the directory exists
mkdir -p "$SCREENSHOT_DIR"

# Get geometry of the active window using hyprctl
# Use jq for more robust JSON parsing if available, otherwise fallback to grep/sed
if command -v jq &> /dev/null; then
    ACTIVE_WINDOW_INFO=$(hyprctl activewindow -j)
    POS=$(echo "$ACTIVE_WINDOW_INFO" | jq -r '.at | "\(.[0]),\(.[1])"')
    SIZE=$(echo "$ACTIVE_WINDOW_INFO" | jq -r '.size | "\(.[0])x\(.[1])"')
    GEOMETRY="$POS $SIZE"
else
    # Fallback using grep/sed (less robust if output format changes)
    WINDOW_INFO_TMP=$(mktemp)
    hyprctl activewindow > "$WINDOW_INFO_TMP"
    if ! grep -q 'Window ' "$WINDOW_INFO_TMP"; then
        notify-send -u critical "Screenshot Failed" "No active window found."
        rm "$WINDOW_INFO_TMP"
        exit 1
    fi
    POS=$(grep 'at:' "$WINDOW_INFO_TMP" | sed 's/.*at: //')
    SIZE=$(grep 'size:' "$WINDOW_INFO_TMP" | sed 's/.*size: //')
    GEOMETRY="$POS $SIZE"
    rm "$WINDOW_INFO_TMP"
fi


# Check if we got valid geometry
if [[ -z "$POS" || -z "$SIZE" ]]; then
    notify-send -u critical "Screenshot Failed" "Could not determine active window geometry."
    exit 1
fi

# Generate the filename with timestamp
FILENAME="$SCREENSHOT_DIR/satty-$(date '+%Y%m%d-%H%M%S')-window.png"

# Execute the screenshot and annotation pipeline for the active window
# Capture the specific geometry, output PPM to stdout, pipe to satty
grim -g "$GEOMETRY" -t ppm - | satty --filename - --output-filename "$FILENAME"

# Optional: Notify user upon success
if [ -f "$FILENAME" ]; then
     notify-send "Screenshot Saved" "Annotated window screenshot saved to:\n$FILENAME" -i "$FILENAME"
else
     # Satty might have been cancelled, or an error occurred
     notify-send -u normal "Screenshot Info" "Satty screenshot process finished (Window)."
fi

exit 0
