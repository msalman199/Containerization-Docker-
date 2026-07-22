#!/bin/bash

export PGPASSWORD='PostgresRootPass123!'

echo "=== Docker Volume and Database Monitoring Report ==="
echo "Generated: $(date)"
echo

echo "--- Volume Disk Usage ---"
docker system df -v | grep -A 20 "Local Volumes"

echo
echo "--- Container Status ---"
docker ps --filter "name=mysql-prod" --filter "name=postgres-prod" \
  --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo
echo "--- MySQL Health Check ---"
if docker ps --filter "name=mysql-prod" --format "{{.Names}}" | grep -q mysql-prod; then
    docker exec mysql-prod mysql -u root -pSecureRootPass123! -e \
      "SHOW STATUS LIKE 'Threads_connected';"
else
    echo "mysql-prod is not running"
fi

echo
echo "--- PostgreSQL Health Check ---"
if docker ps --filter "name=postgres-prod" --format "{{.Names}}" | grep -q postgres-prod; then
    docker exec -e PGPASSWORD="$PGPASSWORD" postgres-prod psql -U postgres -c \
      "SELECT count(*) AS active_connections FROM pg_stat_activity WHERE state = 'active';"
else
    echo "postgres-prod is not running"
fi
