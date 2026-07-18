#!/bin/bash
FUNCTION_URL=$1
REQUESTS=${2:-10}

echo "Sending $REQUESTS requests to $FUNCTION_URL"
for i in $(seq 1 $REQUESTS); do
    echo "Request $i:"
    curl -s "$FUNCTION_URL?name=LoadTest$i" | head -1
    sleep 0.5
done
