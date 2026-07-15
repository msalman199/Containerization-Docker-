<div align="center">

# 💾 Docker Volumes for Persistent Storage

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![DCA](https://img.shields.io/badge/DCA-Certification%20Aligned-blue?style=for-the-badge)
![Level](https://img.shields.io/badge/Level-Intermediate-brightgreen?style=for-the-badge)

**A hands-on lab covering Docker volumes, persistent storage, and data survival across container lifecycles**

</div>

---

## 📚 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [📦 Task 1: Understanding Container Storage vs Persistent Volumes](#-task-1-understanding-container-storage-vs-persistent-volumes)
- [🆕 Task 2: Creating Docker Volumes](#-task-2-creating-docker-volumes)
- [🔗 Task 3: Using Volumes with Containers](#-task-3-using-volumes-with-containers)
- [🔬 Task 4: Inspecting and Managing Volumes](#-task-4-inspecting-and-managing-volumes)
- [🔄 Task 5: Demonstrating Data Persistence Across Container Restarts](#-task-5-demonstrating-data-persistence-across-container-restarts)
- [🚨 Troubleshooting Common Issues](#-troubleshooting-common-issues)
- [🧹 Lab Cleanup](#-lab-cleanup)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | ⚖️ Understand the fundamental difference between container storage and persistent volumes |
| 2 | 🆕 Create and manage Docker volumes using command-line tools |
| 3 | 🔗 Mount volumes to containers for persistent data storage |
| 4 | 🔬 Inspect volume properties and metadata |
| 5 | 🗑️ Remove volumes safely from your Docker environment |
| 6 | 🔄 Demonstrate how data persists across container lifecycle events |
| 7 | ✅ Apply volume management best practices for real-world applications |

---

## ✅ Prerequisites

| Requirement | Status |
|---|---|
| Basic understanding of Docker containers and images | Required |
| Familiarity with Linux command-line interface | Required |
| Knowledge of basic file system operations | Required |
| Completion of previous Docker labs or equivalent experience | Required |
| Understanding of container lifecycle (create, start, stop, remove) | Required |

---

## 🖥️ Lab Environment Setup

> **☁️ Ready-to-Use Cloud Machines:** Al Nafi provides pre-configured Linux-based cloud machines with Docker already installed. Simply click **Start Lab** to access your environment — no need to build your own virtual machine or install Docker manually.

**Your lab environment includes:**

- 🐧 Ubuntu Linux with Docker Engine installed
- 🔑 Command-line access with sudo privileges
- 🧰 All necessary tools and utilities pre-installed

---

## 📦 Task 1: Understanding Container Storage vs Persistent Volumes

### 1️⃣ Subtask 1.1: Explore Container Storage Behavior

First, let's understand how container storage works by default and why we need persistent volumes.

**Step 1:** Create a simple container with temporary data
```bash
# Run a container and create some data inside it
docker run -it --name temp-container ubuntu:20.04 bash  # 🆕 interactive container
```

**Step 2:** Inside the container, create a test file
```bash
# Inside the container shell
echo "This is temporary data" > /tmp/test-file.txt  # 📝 write test file
cat /tmp/test-file.txt                                # 👀 confirm content
ls -la /tmp/                                          # 📂 list directory
exit                                                   # 🚪 leave the shell
```

**Step 3:** Remove the container and observe data loss
```bash
# Remove the container
docker rm temp-container  # 🗑️ delete the container

# Try to run the same container again
docker run -it --name temp-container2 ubuntu:20.04 bash  # 🆕 fresh container
```

**Step 4:** Check if the data still exists
```bash
# Inside the new container
ls -la /tmp/                     # 📂 file is gone
cat /tmp/test-file.txt           # ❌ this will fail - file doesn't exist
exit                              # 🚪 leave the shell
```

**Step 5:** Clean up
```bash
docker rm temp-container2  # 🗑️ remove the container
```

### 2️⃣ Subtask 1.2: Understanding the Problem

The data created in the previous steps disappeared because:

- 💨 **Container Storage:** Data stored inside a container's filesystem is ephemeral
- 🔄 **Container Lifecycle:** When a container is removed, all data inside it is lost
- 🚫 **No Persistence:** There's no way to recover the data once the container is deleted

This is where **Docker Volumes** come to the rescue! 🦸

---

## 🆕 Task 2: Creating Docker Volumes

### 1️⃣ Subtask 2.1: Create Your First Docker Volume

**Step 1:** List existing volumes
```bash
docker volume ls  # 📋 check current volumes
```

**Step 2:** Create a new volume
```bash
docker volume create my-persistent-data  # 🆕 create a named volume
```

**Step 3:** Verify volume creation
```bash
docker volume ls  # ✅ confirm the new volume appears
```

**Step 4:** Get detailed information about the volume
```bash
docker volume inspect my-persistent-data  # 🔬 view volume metadata
```

### 2️⃣ Subtask 2.2: Understanding Volume Properties

The `docker volume inspect` command shows important information:

- 🔌 **Driver:** Usually `local` for standard volumes
- 📍 **Mountpoint:** Physical location on the host system
- 🏷️ **Name:** The volume identifier
- ⚙️ **Options:** Configuration settings
- 🌐 **Scope:** Availability scope (local or global)

### 3️⃣ Subtask 2.3: Create Multiple Volumes

**Step 1:** Create additional volumes for different purposes
```bash
# Create a volume for database data
docker volume create database-data  # 🗄️ database volume

# Create a volume for application logs
docker volume create app-logs        # 📜 logs volume

# Create a volume for configuration files
docker volume create app-config      # ⚙️ config volume
```

**Step 2:** List all volumes
```bash
docker volume ls  # 📋 confirm all volumes exist
```

---

## 🔗 Task 3: Using Volumes with Containers

### 1️⃣ Subtask 3.1: Mount a Volume to a Container

**Step 1:** Run a container with a mounted volume
```bash
# Run Ubuntu container with volume mounted to /data directory
docker run -it --name persistent-container -v my-persistent-data:/data ubuntu:20.04 bash  # 🔗 mount volume
```

**Step 2:** Create data in the mounted volume
```bash
# Inside the container
cd /data
echo "This data will persist!" > persistent-file.txt   # 📝 write data
echo "Container ID: $(hostname)" >> persistent-file.txt
date >> persistent-file.txt
ls -la
cat persistent-file.txt
exit  # 🚪 leave the shell
```

**Step 3:** Remove the container
```bash
docker rm persistent-container  # 🗑️ delete the container
```

**Step 4:** Create a new container with the same volume
```bash
# Mount the same volume to a new container
docker run -it --name new-persistent-container -v my-persistent-data:/data ubuntu:20.04 bash  # 🔗 reuse the volume
```

**Step 5:** Verify data persistence
```bash
# Inside the new container
cd /data
ls -la
cat persistent-file.txt  # ✅ the data is still there!
exit                       # 🚪 leave the shell
```

### 2️⃣ Subtask 3.2: Working with Multiple Volumes

**Step 1:** Run a container with multiple volumes
```bash
# Run container with multiple volume mounts
docker run -it --name multi-volume-container \
  -v database-data:/var/lib/database \
  -v app-logs:/var/log/app \
  -v app-config:/etc/app \
  ubuntu:20.04 bash  # 🔗 mount three volumes at once
```

**Step 2:** Create data in different volumes
```bash
# Inside the container
# Create database data
mkdir -p /var/lib/database
echo "user_data=sample" > /var/lib/database/users.db  # 🗄️ db data

# Create log data
mkdir -p /var/log/app
echo "$(date): Application started" > /var/log/app/app.log  # 📜 log entry

# Create configuration data
mkdir -p /etc/app
echo "debug=true" > /etc/app/config.ini    # ⚙️ config entry
echo "port=8080" >> /etc/app/config.ini

# Verify all data
ls -la /var/lib/database/
ls -la /var/log/app/
ls -la /etc/app/
exit  # 🚪 leave the shell
```

**Step 3:** Clean up the container
```bash
docker rm multi-volume-container  # 🗑️ remove the container
```

### 3️⃣ Subtask 3.3: Using Volumes with Real Applications

**Step 1:** Run a web server with persistent storage
```bash
# Run nginx with a volume for web content
docker run -d --name web-server \
  -v my-persistent-data:/usr/share/nginx/html \
  -p 8080:80 \
  nginx:alpine  # 🌐 nginx with persistent content
```

**Step 2:** Add content to the volume
```bash
# Run a temporary container to add content
docker run --rm -v my-persistent-data:/data ubuntu:20.04 \
  bash -c "echo '<h1>Hello from Persistent Volume!</h1>' > /data/index.html"  # 📝 write HTML content
```

**Step 3:** Test the web server
```bash
# Check if the web server is running
curl http://localhost:8080  # 🌐 verify content served
```

**Step 4:** Restart the web server container
```bash
# Stop and remove the container
docker stop web-server
docker rm web-server

# Start a new web server container with the same volume
docker run -d --name web-server-new \
  -v my-persistent-data:/usr/share/nginx/html \
  -p 8080:80 \
  nginx:alpine  # 🔄 new container, same data
```

**Step 5:** Verify content persistence
```bash
# The content should still be there
curl http://localhost:8080  # ✅ content survived the restart
```

**Step 6:** Clean up
```bash
docker stop web-server-new
docker rm web-server-new  # 🗑️ remove the container
```

```
# TODO: Note what happened to the web content after the container was recreated
```

---

## 🔬 Task 4: Inspecting and Managing Volumes

### 1️⃣ Subtask 4.1: Volume Inspection Commands

**Step 1:** Inspect volume details
```bash
# Get detailed information about a specific volume
docker volume inspect my-persistent-data  # 🔬 full metadata
```

**Step 2:** Check volume usage
```bash
# List all volumes with their drivers
docker volume ls  # 📋 list all volumes

# Get volume information in different formats
docker volume inspect my-persistent-data --format '{{.Mountpoint}}'  # 📍 mountpoint only
docker volume inspect my-persistent-data --format '{{.Driver}}'      # 🔌 driver only
```

**Step 3:** Explore volume contents from host
```bash
# Find the volume mountpoint
VOLUME_PATH=$(docker volume inspect my-persistent-data --format '{{.Mountpoint}}')
echo "Volume is mounted at: $VOLUME_PATH"  # 📍 print path

# List contents (requires sudo on most systems)
sudo ls -la $VOLUME_PATH                       # 📂 list host-side contents
sudo cat $VOLUME_PATH/persistent-file.txt      # 👀 view file directly from host
```

### 2️⃣ Subtask 4.2: Volume Cleanup and Removal

**Step 1:** Remove unused volumes
```bash
# Remove volumes that are not being used by any container
docker volume prune  # 🧹 clean up unused volumes
```

**Step 2:** Remove specific volumes
```bash
# Remove a specific volume (only works if no containers are using it)
docker volume rm app-logs  # 🗑️ remove named volume
```

**Step 3:** Force remove volumes
```bash
# If you need to remove a volume that might be in use
# First, stop and remove any containers using it
docker ps -a  # 🔎 check for containers using the volume

# Then remove the volume
docker volume rm app-config  # 🗑️ remove named volume
```

**Step 4:** Remove multiple volumes
```bash
# Remove multiple volumes at once
docker volume rm database-data  # 🗑️ remove named volume
```

### 3️⃣ Subtask 4.3: Volume Backup and Restore

**Step 1:** Create a backup of volume data
```bash
# Create a backup using a temporary container
docker run --rm -v my-persistent-data:/data -v $(pwd):/backup ubuntu:20.04 \
  tar czf /backup/volume-backup.tar.gz -C /data .  # 📦 archive volume data
```

**Step 2:** Verify backup creation
```bash
ls -la volume-backup.tar.gz  # ✅ confirm backup file exists
```

**Step 3:** Create a new volume and restore data
```bash
# Create a new volume
docker volume create restored-volume  # 🆕 target volume

# Restore data to the new volume
docker run --rm -v restored-volume:/data -v $(pwd):/backup ubuntu:20.04 \
  bash -c "cd /data && tar xzf /backup/volume-backup.tar.gz"  # ♻️ extract backup
```

**Step 4:** Verify restored data
```bash
# Check the restored data
docker run --rm -v restored-volume:/data ubuntu:20.04 \
  bash -c "ls -la /data && cat /data/persistent-file.txt"  # ✅ confirm restore
```

```
# TODO: Confirm the restored file matches the original backup contents
```

---

## 🔄 Task 5: Demonstrating Data Persistence Across Container Restarts

### 1️⃣ Subtask 5.1: Database Persistence Example

**Step 1:** Run a MySQL database with persistent storage
```bash
# Create a volume for MySQL data
docker volume create mysql-data  # 🗄️ MySQL data volume

# Run MySQL container with persistent volume
docker run -d --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=mypassword \
  -e MYSQL_DATABASE=testdb \
  -v mysql-data:/var/lib/mysql \
  mysql:8.0  # 🐬 MySQL with persistent storage
```

**Step 2:** Wait for MySQL to initialize and connect
```bash
# Wait a moment for MySQL to start
sleep 30  # ⏳ allow MySQL to initialize

# Connect to MySQL and create some data
docker exec -it mysql-db mysql -uroot -pmypassword testdb  # 🔌 connect to DB
```

**Step 3:** Create a table and insert data
```sql
-- Inside MySQL shell
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO users (name, email) VALUES 
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com');

SELECT * FROM users;
exit
```

**Step 4:** Stop and remove the MySQL container
```bash
docker stop mysql-db
docker rm mysql-db  # 🗑️ remove the container
```

**Step 5:** Start a new MySQL container with the same volume
```bash
# Start new MySQL container with the same data volume
docker run -d --name mysql-db-new \
  -e MYSQL_ROOT_PASSWORD=mypassword \
  -e MYSQL_DATABASE=testdb \
  -v mysql-data:/var/lib/mysql \
  mysql:8.0  # 🔄 new container, same volume
```

**Step 6:** Verify data persistence
```bash
# Wait for MySQL to start
sleep 30  # ⏳ allow MySQL to initialize

# Connect and check if data is still there
docker exec -it mysql-db-new mysql -uroot -pmypassword testdb
-- Inside MySQL shell
SELECT * FROM users;
-- Your data should still be there! ✅
exit
```

### 2️⃣ Subtask 5.2: Application Log Persistence

**Step 1:** Create a logging application
```bash
# Create a volume for logs
docker volume create app-logs-demo  # 📜 logs volume

# Run a container that generates logs
docker run -d --name log-generator \
  -v app-logs-demo:/var/log/app \
  ubuntu:20.04 \
  bash -c "while true; do echo \$(date): Log entry >> /var/log/app/application.log; sleep 5; done"  # 🔁 continuous logging
```

**Step 2:** Monitor log generation
```bash
# Check logs being generated
docker exec log-generator tail -f /var/log/app/application.log  # 👀 live tail
# Press Ctrl+C to stop monitoring
```

**Step 3:** Restart the logging container
```bash
# Stop and remove the container
docker stop log-generator
docker rm log-generator

# Start a new container with the same volume
docker run -d --name log-generator-new \
  -v app-logs-demo:/var/log/app \
  ubuntu:20.04 \
  bash -c "while true; do echo \$(date): New container log >> /var/log/app/application.log; sleep 5; done"  # 🔄 fresh container, same logs
```

**Step 4:** Verify log persistence and continuation
```bash
# Check that old logs are preserved and new ones are being added
docker exec log-generator-new cat /var/log/app/application.log  # ✅ full log history intact
```

### 3️⃣ Subtask 5.3: Configuration Persistence

**Step 1:** Create a configuration volume
```bash
# Create volume for configuration
docker volume create app-config-demo  # ⚙️ config volume

# Create initial configuration
docker run --rm -v app-config-demo:/config ubuntu:20.04 \
  bash -c "echo 'server_port=8080' > /config/app.conf && echo 'debug_mode=true' >> /config/app.conf"  # 📝 write config
```

**Step 2:** Run application with configuration
```bash
# Run application that reads configuration
docker run -d --name config-app \
  -v app-config-demo:/etc/app \
  ubuntu:20.04 \
  bash -c "while true; do echo 'Reading config:'; cat /etc/app/app.conf; sleep 10; done"  # 🔁 poll config
```

**Step 3:** Monitor application
```bash
# Check application output
docker logs config-app  # 👀 view container logs
```

**Step 4:** Update configuration
```bash
# Update configuration while app is running
docker run --rm -v app-config-demo:/config ubuntu:20.04 \
  bash -c "echo 'server_port=9090' > /config/app.conf && echo 'debug_mode=false' >> /config/app.conf"  # ✏️ update config
```

**Step 5:** Restart application and verify persistence
```bash
# Restart the application
docker stop config-app
docker rm config-app

docker run -d --name config-app-new \
  -v app-config-demo:/etc/app \
  ubuntu:20.04 \
  bash -c "while true; do echo 'Reading config:'; cat /etc/app/app.conf; sleep 10; done"  # 🔄 fresh container, updated config

# Check that updated configuration persisted
docker logs config-app-new  # ✅ confirm new settings applied
```

```
# TODO: Compare the config values before and after the update to confirm persistence
```

---

## 🚨 Troubleshooting Common Issues

<details>
<summary>❗ Issue 1: Volume Mount Permission Problems</summary>

**Problem:** Permission denied when accessing volume data.

**Solution:**
```bash
# Check volume permissions
docker run --rm -v my-persistent-data:/data ubuntu:20.04 ls -la /data

# Fix permissions if needed
docker run --rm -v my-persistent-data:/data ubuntu:20.04 chmod 755 /data
```
</details>

<details>
<summary>❗ Issue 2: Volume Not Found Error</summary>

**Problem:** Error mounting volume that doesn't exist.

**Solution:**
```bash
# Create the volume first
docker volume create missing-volume

# Then use it with containers
docker run -v missing-volume:/data ubuntu:20.04
```
</details>

<details>
<summary>❗ Issue 3: Cannot Remove Volume</summary>

**Problem:** Volume is in use by container.

**Solution:**
```bash
# Find containers using the volume
docker ps -a --filter volume=my-persistent-data

# Stop and remove containers first
docker stop container-name
docker rm container-name

# Then remove the volume
docker volume rm my-persistent-data
```
</details>

---

## 🧹 Lab Cleanup

**Step 1:** Stop all running containers
```bash
# Stop all containers created in this lab
docker stop $(docker ps -q) 2>/dev/null || true  # ⏹️ stop everything running
```

**Step 2:** Remove all containers
```bash
# Remove all containers
docker rm $(docker ps -aq) 2>/dev/null || true  # 🗑️ remove everything
```

**Step 3:** Remove volumes (optional)
```bash
# List all volumes
docker volume ls  # 📋 review before deleting

# Remove specific volumes created in this lab
docker volume rm my-persistent-data mysql-data app-logs-demo app-config-demo restored-volume 2>/dev/null || true

# Or remove all unused volumes
docker volume prune -f  # 🧹 aggressive cleanup
```

**Step 4:** Clean up backup files
```bash
# Remove backup file created during the lab
rm -f volume-backup.tar.gz  # 🗑️ remove local backup archive
```

---

## 🏁 Conclusion

🎉 **Congratulations!** You have successfully completed **Lab 5: Docker Volumes for Persistent Storage**.

### ✅ Key Achievements
- 📦 **Understanding Storage Concepts:** You learned the critical difference between ephemeral container storage and persistent volumes, understanding why data disappears when containers are removed and how volumes solve this problem
- 🆕 **Volume Management Skills:** You mastered creating, inspecting, and removing Docker volumes using command-line tools, gaining practical experience with volume lifecycle management
- 🔗 **Practical Implementation:** You successfully mounted volumes to containers, demonstrating how to persist data across container restarts and removals
- 🌍 **Real-World Applications:** You worked with practical examples including web servers, databases, and logging applications, showing how volumes are used in production environments
- ✅ **Data Persistence Verification:** You proved that data stored in volumes survives container lifecycle events, ensuring business continuity and data integrity

### 🌍 Why This Matters

- 🚀 **Production Readiness:** Understanding persistent storage is crucial for deploying applications in production environments where data loss is unacceptable
- 🎓 **Docker Certified Associate (DCA) Preparation:** The skills you've learned directly align with DCA certification requirements, particularly in the area of storage and volumes
- 🔧 **DevOps Best Practices:** Volume management is a fundamental skill for DevOps engineers working with containerized applications
- 📈 **Scalability Foundation:** Persistent storage knowledge is essential for building scalable, stateful applications in containerized environments

### 🚀 Next Steps

With this foundation in Docker volumes, you're now prepared to:

- 🔌 Explore advanced volume drivers and plugins
- 💾 Implement backup and disaster recovery strategies
- ☸️ Work with container orchestration platforms like Docker Swarm or Kubernetes
- 🏗️ Design persistent storage solutions for complex multi-container applications

The persistent storage concepts you've mastered in this lab form the backbone of reliable containerized applications and are essential for your continued journey in container technology and DevOps practices.

---

<div align="center">

### 🐳 Well done on completing Lab 5!

You've mastered one of the most critical skills for real-world containerized applications.

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Education-blueviolet?style=for-the-badge)

</div>
