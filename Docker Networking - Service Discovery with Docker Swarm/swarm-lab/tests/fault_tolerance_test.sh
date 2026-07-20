#!/bin/bash

echo "=== Fault Tolerance Test ==="
echo

# Get initial service status
echo "Initial service status:"
docker service ls
echo

# Kill one API service container
echo "Killing one API service container..."
API_CONTAINER=$(docker ps --filter "name=api-service" --format "{{.ID}}" | head -1)
if [ ! -z "$API_CONTAINER" ]; then
    docker kill $API_CONTAINER
    echo "Killed container: $API_CONTAINER"
else
    echo "No API container found to kill"
fi

echo
echo "Waiting 30 seconds for recovery..."
sleep 30

# Check if service recovered
echo "Service status after recovery:"
docker service ls
docker service ps api-service

echo
echo "Testing service discovery after recovery:"
curl -s http://localhost:5000/call-api | python3 -m json.tool

echo
echo "=== Fault Tolerance Test Complete ==="
