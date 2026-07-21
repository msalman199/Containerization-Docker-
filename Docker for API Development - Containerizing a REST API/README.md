<div align="center">

# 🔌 Docker for API Development — Containerizing a REST API

### Build, containerize, and orchestrate a Flask + PostgreSQL REST API with Docker

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

</div>

---

## 📑 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🧭 Lab Environment Setup](#-lab-environment-setup)
- [🐍 Task 1: Create a REST API using Flask](#-task-1-create-a-rest-api-using-flask)
- [🐳 Task 2: Write a Dockerfile for the API and Build the Image](#-task-2-write-a-dockerfile-for-the-api-and-build-the-image)
- [🔗 Task 3: Expose the API and Connect it to a PostgreSQL Container](#-task-3-expose-the-api-and-connect-it-to-a-postgresql-container)
- [🧪 Task 4: Deploy and Test the API Inside the Container](#-task-4-deploy-and-test-the-api-inside-the-container)
- [🧩 Task 5: Use Docker Compose for Managing the Application and Database](#-task-5-use-docker-compose-for-managing-the-application-and-database)
- [🔬 Advanced Testing and Troubleshooting](#-advanced-testing-and-troubleshooting)
- [🛠️ Common Troubleshooting Issues](#️-common-troubleshooting-issues)
- [✅ Best Practices Implemented](#-best-practices-implemented)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | 🐍 Create a REST API using Flask (Python) framework |
| 2 | 🐳 Write and understand Dockerfile components for API containerization |
| 3 | 🏗️ Build Docker images for web applications |
| 4 | 🔗 Connect containerized applications to PostgreSQL databases |
| 5 | 🧪 Deploy and test APIs running inside Docker containers |
| 6 | 🧩 Use Docker Compose to orchestrate multi-container applications |
| 7 | 📚 Understand best practices for containerizing web APIs |

---

## 📋 Prerequisites

Before starting this lab, students should have:

| Requirement | Details |
|---|---|
| 🔌 REST API Concepts | Basic understanding of REST API concepts |
| 🐍 Python Familiarity | Familiarity with Python programming language |
| 🌐 HTTP Methods | Basic knowledge of HTTP methods (GET, POST, PUT, DELETE) |
| 📄 JSON Format | Understanding of JSON data format |
| ⌨️ CLI Experience | Basic command-line interface experience |
| 🐳 Docker Fundamentals | Fundamental Docker concepts (containers, images) |

> **💡 Note:** Al Nafi provides ready-to-use Linux-based cloud machines with Docker pre-installed. Simply click **Start Lab** to begin — no need to build your own VM or install Docker manually.

---

## 🧭 Lab Environment Setup

Your cloud machine comes pre-configured with:

- 🐧 Ubuntu Linux operating system
- 🐳 Docker Engine installed and running
- 🧩 Docker Compose installed
- 🐍 Python 3 and pip package manager
- 📝 Text editor (nano/vim)
- 🌐 All necessary networking configurations

---

## 🐍 Task 1: Create a REST API using Flask

### ✅ Subtask 1.1: Set up the project directory structure

First, let's create an organized directory structure for our project:

```bash
# 📁 Create the project layout
mkdir flask-api-docker
cd flask-api-docker
mkdir app
cd app
```

### ✅ Subtask 1.2: Create the Flask application

Create the main application file:

```bash
# 📝 Open the app file for editing
nano app.py
```

Add the following Flask application code:

```python
from flask import Flask, request, jsonify
import psycopg2
from psycopg2.extras import RealDictCursor
import os
import json

app = Flask(__name__)

# 🔧 Database configuration from environment variables
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_NAME = os.getenv('DB_NAME', 'apidb')
DB_USER = os.getenv('DB_USER', 'apiuser')
DB_PASS = os.getenv('DB_PASS', 'apipass')
DB_PORT = os.getenv('DB_PORT', '5432')
# TODO: Move DB_PASS out of plaintext env vars and into a secrets manager for production

def get_db_connection():
    """Create database connection"""
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS,
            port=DB_PORT
        )
        return conn
    except Exception as e:
        print(f"Database connection error: {e}")
        return None

def init_db():
    """Initialize database with users table"""
    conn = get_db_connection()
    if conn:
        try:
            cur = conn.cursor()
            cur.execute('''
                CREATE TABLE IF NOT EXISTS users (
                    id SERIAL PRIMARY KEY,
                    name VARCHAR(100) NOT NULL,
                    email VARCHAR(100) UNIQUE NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            ''')
            conn.commit()
            cur.close()
            conn.close()
            print("Database initialized successfully")
        except Exception as e:
            print(f"Database initialization error: {e}")

# 🩺 Health check endpoint
@app.route('/', methods=['GET'])
def home():
    """Health check endpoint"""
    return jsonify({
        'message': 'Flask API is running!',
        'status': 'healthy',
        'version': '1.0'
    })

# 📋 Read all users
@app.route('/users', methods=['GET'])
def get_users():
    """Get all users"""
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute('SELECT * FROM users ORDER BY id')
        users = cur.fetchall()
        cur.close()
        conn.close()
        
        return jsonify({
            'users': [dict(user) for user in users],
            'count': len(users)
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ➕ Create a user
@app.route('/users', methods=['POST'])
def create_user():
    """Create a new user"""
    data = request.get_json()
    
    if not data or 'name' not in data or 'email' not in data:
        return jsonify({'error': 'Name and email are required'}), 400
    
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute(
            'INSERT INTO users (name, email) VALUES (%s, %s) RETURNING *',
            (data['name'], data['email'])
        )
        new_user = cur.fetchone()
        conn.commit()
        cur.close()
        conn.close()
        
        return jsonify({
            'message': 'User created successfully',
            'user': dict(new_user)
        }), 201
    except psycopg2.IntegrityError:
        return jsonify({'error': 'Email already exists'}), 409
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# 🔍 Read a single user
@app.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    """Get a specific user by ID"""
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute('SELECT * FROM users WHERE id = %s', (user_id,))
        user = cur.fetchone()
        cur.close()
        conn.close()
        
        if user:
            return jsonify({'user': dict(user)})
        else:
            return jsonify({'error': 'User not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ✏️ Update a user
@app.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    """Update a user"""
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        
        # Build dynamic update query
        update_fields = []
        values = []
        
        if 'name' in data:
            update_fields.append('name = %s')
            values.append(data['name'])
        
        if 'email' in data:
            update_fields.append('email = %s')
            values.append(data['email'])
        
        if not update_fields:
            return jsonify({'error': 'No valid fields to update'}), 400
        
        values.append(user_id)
        query = f'UPDATE users SET {", ".join(update_fields)} WHERE id = %s RETURNING *'
        
        cur.execute(query, values)
        updated_user = cur.fetchone()
        
        if updated_user:
            conn.commit()
            cur.close()
            conn.close()
            return jsonify({
                'message': 'User updated successfully',
                'user': dict(updated_user)
            })
        else:
            cur.close()
            conn.close()
            return jsonify({'error': 'User not found'}), 404
            
    except psycopg2.IntegrityError:
        return jsonify({'error': 'Email already exists'}), 409
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# 🗑️ Delete a user
@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    """Delete a user"""
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cur = conn.cursor()
        cur.execute('DELETE FROM users WHERE id = %s', (user_id,))
        
        if cur.rowcount > 0:
            conn.commit()
            cur.close()
            conn.close()
            return jsonify({'message': 'User deleted successfully'})
        else:
            cur.close()
            conn.close()
            return jsonify({'error': 'User not found'}), 404
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
```

### ✅ Subtask 1.3: Create requirements file

Create a `requirements.txt` file to specify Python dependencies:

```bash
# 📝 Open the requirements file for editing
nano requirements.txt
```

Add the following dependencies:

```
Flask==2.3.3
psycopg2-binary==2.9.7
python-dotenv==1.0.0
```

---

## 🐳 Task 2: Write a Dockerfile for the API and Build the Image

### ✅ Subtask 2.1: Create the Dockerfile

Navigate back to the project root and create a Dockerfile:

```bash
# 📁 Back to the project root
cd ..
nano Dockerfile
```

Add the following Dockerfile content:

```dockerfile
# 🐍 Use official Python runtime as base image
FROM python:3.11-slim

# 📁 Set working directory in container
WORKDIR /app

# 🔧 Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 📦 Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        gcc \
        python3-dev \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# 📋 Copy requirements first for better caching
COPY app/requirements.txt .

# 📦 Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 📂 Copy application code
COPY app/ .

# 🔒 Create non-root user for security
RUN adduser --disabled-password --gecos '' appuser && \
    chown -R appuser:appuser /app
USER appuser

# 🌐 Expose port
EXPOSE 5000

# 🩺 Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/ || exit 1

# 🚀 Run the application
CMD ["python", "app.py"]
```

### ✅ Subtask 2.2: Create .dockerignore file

Create a `.dockerignore` file to exclude unnecessary files:

```bash
# 📝 Open the dockerignore file for editing
nano .dockerignore
```

Add the following content:

```
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

### ✅ Subtask 2.3: Build the Docker image

Build the Docker image for your Flask API:

```bash
# 🏗️ Build the image
docker build -t flask-api:v1.0 .
```

Verify the image was created successfully:

```bash
# 🔍 Confirm the image exists
docker images | grep flask-api
```

---

## 🔗 Task 3: Expose the API and Connect it to a PostgreSQL Container

### ✅ Subtask 3.1: Create a Docker network

Create a custom network for container communication:

```bash
# 🌐 Create the shared network
docker network create api-network
```

### ✅ Subtask 3.2: Run PostgreSQL container

Start a PostgreSQL container with the required database configuration:

```bash
# 🐘 Launch PostgreSQL on the shared network
docker run -d \
  --name postgres-db \
  --network api-network \
  -e POSTGRES_DB=apidb \
  -e POSTGRES_USER=apiuser \
  -e POSTGRES_PASSWORD=apipass \
  -p 5432:5432 \
  postgres:15-alpine
# TODO: Replace 'apipass' with a strong, unique password before real use
```

### ✅ Subtask 3.3: Wait for PostgreSQL to be ready

Check if PostgreSQL is ready to accept connections:

```bash
# 📜 Watch the startup logs
docker logs postgres-db
```

> ⏳ Wait until you see messages indicating the database is ready to accept connections.

### ✅ Subtask 3.4: Run the Flask API container

Start your Flask API container connected to the same network:

```bash
# 🚀 Launch the Flask API on the shared network
docker run -d \
  --name flask-api-container \
  --network api-network \
  -e DB_HOST=postgres-db \
  -e DB_NAME=apidb \
  -e DB_USER=apiuser \
  -e DB_PASS=apipass \
  -e DB_PORT=5432 \
  -p 5000:5000 \
  flask-api:v1.0
```

---

## 🧪 Task 4: Deploy and Test the API Inside the Container

### ✅ Subtask 4.1: Verify containers are running

Check that both containers are running properly:

```bash
# 🔍 List running containers
docker ps
```

> You should see both the PostgreSQL and Flask API containers in the running state.

### ✅ Subtask 4.2: Check API health

Test the health endpoint:

```bash
# 🩺 Hit the health check endpoint
curl http://localhost:5000/
```

**Expected response:**

```json
{
  "message": "Flask API is running!",
  "status": "healthy",
  "version": "1.0"
}
```

### ✅ Subtask 4.3: Test API endpoints

**Test creating a new user:**

```bash
# ➕ Create a user
curl -X POST http://localhost:5000/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'
```

**Test getting all users:**

```bash
# 📋 List all users
curl http://localhost:5000/users
```

**Test getting a specific user:**

```bash
# 🔍 Get a single user
curl http://localhost:5000/users/1
```

**Test updating a user:**

```bash
# ✏️ Update a user
curl -X PUT http://localhost:5000/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "John Smith", "email": "johnsmith@example.com"}'
```

### ✅ Subtask 4.4: View container logs

Check the API container logs to see request processing:

```bash
# 📜 Tail the API logs
docker logs flask-api-container
```

Check PostgreSQL logs:

```bash
# 📜 Tail the database logs
docker logs postgres-db
```

---

## 🧩 Task 5: Use Docker Compose for Managing the Application and Database

### ✅ Subtask 5.1: Stop and remove existing containers

Clean up the manually created containers:

```bash
# 🗑️ Tear down the manual setup
docker stop flask-api-container postgres-db
docker rm flask-api-container postgres-db
docker network rm api-network
```

### ✅ Subtask 5.2: Create Docker Compose file

Create a `docker-compose.yml` file in the project root:

```bash
# 📝 Open the compose file for editing
nano docker-compose.yml
```

Add the following Docker Compose configuration:

```yaml
version: '3.8'

services:
  # 🐘 PostgreSQL Database Service
  database:
    image: postgres:15-alpine
    container_name: postgres-db
    environment:
      POSTGRES_DB: apidb
      POSTGRES_USER: apiuser
      POSTGRES_PASSWORD: apipass
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init-db:/docker-entrypoint-initdb.d
    ports:
      - "5432:5432"
    networks:
      - api-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U apiuser -d apidb"]
      interval: 10s
      timeout: 5s
      retries: 5

  # 🐍 Flask API Service
  api:
    build: .
    container_name: flask-api
    environment:
      DB_HOST: database
      DB_NAME: apidb
      DB_USER: apiuser
      DB_PASS: apipass
      DB_PORT: 5432
    ports:
      - "5000:5000"
    networks:
      - api-network
    depends_on:
      database:
        condition: service_healthy
    volumes:
      - ./app:/app
    restart: unless-stopped

networks:
  api-network:
    driver: bridge

volumes:
  postgres_data:
```

### ✅ Subtask 5.3: Create database initialization script (optional)

Create a directory for database initialization scripts:

```bash
# 📁 Set up the init-db directory
mkdir init-db
nano init-db/01-init.sql
```

Add sample data initialization:

```sql
-- 🌱 Create sample users after table creation
INSERT INTO users (name, email) VALUES 
    ('Alice Johnson', 'alice@example.com'),
    ('Bob Wilson', 'bob@example.com'),
    ('Carol Brown', 'carol@example.com')
ON CONFLICT (email) DO NOTHING;
```

### ✅ Subtask 5.4: Start services with Docker Compose

Start all services using Docker Compose:

```bash
# 🚀 Bring up the full stack
docker-compose up -d
```

Check the status of all services:

```bash
# 🔍 Confirm both services are healthy
docker-compose ps
```

### ✅ Subtask 5.5: Test the complete application

Test the API endpoints with the Docker Compose setup:

```bash
# 🩺 Health check
curl http://localhost:5000/

# 📋 Get all users (should include sample data)
curl http://localhost:5000/users

# ➕ Create a new user
curl -X POST http://localhost:5000/users \
  -H "Content-Type: application/json" \
  -d '{"name": "David Miller", "email": "david@example.com"}'

# 🔍 Verify the new user was created
curl http://localhost:5000/users
```

### ✅ Subtask 5.6: View logs using Docker Compose

View logs for all services:

```bash
# 📜 Tail every service's logs
docker-compose logs
```

View logs for a specific service:

```bash
# 📜 Tail just the API or database
docker-compose logs api
docker-compose logs database
```

### ✅ Subtask 5.7: Scale and manage services

Scale the API service (run multiple instances):

```bash
# 📈 Run two API replicas
docker-compose up -d --scale api=2
```

Stop all services:

```bash
# 🛑 Stop the stack
docker-compose down
```

Stop services and remove volumes:

```bash
# 🗑️ Stop the stack and wipe persisted data
docker-compose down -v
```

---

## 🔬 Advanced Testing and Troubleshooting

### 🐘 Database Connection Testing

Connect directly to the PostgreSQL container to verify data:

```bash
# 🔑 Open an interactive psql session
docker exec -it postgres-db psql -U apiuser -d apidb
```

Inside the PostgreSQL shell, run:

```sql
\dt
SELECT * FROM users;
\q
```

### ⚡ Performance Testing

Test API performance using curl in a loop:

```bash
# 🧪 Fire 10 sequential create requests and time each one
for i in {1..10}; do
  curl -X POST http://localhost:5000/users \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"User$i\", \"email\": \"user$i@example.com\"}" \
    -w "Time: %{time_total}s\n"
done
```

### 📊 Container Resource Monitoring

Monitor container resource usage:

```bash
# 📊 Live CPU/memory stats for all containers
docker stats
```

---

## 🛠️ Common Troubleshooting Issues

<details>
<summary>⚠️ Issue 1: Database Connection Refused</summary>

**Problem:** API cannot connect to PostgreSQL

**Solution:**
- Ensure containers are on the same network
- Check environment variables
- Verify PostgreSQL is fully started before API

</details>

<details>
<summary>⚠️ Issue 2: Port Already in Use</summary>

**Problem:** Port 5000 or 5432 already in use

**Solution:**

```bash
# 🔍 Find process using the port
sudo lsof -i :5000
# 🛑 Kill the process or change port in docker-compose.yml
```

</details>

<details>
<summary>⚠️ Issue 3: Permission Denied</summary>

**Problem:** Permission issues with volumes

**Solution:**

```bash
# 🔧 Fix ownership
sudo chown -R $USER:$USER ./app
```

</details>

---

## ✅ Best Practices Implemented

| Practice | Description |
|---|---|
| 🔒 Security | Non-root user in container |
| 🩺 Health Checks | Container health monitoring |
| 🔧 Environment Variables | Configurable database settings |
| 💾 Data Persistence | PostgreSQL data volume |
| 🌐 Network Isolation | Custom Docker network |
| 🔗 Dependency Management | Service dependencies in Compose |
| ⚡ Resource Optimization | Multi-stage builds and `.dockerignore` |

---

## 🏁 Conclusion

In this comprehensive lab, you have successfully:

- 🐍 **Created a fully functional REST API** using Flask with complete CRUD operations for user management
- 🐳 **Containerized the application** using Docker with proper security practices and health checks
- 🧩 **Orchestrated multi-container applications** using Docker Compose for seamless service management
- 🔗 **Implemented database connectivity** between containerized Flask API and PostgreSQL database
- 🧪 **Deployed and tested a production-ready containerized API** with proper error handling and logging
- ✅ **Applied Docker best practices** including network isolation, data persistence, and service dependencies

This lab demonstrates the power of containerization for API development, showing how Docker simplifies deployment, ensures consistency across environments, and enables easy scaling. The skills learned here are directly applicable to real-world API development and deployment scenarios, making you well-prepared for modern containerized application development.

> The combination of Flask, PostgreSQL, and Docker provides a robust foundation for building scalable web APIs that can be easily deployed in any environment that supports Docker, from development laptops to production cloud platforms.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1a1a2e?style=for-the-badge)

</div>
