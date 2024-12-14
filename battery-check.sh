#!/bin/bash

# Check battery percentage and charging status in an infinite loop
# # Debug: print the battery info to see what `acpi -b` returns
battery_info=$(acpi -b)

low_battery_notified=false
while true; do
    # Get battery information (percentage and charging status)
    battery_info=$(acpi -b)
    
    # Debug: print the battery info to see what `acpi -b` returns

    # Extract battery percentage (simplified regex)
    battery_level=$(echo "$battery_info" | grep -o '[0-9]\+%')
    battery_level=${battery_level%\%}  # Remove the '%' sign

    # Debug: print the extracted battery level

    # Extract charging status (simplified)
    charging_status=$(echo "$battery_info" | grep -o 'Charging\|Discharging')

    # Debug: print the charging status

    # Notify user when battery is below 25% and discharging
    if [ "$battery_level" -lt 25 ] && [ "$charging_status" = "Discharging" ] && [ "$low_battery_notified" = false ]; then
        # Notify about low battery
        notify-send "Battery Low" "Battery level is below 25% and not charging. Please plug in the charger." -u critical
        low_battery_notified=true  # Set the flag to true to avoid repeated notifications
    fi

    # Reset notification flag when the charger is plugged in
    if [ "$charging_status" = "Charging" ]; then
        low_battery_notified=false
    fi

    # Put the laptop to sleep if the battery is below 20% and discharging
    if [ "$battery_level" -lt 20 ] && [ "$charging_status" = "Discharging" ]; then
        # Notify the user before sleeping
        notify-send "Battery Critical" "Battery level is below 20%. System will sleep now..." -u critical
        sleep 5  # Wait for 5 seconds before sleeping

        # Command to put the system to sleep (for GNOME use `systemctl suspend`)
        systemctl suspend
        break
    fi

    sleep 120  # Check battery level every 120 seconds (2 minutes)
done
