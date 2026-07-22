#!/bin/bash

echo "=== Production Docker Setup Test ==="

# Test 1: Application availability
echo "Testing application availability..."
if curl -s http://localhost:3000 | grep -q "Production Docker App"; then
    echo "✓ Application is running"
else
    echo "✗ Application test failed"
fi

# Test 2: Health checks
echo "Testing health checks..."
if curl -s http://localhost:3000/health | grep -q "healthy"; then
    echo "✓ Health check is working"
else
    echo "✗ Health check failed"
fi

# Test 3: Resource limits
echo "Testing resource limits..."
MEMORY_LIMIT=$(docker inspect $(docker ps -q -f "name=web") | grep -o '"Memory":[0-9]*' | cut -d':' -f2)
if [ "$MEMORY_LIMIT" -gt 0 ]; then
    echo "✓ Memory limits are set"
else
    echo "✗ Memory limits not configured"
fi

# Test 4: Security
echo "Testing security configuration..."
USER_ID=$(docker exec $(docker ps -q -f "name=web") id -u)
if [ "$USER_ID" != "0" ]; then
    echo "✓ Running as non-root user"
else
    echo "✗ Running as root user (security risk)"
fi

# Test 5: Monitoring endpoints
echo "Testing monitoring..."
if curl -s http://localhost:9090 | grep -q "Prometheus"; then
    echo "✓ Prometheus is accessible"
else
    echo "✗ Prometheus not accessible"
fi

# Test 6: Logging
echo "Testing logging..."
if docker logs $(docker ps -q -f "name=web") | grep -q "Server running"; then
    echo "✓ Application logging is working"
else
    echo "✗ Application logging failed"
fi

echo "=== Test Complete ==="
