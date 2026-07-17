<div align="center">

# 📊 Logging and Monitoring with Docker
### Setting Up the ELK Stack (Elasticsearch, Logstash, Kibana)

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Elasticsearch](https://img.shields.io/badge/Elasticsearch-8.11.0-005571?style=for-the-badge&logo=elasticsearch&logoColor=white)
![Logstash](https://img.shields.io/badge/Logstash-8.11.0-005571?style=for-the-badge&logo=elasticstack&logoColor=white)
![Kibana](https://img.shields.io/badge/Kibana-8.11.0-005571?style=for-the-badge&logo=kibana&logoColor=white)
![Filebeat](https://img.shields.io/badge/Filebeat-005571?style=for-the-badge&logo=elasticstack&logoColor=white)
![Level](https://img.shields.io/badge/Level-Intermediate-orange?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment](#️-lab-environment)
- [🧩 Technology Stack](#-technology-stack)
- [🧱 Task 1: Set Up the ELK Stack with Docker Compose](#-task-1-set-up-the-elk-stack-with-docker-compose)
- [📥 Task 2: Configure Logstash to Receive Docker Container Logs](#-task-2-configure-logstash-to-receive-docker-container-logs)
- [📊 Task 3: Use Kibana to Visualize Log Data](#-task-3-use-kibana-to-visualize-log-data)
- [🔗 Task 4: Integrate Additional Docker Containers](#-task-4-integrate-additional-docker-containers)
- [🏭 Task 5: Advanced ELK Stack Management with Docker Compose](#-task-5-advanced-elk-stack-management-with-docker-compose)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [✅ Lab Validation](#-lab-validation)
- [🎓 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | 🧱 Set up and configure the complete ELK stack (Elasticsearch, Logstash, and Kibana) using Docker Compose |
| 2 | 📥 Configure Logstash to receive and parse logs from Docker containers |
| 3 | 📊 Create visualizations and dashboards in Kibana to monitor log data |
| 4 | 🔗 Integrate multiple Docker containers to send logs to the ELK stack |
| 5 | ⚙️ Manage the entire logging infrastructure using Docker Compose |
| 6 | 📖 Understand best practices for centralized logging in containerized environments |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker basics | Basic understanding of Docker containers and Docker Compose |
| 📄 YAML familiarity | Familiarity with YAML configuration files |
| ⌨️ Linux CLI | Basic knowledge of Linux command line operations |
| 📜 Logging concepts | Understanding of logging concepts and log formats |
| 💾 RAM | At least 8GB of RAM available on your system (ELK stack is resource-intensive) |

---

## 🖥️ Lab Environment

> **☁️ Ready-to-Use Cloud Machines**
> Al Nafi provides pre-configured Linux-based cloud machines for this lab. Simply click **Start Lab** to access your environment — no need to build your own VM or install Docker. Your machine comes with Docker and Docker Compose pre-installed.

---

## 🧩 Technology Stack

<div align="center">

| Technology | Role in This Lab |
|---|---|
| ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white) | Containerizes every stack component |
| ![Compose](https://img.shields.io/badge/Compose-2496ED?style=flat-square&logo=docker&logoColor=white) | Orchestrates ELK + sample application services |
| ![Elasticsearch](https://img.shields.io/badge/Elasticsearch-005571?style=flat-square&logo=elasticsearch&logoColor=white) | Stores and indexes log data |
| ![Logstash](https://img.shields.io/badge/Logstash-005571?style=flat-square&logo=elasticstack&logoColor=white) | Receives, parses, and forwards logs |
| ![Kibana](https://img.shields.io/badge/Kibana-005571?style=flat-square&logo=kibana&logoColor=white) | Visualizes log data via dashboards |
| ![Filebeat](https://img.shields.io/badge/Filebeat-005571?style=flat-square&logo=elasticstack&logoColor=white) | Ships container log files to Logstash |

</div>

---

## 🧱 Task 1: Set Up the ELK Stack with Docker Compose

### 📁 Subtask 1.1: Create Project Directory Structure

```bash
# 📂 Create main project directory
mkdir elk-stack-lab
cd elk-stack-lab

# 📂 Create subdirectories for configuration files
mkdir -p config/elasticsearch
mkdir -p config/logstash
mkdir -p config/kibana
mkdir -p logs
mkdir -p data/elasticsearch
```

### 🔍 Subtask 1.2: Configure Elasticsearch

```bash
nano config/elasticsearch/elasticsearch.yml
```

```yaml
cluster.name: "docker-cluster"
network.host: 0.0.0.0
discovery.type: single-node
xpack.security.enabled: false
xpack.monitoring.collection.enabled: true
```

### 📊 Subtask 1.3: Configure Kibana

```bash
nano config/kibana/kibana.yml
```

```yaml
server.name: kibana
server.host: 0.0.0.0
elasticsearch.hosts: ["http://elasticsearch:9200"]
monitoring.ui.container.elasticsearch.enabled: true
```

### 📥 Subtask 1.4: Configure Logstash

```bash
nano config/logstash/pipeline.conf
```

```conf
input {
  beats {
    port => 5044
  }

  gelf {
    port => 12201
  }

  tcp {
    port => 5000
    codec => json_lines
  }
}

filter {
  if [docker] {
    if [docker][container][name] {
      mutate {
        add_field => { "container_name" => "%{[docker][container][name]}" }
      }
    }
  }

  # 🔍 Parse common log formats
  if [message] =~ /^\d{4}-\d{2}-\d{2}/ {
    grok {
      match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:log_level} %{GREEDYDATA:log_message}" }
    }

    date {
      match => [ "timestamp", "yyyy-MM-dd HH:mm:ss.SSS" ]
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "docker-logs-%{+YYYY.MM.dd}"
  }

  stdout {
    codec => rubydebug
  }
}
```

```bash
nano config/logstash/logstash.yml
```

```yaml
http.host: "0.0.0.0"
xpack.monitoring.elasticsearch.hosts: ["http://elasticsearch:9200"]
```

### 🧱 Subtask 1.5: Create Docker Compose File

```bash
nano docker-compose.yml
```

```yaml
version: '3.8'

services:
  # 🔍 Elasticsearch — stores and indexes logs
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
      - xpack.security.enabled=false
      - xpack.security.enrollment.enabled=false
    volumes:
      - ./config/elasticsearch/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml:ro
      - ./data/elasticsearch:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
      - "9300:9300"
    networks:
      - elk-network
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:9200/_cluster/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5

  # 📥 Logstash — receives, parses, forwards logs
  logstash:
    image: docker.elastic.co/logstash/logstash:8.11.0
    container_name: logstash
    volumes:
      - ./config/logstash/pipeline.conf:/usr/share/logstash/pipeline/logstash.conf:ro
      - ./config/logstash/logstash.yml:/usr/share/logstash/config/logstash.yml:ro
    ports:
      - "5044:5044"
      - "5000:5000/tcp"
      - "5000:5000/udp"
      - "12201:12201/udp"
    networks:
      - elk-network
    depends_on:
      elasticsearch:
        condition: service_healthy
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:9600 || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5

  # 📊 Kibana — visualizes log data
  kibana:
    image: docker.elastic.co/kibana/kibana:8.11.0
    container_name: kibana
    volumes:
      - ./config/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml:ro
    ports:
      - "5601:5601"
    networks:
      - elk-network
    depends_on:
      logstash:
        condition: service_healthy
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:5601/api/status || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5

networks:
  elk-network:
    driver: bridge

volumes:
  elasticsearch-data:
    driver: local
```

### 🚀 Subtask 1.6: Start the ELK Stack

```bash
# 🚀 Start the ELK stack in detached mode
docker-compose up -d

# 📡 Monitor the startup process
docker-compose logs -f
```

> ⏳ Wait for all services to be healthy. This may take 2-3 minutes.

### ✅ Subtask 1.7: Verify ELK Stack Installation

```bash
# ✅ Check container status
docker-compose ps

# 🔍 Test Elasticsearch
curl -X GET "localhost:9200/_cluster/health?pretty"

# 📥 Test Logstash
curl -X GET "localhost:9600"

# 📊 Access Kibana (should show Kibana interface)
echo "Open your browser and navigate to: http://localhost:5601"
```

---

## 📥 Task 2: Configure Logstash to Receive Docker Container Logs

### 🐍 Subtask 2.1: Create a Sample Application with Logging

```bash
mkdir sample-app
cd sample-app
nano app.py
```

```python
# sample-app/app.py
from flask import Flask, jsonify
import logging
import json
import time
import random
from datetime import datetime

app = Flask(__name__)

# 📜 Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s %(message)s',
    handlers=[
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

@app.route('/')
def home():
    logger.info("Home page accessed")
    return jsonify({
        "message": "Welcome to Sample App",
        "timestamp": datetime.now().isoformat(),
        "status": "success"
    })

@app.route('/api/data')
def get_data():
    # 🎲 Simulate different log levels
    log_level = random.choice(['info', 'warning', 'error'])

    if log_level == 'info':
        logger.info("Data endpoint accessed successfully")
    elif log_level == 'warning':
        logger.warning("Data endpoint accessed with potential issues")
    else:
        logger.error("Data endpoint encountered an error")

    return jsonify({
        "data": [1, 2, 3, 4, 5],
        "timestamp": datetime.now().isoformat(),
        "log_level": log_level
    })

@app.route('/health')
def health():
    logger.info("Health check performed")
    return jsonify({"status": "healthy", "timestamp": datetime.now().isoformat()})

if __name__ == '__main__':
    logger.info("Starting Sample Application")
    app.run(host='0.0.0.0', port=5000, debug=True)
```

```bash
nano Dockerfile
```

```dockerfile
FROM python:3.9-slim

WORKDIR /app

RUN pip install flask

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

### 📤 Subtask 2.2: Configure Docker Logging Driver

```bash
nano docker-compose-app.yml
```

```yaml
version: '3.8'

services:
  sample-app:
    build: .
    container_name: sample-app
    ports:
      - "8080:5000"
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
        tag: "sample-app"
    networks:
      - elk-stack-lab_elk-network
    depends_on:
      - logstash-forwarder

  nginx-app:
    image: nginx:alpine
    container_name: nginx-sample
    ports:
      - "8081:80"
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
        tag: "nginx-app"
    networks:
      - elk-stack-lab_elk-network
    depends_on:
      - logstash-forwarder

  # 🔀 Forwards GELF-formatted logs into the main Logstash pipeline
  logstash-forwarder:
    image: docker.elastic.co/logstash/logstash:8.11.0
    container_name: logstash-forwarder
    command: >
      bash -c "
        echo 'input { 
          gelf { port => 12201 } 
        } 
        output { 
          tcp { 
            host => \"logstash\" 
            port => 5000 
            codec => json_lines 
          } 
        }' > /usr/share/logstash/pipeline/logstash.conf &&
        /usr/local/bin/docker-entrypoint
      "
    ports:
      - "12201:12201/udp"
    networks:
      - elk-stack-lab_elk-network

networks:
  elk-stack-lab_elk-network:
    external: true
```

### 🚀 Subtask 2.3: Start Sample Applications

```bash
# 🏗️ Build and start the sample applications
docker-compose -f docker-compose-app.yml up -d

# ✅ Check if applications are running
docker-compose -f docker-compose-app.yml ps
```

### 🚦 Subtask 2.4: Generate Log Data

```bash
# 🐍 Generate logs from the sample Flask app
for i in {1..10}; do
  curl http://localhost:8080/
  curl http://localhost:8080/api/data
  curl http://localhost:8080/health
  sleep 2
done

# 🌐 Generate logs from Nginx
for i in {1..5}; do
  curl http://localhost:8081/
  sleep 1
done
```

---

## 📊 Task 3: Use Kibana to Visualize Log Data

### 🔗 Subtask 3.1: Access Kibana Dashboard

```bash
echo "Open your browser and go to: http://localhost:5601"
```

### 🗂️ Subtask 3.2: Create Index Pattern

1. In Kibana, click **Management** in the left sidebar
2. Click **Stack Management**
3. Under **Kibana**, click **Index Patterns**
4. Click **Create index pattern**
5. Enter `docker-logs-*` as the index pattern
6. Click **Next step**
7. Select `@timestamp` as the time field
8. Click **Create index pattern**

### 🔎 Subtask 3.3: Explore Logs in Discover

1. Click **Discover** in the left sidebar
2. Select the `docker-logs-*` index pattern
3. Set the time range to **Last 15 minutes**
4. Explore the log entries and available fields

### 📈 Subtask 3.4: Create Basic Visualizations

1. Click **Visualize Library** in the left sidebar
2. Click **Create visualization**
3. Select **Vertical bar chart**
4. Choose the `docker-logs-*` index pattern
5. Configure the chart:
   - Y-axis: `Count`
   - X-axis: `Date Histogram` on `@timestamp`
6. Click **Save** and name it `Log Count Over Time`

### 🖼️ Subtask 3.5: Create a Dashboard

1. Click **Dashboard** in the left sidebar
2. Click **Create dashboard**
3. Click **Add an existing**
4. Select the **Log Count Over Time** visualization
5. Click **Save** and name the dashboard `Docker Logs Dashboard`

---

## 🔗 Task 4: Integrate Additional Docker Containers

### 🧩 Subtask 4.1: Create a Multi-Service Application

```bash
cd ..
mkdir multi-service-app
cd multi-service-app
nano docker-compose-multi.yml
```

```yaml
version: '3.8'

services:
  web-frontend:
    image: nginx:alpine
    container_name: web-frontend
    ports:
      - "8082:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
        tag: "web-frontend"
    networks:
      - elk-stack-lab_elk-network
    depends_on:
      - api-backend

  api-backend:
    image: python:3.9-slim
    container_name: api-backend
    command: >
      bash -c "
        pip install flask requests &&
        python -c \"
from flask import Flask, jsonify
import logging
import time
from datetime import datetime

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route('/api/users')
def users():
    logger.info('Users API called')
    return jsonify({'users': ['Alice', 'Bob', 'Charlie']})

@app.route('/api/orders')
def orders():
    logger.info('Orders API called')
    return jsonify({'orders': [{'id': 1, 'item': 'laptop'}, {'id': 2, 'item': 'mouse'}]})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
        \"
      "
    ports:
      - "8083:5000"
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
        tag: "api-backend"
    networks:
      - elk-stack-lab_elk-network

  database:
    image: postgres:13-alpine
    container_name: database
    environment:
      POSTGRES_DB: testdb
      POSTGRES_USER: testuser
      POSTGRES_PASSWORD: testpass
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
        tag: "database"
    networks:
      - elk-stack-lab_elk-network

  redis-cache:
    image: redis:alpine
    container_name: redis-cache
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
        tag: "redis-cache"
    networks:
      - elk-stack-lab_elk-network

networks:
  elk-stack-lab_elk-network:
    external: true
```

<!-- TODO: Replace POSTGRES_PASSWORD with a strong, unique secret outside of this lab environment -->

```bash
nano nginx.conf
```

```nginx
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server api-backend:5000;
    }

    server {
        listen 80;

        location / {
            return 200 'Frontend Service Running';
            add_header Content-Type text/plain;
        }

        location /api/ {
            proxy_pass http://backend/api/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

### 🚀 Subtask 4.2: Start Multi-Service Application

```bash
# 🚀 Start all services
docker-compose -f docker-compose-multi.yml up -d

# ✅ Check service status
docker-compose -f docker-compose-multi.yml ps
```

### 🚦 Subtask 4.3: Generate Diverse Log Data

```bash
# 🌐 Test frontend
curl http://localhost:8082/

# 🔌 Test API endpoints
curl http://localhost:8082/api/users
curl http://localhost:8082/api/orders

# 🎯 Direct API calls
curl http://localhost:8083/api/users
curl http://localhost:8083/api/orders

# 🚦 Generate continuous traffic
for i in {1..20}; do
  curl -s http://localhost:8082/ > /dev/null
  curl -s http://localhost:8082/api/users > /dev/null
  curl -s http://localhost:8082/api/orders > /dev/null
  sleep 1
done
```

---

## 🏭 Task 5: Advanced ELK Stack Management with Docker Compose

### 🏗️ Subtask 5.1: Create Production-Ready Configuration

```bash
cd ../../elk-stack-lab
nano docker-compose-production.yml
```

```yaml
version: '3.8'

services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.0
    container_name: elasticsearch-prod
    environment:
      - cluster.name=production-cluster
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms2g -Xmx2g"
      - xpack.security.enabled=false
      - xpack.monitoring.collection.enabled=true
    volumes:
      - elasticsearch-data:/usr/share/elasticsearch/data
      - ./config/elasticsearch/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml:ro
    ports:
      - "9200:9200"
    networks:
      - elk-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:9200/_cluster/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5

  logstash:
    image: docker.elastic.co/logstash/logstash:8.11.0
    container_name: logstash-prod
    volumes:
      - ./config/logstash/pipeline.conf:/usr/share/logstash/pipeline/logstash.conf:ro
      - ./config/logstash/logstash.yml:/usr/share/logstash/config/logstash.yml:ro
      - ./logs:/var/log/logstash
    ports:
      - "5044:5044"
      - "5000:5000"
      - "12201:12201/udp"
    networks:
      - elk-network
    depends_on:
      elasticsearch:
        condition: service_healthy
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:9600 || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5

  kibana:
    image: docker.elastic.co/kibana/kibana:8.11.0
    container_name: kibana-prod
    volumes:
      - ./config/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml:ro
    ports:
      - "5601:5601"
    networks:
      - elk-network
    depends_on:
      logstash:
        condition: service_healthy
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:5601/api/status || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5

  # 📦 Filebeat — ships Docker container log files directly to Logstash
  filebeat:
    image: docker.elastic.co/beats/filebeat:8.11.0
    container_name: filebeat
    user: root
    volumes:
      - ./config/filebeat/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - elk-network
    depends_on:
      logstash:
        condition: service_healthy
    restart: unless-stopped

networks:
  elk-network:
    driver: bridge

volumes:
  elasticsearch-data:
    driver: local
```

### 📦 Subtask 5.2: Configure Filebeat

```bash
mkdir -p config/filebeat
nano config/filebeat/filebeat.yml
```

```yaml
filebeat.inputs:
- type: container
  paths:
    - '/var/lib/docker/containers/*/*.log'
  processors:
  - add_docker_metadata:
      host: "unix:///var/run/docker.sock"

output.logstash:
  hosts: ["logstash:5044"]

logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
  permissions: 0644
```

### 📝 Subtask 5.3: Create Management Scripts

```bash
nano manage-elk.sh
```

```bash
#!/bin/bash

COMPOSE_FILE="docker-compose-production.yml"

case "$1" in
    start)
        echo "Starting ELK Stack..."
        docker-compose -f $COMPOSE_FILE up -d
        echo "Waiting for services to be ready..."
        sleep 30
        echo "ELK Stack started successfully!"
        ;;
    stop)
        echo "Stopping ELK Stack..."
        docker-compose -f $COMPOSE_FILE down
        echo "ELK Stack stopped!"
        ;;
    restart)
        echo "Restarting ELK Stack..."
        docker-compose -f $COMPOSE_FILE restart
        echo "ELK Stack restarted!"
        ;;
    status)
        echo "ELK Stack Status:"
        docker-compose -f $COMPOSE_FILE ps
        ;;
    logs)
        if [ -z "$2" ]; then
            docker-compose -f $COMPOSE_FILE logs -f
        else
            docker-compose -f $COMPOSE_FILE logs -f $2
        fi
        ;;
    cleanup)
        echo "Cleaning up ELK Stack..."
        docker-compose -f $COMPOSE_FILE down -v
        docker system prune -f
        echo "Cleanup completed!"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs [service]|cleanup}"
        exit 1
        ;;
esac
```

```bash
# 🔓 Make the script executable
chmod +x manage-elk.sh
```

### 🧪 Subtask 5.4: Test Production Configuration

```bash
# 🚀 Start production ELK stack
./manage-elk.sh start

# ✅ Check status
./manage-elk.sh status

# 📜 View logs
./manage-elk.sh logs elasticsearch
```

### 🗂️ Subtask 5.5: Create Index Templates

```bash
# ⏳ Wait for Elasticsearch to be ready
sleep 60

# 🗂️ Create index template
curl -X PUT "localhost:9200/_index_template/docker-logs-template" -H 'Content-Type: application/json' -d'
{
  "index_patterns": ["docker-logs-*"],
  "template": {
    "settings": {
      "number_of_shards": 1,
      "number_of_replicas": 0,
      "index.lifecycle.name": "docker-logs-policy",
      "index.lifecycle.rollover_alias": "docker-logs"
    },
    "mappings": {
      "properties": {
        "@timestamp": {
          "type": "date"
        },
        "container_name": {
          "type": "keyword"
        },
        "log_level": {
          "type": "keyword"
        },
        "message": {
          "type": "text",
          "analyzer": "standard"
        }
      }
    }
  }
}'
```

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔴 Issue 1: Elasticsearch Won't Start</summary>

**Problem:** Elasticsearch container fails to start with memory errors.

```bash
# 📈 Increase virtual memory
sudo sysctl -w vm.max_map_count=262144

# 💾 Make it permanent
echo 'vm.max_map_count=262144' | sudo tee -a /etc/sysctl.conf
```
</details>

<details>
<summary>🔴 Issue 2: Logstash Not Receiving Logs</summary>

**Problem:** Logs are not appearing in Elasticsearch.

```bash
# 📜 Check Logstash logs
docker-compose logs logstash

# 🧪 Test Logstash input
echo '{"message": "test log", "timestamp": "'$(date -Iseconds)'"}' | nc localhost 5000

# ✅ Verify Elasticsearch indices
curl "localhost:9200/_cat/indices?v"
```
</details>

<details>
<summary>🔴 Issue 3: Kibana Connection Issues</summary>

**Problem:** Kibana cannot connect to Elasticsearch.

```bash
# ✅ Check if Elasticsearch is accessible
curl "localhost:9200/_cluster/health"

# 🔄 Restart Kibana
docker-compose restart kibana

# 📜 Check Kibana logs
docker-compose logs kibana
```
</details>

<details>
<summary>🔴 Issue 4: High Resource Usage</summary>

**Problem:** ELK stack consuming too much memory.

```bash
# 📉 Reduce Elasticsearch heap size in docker-compose.yml
# Change: "ES_JAVA_OPTS=-Xms2g -Xmx2g"
# To: "ES_JAVA_OPTS=-Xms512m -Xmx512m"

# 📊 Monitor resource usage
docker stats
```
</details>

---

## ✅ Lab Validation

Verify your lab completion by checking the following:

| # | Check | Command / Action |
|---|---|---|
| 1 | 🧱 **ELK Stack Running** — all three services (Elasticsearch, Logstash, Kibana) are running | `docker-compose ps` |
| 2 | ❤️ **Elasticsearch Health** — cluster is healthy | `curl "localhost:9200/_cluster/health?pretty"` |
| 3 | 📥 **Log Ingestion** — logs are being received and indexed | `curl "localhost:9200/docker-logs-*/_search?pretty&size=5"` |
| 4 | 📊 **Kibana Access** — dashboard is accessible and showing data | Open `http://localhost:5601` → **Discover** → verify log entries are visible |
| 5 | 🔗 **Multiple Container Integration** — logs from different containers are visible | Check for logs from `sample-app`, `nginx`, `api-backend`, etc. |

---

## 🎓 Conclusion

Congratulations! You have successfully completed **Lab 28: Logging and Monitoring with Docker - Setting Up ELK Stack**.

### 🏆 What You Accomplished

- 🧱 Set up a complete ELK stack using Docker Compose with Elasticsearch, Logstash, and Kibana
- 📤 Configured centralized logging for Docker containers using various logging drivers
- 🔍 Created log parsing and filtering rules in Logstash to structure log data
- 📊 Built visualizations and dashboards in Kibana to monitor application logs
- 🔗 Integrated multiple services to send logs to a centralized logging system
- 🏭 Implemented production-ready configurations with health checks and restart policies
- 🛠️ Learned troubleshooting techniques for common ELK stack issues

### 🌍 Why This Matters

| Theme | Why It Matters |
|---|---|
| 👁️ Operational Visibility | Monitor application health and performance across all services |
| 🐛 Debugging and Troubleshooting | Quickly identify and resolve issues in distributed systems |
| 🔒 Security Monitoring | Detect suspicious activities and security threats |
| 📜 Compliance | Meet regulatory requirements for log retention and auditing |
| ⚡ Performance Optimization | Identify bottlenecks and optimize system performance |

### 🔭 Next Steps

- 🔍 Explore advanced Logstash filters and processors
- 🗂️ Learn about Elasticsearch index lifecycle management
- 🚨 Implement alerting with Elasticsearch Watcher
- 🧩 Study log aggregation patterns for microservices
- 📄 Practice with different log formats and parsing techniques
- 📈 Explore integration with metrics monitoring tools like **Prometheus**

> 🏁 This lab provides a solid foundation for implementing enterprise-grade logging solutions in containerized environments, preparing you for real-world DevOps and system administration challenges.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blue?style=for-the-badge)

</div>
