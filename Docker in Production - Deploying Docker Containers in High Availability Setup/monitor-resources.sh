#!/bin/bash

while true; do
    clear
    echo "=== System Resources ==="
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1
    
    echo "Memory Usage:"
    free -h
    
    echo "=== Docker Services ==="
    docker service ls
    
    echo "=== Container Stats ==="
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
    
    sleep 5
done
