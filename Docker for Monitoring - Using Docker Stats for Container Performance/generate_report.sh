#!/bin/bash

# Docker Resource Usage Report Generator
REPORT_FILE="docker_resource_report_$(date +%Y%m%d_%H%M%S).html"

cat > "$REPORT_FILE" << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Docker Resource Usage Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .high-usage { background-color: #ffcccc; }
        .medium-usage { background-color: #ffffcc; }
        .low-usage { background-color: #ccffcc; }
    </style>
</head>
<body>
    <h1>Docker Container Resource Usage Report</h1>
    <p>Generated on: $(date)</p>
    
    <h2>Current Container Statistics</h2>
    <table>
        <tr>
            <th>Container Name</th>
            <th>CPU Usage (%)</th>
            <th>Memory Usage</th>
            <th>Memory Percentage (%)</th>
            <th>Network I/O</th>
            <th>Block I/O</th>
            <th>PIDs</th>
        </tr>
HTML

# Get current stats and format for HTML
docker stats --no-stream --format "{{.Container}},{{.CPUPerc}},{{.MemUsage}},{{.MemPerc}},{{.NetIO}},{{.BlockIO}},{{.PIDs}}" | while IFS=',' read -r container cpu mem_usage mem_perc net_io block_io pids; do
    
    # Determine CSS class based on CPU usage
    cpu_num=$(echo $cpu | sed 's/%//')
    if (( $(echo "$cpu_num > 80" | bc -l) )); then
        css_class="high-usage"
    elif (( $(echo "$cpu_num > 50" | bc -l) )); then
        css_class="medium-usage"
    else
        css_class="low-usage"
    fi
    
    cat >> "$REPORT_FILE" << HTML
        <tr class="$css_class">
            <td>$container</td>
            <td>$cpu</td>
            <td>$mem_usage</td>
            <td>$mem_perc</td>
            <td>$net_io</td>
            <td>$block_io</td>
            <td>$pids</td>
        </tr>
HTML
done

cat >> "$REPORT_FILE" << 'HTML'
    </table>
    
    <h2>Resource Usage Guidelines</h2>
    <ul>
        <li><span style="background-color: #ccffcc; padding: 2px;">Green</span>: Low resource usage (&lt; 50% CPU)</li>
        <li><span style="background-color: #ffffcc; padding: 2px;">Yellow</span>: Medium resource usage (50-80% CPU)</li>
        <li><span style="background-color: #ffcccc; padding: 2px;">Red</span>: High resource usage (&gt; 80% CPU)</li>
    </ul>
</body>
</html>
HTML

echo "Report generated: $REPORT_FILE"
