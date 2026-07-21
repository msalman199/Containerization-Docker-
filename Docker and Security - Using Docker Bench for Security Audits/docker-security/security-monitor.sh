#!/bin/bash

# Docker Security Monitoring Script
REPORT_DIR="/tmp/docker-security-reports"
DATE=$(date +%Y%m%d_%H%M%S)

# Create report directory
mkdir -p $REPORT_DIR

# Run Docker Bench for Security
echo "Running Docker security audit..."
cd ~/docker-security/docker-bench-security
sudo ./docker-bench-security.sh > $REPORT_DIR/audit_$DATE.txt 2>&1

# Generate summary
FAILS=$(grep -c "FAIL" $REPORT_DIR/audit_$DATE.txt)
WARNS=$(grep -c "WARN" $REPORT_DIR/audit_$DATE.txt)
PASSES=$(grep -c "PASS" $REPORT_DIR/audit_$DATE.txt)

echo "Security Audit Complete - $DATE"
echo "Results saved to: $REPORT_DIR/audit_$DATE.txt"
echo "Summary:"
echo "  Passed: $PASSES"
echo "  Failed: $FAILS"
echo "  Warnings: $WARNS"

# Alert if critical issues found
if [ $FAILS -gt 10 ]; then
    echo "WARNING: High number of failed security checks detected!"
    echo "Critical issues:"
    grep "FAIL" $REPORT_DIR/audit_$DATE.txt | head -5
fi
