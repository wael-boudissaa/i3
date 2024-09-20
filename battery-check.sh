#!/bin/bash

# Check battery percentage and charging status in an infinite loop
while true; do
    # Get battery information (percentage and charging status)
    battery_info=$(acpi -b)

    # Extract battery percentage
    battery_level=$(echo "$battery_info" | grep -P -o '[0-9]+(?=%)')

    # Extract charging status (e.g., "Charging", "Discharging")
    charging_status=$(echo "$battery_info" | grep -oP 'Charging|Discharging')

    # Check if battery is below 20% and not charging
    if [ "$battery_level" -lt 20 ] && [ "$charging_status" == "Discharging" ]; then
        # Notify the user before logging out
        notify-send "Battery Low" "Battery level is below 20% and not charging. Logging out..." -u critical
        sleep 5  # Wait for 5 seconds before logging out

        # Log out command (for GNOME use gnome-session-quit, for i3 use pkill)
        pkill -KILL -u $USER  # Force log out
        break
    fi

    sleep 120  # Check battery level every 120 seconds (2 minutes)
done
