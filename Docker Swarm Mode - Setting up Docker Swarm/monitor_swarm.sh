#!/bin/bash
echo "=== Docker Swarm Status ==="
docker node ls
echo ""
echo "=== Service Status ==="
docker service ls
echo ""
echo "=== Service Tasks ==="
docker service ps $(docker service ls -q) --no-trunc
echo ""
echo "=== System Resource Usage ==="
docker system df
