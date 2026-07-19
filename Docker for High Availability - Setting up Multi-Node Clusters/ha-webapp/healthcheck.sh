#!/bin/bash
# Enhanced health check script

# Check if nginx is running
if ! pgrep nginx > /dev/null; then
    echo "Nginx process not found"
    exit 1
fi

# Check if the web page is accessible
if ! curl -f -s http://localhost/ > /dev/null; then
    echo "Web page not accessible"
    exit 1
fi

# Check system resources
MEMORY_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
if [ "$MEMORY_USAGE" -gt 90 ]; then
    echo "Memory usage too high: ${MEMORY_USAGE}%"
    exit 1
fi

echo "Health check passed"
exit 0
