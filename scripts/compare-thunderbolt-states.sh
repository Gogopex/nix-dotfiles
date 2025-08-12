# Compare two Thunderbolt diagnostic captures to identify differences
# Usage: ./compare-thunderbolt-states.sh <working-dir> <broken-dir>

set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <working-diagnostics-dir> <broken-diagnostics-dir>"
    echo "Example: $0 ~/Desktop/thunderbolt-diagnostics-20240101_120000 ~/Desktop/thunderbolt-diagnostics-20240101_130000"
    exit 1
fi

WORKING_DIR="$1"
BROKEN_DIR="$2"
OUTPUT_FILE="$HOME/Desktop/thunderbolt-comparison-$(date +%Y%m%d_%H%M%S).txt"

if [ ! -d "$WORKING_DIR" ]; then
    echo "Error: Working directory not found: $WORKING_DIR"
    exit 1
fi

if [ ! -d "$BROKEN_DIR" ]; then
    echo "Error: Broken directory not found: $BROKEN_DIR"
    exit 1
fi

echo "Comparing Thunderbolt/USB-C States" | tee "$OUTPUT_FILE"
echo "==================================" | tee -a "$OUTPUT_FILE"
echo "Working state: $WORKING_DIR" | tee -a "$OUTPUT_FILE"
echo "Broken state:  $BROKEN_DIR" | tee -a "$OUTPUT_FILE"
echo | tee -a "$OUTPUT_FILE"

# Function to extract and compare specific information
compare_section() {
    local file="$1"
    local section="$2"
    local pattern="${3:-}"
    
    echo "### $section ###" | tee -a "$OUTPUT_FILE"
    
    if [ -f "$WORKING_DIR/$file" ] && [ -f "$BROKEN_DIR/$file" ]; then
        if [ -n "$pattern" ]; then
            echo "Working state:" | tee -a "$OUTPUT_FILE"
            grep -E "$pattern" "$WORKING_DIR/$file" 2>/dev/null | head -20 | tee -a "$OUTPUT_FILE" || echo "(no matches)" | tee -a "$OUTPUT_FILE"
            echo | tee -a "$OUTPUT_FILE"
            echo "Broken state:" | tee -a "$OUTPUT_FILE"
            grep -E "$pattern" "$BROKEN_DIR/$file" 2>/dev/null | head -20 | tee -a "$OUTPUT_FILE" || echo "(no matches)" | tee -a "$OUTPUT_FILE"
        else
            echo "Differences:" | tee -a "$OUTPUT_FILE"
            diff -u "$WORKING_DIR/$file" "$BROKEN_DIR/$file" 2>/dev/null | head -50 | tee -a "$OUTPUT_FILE" || echo "(files are identical or one is missing)" | tee -a "$OUTPUT_FILE"
        fi
    else
        echo "Error: One or both files missing" | tee -a "$OUTPUT_FILE"
    fi
    echo | tee -a "$OUTPUT_FILE"
}

# Compare key sections
compare_section "thunderbolt-info.txt" "Thunderbolt Devices"
compare_section "display-info.txt" "Display Configuration"
compare_section "usb-info.txt" "USB Devices"
compare_section "power-info.txt" "Power/Charging Status"
compare_section "launchd-services.txt" "Running Services"
compare_section "processes.txt" "Running Processes" "(thunderbolt|usb|display)"

# Extract specific Thunderbolt controller info
echo "### Thunderbolt Controller Comparison ###" | tee -a "$OUTPUT_FILE"
if [ -f "$WORKING_DIR/ioreg-thunderbolt.txt" ] && [ -f "$BROKEN_DIR/ioreg-thunderbolt.txt" ]; then
    echo "Working state controllers:" | tee -a "$OUTPUT_FILE"
    grep -E "AppleThunderboltNHI|Thunderbolt|USB4" "$WORKING_DIR/ioreg-thunderbolt.txt" 2>/dev/null | grep -v "grep" | sort | uniq | tee -a "$OUTPUT_FILE"
    echo | tee -a "$OUTPUT_FILE"
    echo "Broken state controllers:" | tee -a "$OUTPUT_FILE"
    grep -E "AppleThunderboltNHI|Thunderbolt|USB4" "$BROKEN_DIR/ioreg-thunderbolt.txt" 2>/dev/null | grep -v "grep" | sort | uniq | tee -a "$OUTPUT_FILE"
fi
echo | tee -a "$OUTPUT_FILE"

# Look for error patterns in logs
echo "### Error Analysis ###" | tee -a "$OUTPUT_FILE"
if [ -f "$BROKEN_DIR/system-logs.txt" ]; then
    echo "Errors in broken state:" | tee -a "$OUTPUT_FILE"
    grep -iE "(error|fail|timeout|disconnect)" "$BROKEN_DIR/system-logs.txt" 2>/dev/null | head -20 | tee -a "$OUTPUT_FILE" || echo "(no errors found)" | tee -a "$OUTPUT_FILE"
fi
echo | tee -a "$OUTPUT_FILE"

# Summary
echo "### Summary ###" | tee -a "$OUTPUT_FILE"
echo "Key things to look for:" | tee -a "$OUTPUT_FILE"
echo "1. Different Thunderbolt device counts or states" | tee -a "$OUTPUT_FILE"
echo "2. Missing displays in broken state" | tee -a "$OUTPUT_FILE"
echo "3. Different power delivery status" | tee -a "$OUTPUT_FILE"
echo "4. Additional or missing services/processes" | tee -a "$OUTPUT_FILE"
echo "5. Error messages in logs" | tee -a "$OUTPUT_FILE"
echo | tee -a "$OUTPUT_FILE"
echo "Full comparison saved to: $OUTPUT_FILE" | tee -a "$OUTPUT_FILE"
