#!/bin/bash

set -e

# Configuration
IMAGE_NAME="labuser/secure-app:v1.0"
COMPOSE_FILE="docker-compose.secure.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting secure deployment process...${NC}"

# Enable Content Trust
export DOCKER_CONTENT_TRUST=1

# Function to verify image signature
verify_image() {
    local image=$1
    echo -e "${YELLOW}Verifying signature for: $image${NC}"
    
    if docker trust inspect "$image" --pretty > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Image signature verified successfully${NC}"
        return 0
    else
        echo -e "${RED}✗ Image signature verification failed${NC}"
        return 1
    fi
}

# Function to deploy application
deploy_app() {
    echo -e "${YELLOW}Deploying application...${NC}"
    
    # Stop existing containers
    docker-compose -f "$COMPOSE_FILE" down
    
    # Pull latest signed images
    docker-compose -f "$COMPOSE_FILE" pull
    
    # Start services
    docker-compose -f "$COMPOSE_FILE" up -d
    
    # Wait for health check
    echo -e "${YELLOW}Waiting for application to be healthy...${NC}"
    sleep 10
    
    # Check application health
    if curl -f http://localhost:5000/health > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Application deployed successfully and is healthy${NC}"
        return 0
    else
        echo -e "${RED}✗ Application deployment failed or unhealthy${NC}"
        return 1
    fi
}

# Main deployment process
main() {
    # Verify image signature
    if verify_image "$IMAGE_NAME"; then
        # Deploy application
        if deploy_app; then
            echo -e "${GREEN}Secure deployment completed successfully!${NC}"
            exit 0
        else
            echo -e "${RED}Deployment failed!${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Image verification failed. Deployment aborted for security reasons.${NC}"
        exit 1
    fi
}

# Run main function
main
