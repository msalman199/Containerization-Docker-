#!/bin/bash

set -e

echo "Starting deployment process..."

# Pull latest images
docker-compose pull

# Stop existing containers
docker-compose down

# Start new containers
docker-compose up -d

# Wait for services to be healthy
echo "Waiting for services to be ready..."
sleep 30

# Check application health
if curl -f http://localhost/health; then
    echo "Deployment successful!"
    echo "Application is running at http://localhost"
else
    echo "Deployment failed - health check failed"
    exit 1
fi

# Clean up unused images
docker image prune -f

echo "Deployment completed successfully!"
