#!/bin/bash

# Function to get current load (simplified example)
get_load() {
    # In production, this would check actual metrics
    # For demo, we'll use random values
    echo $((RANDOM % 100))
}

# Function to scale services based on load
scale_services() {
    load=$(get_load)
    echo "Current load: $load%"
    
    if [ $load -gt 80 ]; then
        echo "High load detected, scaling up..."
        docker service scale ha-app_web=6 ha-app_api=4
    elif [ $load -lt 30 ]; then
        echo "Low load detected, scaling down..."
        docker service scale ha-app_web=2 ha-app_api=2
    else
        echo "Normal load, maintaining current scale"
    fi
}

# Main monitoring loop
while true; do
    scale_services
    echo "Waiting 30 seconds before next check..."
    sleep 30
done
