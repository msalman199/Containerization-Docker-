#!/bin/bash

# Docker Container Monitoring Script
# Usage: ./docker_monitor.sh [interval_seconds] [log_file]

INTERVAL=${1:-5}  # Default 5 seconds
LOGFILE=${2:-"docker_monitoring.log"}
ALERT_CPU_THRESHOLD=80
ALERT_MEM_THRESHOLD=80

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

# Function to send alerts
send_alert() {
    local container=$1
    local metric=$2
    local value=$3
    local threshold=$4
    
    echo -e "${RED}ALERT: Container $container has high $metric usage: $value% (threshold: $threshold%)${NC}"
    log_message "ALERT: Container $container has high $metric usage: $value% (threshold: $threshold%)"
}

# Function to check container health
check_container_health() {
    local stats_line=$1
    local container=$(echo $stats_line | awk '{print $2}')
    local cpu=$(echo $stats_line | awk '{print $3}' | sed 's/%//')
    local mem=$(echo $stats_line | awk '{print $7}' | sed 's/%//')
    
    # Check CPU threshold
    if (( $(echo "$cpu > $ALERT_CPU_THRESHOLD" | bc -l) )); then
        send_alert "$container" "CPU" "$cpu" "$ALERT_CPU_THRESHOLD"
    fi
    
    # Check Memory threshold
    if (( $(echo "$mem > $ALERT_MEM_THRESHOLD" | bc -l) )); then
        send_alert "$container" "Memory" "$mem" "$ALERT_MEM_THRESHOLD"
    fi
}

# Main monitoring loop
echo -e "${GREEN}Starting Docker Container Monitoring...${NC}"
echo "Monitoring interval: ${INTERVAL} seconds"
echo "Log file: ${LOGFILE}"
echo "CPU Alert Threshold: ${ALERT_CPU_THRESHOLD}%"
echo "Memory Alert Threshold: ${ALERT_MEM_THRESHOLD}%"
echo "Press Ctrl+C to stop monitoring"
echo

log_message "Docker monitoring started"

while true; do
    echo -e "${YELLOW}=== $(date) ===${NC}"
    
    # Get container stats
    stats_output=$(docker stats --no-stream 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo "$stats_output"
        
        # Process each container's stats (skip header)
        echo "$stats_output" | tail -n +2 | while read -r line; do
            check_container_health "$line"
        done
        
        # Log summary
        container_count=$(echo "$stats_output" | tail -n +2 | wc -l)
        log_message "Monitored $container_count containers"
    else
        echo -e "${RED}Error: Unable to retrieve Docker stats${NC}"
        log_message "ERROR: Unable to retrieve Docker stats"
    fi
    
    echo
    sleep "$INTERVAL"
done
