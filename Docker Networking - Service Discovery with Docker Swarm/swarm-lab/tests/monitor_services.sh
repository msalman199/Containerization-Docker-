#!/bin/bash

echo "=== Service Discovery Monitoring ==="
echo

while true; do
    clear
    echo "=== Docker Swarm Service Status - $(date) ==="
    echo
    
    # Service status
    echo "Services:"
    docker service ls
    echo
    
    # Network status
    echo "Network connections:"
    docker network inspect swarm-network --format '{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}'
    echo
    
    # Health status
    echo "Service health:"
    for service in api-service web-service; do
        echo "$service containers:"
        docker service ps $service --format "table {{.ID}}\t{{.Name}}\t{{.CurrentState}}\t{{.DesiredState}}"
        echo
    done
    
    # Test connectivity
    echo "Connectivity test:"
    response=$(curl -s -w "Time: %{time_total}s\n" http://localhost:5000/call-api 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "✓ Service discovery working"
    else
        echo "✗ Service discovery failed"
    fi
    
    echo
    echo "Press Ctrl+C to stop monitoring..."
    sleep 10
done
