#!/bin/bash

echo "Generating load on applications..."

# Function to generate HTTP requests
generate_requests() {
    local url=$1
    local name=$2
    
    for i in {1..100}; do
        curl -s "$url" > /dev/null
        curl -s "$url/load" > /dev/null
        sleep 0.1
    done
    echo "Completed requests for $name"
}

# Generate load on both applications
generate_requests "http://localhost:5001" "web-app-1" &
generate_requests "http://localhost:5002" "web-app-2" &
generate_requests "http://localhost:8080" "nginx-proxy" &

wait
echo "Load generation completed"
