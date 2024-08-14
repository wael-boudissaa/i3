#!/bin/bash

# Get battery level
battery_level=$(acpi -b | grep -P -o '[0-9]+(?=%)')

# Check if battery level is less than or equal to 20%
if [ "$battery_level" -le 20 ]; then
    # Send notification
    notify-send -u critical "Battery Low" "Battery level is ${battery_level}%!"
fi

# Output the battery level for i3blocks
echo "Battery: ${battery_level}%"
