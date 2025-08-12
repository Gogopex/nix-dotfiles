#!/usr/bin/env bash

LOG_FILE="$HOME/Desktop/usb-disconnect-monitor.log"

echo "Starting USB disconnect monitor at $(date)" | tee "$LOG_FILE"
echo "Will capture system state every 30 seconds and more frequently near 5-minute mark" | tee -a "$LOG_FILE"

CONNECT_TIME=""
ITERATION=0

while true; do
    DISPLAY_COUNT=$(system_profiler SPDisplaysDataType 2>/dev/null | grep -c "Display Type:" || echo "0")
    USB_HUB=$(system_profiler SPUSBDataType 2>/dev/null | grep -c "USB7206" || echo "0")
    
    if [ "$USB_HUB" -gt 0 ] && [ -z "$CONNECT_TIME" ]; then
        CONNECT_TIME=$(date +%s)
        echo "[$(date)] CONNECTED: Display count=$DISPLAY_COUNT, USB hub detected" | tee -a "$LOG_FILE"
    elif [ "$USB_HUB" -eq 0 ] && [ -n "$CONNECT_TIME" ]; then
        DISCONNECT_TIME=$(date +%s)
        DURATION=$((DISCONNECT_TIME - CONNECT_TIME))
        echo "[$(date)] DISCONNECTED after $DURATION seconds" | tee -a "$LOG_FILE"
        
        echo "Capturing post-disconnect state..." | tee -a "$LOG_FILE"
        echo "=== System Log (last 2 minutes) ===" >> "$LOG_FILE"
        log show --last 2m --predicate 'eventMessage CONTAINS "USB" OR eventMessage CONTAINS "disconnect" OR eventMessage CONTAINS "timeout"' 2>/dev/null | tail -100 >> "$LOG_FILE"
        
        echo "=== Process snapshot ===" >> "$LOG_FILE"
        ps aux | grep -E "(usb|thunderbolt|nix)" | grep -v grep >> "$LOG_FILE"
        
        CONNECT_TIME=""
    fi
    
    if [ -n "$CONNECT_TIME" ]; then
        ELAPSED=$(($(date +%s) - CONNECT_TIME))
        echo "[$(date)] Connected for $ELAPSED seconds - Display=$DISPLAY_COUNT, USB=$USB_HUB" | tee -a "$LOG_FILE"
        
        if [ $ELAPSED -gt 240 ] && [ $ELAPSED -lt 360 ]; then
            sleep 5
        else
            sleep 30
        fi
    else
        sleep 10
    fi
    
    ITERATION=$((ITERATION + 1))
done