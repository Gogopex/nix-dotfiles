#!/usr/bin/env bash

# Thunderbolt/USB-C Diagnostic Script
# Captures comprehensive system state for debugging display connection issues

set -euo pipefail

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_DIR="$HOME/Desktop/thunderbolt-diagnostics-$TIMESTAMP"
mkdir -p "$OUTPUT_DIR"

echo "Thunderbolt/USB-C Diagnostic Tool"
echo "================================="
echo "Output directory: $OUTPUT_DIR"
echo

# Function to run command and save output
run_diagnostic() {
    local name="$1"
    local cmd="$2"
    local output_file="$OUTPUT_DIR/$name.txt"
    
    echo -n "Running $name... "
    echo "Command: $cmd" > "$output_file"
    echo "Timestamp: $(date)" >> "$output_file"
    echo "===========================================" >> "$output_file"
    echo >> "$output_file"
    
    if eval "$cmd" >> "$output_file" 2>&1; then
        echo "✓"
    else
        echo "✗ (see $output_file for errors)"
    fi
}

# System Information
run_diagnostic "system-info" "system_profiler SPSoftwareDataType SPHardwareDataType"

# Thunderbolt Information
run_diagnostic "thunderbolt-info" "system_profiler SPThunderboltDataType"

# USB Information
run_diagnostic "usb-info" "system_profiler SPUSBDataType"

# Display Information
run_diagnostic "display-info" "system_profiler SPDisplaysDataType"

# Power Information (relevant for USB-C charging)
run_diagnostic "power-info" "system_profiler SPPowerDataType"

# IORegistry Thunderbolt/USB4 devices
run_diagnostic "ioreg-thunderbolt" "ioreg -l -w0 | grep -A20 -B5 -i thunderbolt"
run_diagnostic "ioreg-usb4" "ioreg -l -w0 | grep -A20 -B5 -i usb4"
run_diagnostic "ioreg-display" "ioreg -l -w0 | grep -A20 -B5 -i display"

# Kernel Extensions
run_diagnostic "kext-loaded" "kextstat | grep -E '(thunderbolt|usb|display)' | grep -v com.apple"

# LaunchD Services
run_diagnostic "launchd-services" "launchctl list | grep -E '(thunderbolt|usb|display|nix)'"
run_diagnostic "launchd-disabled" "launchctl print-disabled user/$(id -u)"

# Recent System Logs
echo -n "Collecting system logs (this may take a moment)... "
log show --predicate 'subsystem contains "Thunderbolt" OR subsystem contains "USB" OR subsystem contains "IOUSBFamily"' --last 30m > "$OUTPUT_DIR/system-logs.txt" 2>&1 && echo "✓" || echo "✗"

# Process List
run_diagnostic "processes" "ps aux | grep -E '(thunderbolt|usb|display|nix)' | grep -v grep"

# Environment Variables
run_diagnostic "environment" "env | grep -E '(PATH|NIX|DYLD)' | sort"

# Mounted Volumes
run_diagnostic "mounts" "mount"

# Network Interfaces (sometimes USB-C hubs show as network interfaces)
run_diagnostic "network-interfaces" "ifconfig -a"

# Current Display Arrangement
run_diagnostic "display-arrangement" "displayplacer list"

# Create summary
cat > "$OUTPUT_DIR/SUMMARY.txt" << EOF
Thunderbolt/USB-C Diagnostic Summary
====================================
Generated: $(date)
Hostname: $(hostname)
macOS Version: $(sw_vers -productVersion)
Build: $(sw_vers -buildVersion)

Key Points to Check:
1. Check thunderbolt-info.txt for connected devices
2. Check display-info.txt for detected displays
3. Check system-logs.txt for error messages
4. Check launchd-services.txt for conflicting services
5. Compare ioreg outputs when display works vs doesn't work

To share these diagnostics:
tar -czf ~/Desktop/thunderbolt-diagnostics-$TIMESTAMP.tar.gz -C ~/Desktop thunderbolt-diagnostics-$TIMESTAMP
EOF

echo
echo "Diagnostics complete! Results saved to:"
echo "$OUTPUT_DIR"
echo
echo "Run this script when:"
echo "1. Display is NOT working (capture broken state)"
echo "2. Display IS working (capture working state)"
echo "3. Compare the two outputs to identify differences"