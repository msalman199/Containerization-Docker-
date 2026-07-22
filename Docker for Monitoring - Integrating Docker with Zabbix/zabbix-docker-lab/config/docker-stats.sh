#!/bin/bash

# Docker container monitoring script for Zabbix
case $1 in
    "container.count")
        docker ps -q | wc -l
        ;;
    "container.running")
        docker ps --filter "status=running" -q | wc -l
        ;;
    "container.stopped")
        docker ps --filter "status=exited" -q | wc -l
        ;;
    "container.cpu")
        if [ -n "$2" ]; then
            docker stats --no-stream --format "{{.CPUPerc}}" $2 | sed 's/%//'
        fi
        ;;
    "container.memory")
        if [ -n "$2" ]; then
            docker stats --no-stream --format "{{.MemUsage}}" $2 | cut -d'/' -f1 | sed 's/[^0-9.]//g'
        fi
        ;;
    "container.status")
        if [ -n "$2" ]; then
            docker inspect --format='{{.State.Status}}' $2 2>/dev/null || echo "not_found"
        fi
        ;;
    *)
        echo "Usage: $0 {container.count|container.running|container.stopped|container.cpu|container.memory|container.status} [container_name]"
        exit 1
        ;;
esac
