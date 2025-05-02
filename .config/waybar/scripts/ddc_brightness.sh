#!/bin/bash

# --- Configuration ---
VCP_CODE="10" # Standard VCP code for brightness
STEP=5        # How much to change brightness per scroll step
# Add --display option if needed, e.g., DDC_ARGS="--display 1"
DDC_ARGS=""
# Alternatively, uncomment and set display number if needed:
# DISPLAY_NUM=1
# if [ -n "$DISPLAY_NUM" ]; then
#     DDC_ARGS="--display $DISPLAY_NUM"
# fi

# --- Helper Function ---
get_brightness() {
    local output
    # Try without sudo first, then with sudo if needed (for initial setup)
    output=$(ddcutil $DDC_ARGS getvcp $VCP_CODE 2>/dev/null) || output=$(sudo ddcutil $DDC_ARGS getvcp $VCP_CODE 2>/dev/null)

    if [[ $output =~ current\ value\ =\ *([0-9]+) ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo "ERR" # Return error indicator
    fi
}

# --- Actions ---
action_get() {
    local current_brightness=$(get_brightness)
    local text=""
    local tooltip=""

    if [[ "$current_brightness" == "ERR" ]]; then
        text="ERR"
        tooltip="Error getting brightness via ddcutil"
    else
        text="$current_brightness" # Just the number
        tooltip="Brightness: $current_brightness%"
    fi

    # Output JSON for Waybar - percentage is used by format-icons
    printf '{"text": "%s", "tooltip": "%s", "percentage": %s}\n' "$text" "$tooltip" "$current_brightness"
}

action_inc() {
    # Try without sudo first
    ddcutil $DDC_ARGS setvcp $VCP_CODE + $STEP > /dev/null 2>&1 || sudo ddcutil $DDC_ARGS setvcp $VCP_CODE + $STEP > /dev/null 2>&1
}

action_dec() {
    # Try without sudo first
    ddcutil $DDC_ARGS setvcp $VCP_CODE - $STEP > /dev/null 2>&1 || sudo ddcutil $DDC_ARGS setvcp $VCP_CODE - $STEP > /dev/null 2>&1
}

# --- Main Argument Handling ---
case "$1" in
    inc)
        action_inc
        ;;
    dec)
        action_dec
        ;;
    *) # No arguments or unknown - display current state
        action_get
        ;;
esac

exit 0
