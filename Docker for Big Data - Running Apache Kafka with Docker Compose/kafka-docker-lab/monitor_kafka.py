#!/usr/bin/env python3

import subprocess
import json
import time
from datetime import datetime

def get_container_stats():
    """Get Docker container statistics"""
    try:
        result = subprocess.run(
            ['docker', 'stats', 'kafka', '--no-stream', '--format', 'table {{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}'],
            capture_output=True,
            text=True
        )
        return result.stdout.strip()
    except Exception as e:
        return f"Error getting stats: {e}"

def get_kafka_topics():
    """Get list of Kafka topics"""
    try:
        result = subprocess.run(
            ['docker', 'exec', 'kafka', 'kafka-topics', '--list', '--bootstrap-server', 'localhost:9092'],
            capture_output=True,
            text=True
        )
        return result.stdout.strip().split('\n')
    except Exception as e:
        return [f"Error getting topics: {e}"]

def get_topic_details(topic):
    """Get details for a specific topic"""
    try:
        result = subprocess.run(
            ['docker', 'exec', 'kafka', 'kafka-topics', '--describe', '--topic', topic, '--bootstrap-server', 'localhost:9092'],
            capture_output=True,
            text=True
        )
        return result.stdout.strip()
    except Exception as e:
        return f"Error getting topic details: {e}"

def main():
    print("Kafka Monitoring Dashboard")
    print("=" * 50)
    
    while True:
        try:
            print(f"\n[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}]")
            
            # Container statistics
            print("\n--- Container Statistics ---")
            stats = get_container_stats()
            print(stats)
            
            # Topic information
            print("\n--- Topics ---")
            topics = get_kafka_topics()
            for topic in topics:
                if topic and not topic.startswith('Error'):
                    print(f"Topic: {topic}")
            
            # Detailed info for test topic
            if 'test-messages' in topics:
                print("\n--- Test Topic Details ---")
                details = get_topic_details('test-messages')
                print(details)
            
            print("\n" + "="*50)
            time.sleep(10)  # Update every 10 seconds
            
        except KeyboardInterrupt:
            print("\nMonitoring stopped.")
            break
        except Exception as e:
            print(f"Error in monitoring: {e}")
            time.sleep(5)

if __name__ == "__main__":
    main()
