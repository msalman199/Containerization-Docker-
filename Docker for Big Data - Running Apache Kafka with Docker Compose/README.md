<div align="center">

# 🐳📨 Docker for Big Data — Running Apache Kafka with Docker Compose

### Distributed Messaging, Broker Scaling & Fault Tolerance

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Apache Kafka](https://img.shields.io/badge/Apache_Kafka-231F20?style=for-the-badge&logo=apachekafka&logoColor=white)
![Zookeeper](https://img.shields.io/badge/Zookeeper-D22128?style=for-the-badge&logo=apache&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Level](https://img.shields.io/badge/Level-Intermediate-yellow?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [📝 Task 1: Set up Docker Compose File for Kafka and Zookeeper](#-task-1-set-up-docker-compose-file-for-kafka-and-zookeeper)
- [🚀 Task 2: Start Kafka and Zookeeper Containers](#-task-2-start-kafka-and-zookeeper-containers)
- [📤 Task 3: Create a Producer and Consumer](#-task-3-create-a-producer-and-consumer)
- [📊 Task 4: Monitor Kafka Broker Performance](#-task-4-monitor-kafka-broker-performance)
- [📈 Task 5: Scale Kafka Brokers and Test the Configuration](#-task-5-scale-kafka-brokers-and-test-the-configuration)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🧹 Lab Cleanup](#-lab-cleanup)
- [📊 Key Concepts Summary](#-key-concepts-summary)
- [🎓 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | 📨 Deploy Apache Kafka using Docker Compose for distributed messaging |
| 2 | ⚙️ Configure Zookeeper and Kafka services in a containerized environment |
| 3 | 📤 Create and manage Kafka producers and consumers |
| 4 | 📊 Monitor Kafka broker performance using container metrics |
| 5 | 📈 Scale Kafka brokers horizontally using Docker Compose |
| 6 | 🧠 Understand the fundamentals of distributed messaging systems |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker Basics | Basic understanding of Docker containers and Docker Compose |
| ⌨️ CLI Comfort | Familiarity with command-line interface (CLI) |
| 🌐 Distributed Systems | Basic knowledge of distributed systems concepts |
| 📨 Messaging Patterns | Understanding of messaging patterns (producer-consumer model) |

> **☁️ Note:** Al Nafi provides ready-to-use Linux-based cloud machines with Docker and Docker Compose pre-installed. Simply click **Start Lab** to begin — no need to build your own VM or install additional software.

## 🖥️ Lab Environment Setup

**Your Al Nafi cloud machine comes pre-configured with:**

![Docker Engine](https://img.shields.io/badge/Docker_Engine-2496ED?style=flat-square&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat-square&logo=docker&logoColor=white)
![nano/vim](https://img.shields.io/badge/nano%2Fvim-4EAA25?style=flat-square&logo=gnubash&logoColor=white)
![Network Utils](https://img.shields.io/badge/Network_Utilities-000000?style=flat-square&logo=wireshark&logoColor=white)

---

## 📝 Task 1: Set up Docker Compose File for Kafka and Zookeeper

![Kafka](https://img.shields.io/badge/Apache_Kafka-231F20?style=flat-square&logo=apachekafka&logoColor=white)
![Zookeeper](https://img.shields.io/badge/Zookeeper-D22128?style=flat-square&logo=apache&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat-square&logo=docker&logoColor=white)

### 📁 Subtask 1.1: Create Project Directory Structure

```bash
# 📁 Create a dedicated directory for the Kafka project
mkdir kafka-docker-lab
cd kafka-docker-lab
mkdir config logs data
```
✅ **Sign of success:** `config`, `logs`, and `data` subdirectories exist under `kafka-docker-lab`.

### 📄 Subtask 1.2: Create Docker Compose Configuration

```bash
# 📝 Create the main Docker Compose file
nano docker-compose.yml
```

```yaml
version: '3.8'

services:
  zookeeper:
    image: confluentinc/cp-zookeeper:7.4.0
    hostname: zookeeper
    container_name: zookeeper
    ports:
      - "2181:2181"
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    volumes:
      - ./data/zookeeper:/var/lib/zookeeper/data
      - ./logs/zookeeper:/var/lib/zookeeper/log
    networks:
      - kafka-network

  kafka:
    image: confluentinc/cp-kafka:7.4.0
    hostname: kafka
    container_name: kafka
    depends_on:
      - zookeeper
    ports:
      - "9092:9092"
      - "9101:9101"
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: 'zookeeper:2181'
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:29092,PLAINTEXT_HOST://localhost:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
      KAFKA_JMX_PORT: 9101
      KAFKA_JMX_HOSTNAME: localhost
      KAFKA_AUTO_CREATE_TOPICS_ENABLE: 'true'
    volumes:
      - ./data/kafka:/var/lib/kafka/data
      - ./logs/kafka:/var/log/kafka
    networks:
      - kafka-network

  kafka-ui:
    image: provectuslabs/kafka-ui:latest
    container_name: kafka-ui
    depends_on:
      - kafka
    ports:
      - "8080:8080"
    environment:
      KAFKA_CLUSTERS_0_NAME: local
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: kafka:29092
      KAFKA_CLUSTERS_0_ZOOKEEPER: zookeeper:2181
    networks:
      - kafka-network
    # TODO: Point this at your own cluster name/bootstrap servers if reused elsewhere

networks:
  kafka-network:
    driver: bridge
```
Save and exit the file (`Ctrl+X`, then `Y`, then `Enter` in nano).

### 🧩 Subtask 1.3: Understand the Configuration

| Component | Role |
|---|---|
| 🐘 **Zookeeper** | Manages Kafka cluster metadata and coordination |
| 📨 **Kafka** | The main message broker service |
| 🖥️ **Kafka-UI** | Web interface for monitoring and managing Kafka |
| 🌐 **Networks** | Isolated network for service communication |
| 💾 **Volumes** | Persistent storage for data and logs |

---

## 🚀 Task 2: Start Kafka and Zookeeper Containers

![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat-square&logo=docker&logoColor=white)

### ✅ Subtask 2.1: Validate Docker Compose File

```bash
# ✅ Validate the configuration before starting services
docker-compose config
```
✅ **Sign of success:** the parsed configuration is displayed without errors.

### ▶️ Subtask 2.2: Start the Services

```bash
# 🚀 Launch all services in detached mode
docker-compose up -d
```

### 🔎 Subtask 2.3: Verify Service Status

```bash
# 🔎 Check that all containers are running
docker-compose ps
```

Expected output:
```
    Name                  Command               State                       Ports
------------------------------------------------------------------------------------------------
kafka         /etc/confluent/docker/run        Up      0.0.0.0:9092->9092/tcp, 0.0.0.0:9101->9101/tcp
kafka-ui      java -jar kafka-ui-api.jar       Up      0.0.0.0:8080->8080/tcp
zookeeper     /etc/confluent/docker/run        Up      0.0.0.0:2181->2181/tcp
```
✅ **Sign of success:** all three services report `Up` with their expected ports bound.

### 📜 Subtask 2.4: Check Service Logs

```bash
# 📜 Check Zookeeper logs
docker-compose logs zookeeper

# 📜 Check Kafka logs
docker-compose logs kafka

# 👁️ Follow logs in real-time
docker-compose logs -f kafka
```
✅ **Sign of success:** Kafka logs show it is ready to accept connections before you move on.

---

## 📤 Task 3: Create a Producer and Consumer

![Kafka](https://img.shields.io/badge/Apache_Kafka-231F20?style=flat-square&logo=apachekafka&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)

### 🖥️ Subtask 3.1: Access Kafka Container

```bash
# 🖥️ Open a new terminal session and access the Kafka container
docker exec -it kafka bash
```

### 🏷️ Subtask 3.2: Create a Kafka Topic

```bash
# 🏷️ Create a topic for testing (inside the Kafka container)
kafka-topics --create \
  --topic test-messages \
  --bootstrap-server localhost:9092 \
  --partitions 3 \
  --replication-factor 1

# ✅ Verify the topic was created
kafka-topics --list --bootstrap-server localhost:9092
```
✅ **Sign of success:** `test-messages` appears in the topic list.

### 📝 Subtask 3.3: Create a Simple Producer Script

```bash
# 🚪 Exit the container and create a producer script on the host
exit
nano producer.py
```

```python
#!/usr/bin/env python3
# 📤 Simple Kafka producer sending randomized sample events

import json
import time
from kafka import KafkaProducer
from datetime import datetime
import random

def create_producer():
    """Create and configure Kafka producer"""
    producer = KafkaProducer(
        bootstrap_servers=['localhost:9092'],
        value_serializer=lambda v: json.dumps(v).encode('utf-8'),
        key_serializer=lambda k: k.encode('utf-8') if k else None
    )
    return producer

def generate_sample_data():
    """Generate sample data for testing"""
    sample_data = {
        'timestamp': datetime.now().isoformat(),
        'user_id': random.randint(1000, 9999),
        'action': random.choice(['login', 'logout', 'purchase', 'view']),
        'value': random.uniform(10.0, 1000.0)
    }
    return sample_data
    # TODO: Replace with your own event schema

def main():
    producer = create_producer()
    topic = 'test-messages'

    print(f"Starting producer for topic: {topic}")
    print("Press Ctrl+C to stop")

    try:
        message_count = 0
        while True:
            # 📦 Generate and send message
            data = generate_sample_data()
            key = f"user_{data['user_id']}"

            future = producer.send(topic, key=key, value=data)
            result = future.get(timeout=10)

            message_count += 1
            print(f"Message {message_count} sent: {data}")

            time.sleep(2)  # ⏱️ Send message every 2 seconds

    except KeyboardInterrupt:
        print(f"\nStopping producer. Total messages sent: {message_count}")
    finally:
        producer.close()

if __name__ == "__main__":
    main()
```

### 📥 Subtask 3.4: Create a Consumer Script

```bash
nano consumer.py
```

```python
#!/usr/bin/env python3
# 📥 Simple Kafka consumer printing every message received

import json
from kafka import KafkaConsumer
from datetime import datetime

def create_consumer():
    """Create and configure Kafka consumer"""
    consumer = KafkaConsumer(
        'test-messages',
        bootstrap_servers=['localhost:9092'],
        value_deserializer=lambda m: json.loads(m.decode('utf-8')),
        key_deserializer=lambda k: k.decode('utf-8') if k else None,
        group_id='test-consumer-group',
        auto_offset_reset='earliest',
        enable_auto_commit=True
    )
    return consumer

def main():
    consumer = create_consumer()

    print("Starting consumer...")
    print("Waiting for messages (Press Ctrl+C to stop)")

    try:
        message_count = 0
        for message in consumer:
            message_count += 1

            print(f"\n--- Message {message_count} ---")
            print(f"Topic: {message.topic}")
            print(f"Partition: {message.partition}")
            print(f"Offset: {message.offset}")
            print(f"Key: {message.key}")
            print(f"Value: {message.value}")
            print(f"Timestamp: {datetime.fromtimestamp(message.timestamp/1000)}")

    except KeyboardInterrupt:
        print(f"\nStopping consumer. Total messages processed: {message_count}")
    finally:
        consumer.close()

if __name__ == "__main__":
    main()
```

### 📦 Subtask 3.5: Install Python Kafka Client

```bash
# 📦 Install the required Python package
pip3 install kafka-python
```

### ▶️ Subtask 3.6: Test Producer and Consumer

**Terminal 1 — Start Consumer:**
```bash
cd kafka-docker-lab
python3 consumer.py
```

**Terminal 2 — Start Producer:**
```bash
cd kafka-docker-lab
python3 producer.py
```
✅ **Sign of success:** messages appear in the producer terminal and are echoed in the consumer terminal in real-time.

### ⌨️ Subtask 3.7: Alternative Command-Line Testing

**Producer (in Kafka container):**
```bash
docker exec -it kafka bash
kafka-console-producer --topic test-messages --bootstrap-server localhost:9092
```

**Consumer (in another terminal):**
```bash
docker exec -it kafka bash
kafka-console-consumer --topic test-messages --bootstrap-server localhost:9092 --from-beginning
```

---

## 📊 Task 4: Monitor Kafka Broker Performance

![Kafka UI](https://img.shields.io/badge/Kafka_UI-231F20?style=flat-square&logo=apachekafka&logoColor=white)
![Docker Stats](https://img.shields.io/badge/Docker_Stats-2496ED?style=flat-square&logo=docker&logoColor=white)

### 🖥️ Subtask 4.1: Access Kafka UI Dashboard

Open your web browser and navigate to:
```
http://localhost:8080
```

This dashboard lets you monitor:
- 🏷️ Topics and their configurations
- 👥 Consumer groups and their lag
- 📡 Broker information
- 📈 Message throughput

### 📡 Subtask 4.2: Monitor JMX Metrics

```bash
nano monitor_kafka.py
```

```python
#!/usr/bin/env python3
# 📡 Polls container stats, topics, and topic details on a loop

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

            # 📊 Container statistics
            print("\n--- Container Statistics ---")
            stats = get_container_stats()
            print(stats)

            # 🏷️ Topic information
            print("\n--- Topics ---")
            topics = get_kafka_topics()
            for topic in topics:
                if topic and not topic.startswith('Error'):
                    print(f"Topic: {topic}")

            # 🔍 Detailed info for test topic
            if 'test-messages' in topics:
                print("\n--- Test Topic Details ---")
                details = get_topic_details('test-messages')
                print(details)

            print("\n" + "="*50)
            time.sleep(10)  # ⏱️ Update every 10 seconds

        except KeyboardInterrupt:
            print("\nMonitoring stopped.")
            break
        except Exception as e:
            print(f"Error in monitoring: {e}")
            time.sleep(5)

if __name__ == "__main__":
    main()
```

```bash
# ▶️ Run the monitoring script
python3 monitor_kafka.py
```
✅ **Sign of success:** the dashboard refreshes every 10 seconds with live container stats and topic details.

### 📜 Subtask 4.3: Check Kafka Logs for Performance Metrics

```bash
# 📜 View recent logs
docker-compose logs --tail=50 kafka

# 👁️ Monitor logs in real-time, filtered for perf keywords
docker-compose logs -f kafka | grep -E "(throughput|latency|performance)"
```

### 📊 Subtask 4.4: Use Docker Stats for Resource Monitoring

```bash
# 📊 Real-time monitoring
docker stats

# 📸 One-time snapshot
docker stats --no-stream
```
✅ **Sign of success:** CPU%, memory, network I/O, and block I/O are visible for all running containers.

---

## 📈 Task 5: Scale Kafka Brokers and Test the Configuration

![Kafka](https://img.shields.io/badge/Multi--Broker_Cluster-231F20?style=flat-square&logo=apachekafka&logoColor=white)
![Fault Tolerance](https://img.shields.io/badge/Fault_Tolerance-D22128?style=flat-square&logo=statuspage&logoColor=white)

### 🏗️ Subtask 5.1: Create Multi-Broker Configuration

```bash
nano docker-compose-scaled.yml
```

```yaml
version: '3.8'

services:
  zookeeper:
    image: confluentinc/cp-zookeeper:7.4.0
    hostname: zookeeper
    container_name: zookeeper
    ports:
      - "2181:2181"
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    volumes:
      - ./data/zookeeper:/var/lib/zookeeper/data
      - ./logs/zookeeper:/var/lib/zookeeper/log
    networks:
      - kafka-network

  kafka1:
    image: confluentinc/cp-kafka:7.4.0
    hostname: kafka1
    container_name: kafka1
    depends_on:
      - zookeeper
    ports:
      - "9092:9092"
      - "9101:9101"
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: 'zookeeper:2181'
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka1:29092,PLAINTEXT_HOST://localhost:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 2
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 2
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 2
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
      KAFKA_JMX_PORT: 9101
      KAFKA_JMX_HOSTNAME: localhost
    volumes:
      - ./data/kafka1:/var/lib/kafka/data
    networks:
      - kafka-network

  kafka2:
    image: confluentinc/cp-kafka:7.4.0
    hostname: kafka2
    container_name: kafka2
    depends_on:
      - zookeeper
    ports:
      - "9093:9093"
      - "9102:9102"
    environment:
      KAFKA_BROKER_ID: 2
      KAFKA_ZOOKEEPER_CONNECT: 'zookeeper:2181'
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka2:29093,PLAINTEXT_HOST://localhost:9093
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 2
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 2
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 2
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
      KAFKA_JMX_PORT: 9102
      KAFKA_JMX_HOSTNAME: localhost
    volumes:
      - ./data/kafka2:/var/lib/kafka/data
    networks:
      - kafka-network

  kafka3:
    image: confluentinc/cp-kafka:7.4.0
    hostname: kafka3
    container_name: kafka3
    depends_on:
      - zookeeper
    ports:
      - "9094:9094"
      - "9103:9103"
    environment:
      KAFKA_BROKER_ID: 3
      KAFKA_ZOOKEEPER_CONNECT: 'zookeeper:2181'
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka3:29094,PLAINTEXT_HOST://localhost:9094
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 2
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 2
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 2
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
      KAFKA_JMX_PORT: 9103
      KAFKA_JMX_HOSTNAME: localhost
    volumes:
      - ./data/kafka3:/var/lib/kafka/data
    networks:
      - kafka-network

  kafka-ui:
    image: provectuslabs/kafka-ui:latest
    container_name: kafka-ui-scaled
    depends_on:
      - kafka1
      - kafka2
      - kafka3
    ports:
      - "8080:8080"
    environment:
      KAFKA_CLUSTERS_0_NAME: local-cluster
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: kafka1:29092,kafka2:29093,kafka3:29094
      KAFKA_CLUSTERS_0_ZOOKEEPER: zookeeper:2181
    networks:
      - kafka-network
    # TODO: Add a 4th broker here if you need to test larger cluster sizes

networks:
  kafka-network:
    driver: bridge
```

### 🔄 Subtask 5.2: Stop Current Setup and Start Scaled Version

```bash
# 🛑 Stop the current single-broker setup
docker-compose down

# 🚀 Start the scaled setup
docker-compose -f docker-compose-scaled.yml up -d
```

### 🔎 Subtask 5.3: Verify Multi-Broker Cluster

```bash
# 🔎 Check that all brokers are running
docker-compose -f docker-compose-scaled.yml ps
```
✅ **Sign of success:** `kafka1`, `kafka2`, `kafka3`, `zookeeper`, and `kafka-ui-scaled` all report `Up`.

### 🏷️ Subtask 5.4: Create Replicated Topic

```bash
# 🏷️ Create a topic with replication across brokers
docker exec -it kafka1 kafka-topics --create \
  --topic replicated-messages \
  --bootstrap-server localhost:9092 \
  --partitions 6 \
  --replication-factor 3

# ✅ Verify the topic configuration
docker exec -it kafka1 kafka-topics --describe \
  --topic replicated-messages \
  --bootstrap-server localhost:9092
```
✅ **Sign of success:** the describe output shows 6 partitions each with 3 replicas.

### 📝 Subtask 5.5: Test Multi-Broker Producer

```bash
nano producer_scaled.py
```

```python
#!/usr/bin/env python3
# 📤 Producer that targets all three brokers with full-ack replication

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
        acks='all',  # ✅ Wait for all replicas to acknowledge
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

            time.sleep(1)  # ⏱️ Send message every second

    except KeyboardInterrupt:
        print(f"\nStopping producer. Total messages sent: {message_count}")
    finally:
        producer.close()

if __name__ == "__main__":
    main()
```
✅ **Sign of success:** messages are distributed across multiple partitions, visible in the `partition N` output.

### 💥 Subtask 5.6: Test Fault Tolerance

```bash
# ▶️ Start the scaled producer
python3 producer_scaled.py
```

In another terminal, simulate broker failure:
```bash
# 🛑 Stop one broker
docker stop kafka2

# 🔍 Check cluster status
docker exec -it kafka1 kafka-topics --describe \
  --topic replicated-messages \
  --bootstrap-server localhost:9092
```
✅ **Sign of success:** the producer keeps sending messages even with `kafka2` down.

```bash
# ▶️ Restart the stopped broker
docker start kafka2
```

### 📡 Subtask 5.7: Monitor Cluster Performance

```bash
nano cluster_monitor.py
```

```python
#!/usr/bin/env python3
# 📡 Polls broker liveness and topic replication status on a loop

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

            # 📡 Check each broker status
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

            # 🔁 Check topic replication
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
            time.sleep(15)  # ⏱️ Update every 15 seconds

        except KeyboardInterrupt:
            print("\nCluster monitoring stopped.")
            break

if __name__ == "__main__":
    main()
```

```bash
# ▶️ Run the cluster monitor
python3 cluster_monitor.py
```
✅ **Sign of success:** all three brokers report `RUNNING` and partition replicas are listed for `replicated-messages`.

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔴 Issue 1: Containers Not Starting</summary>

**Problem:** Services fail to start or exit immediately.

```bash
# 📜 Check logs for specific errors
docker-compose logs [service-name]

# 🔍 Ensure ports are not in use
netstat -tulpn | grep -E "(2181|9092|9093|9094|8080)"

# 🧹 Clean up and restart
docker-compose down -v
docker-compose up -d
```
</details>

<details>
<summary>🟠 Issue 2: Producer/Consumer Connection Issues</summary>

**Problem:** Cannot connect to Kafka brokers.

```bash
# ✅ Verify Kafka is accepting connections
docker exec -it kafka1 kafka-topics --list --bootstrap-server localhost:9092

# 🌐 Check network connectivity
docker network ls
docker network inspect kafka-docker-lab_kafka-network
```
</details>

<details>
<summary>🟡 Issue 3: Topic Creation Failures</summary>

**Problem:** Cannot create topics or topics not visible.

```bash
# ⏳ Wait for Kafka to fully start
docker-compose logs kafka1 | grep "started (kafka.server.KafkaServer)"

# 🏷️ Manually create topic with explicit settings
docker exec -it kafka1 kafka-topics --create \
  --topic test-topic \
  --bootstrap-server localhost:9092 \
  --partitions 1 \
  --replication-factor 1
```
</details>

<details>
<summary>🔵 Issue 4: Performance Issues</summary>

**Problem:** Slow message processing or high latency.

```bash
# 🔧 Increase container resources
docker-compose down
# Edit docker-compose.yml to add resource limits
docker-compose up -d

# 📊 Monitor resource usage
docker stats

# ⚙️ Optimize Kafka configuration for your use case
```
</details>

---

## 🧹 Lab Cleanup

```bash
# 🛑 Stop and remove containers
docker-compose -f docker-compose-scaled.yml down

# 🗑️ Remove volumes (optional - this will delete all data)
docker-compose -f docker-compose-scaled.yml down -v

# 🧹 Remove unused Docker resources
docker system prune -f
```
✅ **Sign of success:** `docker ps -a` shows no remaining Kafka/Zookeeper/Kafka-UI containers.

---

## 📊 Key Concepts Summary

> This is a big-data/messaging infrastructure lab with no detection targets, so a MITRE ATT&CK mapping is not applicable here — the table below covers the core distributed-messaging concepts instead.

| Concept | Description |
|---|---|
| 🐘 **Zookeeper Coordination** | Tracks broker metadata, leader election, and cluster state for Kafka |
| 📨 **Broker & Partition** | A broker hosts topic partitions; partitions enable parallel consumption and throughput |
| 🔁 **Replication Factor** | Number of copies of each partition kept across brokers for fault tolerance |
| ✅ **acks='all'** | Producer setting that waits for all in-sync replicas to acknowledge before considering a write successful |
| 👥 **Consumer Group** | A set of consumers that share the work of reading a topic's partitions |
| 📈 **Horizontal Broker Scaling** | Adding brokers (`kafka1`/`kafka2`/`kafka3`) to spread load and increase resilience |

---

## 🎓 Conclusion

Congratulations! You have successfully completed **Lab 102: Docker for Big Data — Running Apache Kafka with Docker Compose**.

### 🏆 What You Accomplished
- 📨 **Deployed a Complete Kafka Ecosystem** — set up Zookeeper, Kafka brokers, and monitoring tools using Docker Compose
- 🧩 **Mastered Container Orchestration** — learned how to configure multi-service applications with proper networking and data persistence
- 📤 **Implemented Messaging Patterns** — created functional producers and consumers that demonstrate real-world messaging scenarios
- 📊 **Monitored System Performance** — used multiple approaches to monitor Kafka broker performance and cluster health
- 📈 **Achieved High Availability** — scaled Kafka brokers horizontally and tested fault tolerance in a distributed environment

### 💡 Why This Matters
- 📈 **Scalability** — understanding how to scale message brokers is essential for handling growing data volumes
- 🛡️ **Reliability** — learning fault tolerance patterns helps build robust production systems
- 📊 **Monitoring** — performance monitoring skills are critical for maintaining healthy distributed systems
- 🐳 **Containerization** — Docker and Docker Compose skills are fundamental for modern DevOps practices

### ➡️ Next Steps
- 🔌 Explore Kafka Connect for integrating with external systems
- 🌊 Learn about Kafka Streams for real-time data processing
- ⚙️ Study advanced Kafka configurations for production environments
- 🧰 Practice with other big data tools in containerized environments
- ☸️ Investigate Kubernetes for orchestrating Kafka at enterprise scale

> 🎖️ This lab has provided you with practical experience in deploying and managing Apache Kafka using Docker, preparing you for real-world big data challenges and supporting your journey toward **Docker Certified Associate (DCA)** certification.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
