#!/usr/bin/env python3

import subprocess
import time
from datetime import datetime

def get_broker_list():
    """Get list of running Kafka brokers"""
    try:
        result = subprocess.run(
            ['docker', 'exec', 'kafka1', 'kafka-broker-api-versions', '--bootstrap-server', 'localhost:9092'],
            capture_output=True,
            text=True
        )
        return "Brokers accessible" if result.returncode == 0 else "Broker connection failed"
    except Exception as e:
        return f"Error: {e}"

def get_cluster_metadata():
    """Get cluster metadata"""
    try:
        result = subprocess.run(
            ['docker', 'exec', 'kafka1', 'kafka-metadata-shell', '--snapshot', '/var/lib/kafka/data/__cluster_metadata-0/00000000000000000000.log'],
            capture_output=True,
            text=True,
            timeout=10
        )
        return "Metadata accessible"
    except Exception as e:
        return "Using alternative method"

def main():
    print("Multi-Broker Kafka Cluster Monitor")
    print("=" * 50)
    
    brokers = ['kafka1', 'kafka2', 'kafka3']
    
    while True:
        try:
            print(f"\n[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}]")
            
            # Check each broker status
            print("\n--- Broker Status ---")
            for broker in brokers:
                try:
                    result = subprocess.run(
                        ['docker', 'exec', broker, 'echo', 'Broker alive'],
                        capture_output=True,
                        text=True,
                        timeout=5
                    )
                    status = "RUNNING" if result.returncode == 0 else "STOPPED"
                    print(f"{broker}: {status}")
                except:
                    print(f"{broker}: STOPPED")
            
            # Check topic replication
            print("\n--- Topic Replication Status ---")
            try:
                result = subprocess.run(
                    ['docker', 'exec', 'kafka1', 'kafka-topics', '--describe', 
                     '--topic', 'replicated-messages', '--bootstrap-server', 'localhost:9092'],
                    capture_output=True,
                    text=True
                )
                if result.returncode == 0:
                    lines = result.stdout.strip().split('\n')
                    for line in lines:
                        if 'Partition:' in line:
                            print(line.strip())
                else:
                    print("Could not retrieve topic information")
            except Exception as e:
                print(f"Error checking topics: {e}")
            
            print("\n" + "="*50)
            time.sleep(15)  # Update every 15 seconds
            
        except KeyboardInterrupt:
            print("\nCluster monitoring stopped.")
            break

if __name__ == "__main__":
    main()
