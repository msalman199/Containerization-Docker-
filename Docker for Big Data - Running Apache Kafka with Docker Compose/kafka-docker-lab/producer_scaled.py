#!/usr/bin/env python3

import json
import time
from kafka import KafkaProducer
from datetime import datetime
import random

def create_producer():
    """Create producer with multiple bootstrap servers"""
    producer = KafkaProducer(
        bootstrap_servers=['localhost:9092', 'localhost:9093', 'localhost:9094'],
        value_serializer=lambda v: json.dumps(v).encode('utf-8'),
        key_serializer=lambda k: k.encode('utf-8') if k else None,
        acks='all',  # Wait for all replicas to acknowledge
        retries=3
    )
    return producer

def generate_sample_data():
    """Generate sample data for testing"""
    sample_data = {
        'timestamp': datetime.now().isoformat(),
        'user_id': random.randint(1000, 9999),
        'action': random.choice(['login', 'logout', 'purchase', 'view', 'search']),
        'value': random.uniform(10.0, 1000.0),
        'region': random.choice(['us-east', 'us-west', 'eu-central', 'asia-pacific'])
    }
    return sample_data

def main():
    producer = create_producer()
    topic = 'replicated-messages'
    
    print(f"Starting scaled producer for topic: {topic}")
    print("Sending to multiple brokers with replication")
    print("Press Ctrl+C to stop")
    
    try:
        message_count = 0
        while True:
            data = generate_sample_data()
            key = f"user_{data['user_id']}"
            
            future = producer.send(topic, key=key, value=data)
            result = future.get(timeout=10)
            
            message_count += 1
            print(f"Message {message_count} sent to partition {result.partition}: {data}")
            
            time.sleep(1)  # Send message every second
            
    except KeyboardInterrupt:
        print(f"\nStopping producer. Total messages sent: {message_count}")
    finally:
        producer.close()

if __name__ == "__main__":
    main()
