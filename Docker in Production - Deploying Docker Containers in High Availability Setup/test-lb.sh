#!/bin/bash
echo "Testing load balancing..."
for i in {1..10}; do
    echo "Request $i:"
    curl -s http://localhost:8080 | grep -o "Server: [^<]*" || echo "Response received"
    sleep 1
done
