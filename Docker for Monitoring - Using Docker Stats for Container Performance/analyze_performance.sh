#!/bin/bash

echo "=== Container Performance Analysis ==="
echo "Timestamp: $(date)"
echo

# Get stats in parseable format
docker stats --no-stream --format "{{.Container}},{{.CPUPerc}},{{.MemPerc}},{{.NetIO}},{{.BlockIO}}" > /tmp/docker_stats.csv

# Analyze CPU usage
echo "=== CPU Usage Analysis ==="
while IFS=',' read -r container cpu mem net block; do
    cpu_num=$(echo $cpu | sed 's/%//')
    if (( $(echo "$cpu_num > 80" | bc -l) )); then
        echo "WARNING: $container has high CPU usage: $cpu"
    fi
done < /tmp/docker_stats.csv

echo

# Analyze Memory usage
echo "=== Memory Usage Analysis ==="
while IFS=',' read -r container cpu mem net block; do
    mem_num=$(echo $mem | sed 's/%//')
    if (( $(echo "$mem_num > 80" | bc -l) )); then
        echo "WARNING: $container has high memory usage: $mem"
    fi
done < /tmp/docker_stats.csv

rm /tmp/docker_stats.csv
