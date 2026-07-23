#!/bin/bash
echo "Testing service availability during failover..."
success=0
total=0

for i in {1..60}; do
    total=$((total + 1))
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
        success=$((success + 1))
        echo "Request $i: SUCCESS"
    else
        echo "Request $i: FAILED"
    fi
    sleep 2
done

echo "Availability: $success/$total ($(echo "scale=2; $success*100/$total" | bc)%)"
