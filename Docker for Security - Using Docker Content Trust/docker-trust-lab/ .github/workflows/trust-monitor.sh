#!/bin/bash

# Configuration
LOG_FILE="/tmp/docker-trust-monitor.log"
REPORT_FILE="/tmp/trust-report.html"

# Function to log events
log_event() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to monitor Docker operations
monitor_docker_operations() {
    echo "Starting Docker Content Trust monitoring..."
    log_event "Monitoring started"
    
    # Monitor for 60 seconds (adjust as needed)
    timeout 60s docker events --filter type=image --format "{{.Time}} {{.Action}} {{.Actor.Attributes.name}}" | while read line; do
        log_event "Docker event: $line"
    done
}

# Function to generate HTML report
generate_report() {
    cat > "$REPORT_FILE" << 'HTML_EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Docker Content Trust Security Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background-color: #2196F3; color: white; padding: 20px; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; }
        .success { background-color: #d4edda; border-color: #c3e6cb; }
        .warning { background-color: #fff3cd; border-color: #ffeaa7; }
        .danger { background-color: #f8d7da; border-color: #f5c6cb; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Docker Content Trust Security Report</h1>
        <p>Generated on: $(date)</p>
    </div>
    
    <div class="section success">
        <h2>Content Trust Status</h2>
        <p><strong>Status:</strong> $([ "$DOCKER_CONTENT_TRUST" = "1" ] && echo "ENABLED" || echo "DISABLED")</p>
        <p><strong>Server:</strong> ${DOCKER_CONTENT_TRUST_SERVER:-"Default"}</p>
    </div>
    
    <div class="section">
        <h2>Image Security Summary</h2>
        <table>
            <tr>
                <th>Metric</th>
                <th>Value</th>
                <th>Status</th>
            </tr>
            <tr>
                <td>Total Images</td>
                <td>$(docker images | wc -l)</td>
                <td>-</td>
            </tr>
            <tr>
                <td>Content Trust Enabled</td>
                <td>$([ "$DOCKER_CONTENT_TRUST" = "1" ] && echo "Yes" || echo "No")</td>
                <td>$([ "$DOCKER_CONTENT_TRUST" = "1" ] && echo "✓" || echo "✗")</td>
            </tr>
        </table>
    </div>
    
    <div class="section">
        <h2>Security Recommendations</h2>
        <ul>
            <li>Always enable Docker Content Trust in production environments</li>
            <li>Regularly rotate signing keys</li>
            <li>Implement automated signature verification in CI/CD pipelines</li>
            <li>Monitor and audit image signatures</li>
            <li>Train development teams on secure image practices</li>
        </ul>
    </div>
    
    <div class="section">
        <h2>Recent Activity Log</h2>
        <pre>$(tail -20 "$LOG_FILE" 2>/dev/null || echo "No recent activity")</pre>
    </div>
</body>
</html>
HTML_EOF

    echo "Report generated: $REPORT_FILE"
}

# Main monitoring function
main() {
    # Initialize log
    log_event "Trust monitoring initialized"
    
    # Monitor operations
    monitor_docker_operations &
    MONITOR_PID=$!
    
    # Generate report
    generate_report
    
    # Clean up
    kill $MONITOR_PID 2>/dev/null
    log_event "Monitoring completed"
    
    echo "Monitoring completed. Check $REPORT_FILE for detailed report."
}

# Run monitoring
main
