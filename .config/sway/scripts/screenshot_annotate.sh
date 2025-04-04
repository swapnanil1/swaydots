#!/bin/sh

# Directory where screenshots will be saved
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# Ensure the directory exists
mkdir -p "$SCREENSHOT_DIR"

# Get geometry from slurp. Use specified options.
# Exit if slurp is cancelled (outputs empty string).
GEOMETRY=$(slurp -o -r -c '#ff0000ff')
if [ -z "$GEOMETRY" ]; then
    echo "Screenshot selection cancelled."
    # Optional: notify user about cancellation
    # notify-send "Screenshot Cancelled" "Selection was aborted."
    exit 1
fi

# Generate the filename with timestamp
FILENAME="$SCREENSHOT_DIR/satty-$(date '+%Y%m%d-%H:%M:%S').png"

# Execute the screenshot and annotation pipeline
grim -g "$GEOMETRY" -t ppm - | satty --filename - --fullscreen --output-filename "$FILENAME"

# Optional: Notify user upon success
# Check if satty actually created the file (though satty usually handles errors internally)
if [ -f "$FILENAME" ]; then
     notify-send "Screenshot Saved" "Annotated screenshot saved to:\n$FILENAME" -i "$FILENAME"
else
     notify-send -u critical "Screenshot Failed" "Failed to save annotated screenshot."
fi

exit 0
