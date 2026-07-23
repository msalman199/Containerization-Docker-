#!/bin/bash
while true; do
    clear
    echo "=== Service Status ==="
    docker service ls
    echo ""
    echo "=== Node Status ==="
    docker node ls
    echo ""
    echo "=== Web Service Distribution ==="
    docker service ps ha-app_web --format "table {{.Name}}\t{{.Node}}\t{{.CurrentState}}"
    sleep 5
done
