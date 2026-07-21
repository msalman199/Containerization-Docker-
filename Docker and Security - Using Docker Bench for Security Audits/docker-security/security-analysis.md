# Docker Security Audit Report

## Executive Summary
Date: $(date)
Audit Tool: Docker Bench for Security

## Results Summary
- Total Checks: $(grep -E "(PASS|FAIL|WARN)" audit-results.txt | wc -l)
- Passed: $(grep -c "PASS" audit-results.txt)
- Failed: $(grep -c "FAIL" audit-results.txt)
- Warnings: $(grep -c "WARN" audit-results.txt)

## Critical Issues (FAIL)
$(grep "FAIL" audit-results.txt)

## Warnings (WARN)
$(grep "WARN" audit-results.txt)
