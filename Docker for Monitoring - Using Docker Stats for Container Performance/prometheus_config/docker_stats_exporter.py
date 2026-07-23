#!/usr/bin/env python3

import docker
import time
import json
from http.server import HTTPServer, BaseHTTPRequestHandler
import threading

class DockerStatsExporter:
    def __init__(self):
        self.client = docker.from_env()
        self.stats_cache = {}
        
    def collect_stats(self):
        """Collect stats from all running containers"""
        try:
            containers = self.client.containers.list()
            stats = {}
            
            for container in containers:
                try:
                    # Get stats (non-blocking)
                    container_stats = container.stats(stream=False)
                    stats[container.name] = self.parse_stats(container_stats)
                except Exception as e:
                    print(f"Error collecting stats for {container.name}: {e}")
                    
            self.stats_cache = stats
        except Exception as e:
            print(f"Error collecting container stats: {e}")
    
    def parse_stats(self, stats):
        """Parse Docker stats into Prometheus metrics format"""
        parsed = {}
        
        # CPU usage
        cpu_delta = stats['cpu_stats']['cpu_usage']['total_usage'] - \
                   stats['precpu_stats']['cpu_usage']['total_usage']
        system_delta = stats['cpu_stats']['system_cpu_usage'] - \
                      stats['precpu_stats']['system_cpu_usage']
        
        if system_delta > 0:
            parsed['cpu_usage_percent'] = (cpu_delta / system_delta) * 100.0
        else:
            parsed['cpu_usage_percent'] = 0.0
            
        # Memory usage
        parsed['memory_usage_bytes'] = stats['memory_stats']['usage']
        parsed['memory_limit_bytes'] = stats['memory_stats']['limit']
        parsed['memory_usage_percent'] = (parsed['memory_usage_bytes'] / parsed['memory_limit_bytes']) * 100.0
        
        # Network I/O
        if 'networks' in stats:
            rx_bytes = sum(net['rx_bytes'] for net in stats['networks'].values())
            tx_bytes = sum(net['tx_bytes'] for net in stats['networks'].values())
            parsed['network_rx_bytes'] = rx_bytes
            parsed['network_tx_bytes'] = tx_bytes
        
        return parsed
    
    def generate_prometheus_metrics(self):
        """Generate Prometheus metrics format"""
        metrics = []
        
        for container_name, stats in self.stats_cache.items():
            labels = f'container="{container_name}"'
            
            metrics.append(f'docker_cpu_usage_percent{{{labels}}} {stats.get("cpu_usage_percent", 0)}')
            metrics.append(f'docker_memory_usage_bytes{{{labels}}} {stats.get("memory_usage_bytes", 0)}')
            metrics.append(f'docker_memory_limit_bytes{{{labels}}} {stats.get("memory_limit_bytes", 0)}')
            metrics.append(f'docker_memory_usage_percent{{{labels}}} {stats.get("memory_usage_percent", 0)}')
            metrics.append(f'docker_network_rx_bytes{{{labels}}} {stats.get("network_rx_bytes", 0)}')
            metrics.append(f'docker_network_tx_bytes{{{labels}}} {stats.get("network_tx_bytes", 0)}')
        
        return '\n'.join(metrics)

class MetricsHandler(BaseHTTPRequestHandler):
    def __init__(self, exporter, *args, **kwargs):
        self.exporter = exporter
        super().__init__(*args, **kwargs)
    
    def do_GET(self):
        if self.path == '/metrics':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            
            metrics = self.exporter.generate_prometheus_metrics()
            self.wfile.write(metrics.encode())
        else:
            self.send_response(404)
            self.end_headers()

def stats_collector_thread(exporter):
    """Background thread to collect stats periodically"""
    while True:
        exporter.collect_stats()
        time.sleep(5)  # Collect stats every 5 seconds

if __name__ == '__main__':
    exporter = DockerStatsExporter()
    
    # Start stats collection thread
    collector_thread = threading.Thread(target=stats_collector_thread, args=(exporter,))
    collector_thread.daemon = True
    collector_thread.start()
    
    # Start HTTP server
    handler = lambda *args, **kwargs: MetricsHandler(exporter, *args, **kwargs)
    server = HTTPServer(('localhost', 8081), handler)
    
    print("Docker Stats Exporter running on http://localhost:8081/metrics")
    server.serve_forever()
