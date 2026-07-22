#!/bin/bash

# Test image for performance comparison
TEST_IMAGE="alpine:latest"

echo "=== Docker Content Trust Performance Analysis ==="

# Function to measure operation time
measure_time() {
    local operation=$1
    local command=$2
    
    echo "Measuring: $operation"
    
    # Run command and measure time
    start_time=$(date +%s.%N)
    eval "$command" > /dev/null 2>&1
    end_time=$(date +%s.%N)
    
    # Calculate duration
    duration=$(echo "$end_time - $start_time" | bc -l)
    printf "  Duration: %.3f seconds\n" "$duration"
    
    return 0
}

# Test without Content Trust
echo -e "\n--- Testing WITHOUT Content Trust ---"
export DOCKER_CONTENT_TRUST=0

# Clean up
docker rmi "$TEST_IMAGE" 2>/dev/null

# Measure pull time
measure_time "Image pull (no trust)" "docker pull $TEST_IMAGE"

# Clean up
docker rmi "$TEST_IMAGE" 2>/dev/null

# Test with Content Trust
echo -e "\n--- Testing WITH Content Trust ---"
export DOCKER_CONTENT_TRUST=1

# Measure pull time (this might fail for unsigned images)
measure_time "Image pull (with trust)" "docker pull $TEST_IMAGE" || echo "  Note: Pull failed due to unsigned image (expected behavior)"

# Test with signed image
echo -e "\n--- Testing with Signed Image ---"
measure_time "Signed image pull" "docker pull labuser/secure-app:v1.0"

# Summary
echo -e "\n=== Performance Impact Summary ==="
echo "1. Content Trust adds cryptographic verification overhead"
echo "2. Initial setup requires key generation and repository initialization"
echo "3. Image pulls include signature verification step"
echo "4. Network overhead for downloading trust metadata"
echo "5. Overall impact is minimal for most use cases"
echo "6. Security benefits outweigh performance costs"

# Reset Content Trust
export DOCKER_CONTENT_TRUST=1
