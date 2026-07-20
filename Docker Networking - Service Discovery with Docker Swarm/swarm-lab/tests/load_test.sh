#!/bin/bash

echo "=== Load Testing Service Discovery ==="
echo "Running 20 requests to test service discovery..."
echo

for i in {1..20}; do
    echo "Request $i:"
    response=$(curl -s http://localhost:5000/call-api)
    hostname=$(echo $response | python3 -c "import sys, json; print(json.load(sys.stdin).get('web_service', 'unknown'))")
    api_hostname=$(echo $response | python3 -c "import sys, json; print(json.load(sys.stdin).get('api_response', {}).get('hostname', 'unknown'))")
    echo "  Web: $hostname -> API: $api_hostname"
    sleep 1
done

echo
echo "=== Load Test Complete ==="
