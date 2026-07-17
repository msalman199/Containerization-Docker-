#!/bin/bash

COMPOSE_FILE="docker-compose-production.yml"

case "$1" in
    start)
        echo "Starting ELK Stack..."
        docker-compose -f $COMPOSE_FILE up -d
        echo "Waiting for services to be ready..."
        sleep 30
        echo "ELK Stack started successfully!"
        ;;
    stop)
        echo "Stopping ELK Stack..."
        docker-compose -f $COMPOSE_FILE down
        echo "ELK Stack stopped!"
        ;;
    restart)
        echo "Restarting ELK Stack..."
        docker-compose -f $COMPOSE_FILE restart
        echo "ELK Stack restarted!"
        ;;
    status)
        echo "ELK Stack Status:"
        docker-compose -f $COMPOSE_FILE ps
        ;;
    logs)
        if [ -z "$2" ]; then
            docker-compose -f $COMPOSE_FILE logs -f
        else
            docker-compose -f $COMPOSE_FILE logs -f $2
        fi
        ;;
    cleanup)
        echo "Cleaning up ELK Stack..."
        docker-compose -f $COMPOSE_FILE down -v
        docker system prune -f
        echo "Cleanup completed!"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs [service]|cleanup}"
        exit 1
        ;;
esac
