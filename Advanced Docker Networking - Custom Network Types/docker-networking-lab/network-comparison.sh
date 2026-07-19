#!/bin/bash

echo "=== Network Mode Comparison ==="

# Bridge mode (default)
echo "1. Bridge Mode:"
docker run --rm --network bridge alpine ip route | head -3

# Host mode
echo "2. Host Mode:"
docker run --rm --network host alpine ip route | head -3

# None mode
echo "3. None Mode:"
docker run --rm --network none alpine ip addr show | grep -E "(lo|eth)"

echo "Comparison complete!"
