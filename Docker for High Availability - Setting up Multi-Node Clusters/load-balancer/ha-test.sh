#!/bin/bash

echo "Starting High Availability Test..."

# Function to test application availability
test_availability() {
    local test_name=$1
    echo "Testing: $test_name"
    
    for i in {1..10}; do
        response=$(curl -s -o /dev/null -w "%{http_code}" http://192.168.1.10:8081)
        if [ "$response" = "200" ]; then
            echo "  Request $i: SUCCESS"
        else
            echo "  Request $i: FAILED (HTTP $response)"
        fi
        sleep 1
    done
}

# Test 1: Normal operation
test_availability "Normal Operation"

# Test 2: Simulate container failure
echo "Simulating container failure..."
CONTAINER_ID=$(sudo docker ps --format "table {{.ID}}\t{{.Image}}" | grep ha-webapp | head -1 | awk '{print $1}')
sudo docker kill $CONTAINER_ID
sleep 5
test_availability "After Container Failure"

# Test 3: Scale down and up
echo "Testing scaling..."
sudo docker service scale webapp-final_web=2
sleep 10
test_availability "After Scaling Down"

sudo docker service scale webapp-final_web=4
sleep 10
test_availability "After Scaling Up"

echo "High Availability Test Complete!"
