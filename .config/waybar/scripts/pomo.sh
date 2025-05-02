#!/bin/bash

# --- Settings ---
POMO_DURATION_MIN=25 # Pomodoro duration in minutes
SOUND_FILE_NAME="notify.mp3" # Name of the sound file in the script's directory

# --- State Files ---
STATE_FILE="/tmp/waybar_pomo_state"
END_TIME_FILE="/tmp/waybar_pomo_end_time"
PAUSED_TIME_FILE="/tmp/waybar_pomo_paused_time"

# --- Icons (Font Awesome) ---
ICON_DEFAULT=""  # fa-clock-o
ICON_RUNNING="" # fa-clock-o
ICON_PAUSED=""  # fa-pause

# --- Determine Script Directory and Sound File Path ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SOUND_FILE_PATH="$SCRIPT_DIR/$SOUND_FILE_NAME"

# --- Functions ---
get_state() {
    cat "$STATE_FILE" 2>/dev/null || echo "stopped"
}

set_state() {
    echo "$1" > "$STATE_FILE"
}

format_time() {
    local total_seconds=$1
    local minutes=$((total_seconds / 60))
    local seconds=$((total_seconds % 60))
    printf "%02d:%02d" "$minutes" "$seconds"
}

play_sound() {
    if [ -f "$SOUND_FILE_PATH" ]; then
        # Play sound in background, no video, suppress terminal output
        # If mpv keeps opening a window, try adding --wid=0
        mpv --no-video --really-quiet "$SOUND_FILE_PATH" &
    else
        # Optional: Notify if sound file is missing
        notify-send "Pomodoro Alert" "Sound file not found: $SOUND_FILE_PATH" -i dialog-warning -t 3000
    fi
}

# --- Actions ---
action_start() {
    local end_time=$(( $(date +%s) + POMO_DURATION_MIN * 60 ))
    echo "$end_time" > "$END_TIME_FILE"
    rm -f "$PAUSED_TIME_FILE"
    set_state "running"
    action_display # Update Waybar immediately
}

action_toggle_pause() {
    local state=$(get_state)
    if [[ "$state" == "running" ]]; then
        local end_time=$(cat "$END_TIME_FILE" 2>/dev/null || echo 0)
        local current_time=$(date +%s)
        local remaining=$((end_time - current_time))
        if (( remaining > 0 )); then
            echo "$remaining" > "$PAUSED_TIME_FILE"
            set_state "paused"
            rm -f "$END_TIME_FILE"
        else
            action_stop # Call stop if already finished
        fi
    elif [[ "$state" == "paused" ]]; then
        local paused_remaining=$(cat "$PAUSED_TIME_FILE" 2>/dev/null || echo 0)
        if (( paused_remaining > 0 )); then
            local new_end_time=$(( $(date +%s) + paused_remaining ))
            echo "$new_end_time" > "$END_TIME_FILE"
            set_state "running"
            rm -f "$PAUSED_TIME_FILE"
        else
            action_stop # Call stop if paused but no time left
        fi
    fi
    action_display # Update Waybar immediately
}

action_stop() {
    set_state "stopped"
    rm -f "$END_TIME_FILE" "$PAUSED_TIME_FILE"
    action_display # Update Waybar immediately
}

action_display() {
    local state=$(get_state)
    local text=""
    local tooltip=""
    local class=""

    case "$state" in
        running)
            local end_time=$(cat "$END_TIME_FILE" 2>/dev/null || echo 0)
            local current_time=$(date +%s)
            local remaining=$((end_time - current_time))

            if (( remaining <= 0 )); then
                # --- Timer Finished ---
                # 1. Send Notification
                notify-send "Pomodoro Finished!" "Time for a break." -i clock-symbolic -u critical -t 5000 # Requires libnotify
                # 2. Play Sound
                play_sound
                # 3. Reset State (this will trigger another display call)
                action_stop
                exit 0 # Exit cleanly after triggering stop
            else
                # --- Timer Running ---
                text=$(format_time "$remaining")
                tooltip="Pomodoro Running: ${text} remaining"
                class="running"
            fi
            ;;
        paused)
            local paused_remaining=$(cat "$PAUSED_TIME_FILE" 2>/dev/null || echo 0)
            text=$(format_time "$paused_remaining")
            tooltip="Pomodoro Paused: ${text} left"
            class="paused"
            text="$ICON_PAUSED $text"
            ;;
        stopped|*) # Default to stopped state
            text="$ICON_DEFAULT"
            tooltip="Pomodoro Stopped"
            class="stopped"
            ;;
    esac

    # Output JSON for Waybar
    printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' "$text" "$tooltip" "$class"
}

# --- Main Argument Handling ---
case "$1" in
    start)
        action_start
        ;;
    toggle_pause)
        action_toggle_pause
        ;;
    stop)
        action_stop
        ;;
    *) # No arguments or unknown - just display current state
        action_display
        ;;
esac

exit 0
