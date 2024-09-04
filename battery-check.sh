#!/bin/bash

# Check if acpi is installed
if ! command -v acpi &> /dev/null; then
    echo "acpi command not found. Please install it using 'sudo apt install acpi'."
    exit 1
fi

# Get battery level
battery_level=$(acpi -b | grep -P -o '[0-9]+(?=%)')

# Check if battery_level is a number
if ! [[ "$battery_level" =~ ^[0-9]+$ ]]; then
    echo "Unable to retrieve battery level."
    exit 1
fi

# Check if battery level is less than or equal to 20%
if [ "$battery_level" -le 20 ]; then
    # Send notification
    notify-send -u critical "Battery Low" "Battery level is ${battery_level}%!"
fi

# Output the battery level for i3blocks
echo "Battery: ${battery_level}%"
