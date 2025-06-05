#!/bin/bash
#
# A simplified temperature script for an Intel CPU with an integrated GPU.
# It uses the CPU Package temperature for both CPU and iGPU readings.

# --- Configuration ---
# Use a single set of thresholds, as we're reading a single sensor.
warn_threshold=75
crit_threshold=90

# --- Helper Function ---
# Extracts a numeric temperature value from the 'sensors' command output.
get_temp() {
    local sensor_output=$1
    local label=$2
    local temp_val=$(echo "$sensor_output" | grep "$label:" | awk '{print $2}' | sed 's/+//; s/°C//')

    if [[ "$temp_val" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        printf "%.0f" "$temp_val" # Return rounded integer
    else
        echo "N/A"
    fi
}

# --- Main Logic ---
sensors_data=$(sensors)

# For an Intel CPU/iGPU, "Package id 0" is the main temperature for the whole chip.
pkg_temp=$(get_temp "$sensors_data" "Package id 0")

# If we couldn't get a temp, output an error and exit.
if [[ "$pkg_temp" == "N/A" ]]; then
    printf '{"text": "ERR"}\n'
    exit 1
fi

# Determine CSS class based on the temperature
class=""
if (( pkg_temp >= crit_threshold )); then
    class="critical"
elif (( pkg_temp >= warn_threshold )); then
    class="warning"
fi

# Output the correct JSON based on which module is calling the script.
# Both will show the same temperature, but with different tooltips.
case "$1" in
    cpu)
        printf '{"text": "%s", "tooltip": "CPU Package Temp: %s°C", "class": "%s"}\n' "$pkg_temp" "$pkg_temp" "$class"
        ;;
    gpu)
        printf '{"text": "%s", "tooltip": "iGPU Temp (as CPU Package): %s°C", "class": "%s"}\n' "$pkg_temp" "$pkg_temp" "$class"
        ;;
    *)
        echo "Usage: $0 [cpu|gpu]" >&2
        exit 1
        ;;
esac

exit 0