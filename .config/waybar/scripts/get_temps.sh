#!/bin/bash

# --- Configuration ---
cpu_warn_threshold=75
cpu_crit_threshold=90
gpu_warn_threshold=70
gpu_crit_threshold=85

# --- Helper Function ---
get_temp() {
    local sensor_output=$1
    local label=$2 # e.g., Tctl, edge
    local temp_line=$(echo "$sensor_output" | grep "$label:")
    local temp_val=$(echo "$temp_line" | awk '{print $2}' | sed 's/+//; s/°C//')

    # Check if temp_val is a valid number
    if [[ "$temp_val" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        printf "%.0f" "$temp_val" # Return rounded integer
    else
        echo "N/A" # Return error indicator
    fi
}

# --- Main Logic ---
sensors_data=$(sensors) # Get all sensor data once

# --- CPU Temperature (Prefers Tctl, falls back to Tdie) ---
cpu_temp=$(get_temp "$sensors_data" "Tctl")
if [[ "$cpu_temp" == "N/A" ]]; then
    cpu_temp=$(get_temp "$sensors_data" "Tdie") # Fallback for some AMD CPUs
fi
if [[ "$cpu_temp" == "N/A" ]]; then
    # Fallback for Intel - adjust Core/Package if needed
    cpu_temp=$(get_temp "$sensors_data" "Package id 0")
fi

# --- GPU Temperature (Prefers edge, falls back to junction for AMD) ---
gpu_temp=$(get_temp "$sensors_data" "edge")
if [[ "$gpu_temp" == "N/A" ]]; then
    gpu_temp=$(get_temp "$sensors_data" "junction") # Fallback for hotspot
fi
# Add NVIDIA support here if needed using nvidia-smi

# Determine CSS Class based on thresholds
cpu_class=""
gpu_class=""

if [[ "$cpu_temp" != "N/A" ]]; then
    if (( cpu_temp >= cpu_crit_threshold )); then
        cpu_class="critical"
    elif (( cpu_temp >= cpu_warn_threshold )); then
        cpu_class="warning"
    fi
fi

if [[ "$gpu_temp" != "N/A" ]]; then
    if (( gpu_temp >= gpu_crit_threshold )); then
        gpu_class="critical"
    elif (( gpu_temp >= gpu_warn_threshold )); then
        gpu_class="warning"
    fi
fi


# Output JSON based on argument ($1)
case "$1" in
    cpu)
        if [[ "$cpu_temp" != "N/A" ]]; then
            # MODIFIED: Removed degree symbol from "text"
            printf '{"text": "%s", "tooltip": "CPU Temp: %s°C", "class": "%s"}\n' "$cpu_temp" "$cpu_temp" "$cpu_class"
        else
            printf '{"text": "N/A", "tooltip": "CPU Temp Error"}\n'
        fi
        ;;
    gpu)
        if [[ "$gpu_temp" != "N/A" ]]; then
             # MODIFIED: Removed degree symbol from "text"
             printf '{"text": "%s", "tooltip": "GPU Temp: %s°C", "class": "%s"}\n' "$gpu_temp" "$gpu_temp" "$gpu_class"
        else
            printf '{"text": "N/A", "tooltip": "GPU Temp Error"}\n'
        fi
        ;;
    *)
        echo "Usage: $0 [cpu|gpu]" >&2
        exit 1
        ;;
esac

exit 0
