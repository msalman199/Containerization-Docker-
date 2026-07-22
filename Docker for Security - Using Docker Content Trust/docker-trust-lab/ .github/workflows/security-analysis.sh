#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Docker Content Trust Security Analysis ===${NC}"

# Function to analyze image trust status
analyze_image_trust() {
    local image=$1
    echo -e "\n${YELLOW}Analyzing: $image${NC}"
    
    # Check if image exists locally
    if docker images --format "table {{.Repository}}:{{.Tag}}" | grep -q "$image"; then
        echo -e "${GREEN}✓ Image exists locally${NC}"
    else
        echo -e "${RED}✗ Image not found locally${NC}"
        return 1
    fi
    
    # Check trust information
    if docker trust inspect "$image" --pretty > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Image has trust information${NC}"
        
        # Get signature details
        SIGNERS=$(docker trust inspect "$image" --pretty | grep "Signer:" | wc -l)
        echo -e "${BLUE}  - Number of signers: $SIGNERS${NC}"
        
        # Get signature timestamp
        TIMESTAMP=$(docker trust inspect "$image" | jq -r '.[0].SignedTags[0].SignedTag.Signed.Expires' 2>/dev/null)
        if [ "$TIMESTAMP" != "null" ] && [ -n "$TIMESTAMP" ]; then
            echo -e "${BLUE}  - Signature expires: $TIMESTAMP${NC}"
        fi
        
        return 0
    else
        echo -e "${RED}✗ No trust information available${NC}"
        return 1
    fi
}

# Function to demonstrate security benefits
demonstrate_security_benefits() {
    echo -e "\n${BLUE}=== Security Benefits Analysis ===${NC}"
    
    echo -e "\n${YELLOW}1. Image Integrity Protection:${NC}"
    echo -e "   - Cryptographic signatures ensure image hasn't been tampered with"
    echo -e "   - SHA256 hashes verify content integrity"
    echo -e "   - Prevents man-in-the-middle attacks during image distribution"
    
    echo -e "\n${YELLOW}2. Publisher Authentication:${NC}"
    echo -e "   - Digital signatures verify image publisher identity"
    echo -e "   - Prevents impersonation attacks"
    echo -e "   - Establishes chain of trust from publisher to consumer"
    
    echo -e "\n${YELLOW}3. Supply Chain Security:${NC}"
    echo -e "   - Ensures images come from trusted sources"
    echo -e "   - Prevents injection of malicious images"
    echo -e "   - Enables audit trail of image provenance"
    
    echo -e "\n${YELLOW}4. Compliance and Governance:${NC}"
    echo -e "   - Enforces organizational security policies"
    echo -e "   - Provides non-repudiation of image publishing"
    echo -e "   - Supports regulatory compliance requirements"
}

# Function to show trust vs non-trust comparison
compare_trust_scenarios() {
    echo -e "\n${BLUE}=== Trust vs Non-Trust Comparison ===${NC}"
    
    echo -e "\n${YELLOW}With Docker Content Trust ENABLED:${NC}"
    echo -e "${GREEN}✓ Only signed images can be pulled and run${NC}"
    echo -e "${GREEN}✓ Image integrity is cryptographically verified${NC}"
    echo -e "${GREEN}✓ Publisher identity is authenticated${NC}"
    echo -e "${GREEN}✓ Tampered images are automatically rejected${NC}"
    
    echo -e "\n${YELLOW}With Docker Content Trust DISABLED:${NC}"
    echo -e "${RED}✗ Any image can be pulled and run${NC}"
    echo -e "${RED}✗ No integrity verification${NC}"
    echo -e "${RED}✗ No publisher authentication${NC}"
    echo -e "${RED}✗ Vulnerable to supply chain attacks${NC}"
}

# Function to calculate security metrics
calculate_security_metrics() {
    echo -e "\n${BLUE}=== Security Metrics ===${NC}"
    
    # Count total images
    TOTAL_IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}}" | wc -l)
    
    # Count signed images (this is a simplified check)
    SIGNED_IMAGES=0
    for image in $(docker images --format "{{.Repository}}:{{.Tag}}"); do
        if docker trust inspect "$image" > /dev/null 2>&1; then
            ((SIGNED_IMAGES++))
        fi
    done
    
    # Calculate percentage
    if [ $TOTAL_IMAGES -gt 0 ]; then
        SIGNED_PERCENTAGE=$((SIGNED_IMAGES * 100 / TOTAL_IMAGES))
    else
        SIGNED_PERCENTAGE=0
    fi
    
    echo -e "${BLUE}Total images: $TOTAL_IMAGES${NC}"
    echo -e "${BLUE}Signed images: $SIGNED_IMAGES${NC}"
    echo -e "${BLUE}Signed percentage: $SIGNED_PERCENTAGE%${NC}"
    
    if [ $SIGNED_PERCENTAGE -ge 80 ]; then
        echo -e "${GREEN}✓ Good security posture (≥80% signed)${NC}"
    elif [ $SIGNED_PERCENTAGE -ge 50 ]; then
        echo -e "${YELLOW}⚠ Moderate security posture (50-79% signed)${NC}"
    else
        echo -e "${RED}✗ Poor security posture (<50% signed)${NC}"
    fi
}

# Main analysis function
main() {
    # Analyze specific images
    analyze_image_trust "labuser/secure-app:v1.0"
    
    # Show security benefits
    demonstrate_security_benefits
    
    # Compare scenarios
    compare_trust_scenarios
    
    # Calculate metrics
    calculate_security_metrics
    
    echo -e "\n${GREEN}Security analysis completed!${NC}"
}

# Run main function
main
