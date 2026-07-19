#!/bin/bash

while true; do
    clear
    echo "=== Docker Swarm Cluster Status ==="
    echo "Timestamp: $(date)"
    echo
    
    echo "=== Nodes ==="
    sudo docker node ls
    echo
    
    echo "=== Services ==="
    sudo docker service ls
    echo
    
    echo "=== Service Tasks ==="
    sudo docker service ps webapp-final_web --no-trunc
    echo
    
    sleep 5
done
