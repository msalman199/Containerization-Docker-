<div align="center">

# 🧩 Docker Compose for Complex Applications 🐘

### Orchestrating a Multi-Service Flask + Redis + PostgreSQL Stack with Scaling and Load Balancing

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![DockerCompose](https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

![Level](https://img.shields.io/badge/Level-Intermediate-orange?style=for-the-badge)
![Duration](https://img.shields.io/badge/Duration-105%20min-informational?style=for-the-badge)
![Track](https://img.shields.io/badge/Track-DevOps%20%2F%20Orchestration-blueviolet?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Objectives](#-objectives)
- [🧩 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [1️⃣ Task 1: Create a Docker Compose File for Multi-Service Application](#1️⃣-task-1-create-a-docker-compose-file-for-multi-service-application)
- [2️⃣ Task 2: Configure Environment Variables and Container Links](#2️⃣-task-2-configure-environment-variables-and-container-links)
- [3️⃣ Task 3: Manage Services with Docker Compose](#3️⃣-task-3-manage-services-with-docker-compose)
- [4️⃣ Task 4: View Logs for All Services](#4️⃣-task-4-view-logs-for-all-services)
- [5️⃣ Task 5: Implement Service Scaling](#5️⃣-task-5-implement-service-scaling)
- [🐛 Troubleshooting Tips](#-troubleshooting-tips)
- [❤️ Health Check Commands](#️-health-check-commands)
- [✅ Best Practices Implemented](#-best-practices-implemented)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Create a comprehensive `docker-compose.yml` file for multi-service applications |
| 2 | Configure environment variables and establish communication between containers |
| 3 | Manage complex Docker services using Docker Compose commands |
| 4 | Monitor and troubleshoot multi-container applications using logs |
| 5 | Scale individual services within a Docker Compose environment |
| 6 | Understand best practices for orchestrating complex containerized applications |

---

## 🧩 Prerequisites

| Requirement | Description |
|-------------|-------------|
| 🐳 Docker basics | Understanding of Docker containers and images |
| 📄 YAML familiarity | Comfort reading and editing YAML file format |
| 🌐 App architecture | Basic knowledge of web applications, databases, and caching systems |
| 🔧 Env vars & networking | Understanding of environment variables and networking concepts |
| 💻 Terminal access | Access to a terminal or command-line interface |

> 🖱️ **Ready-to-Use Cloud Machines:** Al Nafi provides pre-configured Linux-based cloud machines with Docker and Docker Compose already installed. Simply click **Start Lab** to access your environment — no need to build your own VM or install Docker manually.

---

## 🖥️ Lab Environment Setup

Your cloud machine comes with:

- 🐳 Docker Engine (latest stable version)
- 🧩 Docker Compose (latest stable version)
- 📝 Text editor (nano/vim)
- 🔐 All necessary networking and permissions configured

---

## 1️⃣ Task 1: Create a Docker Compose File for Multi-Service Application

### 🔹 Subtask 1.1: Create Project Directory Structure

```bash
# 📁 Create a proper directory structure for our complex application
mkdir complex-app-lab
cd complex-app-lab
mkdir web-app
mkdir config
```

### 🔹 Subtask 1.2: Create a Simple Web Application

> 🐍 A Flask app that talks to both Redis and PostgreSQL.

```bash
cd web-app
# 📝 Create the main application file
nano app.py
```

```python
# 🐍 web-app/app.py
from flask import Flask, request, jsonify
import redis
import psycopg2
import os
import json
from datetime import datetime

app = Flask(__name__)

# 🔴 Redis connection
redis_client = redis.Redis(
    host=os.getenv('REDIS_HOST', 'redis'),
    port=int(os.getenv('REDIS_PORT', 6379)),
    decode_responses=True
)

# 🐘 PostgreSQL connection parameters
db_params = {
    'host': os.getenv('POSTGRES_HOST', 'postgres'),
    'database': os.getenv('POSTGRES_DB', 'appdb'),
    'user': os.getenv('POSTGRES_USER', 'appuser'),
    'password': os.getenv('POSTGRES_PASSWORD', 'apppass'),
    'port': int(os.getenv('POSTGRES_PORT', 5432))
}

@app.route('/')
def home():
    return jsonify({
        'message': 'Complex Application with Redis and PostgreSQL',
        'timestamp': datetime.now().isoformat(),
        'services': ['web', 'redis', 'postgres']
    })

@app.route('/cache/<key>')
def get_cache(key):
    # 📥 Read a cached value from Redis
    try:
        value = redis_client.get(key)
        return jsonify({
            'key': key,
            'value': value,
            'cached': value is not None
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/cache/<key>/<value>')
def set_cache(key, value):
    # 📤 Write a value to Redis with a 5-minute expiry
    try:
        redis_client.set(key, value, ex=300)  # Expire in 5 minutes
        return jsonify({
            'message': f'Cached {key} = {value}',
            'expiry': '5 minutes'
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/users')
def get_users():
    # 📋 List users from PostgreSQL
    try:
        conn = psycopg2.connect(**db_params)
        cur = conn.cursor()
        cur.execute('SELECT id, name, email, created_at FROM users ORDER BY created_at DESC')
        users = cur.fetchall()
        cur.close()
        conn.close()

        user_list = []
        for user in users:
            user_list.append({
                'id': user[0],
                'name': user[1],
                'email': user[2],
                'created_at': user[3].isoformat() if user[3] else None
            })

        return jsonify({'users': user_list})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/users', methods=['POST'])
def create_user():
    # ➕ Insert a new user into PostgreSQL
    try:
        data = request.get_json()
        name = data.get('name')
        email = data.get('email')

        if not name or not email:
            return jsonify({'error': 'Name and email are required'}), 400

        conn = psycopg2.connect(**db_params)
        cur = conn.cursor()
        cur.execute(
            'INSERT INTO users (name, email, created_at) VALUES (%s, %s, %s) RETURNING id',
            (name, email, datetime.now())
        )
        user_id = cur.fetchone()[0]
        conn.commit()
        cur.close()
        conn.close()

        return jsonify({
            'message': 'User created successfully',
            'user_id': user_id,
            'name': name,
            'email': email
        }), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health')
def health_check():
    # 💓 Aggregate health status of web, redis, and postgres
    health_status = {'web': 'healthy'}

    # 🔴 Check Redis
    try:
        redis_client.ping()
        health_status['redis'] = 'healthy'
    except:
        health_status['redis'] = 'unhealthy'

    # 🐘 Check PostgreSQL
    try:
        conn = psycopg2.connect(**db_params)
        conn.close()
        health_status['postgres'] = 'healthy'
    except:
        health_status['postgres'] = 'unhealthy'

    return jsonify(health_status)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
```

### 🔹 Subtask 1.3: Create Requirements File

```bash
nano requirements.txt
```

```text
# 📦 web-app/requirements.txt
Flask==2.3.3
redis==5.0.1
psycopg2-binary==2.9.7
```

### 🔹 Subtask 1.4: Create Dockerfile for Web Application

```bash
nano Dockerfile
```

```dockerfile
# 🐳 web-app/Dockerfile
FROM python:3.11-slim

WORKDIR /app

# ⚙️ Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 📦 Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 📋 Copy application code
COPY app.py .

# 🌐 Expose port
EXPOSE 5000

# ▶️ Run the application
CMD ["python", "app.py"]
```

### 🔹 Subtask 1.5: Create Database Initialization Script

```bash
# 📂 Navigate back to the main directory and create database initialization
cd ..
mkdir -p config/postgres
cd config/postgres
nano init.sql
```

```sql
-- 🐘 config/postgres/init.sql

-- 🆕 Create the application database
CREATE DATABASE appdb;

-- 🔗 Connect to the application database
\c appdb;

-- 📋 Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 🌱 Insert sample data
INSERT INTO users (name, email) VALUES
    ('John Doe', 'john.doe@example.com'),
    ('Jane Smith', 'jane.smith@example.com'),
    ('Bob Johnson', 'bob.johnson@example.com');

-- ⚡ Create an index on email for faster lookups
CREATE INDEX idx_users_email ON users(email);

-- 🔐 Grant permissions to the application user
GRANT ALL PRIVILEGES ON DATABASE appdb TO appuser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO appuser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO appuser;
```

### 🔹 Subtask 1.6: Create the Main Docker Compose File

```bash
# 📂 Navigate back to the project root
cd ../..
nano docker-compose.yml
```

```yaml
# 🐳 docker-compose.yml
version: '3.8'

services:
  # 🌐 Web Application Service
  web:
    build: ./web-app
    container_name: complex-app-web
    ports:
      - "8080:5000"
    environment:
      - FLASK_ENV=development
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - POSTGRES_HOST=postgres
      - POSTGRES_DB=appdb
      - POSTGRES_USER=appuser
      - POSTGRES_PASSWORD=apppass
      - POSTGRES_PORT=5432
    depends_on:
      - redis
      - postgres
    networks:
      - app-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  # 🔴 Redis Cache Service
  redis:
    image: redis:7-alpine
    container_name: complex-app-redis
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes --requirepass redispass
    environment:
      - REDIS_PASSWORD=redispass
    volumes:
      - redis-data:/data
    networks:
      - app-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3

  # 🐘 PostgreSQL Database Service
  postgres:
    image: postgres:15-alpine
    container_name: complex-app-postgres
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_DB=appdb
      - POSTGRES_USER=appuser
      - POSTGRES_PASSWORD=apppass
      - POSTGRES_ROOT_PASSWORD=rootpass
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./config/postgres/init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - app-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U appuser -d appdb"]
      interval: 30s
      timeout: 10s
      retries: 3

  # 🛠️ Database Administration Tool (Optional)
  adminer:
    image: adminer:4.8.1
    container_name: complex-app-adminer
    ports:
      - "8081:8080"
    environment:
      - ADMINER_DEFAULT_SERVER=postgres
    depends_on:
      - postgres
    networks:
      - app-network
    restart: unless-stopped

# 💾 Define named volumes for data persistence
volumes:
  redis-data:
    driver: local
  postgres-data:
    driver: local

# 🌐 Define custom network
networks:
  app-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

---

## 2️⃣ Task 2: Configure Environment Variables and Container Links

### 🔹 Subtask 2.1: Create Environment Configuration File

```bash
nano .env
```

```bash
# 🔧 .env

# ⚙️ Application Configuration
FLASK_ENV=development
APP_PORT=8080

# 🔴 Redis Configuration
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=redispass

# 🐘 PostgreSQL Configuration
POSTGRES_HOST=postgres
POSTGRES_DB=appdb
POSTGRES_USER=appuser
POSTGRES_PASSWORD=apppass
POSTGRES_PORT=5432
POSTGRES_ROOT_PASSWORD=rootpass

# 🌐 Network Configuration
NETWORK_SUBNET=172.20.0.0/16
```

### 🔹 Subtask 2.2: Update Docker Compose to Use Environment File

```bash
nano docker-compose.yml
```

```yaml
# ➕ Add the env_file directive to the web service
services:
  web:
    build: ./web-app
    container_name: complex-app-web
    env_file:
      - .env
    ports:
      - "${APP_PORT:-8080}:5000"
    # ⚙️ ... rest of the configuration remains the same
```

### 🔹 Subtask 2.3: Verify Container Communication Setup

> 🔗 The containers are configured to communicate through:

| Mechanism | Description |
|-----------|--------------|
| 🌐 Custom Network | All services are on the `app-network` bridge network |
| 🏷️ Service Names | Containers reach each other using service names (`redis`, `postgres`, `web`) |
| 🔗 Dependencies | The `web` service depends on both `redis` and `postgres` services |
| 💓 Health Checks | Each service has health checks to ensure proper startup order |

---

## 3️⃣ Task 3: Manage Services with Docker Compose

### 🔹 Subtask 3.1: Start All Services

```bash
# 🚀 Start the entire application stack
docker-compose up -d
```

**⚙️ This command will:**
- 🏗️ Build the web application image
- 📥 Pull the Redis and PostgreSQL images
- 🌐 Create the custom network
- ▶️ Start all services in the background

### 🔹 Subtask 3.2: Check Service Status

```bash
# 🔍 Verify that all services are running
docker-compose ps
```

> ✅ **Expected Output:**
> ```
> Name                     Command               State           Ports
> -------------------------------------------------------------------------
> complex-app-adminer   entrypoint.sh docker-php-e...   Up      0.0.0.0:8081->8080/tcp
> complex-app-postgres  docker-entrypoint.sh postgres    Up      0.0.0.0:5432->5432/tcp
> complex-app-redis     docker-entrypoint.sh redis ...   Up      0.0.0.0:6379->6379/tcp
> complex-app-web       python app.py                     Up      0.0.0.0:8080->5000/tcp
> ```

### 🔹 Subtask 3.3: Test Application Functionality

```bash
# 🏠 Test the home endpoint
curl http://localhost:8080/

# 🔴 Test Redis caching
curl http://localhost:8080/cache/testkey/testvalue
curl http://localhost:8080/cache/testkey

# 🐘 Test database functionality
curl http://localhost:8080/users

# 💓 Test health check
curl http://localhost:8080/health
```

### 🔹 Subtask 3.4: Stop Services

```bash
# 🛑 Stop all services
docker-compose stop
```

### 🔹 Subtask 3.5: Restart Services

```bash
# 🔄 Restart all services
docker-compose restart
```

### 🔹 Subtask 3.6: Stop and Remove Services

```bash
# 🗑️ Stop and remove all containers, networks, and volumes
docker-compose down

# ⚠️ To also remove volumes (this will delete all data)
docker-compose down -v
```

---

## 4️⃣ Task 4: View Logs for All Services

### 🔹 Subtask 4.1: View All Service Logs

```bash
# 📜 View logs from all services
docker-compose logs
```

### 🔹 Subtask 4.2: View Logs for Specific Service

```bash
# 🌐 Web application logs
docker-compose logs web

# 🔴 Redis logs
docker-compose logs redis

# 🐘 PostgreSQL logs
docker-compose logs postgres
```

### 🔹 Subtask 4.3: Follow Live Logs

```bash
# 👀 Follow all service logs
docker-compose logs -f

# 👀 Follow specific service logs
docker-compose logs -f web
```

### 🔹 Subtask 4.4: View Recent Logs

```bash
# 📄 Last 50 lines from all services
docker-compose logs --tail=50

# 📄 Last 20 lines from web service
docker-compose logs --tail=20 web
```

### 🔹 Subtask 4.5: View Logs with Timestamps

```bash
# 🕐 View logs with timestamps
docker-compose logs -t
```

---

## 5️⃣ Task 5: Implement Service Scaling

### 🔹 Subtask 5.1: Scale the Web Service

```bash
# ⬆️ Scale the web service to multiple instances
docker-compose up -d --scale web=3
```

> 🧩 This will create 3 instances of the web service.

### 🔹 Subtask 5.2: Verify Scaled Services

```bash
# 🔍 Check the status of scaled services
docker-compose ps
```

> ✅ **Expected Output:** you should see multiple `web` service instances.

### 🔹 Subtask 5.3: Configure Load Balancing (Advanced)

> 🎯 For production use, you would typically add a load balancer.

```bash
# 📁 Create a simple nginx configuration
mkdir nginx
cd nginx
nano nginx.conf
```

```nginx
# 🌐 nginx/nginx.conf
upstream web_servers {
    server web:5000;
}

server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://web_servers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 🔹 Subtask 5.4: Add Load Balancer to Docker Compose

```bash
cd ..
nano docker-compose.yml
```

```yaml
# ➕ Add the nginx service
  # ⚖️ Load Balancer
  nginx:
    image: nginx:alpine
    container_name: complex-app-nginx
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - web
    networks:
      - app-network
    restart: unless-stopped
```

### 🔹 Subtask 5.5: Test Scaled Application

```bash
# 🚀 Start the application with scaling and load balancing
docker-compose up -d --scale web=3

# ⚖️ Test multiple requests to see load balancing
for i in {1..10}; do
  curl http://localhost/
  echo "Request $i completed"
done
```

### 🔹 Subtask 5.6: Scale Down Services

```bash
# ⬇️ Scale down the web service
docker-compose up -d --scale web=1
```

---

## 🐛 Troubleshooting Tips

<details>
<summary>🔴 Issue 1: Port Already in Use</summary>

```bash
# 🔍 Check what's using the port
sudo netstat -tulpn | grep :8080

# 🛑 Kill the process or change the port in docker-compose.yml
```

</details>

<details>
<summary>🟠 Issue 2: Database Connection Errors</summary>

```bash
# ✅ Check if PostgreSQL is ready
docker-compose exec postgres pg_isready -U appuser -d appdb

# 📜 View PostgreSQL logs
docker-compose logs postgres
```

</details>

<details>
<summary>🟡 Issue 3: Redis Connection Errors</summary>

```bash
# 🧪 Test Redis connection
docker-compose exec redis redis-cli ping

# 📜 Check Redis logs
docker-compose logs redis
```

</details>

<details>
<summary>🟢 Issue 4: Build Failures</summary>

```bash
# 🏗️ Rebuild without cache
docker-compose build --no-cache

# 🔄 Remove all containers and rebuild
docker-compose down
docker-compose up --build
```

</details>

---

## ❤️ Health Check Commands

```bash
# 🔍 Check health status
docker-compose ps

# 📋 View detailed health information
docker inspect complex-app-web | grep -A 10 Health

# 🧪 Manual health checks
curl http://localhost:8080/health
```

---

## ✅ Best Practices Implemented

This lab demonstrates several Docker Compose best practices:

| Practice | Description |
|----------|--------------|
| 🧩 Service Isolation | Each service runs in its own container |
| 🔧 Environment Variables | Configuration through environment variables |
| 💾 Named Volumes | Persistent data storage |
| 🌐 Custom Networks | Isolated network communication |
| 💓 Health Checks | Service health monitoring |
| 🔗 Dependency Management | Proper service startup order |
| ⚙️ Resource Management | Restart policies and resource limits |
| 🔐 Security | Non-root users and secure passwords |

---

## 🏁 Conclusion

In this comprehensive lab, you have successfully:

### 🏆 Key Achievements

| Achievement | Description |
|-------------|-------------|
| 🧩 Created a Multi-Service Application | Built a complex application with web, cache, and database components |
| 🔗 Configured Service Communication | Established secure communication between containers using custom networks and environment variables |
| ⚙️ Managed Application Lifecycle | Learned to start, stop, restart, and scale services using Docker Compose commands |
| 📊 Implemented Monitoring | Used Docker Compose logs to monitor and troubleshoot multi-container applications |
| 📈 Applied Scaling Techniques | Scaled services horizontally and implemented basic load balancing |

### 💡 Why This Matters

This lab demonstrates real-world application architecture patterns commonly used in modern software development. The skills learned here are directly applicable to:

- **🧩 Microservices Architecture** — breaking applications into smaller, manageable services
- **⚙️ DevOps Practices** — automating application deployment and management
- **☁️ Cloud-Native Development** — building applications designed for containerized environments
- **🏭 Production Deployments** — understanding how complex applications are orchestrated in production

### 🔮 Next Steps

The Docker Compose skills mastered here are essential for the Docker Certified Associate (DCA) certification and are widely used in enterprise environments for application orchestration, development environment setup, and CI/CD pipelines.

> Understanding how to orchestrate complex applications with multiple dependencies prepares you for more advanced container orchestration platforms like Kubernetes, while providing a solid foundation in containerized application architecture and management! 🚀

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
