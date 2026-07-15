<div align="center">

# 🧩 Docker Compose - Introduction to Multi-Container Applications

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-CB171E?style=for-the-badge&logo=yaml&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![DCA](https://img.shields.io/badge/DCA-Certification%20Aligned-blue?style=for-the-badge)
![Level](https://img.shields.io/badge/Level-Intermediate-brightgreen?style=for-the-badge)

**A hands-on lab building, scaling, and managing a multi-container Nginx + MySQL stack with Docker Compose**

</div>

---

## 📚 Table of Contents

- [🎯 Objectives](#-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [ℹ️ What is Docker Compose?](#️-what-is-docker-compose)
- [⚙️ Task 1: Install Docker Compose](#️-task-1-install-docker-compose)
- [📝 Task 2: Create a Docker Compose File for Multi-Service Application](#-task-2-create-a-docker-compose-file-for-multi-service-application)
- [🚀 Task 3: Start the Multi-Container Application](#-task-3-start-the-multi-container-application)
- [📈 Task 4: Scale Services Using Docker Compose](#-task-4-scale-services-using-docker-compose)
- [🗑️ Task 5: Stop and Remove Services](#️-task-5-stop-and-remove-services)
- [🔬 Advanced Docker Compose Operations](#-advanced-docker-compose-operations)
- [🚨 Troubleshooting Common Issues](#-troubleshooting-common-issues)
- [✅ Best Practices for Docker Compose](#-best-practices-for-docker-compose)
- [🧪 Lab Verification Checklist](#-lab-verification-checklist)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | ℹ️ Understand the purpose and benefits of Docker Compose for multi-container applications |
| 2 | ⚙️ Install and configure Docker Compose on a Linux system |
| 3 | 📝 Create and configure `docker-compose.yml` files for multi-service applications |
| 4 | 🚀 Deploy and manage multi-container applications using Docker Compose commands |
| 5 | 📈 Scale services dynamically using Docker Compose |
| 6 | 🗑️ Properly stop and clean up multi-container applications |
| 7 | 🚨 Troubleshoot common Docker Compose issues |

---

## ✅ Prerequisites

| Requirement | Status |
|---|---|
| Basic understanding of Docker containers and images | Required |
| Familiarity with Linux command line operations | Required |
| Knowledge of YAML file format basics | Required |
| Understanding of web applications and databases concepts | Required |
| Completion of previous Docker labs | Recommended |

---

## 🖥️ Lab Environment Setup

> **☁️ Ready-to-Use Cloud Machines:** Al Nafi provides pre-configured Linux-based cloud machines for this lab. Simply click **Start Lab** to access your dedicated environment. No need to build your own virtual machine or install Docker manually — everything is ready to use.

**Your cloud machine includes:**

- 🐧 Ubuntu 20.04 LTS or later
- 🐳 Docker Engine pre-installed
- 🧰 All necessary development tools
- 🌐 Internet connectivity for downloading images

---

## ℹ️ What is Docker Compose?

Docker Compose is a tool for defining and running multi-container Docker applications. Instead of managing multiple containers individually, Compose allows you to define your entire application stack in a single YAML file and manage it with simple commands.

**Key Benefits:**

- 🎛️ **Simplified Management:** Control multiple containers with single commands
- 🔁 **Environment Consistency:** Ensure same setup across development, testing, and production
- 🔗 **Service Dependencies:** Define how services depend on each other
- 📈 **Easy Scaling:** Scale services up or down with simple commands

---

## ⚙️ Task 1: Install Docker Compose

### 1️⃣ Step 1.1: Verify Docker Installation

First, let's confirm Docker is installed and running on your system.

```bash
# Check Docker version
docker --version  # 🔎 confirm CLI version

# Check Docker service status
sudo systemctl status docker  # ✅ confirm daemon running

# Test Docker with hello-world
docker run hello-world  # 👋 sanity check
```

### 2️⃣ Step 1.2: Install Docker Compose

Docker Compose comes pre-installed with Docker Desktop, but on Linux servers, we need to install it separately.

```bash
# Download the latest stable release of Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose  # ⬇️ download binary

# Make the binary executable
sudo chmod +x /usr/local/bin/docker-compose  # 🔑 make executable

# Create a symbolic link (optional, for easier access)
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose  # 🔗 symlink
```

### 3️⃣ Step 1.3: Verify Docker Compose Installation

```bash
# Check Docker Compose version
docker-compose --version  # 🔎 confirm installed version

# Display help information
docker-compose --help  # ❓ view usage help
```

Expected Output:
```
Docker Compose version v2.x.x
```

---

## 📝 Task 2: Create a Docker Compose File for Multi-Service Application

We'll create a simple web application with two services: a web server (Nginx) and a database (MySQL).

### 1️⃣ Step 2.1: Create Project Directory Structure

```bash
# Create project directory
mkdir ~/docker-compose-lab  # 📁 project root
cd ~/docker-compose-lab

# Create subdirectories for organization
mkdir -p web/html          # 📁 web content
mkdir -p database/init     # 📁 db init scripts
```

### 2️⃣ Step 2.2: Create a Simple Web Page

Create a basic HTML file for our web server:

```bash
# Create index.html file
cat > web/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Docker Compose Lab</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .info {
            background-color: #e7f3ff;
            padding: 15px;
            border-left: 4px solid #2196F3;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Docker Compose Lab!</h1>
        <div class="info">
            <h3>Multi-Container Application</h3>
            <p>This web page is served by an Nginx container, which is part of a multi-container application managed by Docker Compose.</p>
            <p><strong>Services Running:</strong></p>
            <ul>
                <li>Web Server: Nginx (Port 8080)</li>
                <li>Database: MySQL (Port 3306)</li>
            </ul>
        </div>
        <p>Congratulations! You have successfully deployed a multi-container application using Docker Compose.</p>
    </div>
</body>
</html>
EOF
```

### 3️⃣ Step 2.3: Create Database Initialization Script

```bash
# Create database initialization script
cat > database/init/init.sql << 'EOF'
-- Create a sample database
CREATE DATABASE IF NOT EXISTS sampleapp;

-- Use the database
USE sampleapp;

-- Create a users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO users (username, email) VALUES 
('john_doe', 'john@example.com'),
('jane_smith', 'jane@example.com'),
('docker_user', 'docker@compose.com');

-- Create a simple view
CREATE VIEW user_count AS 
SELECT COUNT(*) as total_users FROM users;
EOF
```

### 4️⃣ Step 2.4: Create Docker Compose Configuration File

Now, let's create the main `docker-compose.yml` file:

```bash
# Create docker-compose.yml file
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  # Web Server Service
  webserver:
    image: nginx:alpine
    container_name: compose-webserver
    ports:
      - "8080:80"
    volumes:
      - ./web/html:/usr/share/nginx/html:ro
    depends_on:
      - database
    networks:
      - app-network
    restart: unless-stopped

  # Database Service
  database:
    image: mysql:8.0
    container_name: compose-database
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword123
      MYSQL_DATABASE: sampleapp
      MYSQL_USER: appuser
      MYSQL_PASSWORD: apppassword123
    ports:
      - "3306:3306"
    volumes:
      - ./database/init:/docker-entrypoint-initdb.d:ro
      - mysql-data:/var/lib/mysql
    networks:
      - app-network
    restart: unless-stopped

# Define named volumes
volumes:
  mysql-data:
    driver: local

# Define custom networks
networks:
  app-network:
    driver: bridge
EOF
```

### 5️⃣ Step 2.5: Understanding the Docker Compose File

Let's break down the key components:

- 🔢 **Version:** Specifies the Compose file format version
- 🧩 **Services:** Defines the containers that make up your application
- 💾 **Volumes:** Persistent data storage
- 🌐 **Networks:** Custom networks for service communication

**Key Configuration Elements:**
- `ports`: Maps host ports to container ports
- `volumes`: Mounts host directories or named volumes
- `environment`: Sets environment variables
- `depends_on`: Defines service dependencies
- `restart`: Container restart policy

```
# TODO: Identify which service depends on which, and why that order matters
```

---

## 🚀 Task 3: Start the Multi-Container Application

### 1️⃣ Step 3.1: Launch the Application Stack

```bash
# Start all services defined in docker-compose.yml
docker-compose up -d  # 🚀 launch the full stack

# The -d flag runs containers in detached mode (background)
```

### 2️⃣ Step 3.2: Monitor the Startup Process

```bash
# View logs from all services
docker-compose logs  # 📜 all service logs

# View logs from a specific service
docker-compose logs webserver
docker-compose logs database

# Follow logs in real-time
docker-compose logs -f  # 👀 live tail
```

### 3️⃣ Step 3.3: Verify Services are Running

```bash
# List running containers
docker-compose ps  # 📋 compose-managed containers

# Check container status
docker ps  # ✅ all running containers

# Verify network connectivity
docker network ls  # 🌐 confirm app-network exists
```

Expected Output:
```
NAME                   COMMAND                  SERVICE             STATUS              PORTS
compose-database       "docker-entrypoint.s…"   database            running             0.0.0.0:3306->3306/tcp, 33060/tcp
compose-webserver      "/docker-entrypoint.…"   webserver           running             0.0.0.0:8080->80/tcp
```

### 4️⃣ Step 3.4: Test the Application

```bash
# Test web server response
curl http://localhost:8080  # 🌐 test the web page

# Test database connectivity (from within the database container)
docker-compose exec database mysql -u appuser -papppassword123 -e "SELECT * FROM sampleapp.users;"  # 🗄️ query the DB
```

**Access the Web Application:** Open your web browser and navigate to `http://localhost:8080` to see your web page. 🌐

```
# TODO: Paste the query result confirming the sample users were seeded correctly
```

---

## 📈 Task 4: Scale Services Using Docker Compose

### 1️⃣ Step 4.1: Scale the Web Server Service

```bash
# Scale webserver to 3 instances
docker-compose up -d --scale webserver=3  # 📈 scale to 3 replicas

# Note: You'll need to modify the compose file to remove container_name 
# and use port ranges for scaling to work properly
```

### 2️⃣ Step 4.2: Create a Scalable Version

Let's create a modified version that supports scaling:

```bash
# Create a scalable version of docker-compose.yml
cat > docker-compose-scalable.yml << 'EOF'
version: '3.8'

services:
  # Load Balancer
  loadbalancer:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - webserver
    networks:
      - app-network

  # Web Server Service (scalable)
  webserver:
    image: nginx:alpine
    volumes:
      - ./web/html:/usr/share/nginx/html:ro
    depends_on:
      - database
    networks:
      - app-network
    restart: unless-stopped

  # Database Service
  database:
    image: mysql:8.0
    container_name: compose-database
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword123
      MYSQL_DATABASE: sampleapp
      MYSQL_USER: appuser
      MYSQL_PASSWORD: apppassword123
    volumes:
      - ./database/init:/docker-entrypoint-initdb.d:ro
      - mysql-data:/var/lib/mysql
    networks:
      - app-network
    restart: unless-stopped

volumes:
  mysql-data:
    driver: local

networks:
  app-network:
    driver: bridge
EOF
```

### 3️⃣ Step 4.3: Create Load Balancer Configuration

```bash
# Create nginx load balancer configuration
cat > nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream webservers {
        server webserver:80;
    }

    server {
        listen 80;
        
        location / {
            proxy_pass http://webservers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
EOF
```

### 4️⃣ Step 4.4: Scale with the New Configuration

```bash
# Stop current services
docker-compose down  # ⏹️ tear down current stack

# Start with scalable configuration
docker-compose -f docker-compose-scalable.yml up -d  # 🚀 launch scalable stack

# Scale webserver to 3 instances
docker-compose -f docker-compose-scalable.yml up -d --scale webserver=3  # 📈 scale to 3

# Verify scaling
docker-compose -f docker-compose-scalable.yml ps  # ✅ confirm 3 replicas
```

```
# TODO: Confirm all 3 webserver replicas are reachable through the load balancer
```

---

## 🗑️ Task 5: Stop and Remove Services

### 1️⃣ Step 5.1: Stop Services Gracefully

```bash
# Stop all services (containers remain)
docker-compose stop  # ⏸️ pause without removing

# Verify services are stopped
docker-compose ps  # ✅ confirm stopped state
```

### 2️⃣ Step 5.2: Start Stopped Services

```bash
# Restart stopped services
docker-compose start  # ▶️ resume all services

# Or restart specific services
docker-compose start webserver  # ▶️ resume one service
```

### 3️⃣ Step 5.3: Remove Services and Resources

```bash
# Stop and remove containers, networks
docker-compose down  # 🗑️ remove containers + networks

# Stop and remove containers, networks, and volumes
docker-compose down -v  # 🗑️ also remove volumes

# Stop and remove everything including images
docker-compose down -v --rmi all  # 💥 full teardown
```

### 4️⃣ Step 5.4: Clean Up System Resources

```bash
# Remove unused containers, networks, images
docker system prune -f  # 🧹 general cleanup

# Remove unused volumes
docker volume prune -f  # 🧹 volume cleanup

# View disk usage
docker system df  # 💾 check disk usage
```

---

## 🔬 Advanced Docker Compose Operations

### 📖 Viewing Service Information

```bash
# View service configuration
docker-compose config  # 🔬 resolved configuration

# View service logs with timestamps
docker-compose logs -t  # 🕐 timestamped logs

# Execute commands in running containers
docker-compose exec webserver sh          # ⌨️ shell into webserver
docker-compose exec database mysql -u root -p  # 🗄️ MySQL shell
```

### ⚙️ Environment-Specific Configurations

```bash
# Create environment-specific override file
cat > docker-compose.override.yml << 'EOF'
version: '3.8'

services:
  webserver:
    environment:
      - ENV=development
    ports:
      - "8081:80"
  
  database:
    environment:
      - MYSQL_ROOT_PASSWORD=devpassword123
EOF
```

---

## 🚨 Troubleshooting Common Issues

<details>
<summary>❗ Issue 1: Port Already in Use</summary>

**Problem:** Error binding to port 8080.

**Solution:**
```bash
# Check what's using the port
sudo netstat -tulpn | grep :8080

# Kill the process or change the port in docker-compose.yml
```
</details>

<details>
<summary>❗ Issue 2: Database Connection Issues</summary>

**Problem:** Web server can't connect to database.

**Solution:**
```bash
# Check if database is ready
docker-compose logs database

# Test network connectivity
docker-compose exec webserver ping database
```
</details>

<details>
<summary>❗ Issue 3: Volume Mount Issues</summary>

**Problem:** Files not appearing in container.

**Solution:**
```bash
# Check file permissions
ls -la web/html/

# Verify volume mounts
docker-compose exec webserver ls -la /usr/share/nginx/html/
```
</details>

<details>
<summary>❗ Issue 4: Service Dependencies</summary>

**Problem:** Services starting in wrong order.

**Solution:**
```bash
# Use depends_on and health checks
# Add to docker-compose.yml:
healthcheck:
  test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
  timeout: 20s
  retries: 10
```
</details>

---

## ✅ Best Practices for Docker Compose

### 1️⃣ File Organization
- 📁 Keep `docker-compose.yml` in project root
- 🗂️ Use separate directories for service-specific files
- ⚙️ Use environment-specific override files

### 2️⃣ Security Considerations
```yaml
# Use secrets for sensitive data
secrets:
  db_password:
    file: ./secrets/db_password.txt

# In service definition:
secrets:
  - db_password
```

### 3️⃣ Resource Management
```yaml
# Add resource limits
deploy:
  resources:
    limits:
      cpus: '0.5'
      memory: 512M
```

### 4️⃣ Health Checks
```yaml
# Add health checks for better reliability
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  interval: 30s
  timeout: 10s
  retries: 3
```

---

## 🧪 Lab Verification Checklist

Ensure you have completed the following:

- [ ] 🐳 Docker Compose is installed and working
- [ ] 📝 Created a multi-service `docker-compose.yml` file
- [ ] 🚀 Successfully started services with `docker-compose up`
- [ ] 🌐 Verified web application is accessible on port 8080
- [ ] 🗄️ Database service is running and accessible
- [ ] 📈 Tested service scaling capabilities
- [ ] 🗑️ Successfully stopped and removed services
- [ ] 🧹 Cleaned up system resources

---

## 🏁 Conclusion

🎉 **Congratulations!** You have successfully completed the **Docker Compose lab**.

### ✅ Key Accomplishments
- ⚙️ Installed Docker Compose and verified its functionality
- 🧩 Created a multi-container application with web server and database services
- 📝 Learned YAML configuration for defining complex application stacks
- 🎛️ Managed service lifecycles using Docker Compose commands
- 📈 Implemented service scaling for handling increased load
- 🧹 Practiced proper cleanup of containers, networks, and volumes

### 🌍 Why This Matters

Docker Compose is essential for modern application development because it:

- 🚀 **Simplifies Development:** Developers can spin up entire application stacks with a single command
- 🔁 **Ensures Consistency:** Same environment across development, testing, and production
- 🤝 **Improves Collaboration:** Team members can easily replicate complex setups
- 🧩 **Supports Microservices:** Perfect for managing distributed applications
- 🔧 **Enables DevOps Practices:** Foundation for container orchestration and CI/CD pipelines

### 🚀 Next Steps

- 🐝 Explore Docker Swarm for production orchestration
- ☸️ Learn Kubernetes for enterprise container management
- 🧩 Practice with more complex multi-service applications
- 📊 Implement monitoring and logging for containerized applications
- 🔒 Study container security best practices

This lab has provided you with fundamental skills for managing multi-container applications, which is crucial for the **Docker Certified Associate (DCA)** certification and real-world container deployments.

---

<div align="center">

### 🐳 Well done on completing the Docker Compose lab!

You're now equipped to design and orchestrate full multi-service application stacks.

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Education-blueviolet?style=for-the-badge)

</div>
