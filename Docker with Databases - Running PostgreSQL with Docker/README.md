<div align="center">

# 🐘 Docker with Databases — Running PostgreSQL with Docker

### Deploy, persist, connect, and migrate a containerized PostgreSQL database

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

</div>

---

## 📑 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [☁️ Ready-to-Use Cloud Machines](#️-ready-to-use-cloud-machines)
- [🧩 Task 1: Pull the PostgreSQL Docker Image](#-task-1-pull-the-postgresql-docker-image)
- [🔗 Task 2: Run PostgreSQL Container and Link with Web Application](#-task-2-run-postgresql-container-and-link-with-web-application)
- [💾 Task 3: Configure Persistent Storage Using Docker Volumes](#-task-3-configure-persistent-storage-using-docker-volumes)
- [🖥️ Task 4: Connect to Database from Applications](#️-task-4-connect-to-database-from-applications)
- [🔄 Task 5: Perform Database Migrations Using Docker](#-task-5-perform-database-migrations-using-docker)
- [🛠️ Troubleshooting Tips](#️-troubleshooting-tips)
- [✅ Best Practices](#-best-practices)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | 🐘 Deploy PostgreSQL database inside a Docker container for development and testing environments |
| 2 | 💾 Configure persistent storage using Docker volumes to maintain data across container restarts |
| 3 | 🔗 Connect PostgreSQL container with web application containers using Docker networking |
| 4 | 🐍 Establish database connections from Python and Node.js applications |
| 5 | 🔄 Perform database migrations and management tasks using Docker containers |
| 6 | 📚 Understand best practices for running databases in containerized environments |

---

## 📋 Prerequisites

Before starting this lab, you should have:

| Requirement | Details |
|---|---|
| 🐳 Docker Fundamentals | Basic understanding of Docker concepts (containers, images, volumes) |
| ⌨️ CLI Comfort | Familiarity with command-line interface operations |
| 🗄️ Database Basics | Basic knowledge of SQL and database concepts |
| 🐍 Programming Fundamentals | Understanding of Python or Node.js programming fundamentals |
| 📝 Editor Experience | Experience with text editors for configuration files |

---

## ☁️ Ready-to-Use Cloud Machines

> **💡 Note:** Al Nafi provides pre-configured Linux-based cloud machines with Docker already installed. Simply click **Start Lab** to access your environment — no need to build your own virtual machine or install Docker manually.

Your lab environment includes:

- 🐧 Ubuntu Linux with Docker Engine pre-installed
- 🧰 All necessary development tools and text editors
- 🌐 Network access for downloading Docker images
- 💽 Sufficient storage space for containers and volumes

---

## 🧩 Task 1: Pull the PostgreSQL Docker Image

### ✅ Step 1.1: Verify Docker Installation

First, let's confirm Docker is running properly in your environment.

```bash
# 🔍 Check installed Docker version
docker --version

# 🩺 Check the Docker daemon's health and configuration
docker info
```

### ✅ Step 1.2: Pull the Official PostgreSQL Image

Download the latest PostgreSQL Docker image from Docker Hub.

```bash
# ⬇️ Pull PostgreSQL 15 from Docker Hub
docker pull postgres:15
```

> **📌 Note:** We're using PostgreSQL version 15, which is stable and widely supported. You can also use `postgres:latest` for the most recent version.

### ✅ Step 1.3: Verify the Image Download

Check that the PostgreSQL image has been downloaded successfully.

```bash
# 📋 List local images filtered for postgres
docker images | grep postgres
```

You should see output similar to:

```
postgres    15    [IMAGE_ID]    [CREATED]    [SIZE]
```

---

## 🔗 Task 2: Run PostgreSQL Container and Link with Web Application

### ✅ Step 2.1: Create a Docker Network

Create a custom network to enable communication between containers.

```bash
# 🌐 Create an isolated bridge network for the app stack
docker network create webapp-network
```

### ✅ Step 2.2: Run PostgreSQL Container

Start the PostgreSQL container with proper configuration.

```bash
# 🚀 Launch the PostgreSQL container on the custom network
docker run -d \
  --name postgres-db \
  --network webapp-network \
  -e POSTGRES_DB=webapp_db \
  -e POSTGRES_USER=webapp_user \
  -e POSTGRES_PASSWORD=secure_password123 \
  -p 5432:5432 \
  postgres:15
# TODO: Replace 'secure_password123' with a strong, unique password before real use
```

**🔧 Environment Variables Explanation:**

| Variable | Purpose |
|---|---|
| `POSTGRES_DB` | Creates a database named `webapp_db` |
| `POSTGRES_USER` | Creates a user named `webapp_user` |
| `POSTGRES_PASSWORD` | Sets the password for the user |
| `-p 5432:5432` | Maps container port 5432 to host port 5432 |

### ✅ Step 2.3: Verify Container is Running

Check that the PostgreSQL container is running properly.

```bash
# 📋 Confirm the container is up
docker ps

# 📜 Inspect startup logs
docker logs postgres-db
```

### ✅ Step 2.4: Test Database Connection

Connect to the PostgreSQL database to verify it's working.

```bash
# 🔑 Open an interactive psql session inside the container
docker exec -it postgres-db psql -U webapp_user -d webapp_db
```

Once connected, run a simple SQL command:

```sql
-- 🧪 Confirm the server version
SELECT version();
\q
```

---

## 💾 Task 3: Configure Persistent Storage Using Docker Volumes

### ✅ Step 3.1: Stop the Current Container

Stop the existing container to recreate it with persistent storage.

```bash
# 🛑 Stop and remove the non-persistent container
docker stop postgres-db
docker rm postgres-db
```

### ✅ Step 3.2: Create a Named Volume

Create a Docker volume for persistent data storage.

```bash
# 💽 Create a named volume for database files
docker volume create postgres-data
```

### ✅ Step 3.3: Run PostgreSQL with Persistent Storage

Start PostgreSQL container with the volume mounted.

```bash
# 🚀 Relaunch with a persistent volume mounted at the data directory
docker run -d \
  --name postgres-db \
  --network webapp-network \
  -e POSTGRES_DB=webapp_db \
  -e POSTGRES_USER=webapp_user \
  -e POSTGRES_PASSWORD=secure_password123 \
  -p 5432:5432 \
  -v postgres-data:/var/lib/postgresql/data \
  postgres:15
```

### ✅ Step 3.4: Test Data Persistence

Create a test table and data to verify persistence.

```bash
# 🔑 Reconnect to the database
docker exec -it postgres-db psql -U webapp_user -d webapp_db
```

In the PostgreSQL prompt:

```sql
-- 🏗️ Create a sample users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- ➕ Insert sample rows
INSERT INTO users (name, email) VALUES 
    ('John Doe', 'john@example.com'),
    ('Jane Smith', 'jane@example.com');

-- 👀 Confirm the data
SELECT * FROM users;
\q
```

### ✅ Step 3.5: Verify Persistence

Restart the container and check if data persists.

```bash
# 🔁 Restart the container
docker restart postgres-db

# 🔍 Confirm the data survived the restart
docker exec -it postgres-db psql -U webapp_user -d webapp_db -c "SELECT * FROM users;"
```

---

## 🖥️ Task 4: Connect to Database from Applications

### ✅ Step 4.1: Create Python Application

Create a directory for your Python application.

```bash
# 📁 Set up the project folder
mkdir python-app
cd python-app
```

Create a Python script to connect to PostgreSQL:

```bash
cat > app.py << 'EOF'
import psycopg2
import sys

def connect_to_database():
    try:
        # 🔌 Database connection parameters
        connection = psycopg2.connect(
            host="localhost",
            database="webapp_db",
            user="webapp_user",
            password="secure_password123",
            port="5432"
        )
        
        cursor = connection.cursor()
        
        # 🧪 Test the connection
        cursor.execute("SELECT version();")
        db_version = cursor.fetchone()
        print(f"Connected to PostgreSQL: {db_version[0]}")
        
        # 📋 Query users table
        cursor.execute("SELECT * FROM users;")
        users = cursor.fetchall()
        
        print("\nUsers in database:")
        for user in users:
            print(f"ID: {user[0]}, Name: {user[1]}, Email: {user[2]}")
        
        cursor.close()
        connection.close()
        print("\nDatabase connection closed.")
        
    except Exception as error:
        print(f"Error connecting to PostgreSQL: {error}")
        sys.exit(1)

if __name__ == "__main__":
    connect_to_database()
EOF
# TODO: Move credentials into environment variables instead of hardcoding them
```

### ✅ Step 4.2: Create Python Application Container

Create a Dockerfile for the Python application:

```dockerfile
# Dockerfile
FROM python:3.9-slim

WORKDIR /app

# 📦 Install the PostgreSQL driver
RUN pip install psycopg2-binary

COPY app.py .

CMD ["python", "app.py"]
```

### ✅ Step 4.3: Build and Run Python Application

Build the Python application container:

```bash
# 🏗️ Build the Python app image
docker build -t python-db-app .
```

Run the Python application container:

```bash
# 🚀 Run it on the shared network so it can reach postgres-db
docker run --rm --network webapp-network python-db-app
```

### ✅ Step 4.4: Create Node.js Application

Navigate back to the main directory and create a Node.js application:

```bash
# 📁 Set up the Node.js project folder
cd ..
mkdir nodejs-app
cd nodejs-app
```

Create a Node.js application:

```bash
cat > app.js << 'EOF'
const { Client } = require('pg');

async function connectToDatabase() {
    const client = new Client({
        host: 'postgres-db',
        database: 'webapp_db',
        user: 'webapp_user',
        password: 'secure_password123',
        port: 5432,
    });

    try {
        await client.connect();
        console.log('Connected to PostgreSQL database');

        // 🧪 Test query
        const versionResult = await client.query('SELECT version()');
        console.log('Database version:', versionResult.rows[0].version);

        // 📋 Query users
        const usersResult = await client.query('SELECT * FROM users');
        console.log('\nUsers in database:');
        usersResult.rows.forEach(user => {
            console.log(`ID: ${user.id}, Name: ${user.name}, Email: ${user.email}`);
        });

    } catch (error) {
        console.error('Database connection error:', error);
    } finally {
        await client.end();
        console.log('Database connection closed');
    }
}

connectToDatabase();
EOF
# TODO: Replace hardcoded credentials with process.env values
```

Create `package.json`:

```json
{
    "name": "nodejs-db-app",
    "version": "1.0.0",
    "description": "Node.js PostgreSQL connection example",
    "main": "app.js",
    "dependencies": {
        "pg": "^8.8.0"
    }
}
```

Create Dockerfile for Node.js:

```dockerfile
# Dockerfile
FROM node:16-slim

WORKDIR /app

COPY package.json .
# 📦 Install dependencies
RUN npm install

COPY app.js .

CMD ["node", "app.js"]
```

### ✅ Step 4.5: Build and Run Node.js Application

Build and run the Node.js application:

```bash
# 🏗️ Build the Node.js app image
docker build -t nodejs-db-app .

# 🚀 Run it on the shared network
docker run --rm --network webapp-network nodejs-db-app
```

---

## 🔄 Task 5: Perform Database Migrations Using Docker

### ✅ Step 5.1: Create Migration Scripts

Navigate back to the main directory and create a migrations folder:

```bash
# 📁 Set up the migrations folder
cd ..
mkdir migrations
cd migrations
```

Create migration scripts:

```bash
cat > 001_create_products_table.sql << 'EOF'
-- 🏗️ Migration: Create products table
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ➕ Insert sample data
INSERT INTO products (name, price, description) VALUES
    ('Laptop', 999.99, 'High-performance laptop'),
    ('Mouse', 29.99, 'Wireless optical mouse'),
    ('Keyboard', 79.99, 'Mechanical keyboard');
EOF
```

```bash
cat > 002_add_category_to_products.sql << 'EOF'
-- ✏️ Migration: Add category column to products table
ALTER TABLE products ADD COLUMN IF NOT EXISTS category VARCHAR(100);

-- 🔄 Update existing products with categories
UPDATE products SET category = 'Electronics' WHERE name IN ('Laptop', 'Mouse', 'Keyboard');
EOF
```

### ✅ Step 5.2: Create Migration Runner Script

Create a script to run migrations:

```bash
cat > run_migrations.sh << 'EOF'
#!/bin/bash

echo "Starting database migrations..."

# 🔄 Run each migration file in order
for migration_file in /migrations/*.sql; do
    if [ -f "$migration_file" ]; then
        echo "Running migration: $(basename $migration_file)"
        psql -U webapp_user -d webapp_db -f "$migration_file"
        if [ $? -eq 0 ]; then
            echo "Migration $(basename $migration_file) completed successfully"
        else
            echo "Migration $(basename $migration_file) failed"
            exit 1
        fi
    fi
done

echo "All migrations completed successfully!"
EOF
```

Make the script executable:

```bash
# 🔓 Grant execute permission
chmod +x run_migrations.sh
```

### ✅ Step 5.3: Run Migrations Using Docker

Execute the migrations by mounting the migrations directory:

```bash
# 🚀 Run the migration runner inside a throwaway postgres container
docker run --rm \
  --network webapp-network \
  -v $(pwd):/migrations \
  postgres:15 \
  bash -c "
    export PGPASSWORD=secure_password123
    /migrations/run_migrations.sh
  "
```

### ✅ Step 5.4: Verify Migration Results

Check that the migrations were applied successfully:

```bash
# 🔑 Connect to inspect the results
docker exec -it postgres-db psql -U webapp_user -d webapp_db
```

In the PostgreSQL prompt:

```sql
-- 🔍 Check products table structure
\d products

-- 👀 View products data
SELECT * FROM products;

-- ✅ Check users table still exists
SELECT * FROM users;

\q
```

### ✅ Step 5.5: Create a Migration Container

For more complex scenarios, create a dedicated migration container:

```dockerfile
# Dockerfile.migrations
FROM postgres:15

COPY *.sql /migrations/
COPY run_migrations.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/run_migrations.sh

CMD ["/usr/local/bin/run_migrations.sh"]
```

Build the migration container:

```bash
# 🏗️ Build the dedicated migration image
docker build -f Dockerfile.migrations -t db-migrations .
```

Run migrations using the dedicated container:

```bash
# 🚀 Run migrations as a self-contained, repeatable job
docker run --rm \
  --network webapp-network \
  -e PGHOST=postgres-db \
  -e PGUSER=webapp_user \
  -e PGPASSWORD=secure_password123 \
  -e PGDATABASE=webapp_db \
  db-migrations
# TODO: Wire this container into a CI/CD pipeline for automated schema rollout
```

---

## 🛠️ Troubleshooting Tips

<details>
<summary>⚠️ Issue 1: Container fails to start</summary>

- Check if port 5432 is already in use: `netstat -tlnp | grep 5432`
- Use a different port mapping: `-p 5433:5432`

</details>

<details>
<summary>⚠️ Issue 2: Connection refused errors</summary>

- Ensure containers are on the same network
- Verify container names and network configuration
- Check firewall settings

</details>

<details>
<summary>⚠️ Issue 3: Data not persisting</summary>

- Verify volume is properly mounted
- Check volume permissions: `docker volume inspect postgres-data`

</details>

<details>
<summary>⚠️ Issue 4: Authentication failures</summary>

- Double-check environment variables
- Ensure password meets PostgreSQL requirements
- Verify user permissions

</details>

<details>
<summary>⚠️ Issue 5: Migration failures</summary>

- Check SQL syntax in migration files
- Ensure proper file permissions
- Verify database connectivity before running migrations

</details>

---

## ✅ Best Practices

### 🔒 Security Considerations
- Use strong passwords for database users
- Limit network exposure by using custom networks
- Regularly update PostgreSQL images
- Use secrets management for production environments

### ⚡ Performance Optimization
- Configure appropriate memory settings for PostgreSQL
- Use specific PostgreSQL versions instead of `latest`
- Monitor container resource usage
- Implement proper indexing strategies

### 💾 Data Management
- Always use volumes for persistent data
- Implement regular backup strategies
- Test data recovery procedures
- Monitor disk space usage

---

## 🏁 Conclusion

In this lab, you have successfully:

| Achievement | Description |
|---|---|
| 🐘 Deployed PostgreSQL in Docker | Learned how to pull and run PostgreSQL containers with proper configuration for development environments |
| 💾 Implemented Persistent Storage | Configured Docker volumes to ensure database data survives container restarts and updates |
| 🔗 Connected Applications | Created both Python and Node.js applications that successfully connect to the containerized PostgreSQL database |
| 🔄 Performed Database Migrations | Implemented a migration system using Docker containers to manage database schema changes |
| 📚 Established Best Practices | Learned important concepts about networking, security, and data persistence in containerized database environments |

### 🌍 Real-World Applications

This knowledge is directly applicable to:

- 🧑‍💻 **Development Environments** — Quickly spinning up consistent database environments for development teams
- 🧪 **Testing Scenarios** — Creating isolated database instances for automated testing
- 🧩 **Microservices Architecture** — Managing database containers as part of larger containerized applications
- ⚙️ **DevOps Practices** — Implementing database deployment and migration strategies in CI/CD pipelines

> The techniques demonstrated in this lab form the foundation for more advanced topics like container orchestration with Kubernetes, database clustering, and production deployment strategies. Understanding how to properly containerize and manage databases is a crucial skill for the Docker Certified Associate certification and modern software development practices.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1a1a2e?style=for-the-badge)

</div>
