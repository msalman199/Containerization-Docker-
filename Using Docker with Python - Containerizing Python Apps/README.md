<div align="center">

# 🐍 Using Docker with Python
### Containerizing Python Apps — Flask, PostgreSQL & Docker Compose

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.9+-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-2.3.3-000000?style=for-the-badge&logo=flask&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-7--alpine-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![Level](https://img.shields.io/badge/Level-Beginner%20Friendly-yellow?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🧩 Technology Stack](#-technology-stack)
- [🐍 Task 1: Create a Simple Python Web Application](#-task-1-create-a-simple-python-web-application)
- [🐳 Task 2: Write a Dockerfile to Containerize the Python App](#-task-2-write-a-dockerfile-to-containerize-the-python-app)
- [🏗️ Task 3: Build and Run the Docker Container](#️-task-3-build-and-run-the-docker-container)
- [🗄️ Task 4: Expose Ports and Connect to a Database Container](#️-task-4-expose-ports-and-connect-to-a-database-container)
- [🧱 Task 5: Create Multi-Container Setup with Docker Compose](#-task-5-create-multi-container-setup-with-docker-compose)
- [🔧 Advanced Operations and Management](#-advanced-operations-and-management)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🧹 Cleanup and Resource Management](#-cleanup-and-resource-management)
- [🎓 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | 🐍 Create a simple Python web application using Flask |
| 2 | 🐳 Write a Dockerfile to containerize a Python application |
| 3 | 🏗️ Build and run Docker containers for Python applications |
| 4 | 🔌 Configure port exposure and container networking |
| 5 | 🗄️ Connect a Python application container to a database container |
| 6 | 🧱 Create and manage multi-container applications using Docker Compose |
| 7 | 📖 Understand best practices for containerizing Python applications |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐍 Python basics | Basic understanding of Python programming |
| ⌨️ CLI comfort | Familiarity with command-line interface |
| 🌐 Web fundamentals | Basic knowledge of web applications and HTTP |
| 🔌 Networking basics | Understanding of basic networking concepts (ports, localhost) |
| 🐳 Docker experience | Not required — we'll cover everything step by step |

---

## 🖥️ Lab Environment Setup

> **☁️ Ready-to-Use Cloud Machines**
> Al Nafi provides Linux-based cloud machines with Docker pre-installed. Simply click **Start Lab** to access your environment — no need to build your own VM or install Docker locally.

Your lab environment includes:

- ✅ Ubuntu Linux machine with Docker Engine installed
- ✅ Python 3.9+ pre-installed
- ✅ Text editor (`nano`/`vim`) available
- ✅ All necessary networking configured

---

## 🧩 Technology Stack

<div align="center">

| Technology | Role in This Lab |
|---|---|
| ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white) | Containerizes the Flask application |
| ![Python](https://img.shields.io/badge/Python%203.9-3776AB?style=flat-square&logo=python&logoColor=white) | Application runtime language |
| ![Flask](https://img.shields.io/badge/Flask-000000?style=flat-square&logo=flask&logoColor=white) | Web framework serving the visitor-tracker app |
| ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat-square&logo=postgresql&logoColor=white) | Persists visitor records (replaces SQLite) |
| ![Docker Compose](https://img.shields.io/badge/Compose-2496ED?style=flat-square&logo=docker&logoColor=white) | Orchestrates the full multi-service stack |
| ![Redis](https://img.shields.io/badge/Redis-DC382D?style=flat-square&logo=redis&logoColor=white) | Optional caching layer |
| ![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white) | Optional reverse proxy |

</div>

---

## 🐍 Task 1: Create a Simple Python Web Application

### 📁 Subtask 1.1: Set Up Project Directory

```bash
# 📂 Create main project directory
mkdir python-docker-lab
cd python-docker-lab

# 📂 Create subdirectories for organization
mkdir app
mkdir database
```

### 🐍 Subtask 1.2: Create a Flask Web Application

```bash
# 📂 Navigate to the app directory
cd app

# 📝 Create the main application file
nano app.py
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
            name TEXT NOT NULL,
            visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()

def add_visitor(name):
    """Add a visitor to the database"""
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    cursor.execute('INSERT INTO visitors (name) VALUES (?)', (name,))
    conn.commit()
    conn.close()

def get_visitors():
    """Get all visitors from the database"""
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    cursor.execute('SELECT name, visit_time FROM visitors ORDER BY visit_time DESC')
    visitors = cursor.fetchall()
    conn.close()
    return visitors

@app.route('/')
def home():
    """Home page route"""
    visitors = get_visitors()
    return render_template('index.html', visitors=visitors)

@app.route('/add_visitor', methods=['POST'])
def add_visitor_route():
    """Add visitor route"""
    name = request.form.get('name')
    if name:
        add_visitor(name)
        return jsonify({'status': 'success', 'message': f'Welcome {name}!'})
    return jsonify({'status': 'error', 'message': 'Name is required'})

@app.route('/health')
def health_check():
    """Health check endpoint"""
    return jsonify({'status': 'healthy', 'timestamp': datetime.now().isoformat()})

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
```

### 🎨 Subtask 1.3: Create HTML Template

```bash
# 📂 Create templates directory
mkdir templates
cd templates

# 📝 Create the HTML template
nano index.html
```

```html
<!-- templates/index.html -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Python Docker Lab - Visitor Tracker</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 { color: #333; text-align: center; }
        .form-group { margin-bottom: 20px; }
        input[type="text"] {
            width: 70%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover { background-color: #0056b3; }
        .visitors-list { margin-top: 30px; }
        .visitor-item {
            padding: 10px;
            margin: 5px 0;
            background-color: #f8f9fa;
            border-left: 4px solid #007bff;
        }
        .message { padding: 10px; margin: 10px 0; border-radius: 5px; }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐳 Python Docker Lab - Visitor Tracker</h1>
        <p>Welcome to our containerized Python application! Add your name to the visitor list.</p>

        <div class="form-group">
            <form id="visitorForm">
                <input type="text" id="visitorName" placeholder="Enter your name" required>
                <button type="submit">Add Visitor</button>
            </form>
        </div>

        <div id="message"></div>

        <div class="visitors-list">
            <h3>Recent Visitors:</h3>
            {% if visitors %}
                {% for visitor in visitors %}
                <div class="visitor-item">
                    <strong>{{ visitor[0] }}</strong> - {{ visitor[1] }}
                </div>
                {% endfor %}
            {% else %}
                <p>No visitors yet. Be the first!</p>
            {% endif %}
        </div>
    </div>

    <script>
        document.getElementById('visitorForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const name = document.getElementById('visitorName').value;
            const formData = new FormData();
            formData.append('name', name);

            fetch('/add_visitor', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                const messageDiv = document.getElementById('message');
                messageDiv.innerHTML = `<div class="message success">${data.message}</div>`;

                if (data.status === 'success') {
                    document.getElementById('visitorName').value = '';
                    // 🔄 Reload page after 1 second to show updated visitor list
                    setTimeout(() => location.reload(), 1000);
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
        });
    </script>
</body>
</html>
```

### 📦 Subtask 1.4: Create Requirements File

```bash
# 📂 Go back to app directory
cd ..

# 📝 Create requirements.txt file
nano requirements.txt
```

```text
Flask==2.3.3
Werkzeug==2.3.7
```

### 🧪 Subtask 1.5: Test the Application Locally

```bash
# 📥 Install Flask (if not already installed)
pip3 install flask

# ▶️ Run the application
python3 app.py
```

You should see output similar to:

```text
* Running on all addresses (0.0.0.0)
* Running on http://127.0.0.1:5000
* Running on http://[your-ip]:5000
```

> 📝 **Note:** Press `Ctrl+C` to stop the application when you're done testing.

---

## 🐳 Task 2: Write a Dockerfile to Containerize the Python App

### 🐳 Subtask 2.1: Create the Dockerfile

A Dockerfile contains instructions for building a Docker image.

```bash
# 📂 Make sure you're in the app directory
pwd
# Should show: /home/user/python-docker-lab/app

# 📝 Create Dockerfile
nano Dockerfile
```

```dockerfile
# 🐍 Use official Python runtime as base image
FROM python:3.9-slim

# 🏷️ Set maintainer information
LABEL maintainer="your-email@example.com"
LABEL description="Python Flask Web Application for Docker Lab"

# ⚙️ Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 📂 Set work directory inside container
WORKDIR /app

# 🗄️ Create directory for database
RUN mkdir -p /app/data

# 📋 Copy requirements file
COPY requirements.txt /app/

# 📥 Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 📤 Copy application code
COPY . /app/

# 🔒 Create a non-root user for security
RUN adduser --disabled-password --gecos '' appuser && \
    chown -R appuser:appuser /app
USER appuser

# 🔌 Expose port 5000
EXPOSE 5000

# ❤️ Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

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
env
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
# 🏗️ Build the Docker image
docker build -t python-flask-app:v1.0 .

# ✅ Verify the image was created
docker images | grep python-flask-app
```

You should see output showing your newly created image:

```text
python-flask-app   v1.0    [image-id]   [time]   [size]
```

### ▶️ Subtask 3.2: Run the Docker Container

```bash
# ▶️ Run the container
docker run -d \
  --name flask-app-container \
  -p 8080:5000 \
  -v $(pwd)/data:/app/data \
  python-flask-app:v1.0

# ✅ Check if container is running
docker ps
```

### 🧪 Subtask 3.3: Test the Containerized Application

```bash
# ❤️ Test the health endpoint
curl http://localhost:8080/health

# 📜 Check application logs
docker logs flask-app-container

# 🌐 Access the application
echo "Open your browser and navigate to http://localhost:8080"
```

### 🔎 Subtask 3.4: Inspect Container Details

```bash
# 🔎 Inspect container details
docker inspect flask-app-container

# 📊 Check container resource usage
docker stats flask-app-container --no-stream

# 🖥️ Execute commands inside the container
docker exec -it flask-app-container /bin/bash
# Type 'exit' to leave the container shell
```

---

## 🗄️ Task 4: Expose Ports and Connect to a Database Container

### 🐘 Subtask 4.1: Create a PostgreSQL Database Container

```bash
# 🛑 Stop the current container
docker stop flask-app-container
docker rm flask-app-container

# 🌉 Create a Docker network for our containers
docker network create flask-network

# 🐘 Run PostgreSQL container
docker run -d \
  --name postgres-db \
  --network flask-network \
  -e POSTGRES_DB=flaskapp \
  -e POSTGRES_USER=flaskuser \
  -e POSTGRES_PASSWORD=flaskpass \
  -p 5432:5432 \
  postgres:13
```

<!-- TODO: Replace POSTGRES_PASSWORD with a strong, unique secret outside of this lab environment -->

### 🔁 Subtask 4.2: Update Python Application for PostgreSQL

```bash
# 📝 Update requirements.txt to include PostgreSQL driver
nano requirements.txt
```

```text
Flask==2.3.3
Werkzeug==2.3.7
psycopg2-binary==2.9.7
```

```bash
nano app.py
```

```python
# app/app.py (PostgreSQL version)
from flask import Flask, render_template, request, jsonify
import os
import psycopg2
from psycopg2.extras import RealDictCursor
from datetime import datetime
import time

app = Flask(__name__)

# 🗄️ Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'postgres-db'),
    'database': os.getenv('DB_NAME', 'flaskapp'),
    'user': os.getenv('DB_USER', 'flaskuser'),
    'password': os.getenv('DB_PASSWORD', 'flaskpass'),
    'port': os.getenv('DB_PORT', '5432')
}

def wait_for_db():
    """Wait for database to be ready"""
    max_retries = 30
    for i in range(max_retries):
        try:
            conn = psycopg2.connect(**DB_CONFIG)
            conn.close()
            print("Database connection successful!")
            return True
        except psycopg2.OperationalError:
            print(f"Database not ready, retrying... ({i+1}/{max_retries})")
            time.sleep(2)
    return False

def init_db():
    """Initialize the database with a visitors table"""
    if not wait_for_db():
        raise Exception("Could not connect to database")

    conn = psycopg2.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS visitors (
            id SERIAL PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()

def add_visitor(name):
    """Add a visitor to the database"""
    conn = psycopg2.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute('INSERT INTO visitors (name) VALUES (%s)', (name,))
    conn.commit()
    conn.close()

def get_visitors():
    """Get all visitors from the database"""
    conn = psycopg2.connect(**DB_CONFIG)
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT name, visit_time FROM visitors ORDER BY visit_time DESC LIMIT 10')
    visitors = cursor.fetchall()
    conn.close()
    return visitors

@app.route('/')
def home():
    """Home page route"""
    try:
        visitors = get_visitors()
        return render_template('index.html', visitors=visitors)
    except Exception as e:
        return f"Database error: {str(e)}", 500

@app.route('/add_visitor', methods=['POST'])
def add_visitor_route():
    """Add visitor route"""
    try:
        name = request.form.get('name')
        if name:
            add_visitor(name)
            return jsonify({'status': 'success', 'message': f'Welcome {name}!'})
        return jsonify({'status': 'error', 'message': 'Name is required'})
    except Exception as e:
        return jsonify({'status': 'error', 'message': f'Database error: {str(e)}'})

@app.route('/health')
def health_check():
    """Health check endpoint"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        conn.close()
        return jsonify({'status': 'healthy', 'database': 'connected', 'timestamp': datetime.now().isoformat()})
    except Exception as e:
        return jsonify({'status': 'unhealthy', 'database': 'disconnected', 'error': str(e)}), 500

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
```

### 🔄 Subtask 4.3: Rebuild and Run with Database Connection

```bash
# 🏗️ Rebuild the image
docker build -t python-flask-app:v2.0 .

# ▶️ Run the updated container connected to the database
docker run -d \
  --name flask-app-container \
  --network flask-network \
  -p 8080:5000 \
  -e DB_HOST=postgres-db \
  -e DB_NAME=flaskapp \
  -e DB_USER=flaskuser \
  -e DB_PASSWORD=flaskpass \
  python-flask-app:v2.0
```

### 🧪 Subtask 4.4: Test the Multi-Container Setup

```bash
# ✅ Check both containers are running
docker ps

# ❤️ Test the health endpoint
curl http://localhost:8080/health

# 📜 Check application logs
docker logs flask-app-container

# 🗄️ Test database connectivity
docker exec -it postgres-db psql -U flaskuser -d flaskapp -c "SELECT * FROM visitors;"
```

---

## 🧱 Task 5: Create Multi-Container Setup with Docker Compose

### 📝 Subtask 5.1: Create Docker Compose File

```bash
# 📂 Navigate to the main project directory
cd /home/user/python-docker-lab

# 📝 Create docker-compose.yml file
nano docker-compose.yml
```

```yaml
version: '3.8'

services:
  # 🐘 PostgreSQL Database Service
  database:
    image: postgres:13
    container_name: flask-postgres-db
    environment:
      POSTGRES_DB: flaskapp
      POSTGRES_USER: flaskuser
      POSTGRES_PASSWORD: flaskpass
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
    networks:
      - flask-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U flaskuser -d flaskapp"]
      interval: 10s
      timeout: 5s
      retries: 5

  # 🐍 Flask Web Application Service
  web:
    build: 
      context: ./app
      dockerfile: Dockerfile
    container_name: flask-web-app
    environment:
      DB_HOST: database
      DB_NAME: flaskapp
      DB_USER: flaskuser
      DB_PASSWORD: flaskpass
      DB_PORT: 5432
    ports:
      - "8080:5000"
    volumes:
      - ./app:/app
      - app_data:/app/data
    networks:
      - flask-network
    depends_on:
      database:
        condition: service_healthy
    restart: unless-stopped

  # ⚡ Redis Cache Service (optional enhancement)
  cache:
    image: redis:7-alpine
    container_name: flask-redis-cache
    ports:
      - "6379:6379"
    networks:
      - flask-network
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes

  # 🌐 Nginx Reverse Proxy (optional enhancement)
  nginx:
    image: nginx:alpine
    container_name: flask-nginx-proxy
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
    networks:
      - flask-network
    depends_on:
      - web

# 💾 Define named volumes
volumes:
  postgres_data:
    driver: local
  app_data:
    driver: local
  redis_data:
    driver: local

# 🌉 Define networks
networks:
  flask-network:
    driver: bridge
```

### 🗄️ Subtask 5.2: Create Database Initialization Script

```bash
# 📂 Create database directory and init script
mkdir -p database
nano database/init.sql
```

```sql
-- Initialize the Flask application database
-- This script runs when the PostgreSQL container starts

-- 👥 Create visitors table
CREATE TABLE IF NOT EXISTS visitors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address INET,
    user_agent TEXT
);

-- 🌱 Insert some sample data
INSERT INTO visitors (name, ip_address) VALUES 
    ('Docker Lab Student', '127.0.0.1'),
    ('Container Enthusiast', '192.168.1.100'),
    ('Python Developer', '10.0.0.1');

-- ⚡ Create an index for better performance
CREATE INDEX IF NOT EXISTS idx_visitors_visit_time ON visitors(visit_time);

-- 🔑 Grant permissions
GRANT ALL PRIVILEGES ON TABLE visitors TO flaskuser;
GRANT USAGE, SELECT ON SEQUENCE visitors_id_seq TO flaskuser;
```

### 🌐 Subtask 5.3: Create Nginx Configuration (Optional)

```bash
# 📂 Create nginx directory and configuration
mkdir -p nginx
nano nginx/nginx.conf
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

### 🧹 Subtask 5.4: Clean Up Previous Containers

```bash
# 🛑 Stop and remove existing containers
docker stop flask-app-container postgres-db 2>/dev/null || true
docker rm flask-app-container postgres-db 2>/dev/null || true

# 🌉 Remove the network we created manually
docker network rm flask-network 2>/dev/null || true
```

### 🚀 Subtask 5.5: Launch Multi-Container Application

```bash
# 🚀 Start all services with Docker Compose
docker-compose up -d

# ✅ Check the status of all services
docker-compose ps

# 📜 View logs from all services
docker-compose logs

# 🐍 View logs from a specific service
docker-compose logs web
```

### 🧪 Subtask 5.6: Test the Complete Application Stack

```bash
# ❤️ Test the web application
curl http://localhost:8080/health

# 🗄️ Test direct database connection
docker-compose exec database psql -U flaskuser -d flaskapp -c "SELECT COUNT(*) FROM visitors;"

# ⚡ Test Redis cache (if included)
docker-compose exec cache redis-cli ping

# 🌐 Test Nginx proxy (if included)
curl http://localhost/health
```

### 📐 Subtask 5.7: Scale the Application

```bash
# 📐 Scale the web service to 3 instances
docker-compose up -d --scale web=3

# ✅ Check the scaled services
docker-compose ps

# 🔽 Scale back to 1 instance
docker-compose up -d --scale web=1
```

---

## 🔧 Advanced Operations and Management

### 📊 Container Monitoring and Logs

```bash
# 📡 View real-time logs from all services
docker-compose logs -f

# 📊 Monitor resource usage
docker stats

# ❤️ Check container health
docker-compose exec web curl http://localhost:5000/health
```

### 🗄️ Database Operations

```bash
# 🔑 Access database shell
docker-compose exec database psql -U flaskuser -d flaskapp

# 💾 Backup database
docker-compose exec database pg_dump -U flaskuser flaskapp > backup.sql

# 📋 View database tables
docker-compose exec database psql -U flaskuser -d flaskapp -c "\dt"
```

### 🔄 Application Updates

```bash
# 🔄 Rebuild and update a specific service
docker-compose build web
docker-compose up -d web

# 🔄 Update all services
docker-compose build
docker-compose up -d
```

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔴 Issue 1: Container Won't Start</summary>

```bash
# 📜 Check container logs
docker-compose logs web

# 🔌 Check if ports are already in use
netstat -tulpn | grep :8080

# 🔄 Restart specific service
docker-compose restart web
```
</details>

<details>
<summary>🔴 Issue 2: Database Connection Issues</summary>

```bash
# ✅ Check database container status
docker-compose ps database

# 🔗 Test database connectivity
docker-compose exec web ping database

# 📜 Check database logs
docker-compose logs database
```
</details>

<details>
<summary>🔴 Issue 3: Port Conflicts</summary>

```bash
# ⚙️ Change ports in docker-compose.yml if needed
# For example, change "8080:5000" to "8081:5000"

# 🔄 Apply changes
docker-compose down
docker-compose up -d
```
</details>

---

## 🧹 Cleanup and Resource Management

### 🛑 Stop and Remove All Services

```bash
# 🛑 Stop all services
docker-compose down

# ⚠️ Stop and remove volumes (WARNING: This deletes data)
docker-compose down -v

# 🧹 Remove all unused Docker resources
docker system prune -a
```

---

## 🎓 Conclusion

Congratulations! You have successfully completed **Lab 30: Using Docker with Python - Containerizing Python Apps**.

### 🏆 What You Accomplished

- 🐍 **Created a Python Web Application** — built a functional Flask web application with database integration and a user-friendly interface
- 🐳 **Mastered Docker Containerization** — learned to write effective Dockerfiles, build Docker images, and run containers for Python applications
- 🗄️ **Implemented Multi-Container Architecture** — connected a Python application container to a PostgreSQL database container with proper networking
- 🧱 **Utilized Docker Compose** — created and managed complex multi-container applications using Docker Compose for orchestration
- 🔒 **Applied Best Practices** — implemented security measures, health checks, volume management, and proper container configuration

### 🌍 Why This Matters

| Theme | Why It Matters |
|---|---|
| 🏭 Professional Development | Container technologies are essential in modern software development and DevOps, directly applicable to Docker Certified Associate (DCA) certification requirements |
| 🧩 Real-World Applications | Microservices architecture, cloud deployment strategies, development environment standardization, CI/CD pipelines |
| 📈 Career Advancement | Understanding containerization is crucial for DevOps Engineering, Cloud Architecture, Software Development, and System Administration roles |

### 🔭 Next Steps

- ☸️ Explore **Kubernetes** for container orchestration at scale
- 🔒 Learn about container security best practices
- 🔁 Investigate CI/CD pipeline integration with Docker
- ☁️ Study cloud-native application development patterns
- 🧪 Practice with more complex multi-service architectures

> 🏁 You now have the foundational knowledge to containerize Python applications professionally and can confidently work with Docker in enterprise environments.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blue?style=for-the-badge)

</div>
