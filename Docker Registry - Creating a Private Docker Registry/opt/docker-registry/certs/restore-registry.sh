#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <backup_file>"
    echo "Available backups:"
    ls -la /opt/docker-registry/backups/
    exit 1
