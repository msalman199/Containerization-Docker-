#!/bin/bash

# Docker API monitoring script using docker commands
# This script provides detailed container metrics

get_container_list() {
    docker ps --format "{{.Names}}" | tr '\n' ','
}

get_container_cpu_usage() {
    local container=$1
    if [ -n "$container" ]; then
        docker stats --no-stream --format "{{.CPUPerc}}" "$container" 2>/dev/null | sed 's/%//' || echo "0"
    fi
}

get_container_memory_usage() {
    local container=$1
    if [ -n "$container" ]; then
        # Get memory usage in MB
        docker stats --no-stream --format "{{.MemUsage}}" "$container" 2>/dev/null | \
        cut -d'/' -f1 | sed 's/[^0-9.]//g' || echo "0"
    fi
}

get_container_memory_limit() {
    local container=$1
    if [ -n "$container" ]; then
        # Get memory limit in MB
        docker stats --no-stream --format "{{.MemUsage}}" "$container" 2>/dev/null | \
        cut -d'/' -f2 | sed 's/[^0-9.]//g' || echo "0"
    fi
}

get_container_network_io() {
    local container=$1
    local direction=$2  # "rx" or "tx"
    if [ -n "$container" ]; then
        if [ "$direction" = "rx" ]; then
            docker stats --no-stream --format "{{.NetIO}}" "$container" 2>/dev/null | \
            cut -d'/' -f1 | sed 's/[^0-9.]//g' || echo "0"
        else
            docker stats --no-stream --format "{{.NetIO}}" "$container" 2>/dev/null | \
            cut -d'/' -f2 | sed 's/[^0-9.]//g' || echo "0"
        fi
    fi
}

get_container_uptime() {
    local container=$1
    if [ -n "$container" ]; then
        docker inspect --format='{{.State.StartedAt}}' "$container" 2>/dev/null | \
        xargs -I {} date -d {} +%s 2>/dev/null || echo "0"
    fi
}

# Main script logic
case $1 in
    "api.container.list")
        get_container_list
        ;;
    "api.container.cpu")
        get_container_cpu_usage "$2"
        ;;
    "api.container.memory.usage")
        get_container_memory_usage "$2"
        ;;
    "api.container.memory.limit")
        get_container_memory_limit "$2"
        ;;
    "api.container.network.rx")
        get_container_network_io "$2" "rx"
        ;;
    "api.container.network.tx")
        get_container_network_io "$2" "tx"
        ;;
    "api.container.uptime")
        get_container_uptime "$2"
        ;;
    "api.docker.version")
        docker version --format '{{.Server.Version}}' 2>/dev/null || echo "unknown"
        ;;
    *)
        echo "Usage: $0 {api.container.list|api.container.cpu|api.container.memory.usage|api.container.memory.limit|api.container.network.rx|api.container.network.tx|api.container.uptime|api.docker.version} [container_name]"
        exit 1
        ;;
esac
