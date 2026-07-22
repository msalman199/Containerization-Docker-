#!/bin/bash

IMAGE_NAME=$1

if [ -z "$IMAGE_NAME" ]; then
    echo "Usage: $0 <image-name>"
    exit 1
fi

echo "Verifying image: $IMAGE_NAME"

# Check if Content Trust is enabled
if [ "$DOCKER_CONTENT_TRUST" != "1" ]; then
    echo "Warning: Docker Content Trust is not enabled"
    exit 1
fi

# Inspect trust information
echo "Trust information:"
docker trust inspect "$IMAGE_NAME" --pretty

# Check if image has valid signatures
SIGNATURES=$(docker trust inspect "$IMAGE_NAME" 2>/dev/null | jq -r '.[] | select(.SignedTags != null) | .SignedTags | length')

if [ "$SIGNATURES" -gt 0 ]; then
    echo "✓ Image is properly signed with $SIGNATURES signature(s)"
    exit 0
else
    echo "✗ Image is not signed or signatures are invalid"
    exit 1
fi
