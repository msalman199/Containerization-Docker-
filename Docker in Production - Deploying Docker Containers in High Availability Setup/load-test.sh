#!/bin/bash

echo "Starting load test..."
echo "Testing with 100 concurrent connections, 1000 total requests"

# Run load test
ab -n 1000 -c 100 http://localhost:8080/

echo "Load test completed. Check service scaling..."
docker service ls
