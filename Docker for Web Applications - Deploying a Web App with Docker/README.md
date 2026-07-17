<div align="center">

# 🐳 Lab 20: Docker for Web Applications
### Deploying a Full-Stack Web App with Docker, Flask, Redis & Nginx

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.9-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-2.3.3-000000?style=for-the-badge&logo=flask&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-7--alpine-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-Reverse%20Proxy-009639?style=for-the-badge&logo=nginx&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-Database-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Level](https://img.shields.io/badge/Level-Intermediate-orange?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Learning Objectives](#-learning-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🧩 Technology Stack](#-technology-stack)
- [📝 Task 1: Create a Simple Flask Web Application](#-task-1-create-a-simple-flask-web-application)
- [🐳 Task 2: Create Dockerfile for the Flask Application](#-task-2-create-dockerfile-for-the-flask-application)
- [🏗️ Task 3: Build and Run the Docker Container](#️-task-3-build-and-run-the-docker-container)
- [🧱 Task 4: Add Database Container with Docker Compose](#-task-4-add-database-container-with-docker-compose)
- [🚀 Task 5: Deploy with Docker Compose](#-task-5-deploy-with-docker-compose)
- [📊 Task 6: Application Testing and Monitoring](#-task-6-application-testing-and-monitoring)
- [📐 Task 7: Scaling and Management](#-task-7-scaling-and-management)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [⚡ Performance Optimization Tips](#-performance-optimization-tips)
- [🎓 Conclusion](#-conclusion)

---

## 🎯 Learning Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | 🐍 Create a Dockerfile for a Python Flask web application |
| 2 | 🏗️ Build Docker images and run containers for web applications |
| 3 | 🔌 Configure port mapping to expose web services |
| 4 | 🗄️ Connect web applications to database containers |
| 5 | 🧱 Use Docker Compose to manage multi-container applications |
| 6 | 🧪 Deploy and test web applications in containerized environments |
| 7 | 📖 Understand the fundamentals of containerized web application deployment |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🌐 Web fundamentals | Basic understanding of web applications and HTTP protocols |
| ⌨️ CLI comfort | Familiarity with command-line interface operations |
| 🐍 Python (helpful) | Basic knowledge of Python programming — not required |
| 🔌 Networking basics | Understanding of ports, IP addresses, and basic networking concepts |
| 🐳 Prior labs | Completion of previous Docker fundamentals labs, or equivalent knowledge |

---

## 🖥️ Lab Environment Setup

> **☁️ Ready-to-Use Cloud Machines**
> Al Nafi provides pre-configured Linux-based cloud machines with Docker already installed. Simply click **Start Lab** to access your environment — no need to build your own VM or install Docker manually.

Your lab environment includes:

- ✅ Ubuntu Linux machine with Docker Engine installed
- ✅ Docker Compose pre-installed
- ✅ Text editor (`nano` / `vim`) available
- ✅ All necessary networking configurations

---

## 🧩 Technology Stack

<div align="center">

| Technology | Role in This Lab |
|---|---|
| ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white) | Containerizes and runs the web application |
| ![Docker Compose](https://img.shields.io/badge/Compose-2496ED?style=flat-square&logo=docker&logoColor=white) | Orchestrates the web, cache, and proxy services together |
| ![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white) | Application runtime language |
| ![Flask](https://img.shields.io/badge/Flask-000000?style=flat-square&logo=flask&logoColor=white) | Web framework serving the HTTP routes |
| ![SQLite](https://img.shields.io/badge/SQLite-003B57?style=flat-square&logo=sqlite&logoColor=white) | Lightweight persistent visitor database |
| ![Redis](https://img.shields.io/badge/Redis-DC382D?style=flat-square&logo=redis&logoColor=white) | In-memory store for session/page-view data |
| ![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white) | Reverse proxy and load balancer |

</div>

---

## 📝 Task 1: Create a Simple Flask Web Application

### 📁 Subtask 1.1: Set Up Project Directory Structure

```bash
# 📂 Create main project directory
mkdir flask-docker-app
cd flask-docker-app

# 📂 Create subdirectories for organization
mkdir app
mkdir database
```

### 🐍 Subtask 1.2: Create the Flask Application

```bash
# 📝 Open the main Flask application file
nano app/app.py
```

```python
# app/app.py
from flask import Flask, render_template, request, jsonify
import os
import sqlite3
from datetime import datetime

app = Flask(__name__)

# 🗄️ Database configuration
DATABASE = '/app/data/visitors.db'

def init_db():
    """Initialize the database with a visitors table"""
    os.makedirs('/app/data', exist_ok=True)
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS visitors (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ip_address TEXT,
            visit_time TIMESTAMP,
            user_agent TEXT
        )
    ''')
    conn.commit()
    conn.close()

def log_visitor(ip_address, user_agent):
    """Log visitor information to database"""
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO visitors (ip_address, visit_time, user_agent)
        VALUES (?, ?, ?)
    ''', (ip_address, datetime.now(), user_agent))
    conn.commit()
    conn.close()

def get_visitor_count():
    """Get total number of visitors"""
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    cursor.execute('SELECT COUNT(*) FROM visitors')
    count = cursor.fetchone()[0]
    conn.close()
    return count

@app.route('/')
def home():
    """Main page route"""
    # 👀 Log the visitor
    ip_address = request.environ.get('HTTP_X_FORWARDED_FOR', request.remote_addr)
    user_agent = request.environ.get('HTTP_USER_AGENT', 'Unknown')
    log_visitor(ip_address, user_agent)

    # 📈 Get visitor count
    visitor_count = get_visitor_count()

    return f'''
    <html>
    <head>
        <title>Flask Docker App</title>
        <style>
            body {{ font-family: Arial, sans-serif; margin: 40px; background-color: #f0f0f0; }}
            .container {{ background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
            h1 {{ color: #333; }}
            .info {{ background-color: #e7f3ff; padding: 15px; border-radius: 5px; margin: 20px 0; }}
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Welcome to Flask Docker Application!</h1>
            <div class="info">
                <p><strong>Application Status:</strong> Running in Docker Container</p>
                <p><strong>Total Visitors:</strong> {{visitor_count}}</p>
                <p><strong>Your IP:</strong> {{ip_address}}</p>
            </div>
            <p>This is a simple Flask web application running inside a Docker container.</p>
        </div>
    </body>
    </html>
    '''

@app.route('/health')
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'visitors': get_visitor_count()
    })

@app.route('/visitors')
def visitors():
    """Display recent visitors"""
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM visitors ORDER BY visit_time DESC LIMIT 10')
    recent_visitors = cursor.fetchall()
    conn.close()

    html = '<html><head><title>Recent Visitors</title></head><body>'
    html += '<h1>Recent Visitors</h1>'
    html += '<table border="1"><tr><th>ID</th><th>IP Address</th><th>Visit Time</th><th>User Agent</th></tr>'
    for visitor in recent_visitors:
        html += f'<tr><td>{visitor[0]}</td><td>{visitor[1]}</td><td>{visitor[2]}</td><td>{visitor[3][:50]}...</td></tr>'
    html += '</table><br><a href="/">Back to Home</a></body></html>'
    return html

if __name__ == '__main__':
    init_db()
    # TODO: Set debug=False before any production deployment
    app.run(host='0.0.0.0', port=5000, debug=True)
```

### 📦 Subtask 1.3: Create Requirements File

```bash
# 📝 Create the requirements file
nano app/requirements.txt
```

```text
Flask==2.3.3
Werkzeug==2.3.7
```

---

## 🐳 Task 2: Create Dockerfile for the Flask Application

### 🧱 Subtask 2.1: Create the Dockerfile

```bash
nano Dockerfile
```

```dockerfile
# 🐍 Use official Python runtime as base image
FROM python:3.9-slim

# 📂 Set working directory in container
WORKDIR /app

# ⚙️ Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 🔧 Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 📋 Copy requirements file
COPY app/requirements.txt .

# 📥 Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 📤 Copy application code
COPY app/ .

# 🗄️ Create directory for database
RUN mkdir -p /app/data

# 🔌 Expose port 5000
EXPOSE 5000

# ❤️ Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# 🔒 Create non-root user for security
RUN adduser --disabled-password --gecos '' appuser && \
    chown -R appuser:appuser /app
USER appuser

# ▶️ Command to run the application
CMD ["python", "app.py"]
```

### 🚫 Subtask 2.2: Create .dockerignore File

```bash
nano .dockerignore
```

```text
__pycache__
*.pyc
*.pyo
*.pyd
.Python
env/
venv/
.venv/
pip-log.txt
pip-delete-this-directory.txt
.tox
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.log
.git
.mypy_cache
.pytest_cache
.hypothesis
.DS_Store
```

---

## 🏗️ Task 3: Build and Run the Docker Container

### 🔨 Subtask 3.1: Build the Docker Image

```bash
# 🏗️ Build the Docker image with a tag
docker build -t flask-web-app:v1.0 .

# ✅ Verify the image was created
docker images | grep flask-web-app
```

### ▶️ Subtask 3.2: Run the Container with Port Mapping

```bash
# 🚀 Run the container with port mapping
docker run -d \
  --name flask-app-container \
  -p 8080:5000 \
  -v flask-app-data:/app/data \
  flask-web-app:v1.0

# ✅ Verify the container is running
docker ps
```

### 🧪 Subtask 3.3: Test the Web Application

```bash
# 🌐 Test the main page
curl http://localhost:8080

# ❤️ Test the health check endpoint
curl http://localhost:8080/health

# 📜 Check container logs
docker logs flask-app-container
```

---

## 🧱 Task 4: Add Database Container with Docker Compose

### 📄 Subtask 4.1: Create Docker Compose Configuration

```bash
nano docker-compose.yml
```

```yaml
version: '3.8'

services:
  web:
    build: .
    container_name: flask-web-app
    ports:
      - "8080:5000"       # 🔌 host:container
    volumes:
      - app-data:/app/data
    environment:
      - FLASK_ENV=production
      - DATABASE_URL=sqlite:///app/data/visitors.db
    depends_on:
      - redis
    networks:
      - app-network
    restart: unless-stopped

  redis:
    image: redis:7-alpine   # ⚡ in-memory cache/session store
    container_name: flask-redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    networks:
      - app-network
    restart: unless-stopped
    command: redis-server --appendonly yes

  nginx:
    image: nginx:alpine     # 🌐 reverse proxy / load balancer
    container_name: flask-nginx
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - web
    networks:
      - app-network
    restart: unless-stopped

volumes:
  app-data:
    driver: local
  redis-data:
    driver: local

networks:
  app-network:
    driver: bridge
```

### 🌐 Subtask 4.2: Create Nginx Configuration

```bash
nano nginx.conf
```

```nginx
events {
    worker_connections 1024;
}

http {
    upstream flask_app {
        server web:5000;
    }

    server {
        listen 80;
        server_name localhost;

        location / {
            proxy_pass http://flask_app;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /health {
            proxy_pass http://flask_app/health;
            access_log off;
        }
    }
}
```

### ⚡ Subtask 4.3: Enhanced Flask Application with Redis

```bash
nano app/app_enhanced.py
```

```python
# app/app_enhanced.py
from flask import Flask, render_template, request, jsonify, session
import os
import sqlite3
import redis
from datetime import datetime
import json

app = Flask(__name__)
# TODO: Replace with a securely generated secret before deploying
app.secret_key = 'your-secret-key-change-in-production'

DATABASE = '/app/data/visitors.db'

# ⚡ Redis configuration
try:
    redis_client = redis.Redis(host='redis', port=6379, db=0, decode_responses=True)
    redis_client.ping()
    REDIS_AVAILABLE = True
except:
    REDIS_AVAILABLE = False

def init_db():
    """Initialize the database with a visitors table"""
    os.makedirs('/app/data', exist_ok=True)
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS visitors (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ip_address TEXT,
            visit_time TIMESTAMP,
            user_agent TEXT,
            session_id TEXT
        )
    ''')
    conn.commit()
    conn.close()

def log_visitor(ip_address, user_agent, session_id):
    """Log visitor information to database"""
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO visitors (ip_address, visit_time, user_agent, session_id)
        VALUES (?, ?, ?, ?)
    ''', (ip_address, datetime.now(), user_agent, session_id))
    conn.commit()
    conn.close()

def get_visitor_count():
    """Get total number of visitors"""
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    cursor.execute('SELECT COUNT(*) FROM visitors')
    count = cursor.fetchone()[0]
    conn.close()
    return count

def increment_page_views():
    """Increment page views counter in Redis"""
    if REDIS_AVAILABLE:
        try:
            return redis_client.incr('page_views')
        except:
            return 0
    return 0

@app.route('/')
def home():
    """Main page route"""
    # 🍪 Generate session ID if not exists
    if 'session_id' not in session:
        session['session_id'] = os.urandom(16).hex()

    ip_address = request.environ.get('HTTP_X_FORWARDED_FOR', request.remote_addr)
    user_agent = request.environ.get('HTTP_USER_AGENT', 'Unknown')
    log_visitor(ip_address, user_agent, session['session_id'])

    visitor_count = get_visitor_count()
    page_views = increment_page_views()

    return f'''
    <html>
    <head><title>Enhanced Flask Docker App</title></head>
    <body>
        <h1>Enhanced Flask Docker Application!</h1>
        <p>Total Visitors: {{visitor_count}}</p>
        <p>Page Views: {{page_views}}</p>
        <p>Redis Status: {{'Connected' if REDIS_AVAILABLE else 'Not Available'}}</p>
        <p><a href="/visitors">Recent Visitors</a> | <a href="/stats">Statistics</a></p>
    </body>
    </html>
    '''

@app.route('/health')
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'visitors': get_visitor_count(),
        'redis_available': REDIS_AVAILABLE,
        'page_views': increment_page_views() if REDIS_AVAILABLE else 0
    })

@app.route('/stats')
def stats():
    """Statistics page"""
    visitor_count = get_visitor_count()
    page_views = redis_client.get('page_views') if REDIS_AVAILABLE else 0
    return jsonify({
        'total_visitors': visitor_count,
        'total_page_views': int(page_views) if page_views else 0,
        'redis_status': 'connected' if REDIS_AVAILABLE else 'disconnected',
        'timestamp': datetime.now().isoformat()
    })

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=False)
```

### 📦 Subtask 4.4: Update Requirements for Enhanced App

```bash
nano app/requirements.txt
```

```text
Flask==2.3.3
Werkzeug==2.3.7
redis==5.0.1
```

---

## 🚀 Task 5: Deploy with Docker Compose

### 🛑 Subtask 5.1: Stop Single Container

```bash
# 🛑 Stop and remove the single container
docker stop flask-app-container
docker rm flask-app-container
```

### 🔄 Subtask 5.2: Update Dockerfile for Enhanced App

```bash
nano Dockerfile
```

```dockerfile
# ▶️ Command to run the enhanced application
CMD ["python", "app_enhanced.py"]
```

### 🧱 Subtask 5.3: Deploy Multi-Container Application

```bash
# 🏗️ Build and start all services
docker-compose up -d --build

# ✅ Verify all containers are running
docker-compose ps

# 📜 Check logs for all services
docker-compose logs
```

### 🧪 Subtask 5.4: Test the Multi-Container Application

```bash
# 🌐 Test through Nginx (port 80)
curl http://localhost/

# 🐍 Test direct Flask app (port 8080)
curl http://localhost:8080/

# ❤️ Test health endpoint
curl http://localhost/health

# 📊 Test statistics endpoint
curl http://localhost/stats

# ⚡ Check Redis connectivity
docker-compose exec redis redis-cli ping
```

---

## 📊 Task 6: Application Testing and Monitoring

### 🏋️ Subtask 6.1: Load Testing

```bash
nano load_test.sh
```

```bash
#!/bin/bash
# 🏋️ Simple load test script

echo "Starting load test..."
echo "Testing main page..."

for i in {1..10}; do
    echo "Request $i:"
    curl -s -w "Time: %{time_total}s, Status: %{http_code}\n" http://localhost/ > /dev/null
    sleep 1
done

echo "Testing health endpoint..."
for i in {1..5}; do
    echo "Health check $i:"
    curl -s http://localhost/health | jq '.status'
    sleep 1
done

echo "Load test completed!"
```

```bash
# 🔓 Make the script executable and run it
chmod +x load_test.sh
./load_test.sh
```

### 📈 Subtask 6.2: Monitor Container Resources

```bash
# 📊 Check container resource usage
docker stats

# 📜 Check specific container logs
docker-compose logs web
docker-compose logs redis
docker-compose logs nginx

# ❤️ Check container health
docker-compose exec web curl http://localhost:5000/health
```

### 🗃️ Subtask 6.3: Database Verification

```bash
# 🔑 Access the web container
docker-compose exec web /bin/bash
```

```python
# 🐍 Inside the container, check the database
import sqlite3
conn = sqlite3.connect('/app/data/visitors.db')
cursor = conn.cursor()
cursor.execute('SELECT COUNT(*) FROM visitors')
print('Total visitors:', cursor.fetchone()[0])
cursor.execute('SELECT * FROM visitors ORDER BY visit_time DESC LIMIT 5')
print('Recent visitors:')
for row in cursor.fetchall():
    print(row)
conn.close()
```

```bash
# 🚪 Exit the container
exit
```

---

## 📐 Task 7: Scaling and Management

### 📈 Subtask 7.1: Scale the Web Application

```bash
# 📐 Scale the web service to 3 instances
docker-compose up -d --scale web=3

# ✅ Verify scaling
docker-compose ps

# ⚖️ Test load balancing
for i in {1..10}; do
    curl -s http://localhost/ | grep "Session ID" | head -1
    sleep 1
done
```

### ⚙️ Subtask 7.2: Update Application Configuration

```bash
nano .env
```

```env
FLASK_ENV=production
FLASK_DEBUG=False
# TODO: Generate a strong, unique secret key for production
SECRET_KEY=your-production-secret-key-here
REDIS_URL=redis://redis:6379/0
DATABASE_PATH=/app/data/visitors.db
```

```yaml
# docker-compose.yml — add env_file to the web service
  web:
    build: .
    container_name: flask-web-app
    ports:
      - "8080:5000"
    volumes:
      - app-data:/app/data
    env_file:
      - .env
    depends_on:
      - redis
    networks:
      - app-network
    restart: unless-stopped
```

### 💾 Subtask 7.3: Backup and Restore Data

```bash
nano backup.sh
```

```bash
#!/bin/bash
# 💾 Backup script for app data and Redis data

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# 🗄️ Backup application data
docker run --rm \
  -v flask-docker-app_app-data:/data \
  -v $(pwd)/$BACKUP_DIR:/backup \
  alpine tar czf /backup/app-data-$TIMESTAMP.tar.gz -C /data .

# ⚡ Backup Redis data
docker run --rm \
  -v flask-docker-app_redis-data:/data \
  -v $(pwd)/$BACKUP_DIR:/backup \
  alpine tar czf /backup/redis-data-$TIMESTAMP.tar.gz -C /data .

echo "Backup completed: $TIMESTAMP"
ls -la $BACKUP_DIR/
```

```bash
# 🔓 Make executable and run
chmod +x backup.sh
./backup.sh
```

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔴 Issue 1: Container Won't Start</summary>

**Problem:** Container fails to start or exits immediately.

```bash
# 📜 Check container logs
docker-compose logs web

# 🔎 Check if ports are already in use
netstat -tulpn | grep :8080

# 🔄 Rebuild containers
docker-compose down
docker-compose up --build -d
```
</details>

<details>
<summary>🔴 Issue 2: Database Connection Issues</summary>

**Problem:** Application can't connect to database.

```bash
# 🔐 Check if data directory exists and has correct permissions
docker-compose exec web ls -la /app/data/

# ♻️ Recreate the database
docker-compose exec web python3 -c "
from app_enhanced import init_db
init_db()
print('Database initialized')
"
```
</details>

<details>
<summary>🔴 Issue 3: Redis Connection Problems</summary>

**Problem:** Redis service is not accessible.

```bash
# ✅ Check Redis container status
docker-compose ps redis

# 🏓 Test Redis connectivity
docker-compose exec redis redis-cli ping

# 🌐 Check network connectivity
docker-compose exec web ping redis
```
</details>

<details>
<summary>🔴 Issue 4: Port Conflicts</summary>

**Problem:** Ports are already in use.

```bash
# 🔎 Find processes using the ports
sudo lsof -i :80
sudo lsof -i :8080

# ⚙️ Change ports in docker-compose.yml
# For example, change "80:80" to "8081:80"
```
</details>

---

## ⚡ Performance Optimization Tips

### 🪶 Tip 1: Optimize Docker Images

```bash
nano Dockerfile.optimized
```

```dockerfile
# 🏗️ Multi-stage build for optimization
FROM python:3.9-slim as builder

WORKDIR /app
COPY app/requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.9-slim

WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY app/ .

ENV PATH=/root/.local/bin:$PATH
EXPOSE 5000
CMD ["python", "app_enhanced.py"]
```

### 📏 Tip 2: Configure Resource Limits

```yaml
  web:
    build: .
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
```

---

## 🎓 Conclusion

Congratulations! You have successfully completed **Lab 20: Docker for Web Applications**.

### 🏆 Key Achievements

- 🐳 **Created a Containerized Web Application** — built a complete Flask web application from scratch and containerized it with Docker
- 📘 **Mastered Docker Fundamentals** — effective Dockerfiles, optimized images, port mapping, and volume management
- 🧱 **Implemented Multi-Container Architecture** — deployed a Flask + Redis + Nginx stack with Docker Compose
- 🌐 **Configured Container Networking** — established secure inter-container communication via Docker networks
- 💾 **Implemented Data Persistence** — configured persistent storage for both application data and Redis cache
- 🔒 **Applied Production Best Practices** — health checks, resource limits, environment configuration, and backups

### 🌍 Real-World Applications

| Theme | Why It Matters |
|---|---|
| 🏭 Industry Relevance | Docker is a DevOps standard used across companies of every size |
| 📈 Scalability | The multi-container architecture scales horizontally to handle more traffic |
| 🚚 Portability | Containerized apps run consistently from laptop to production server |
| ⚙️ Efficiency | Containers cut resource overhead versus VMs while keeping isolation and security |

### 🔭 Next Steps

- ☸️ Explore **Kubernetes** for container orchestration at scale
- 🔁 Implement **CI/CD pipelines** to automate Docker builds and deployments
- 🔐 Study container **security best practices** and image scanning
- 🧪 Practice containerizing other application types (databases, microservices)

### 📜 Certification Preparation

This lab directly supports preparation for the **Docker Certified Associate (DCA)** certification, covering container lifecycle management, Docker Compose and multi-container applications, networking and storage configuration, and security best practices.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blue?style=for-the-badge)

</div>
