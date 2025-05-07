#!/bin/bash

POMO_DURATION_MIN=25
BREAK_DURATION_MIN=5
SOUND_FILE_NAME="notify.mp3"

STATE_FILE="/tmp/waybar_pomo_state"
END_TIME_FILE="/tmp/waybar_pomo_end_time"
PAUSED_TIME_FILE="/tmp/waybar_pomo_paused_time"

ICON_STOPPED=""
ICON_RUNNING=""
ICON_PAUSED=""
ICON_BREAK_RUNNING="󰗊"
ICON_BREAK_PAUSED=""

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SOUND_FILE_PATH="$SCRIPT_DIR/$SOUND_FILE_NAME"

get_state() {
    cat "$STATE_FILE" 2>/dev/null || echo "stopped"
}

set_state() {
    echo "$1" > "$STATE_FILE"
}

format_time() {
    local total_seconds=$1
    if (( total_seconds < 0 )); then total_seconds=0; fi
    local minutes=$((total_seconds / 60))
    local seconds=$((total_seconds % 60))
    printf "%02d:%02d" "$minutes" "$seconds"
}

play_sound() {
    if [ -f "$SOUND_FILE_PATH" ]; then
        mpv --no-video --really-quiet "$SOUND_FILE_PATH" &>/dev/null &
    else
        notify-send "Pomodoro Alert" "Sound file missing:\n$SOUND_FILE_PATH" -i dialog-warning -t 3000
    fi
}

send_notification() {
    local title="$1"
    local message="$2"
    local icon="$3"
    local urgency="$4"
    notify-send "$title" "$message" -i "$icon" -u "$urgency" -t 5000
}

action_start_pomo() {
    local end_time=$(( $(date +%s) + POMO_DURATION_MIN * 60 ))
    echo "$end_time" > "$END_TIME_FILE"
    rm -f "$PAUSED_TIME_FILE"
    set_state "running"
    echo "Pomodoro started."
    action_display
}

action_start_break() {
    local end_time=$(( $(date +%s) + BREAK_DURATION_MIN * 60 ))
    echo "$end_time" > "$END_TIME_FILE"
    rm -f "$PAUSED_TIME_FILE"
    set_state "break_running"
    echo "Break started."
    action_display
}

action_toggle_pause() {
    local state=$(get_state)
    local current_time=$(date +%s)
    local end_time
    local remaining
    local next_state_paused
    local next_state_running

    case "$state" in
        running)
            end_time=$(cat "$END_TIME_FILE" 2>/dev/null || echo 0)
            remaining=$((end_time - current_time))
            next_state_paused="paused"
            ;;
        break_running)
            end_time=$(cat "$END_TIME_FILE" 2>/dev/null || echo 0)
            remaining=$((end_time - current_time))
            next_state_paused="break_paused"
            ;;
        paused)
            remaining=$(cat "$PAUSED_TIME_FILE" 2>/dev/null || echo 0)
            next_state_running="running"
            ;;
        break_paused)
            remaining=$(cat "$PAUSED_TIME_FILE" 2>/dev/null || echo 0)
            next_state_running="break_running"
            ;;
        *)
            action_display
            return
            ;;
    esac

    if [[ "$state" == "running" || "$state" == "break_running" ]]; then
        if (( remaining > 0 )); then
            echo "$remaining" > "$PAUSED_TIME_FILE"
            set_state "$next_state_paused"
            rm -f "$END_TIME_FILE"
            echo "Timer paused."
        else
            action_stop
        fi
    elif [[ "$state" == "paused" || "$state" == "break_paused" ]]; then
        if (( remaining > 0 )); then
            local new_end_time=$(( current_time + remaining ))
            echo "$new_end_time" > "$END_TIME_FILE"
            set_state "$next_state_running"
            rm -f "$PAUSED_TIME_FILE"
            echo "Timer resumed."
        else
            action_stop
        fi
    fi
    action_display
}

action_stop() {
    set_state "stopped"
    rm -f "$END_TIME_FILE" "$PAUSED_TIME_FILE"
    echo "Pomodoro stopped."
    action_display
}

action_display() {
    local state=$(get_state)
    local text=""
    local tooltip=""
    local class=""
    local current_time=$(date +%s)
    local end_time
    local remaining

    case "$state" in
        running)
            end_time=$(cat "$END_TIME_FILE" 2>/dev/null || echo 0)
            remaining=$((end_time - current_time))

            if (( remaining <= 0 )); then
                send_notification "Pomodoro Finished!" "Time for a ${BREAK_DURATION_MIN} min break." "clock-symbolic" "critical"
                play_sound
                action_start_break
                exit 0
            else
                text="$ICON_RUNNING $(format_time "$remaining")"
                tooltip="Work: $(format_time "$remaining") remaining"
                class="running"
            fi
            ;;
        paused)
            remaining=$(cat "$PAUSED_TIME_FILE" 2>/dev/null || echo 0)
            text="$ICON_PAUSED $(format_time "$remaining")"
            tooltip="Work Paused: $(format_time "$remaining") left"
            class="paused"
            ;;
        break_running)
            end_time=$(cat "$END_TIME_FILE" 2>/dev/null || echo 0)
            remaining=$((end_time - current_time))

            if (( remaining <= 0 )); then
                send_notification "Break Over!" "Time for a ${POMO_DURATION_MIN} min work session." "appointment-soon-symbolic" "normal"
                play_sound
                action_start_pomo
                exit 0
            else
                text="$ICON_BREAK_RUNNING $(format_time "$remaining")"
                tooltip="Break: $(format_time "$remaining") remaining"
                class="break"
            fi
            ;;
        break_paused)
            remaining=$(cat "$PAUSED_TIME_FILE" 2>/dev/null || echo 0)
            text="$ICON_BREAK_PAUSED $(format_time "$remaining")"
            tooltip="Break Paused: $(format_time "$remaining") left"
            class="break-paused"
            ;;
        stopped|*)
            text="$ICON_STOPPED"
            tooltip="Start Pomodoro (${POMO_DURATION_MIN} min)"
            class="stopped"
            ;;
    esac

    printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' "$text" "$tooltip" "$class"
}

case "$1" in
    start)
        if [[ "$(get_state)" == "stopped" ]]; then
            action_start_pomo
        else
            echo "Timer already running or paused."
            action_display
        fi
        ;;
    toggle_pause)
        action_toggle_pause
        ;;
    stop)
        action_stop
        ;;
    *)
        action_display
        ;;
esac

exit 0

