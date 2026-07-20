#!/bin/bash

echo "=== Docker Swarm Service Discovery Test ==="
echo

# Test 1: Check if services are running
echo "1. Checking service status..."
docker service ls
echo

# Test 2: Test DNS resolution
echo "2. Testing DNS resolution..."
WEB_CONTAINER=$(docker ps --filter "name=web-service" --format "{{.ID}}" | head -1)
if [ ! -z "$WEB_CONTAINER" ]; then
    echo "Resolving api-service from web-service container:"
    docker exec $WEB_CONTAINER nslookup api-service
else
    echo "No web-service container found"
fi
echo

# Test 3: Test HTTP connectivity
echo "3. Testing HTTP connectivity..."
API_CONTAINER=$(docker ps --filter "name=api-service" --format "{{.ID}}" | head -1)
if [ ! -z "$API_CONTAINER" ]; then
    echo "Testing API service health endpoint:"
    docker exec $API_CONTAINER curl -s http://localhost:8080/health | python3 -m json.tool
else
    echo "No api-service container found"
fi
echo

# Test 4: Test service-to-service communication
echo "4. Testing service-to-service communication..."
if [ ! -z "$WEB_CONTAINER" ]; then
    echo "Web service calling API service:"
    docker exec $WEB_CONTAINER curl -s http://api-service:8080/data | python3 -m json.tool
else
    echo "Cannot test - no web container available"
fi

echo
echo "=== Test Complete ==="
