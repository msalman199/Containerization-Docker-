#!/bin/bash

# Docker + Ansible Deployment Script
# Usage: ./deploy.sh [environment] [service]

set -e

ENVIRONMENT=${1:-development}
SERVICE=${2:-all}
INVENTORY_FILE="inventory.ini"
PLAYBOOK_DIR="."

echo "=== Docker + Ansible Deployment Script ==="
echo "Environment: $ENVIRONMENT"
echo "Service: $SERVICE"
echo "=========================================="

# Function to check prerequisites
check_prerequisites() {
    echo "Checking prerequisites..."
    
    if ! command -v ansible &> /dev/null; then
        echo "Error: Ansible is not installed"
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        echo "Error: Docker is not installed"
        exit 1
    fi
    
    if [ ! -f "$INVENTORY_FILE" ]; then
        echo "Error: Inventory file not found: $INVENTORY_FILE"
        exit 1
    fi
    
    echo "Prerequisites check passed!"
}

# Function to deploy specific service
deploy_service() {
    local service=$1
    local env=$2
    
    case $service in
        "nginx")
            echo "Deploying Nginx service..."
            ansible-playbook -i $INVENTORY_FILE deploy-nginx.yml -e "environment=$env"
            ;;
        "wordpress")
            echo "Deploying WordPress service..."
            ansible-playbook -i $INVENTORY_FILE deploy-wordpress.yml -e "environment=$env"
            ;;
        "scaled")
            echo "Deploying scaled services..."
            ansible-playbook -i multi-host-inventory.ini scale-services.yml -e "environment=$env"
            ;;
        "all")
            echo "Deploying all services..."
            deploy_service "nginx" "$env"
            deploy_service "wordpress" "$env"
            ;;
        *)
            echo "Unknown service: $service"
            echo "Available services: nginx, wordpress, scaled, all"
            exit 1
            ;;
    esac
}

# Function to run health checks
health_check() {
    echo "Running health checks..."
    
    # Check Nginx
    if curl -f http://localhost:8080 > /dev/null 2>&1; then
        echo "✓ Nginx service is healthy"
    else
        echo "✗ Nginx service is not responding"
    fi
    
    # Check WordPress
    if curl -f http://localhost:8081 > /dev/null 2>&1; then
        echo "✓ WordPress service is healthy"
    else
        echo "✗ WordPress service is not responding"
    fi
    
    # List running containers
    echo "Running containers:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

# Function to cleanup old containers
cleanup() {
    echo "Cleaning up old containers..."
    
    # Remove stopped containers
    docker container prune -f
    
    # Remove unused images
    docker image prune -f
    
    echo "Cleanup completed!"
}

# Main execution
main() {
    check_prerequisites
    
    if [ "$SERVICE" == "cleanup" ]; then
        cleanup
        exit 0
    fi
    
    deploy_service "$SERVICE" "$ENVIRONMENT"
    
    echo "Waiting for services to start..."
    sleep 10
    
    health_check
    
    echo "Deployment completed successfully!"
}

# Execute main function
main
