#!/bin/bash
# Docker Volume Backup Script
# Usage: ./backup_volume.sh <volume_name> [backup_directory]

VOLUME_NAME=$1
BACKUP_DIR=${2:-$HOME/docker-backups}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/${VOLUME_NAME}_${TIMESTAMP}.tar.gz"

if [ -z "$VOLUME_NAME" ]; then
    echo "Usage: $0 <volume_name> [backup_directory]"
    exit 1
fi

if ! docker volume inspect "$VOLUME_NAME" > /dev/null 2>&1; then
    echo "Error: Volume '$VOLUME_NAME' does not exist"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

echo "Creating backup of volume '$VOLUME_NAME'..."
docker run --rm \
    --mount source="$VOLUME_NAME",target=/data \
    -v "$BACKUP_DIR":/backup \
    ubuntu:latest \
    tar czf "/backup/$(basename "$BACKUP_FILE")" -C /data .

if [ $? -eq 0 ]; then
    echo "Backup created successfully: $BACKUP_FILE"
    echo "Backup size: $(du -h "$BACKUP_FILE" | cut -f1)"
else
    echo "Backup failed!"
    exit 1
fi
