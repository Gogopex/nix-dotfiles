#!/usr/bin/env bash

# Continuous Thunderbolt/USB-C monitoring script
# Logs state changes and captures diagnostics when display connects/disconnects

set -euo pipefail

LOG_DIR="$HOME/Desktop/thunderbolt-monitor-logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/thunderbolt-monitor-$(date +%Y%m%d).log"
STATE_FILE="$LOG_DIR/.last-state"

# Initialize state file if it doesn't exist
[ -f "$STATE_FILE" ] || echo "unknown" > "$STATE_FILE"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

get_display_count() {
    system_profiler SPDisplaysDataType 2>/dev/null | grep -c "Display Type:" || echo "0"
}

get_thunderbolt_devices() {
    system_profiler SPThunderboltDataType 2>/dev/null | grep -E "(Device Name:|Vendor Name:)" | wc -l || echo "0"
}

capture_state() {
    local state_name="$1"
    local capture_dir="$LOG_DIR/capture-$(date +%Y%m%d_%H%M%S)-$state_name"
    mkdir -p "$capture_dir"
    
    log_message "Capturing $state_name state to $capture_dir"
    
    # Quick captures only
    system_profiler SPDisplaysDataType > "$capture_dir/displays.txt" 2>&1
    system_profiler SPThunderboltDataType > "$capture_dir/thunderbolt.txt" 2>&1
    system_profiler SPUSBDataType > "$capture_dir/usb.txt" 2>&1
    ioreg -l -w0 | grep -A10 -B10 -i "thunderbolt\|usb4" > "$capture_dir/ioreg-excerpt.txt" 2>&1
    
    # Capture recent logs
    log show --predicate 'subsystem contains "Thunderbolt"' --last 5m > "$capture_dir/recent-logs.txt" 2>&1
}

log_message "Starting Thunderbolt/USB-C monitor"
log_message "Logs will be saved to: $LOG_FILE"
log_message "Press Ctrl+C to stop monitoring"

# Initial state
LAST_DISPLAY_COUNT=$(get_display_count)
LAST_TB_DEVICES=$(get_thunderbolt_devices)
LAST_STATE=$(cat "$STATE_FILE")

log_message "Initial state: Displays=$LAST_DISPLAY_COUNT, Thunderbolt devices=$LAST_TB_DEVICES"

# Monitor loop
while true; do
    CURRENT_DISPLAY_COUNT=$(get_display_count)
    CURRENT_TB_DEVICES=$(get_thunderbolt_devices)
    
    # Detect changes
    if [ "$CURRENT_DISPLAY_COUNT" != "$LAST_DISPLAY_COUNT" ] || [ "$CURRENT_TB_DEVICES" != "$LAST_TB_DEVICES" ]; then
        log_message "STATE CHANGE DETECTED!"
        log_message "Displays: $LAST_DISPLAY_COUNT -> $CURRENT_DISPLAY_COUNT"
        log_message "Thunderbolt devices: $LAST_TB_DEVICES -> $CURRENT_TB_DEVICES"
        
        # Determine state
        if [ "$CURRENT_DISPLAY_COUNT" -gt "$LAST_DISPLAY_COUNT" ]; then
            log_message "Display CONNECTED"
            capture_state "connected"
            echo "connected" > "$STATE_FILE"
        elif [ "$CURRENT_DISPLAY_COUNT" -lt "$LAST_DISPLAY_COUNT" ]; then
            log_message "Display DISCONNECTED"
            capture_state "disconnected"
            echo "disconnected" > "$STATE_FILE"
        else
            log_message "Thunderbolt device change (no display change)"
            capture_state "tb-change"
        fi
        
        # Update last known state
        LAST_DISPLAY_COUNT=$CURRENT_DISPLAY_COUNT
        LAST_TB_DEVICES=$CURRENT_TB_DEVICES
    fi
    
    # Sleep interval (adjust as needed)
    sleep 5
done