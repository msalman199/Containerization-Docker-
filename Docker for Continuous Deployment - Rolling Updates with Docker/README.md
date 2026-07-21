<div align="center">

# 🔄 Docker for Continuous Deployment — Rolling Updates with Docker

### Lab 78 · Zero-downtime deployments, monitoring, and rollback in Docker Swarm

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Swarm](https://img.shields.io/badge/Docker%20Swarm-1D63ED?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

</div>

---

## 📑 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🧭 Lab Environment Setup](#-lab-environment-setup)
- [🐳 Task 1: Deploy a Multi-Container Application in Docker Swarm](#-task-1-deploy-a-multi-container-application-in-docker-swarm)
- [🔁 Task 2: Perform a Rolling Update Using docker service update](#-task-2-perform-a-rolling-update-using-docker-service-update)
- [🟢 Task 3: Ensure Zero Downtime During Updates](#-task-3-ensure-zero-downtime-during-updates)
- [⏪ Task 4: Roll Back to Previous Version](#-task-4-roll-back-to-previous-version)
- [📊 Task 5: Monitor the Update Process](#-task-5-monitor-the-update-process)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🧹 Lab Cleanup](#-lab-cleanup)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | 🐳 Deploy a multi-container application using Docker Swarm mode |
| 2 | 🔁 Perform rolling updates on containerized services with zero downtime |
| 3 | 📊 Monitor the rolling update process and verify service availability |
| 4 | ⏪ Roll back to previous container versions when issues occur |
| 5 | 📚 Implement best practices for continuous deployment with Docker |

---

## 📋 Prerequisites

Before starting this lab, you should have:

| Requirement | Details |
|---|---|
| 🐳 Docker Fundamentals | Basic understanding of Docker containers and images |
| ⌨️ CLI Comfort | Familiarity with command-line interface (CLI) |
| 🌐 Networking Basics | Knowledge of basic networking concepts |
| 🖥️ Web App Awareness | Understanding of web applications and HTTP requests |

**⚙️ Technical Requirements:**

- 🐳 Docker Engine version 20.10 or later
- 🧩 Docker Compose version 2.0 or later
- 📝 Basic text editor (nano, vim, or similar)

---

## 🧭 Lab Environment Setup

> **💡 Ready-to-Use Cloud Machines:** Al Nafi provides pre-configured Linux-based cloud machines with Docker already installed. Simply click **Start Lab** to begin — no need to build your own virtual machine or install Docker manually.

Your lab environment includes:

- 🐧 Ubuntu 20.04 LTS with Docker Engine installed
- 🐳 Docker Swarm mode ready to initialize
- 🌐 All necessary networking configurations
- 📦 Sample application files pre-loaded

---

## 🐳 Task 1: Deploy a Multi-Container Application in Docker Swarm

### ✅ Subtask 1.1: Initialize Docker Swarm Mode

First, we'll initialize Docker Swarm mode on your machine to enable orchestration capabilities.

```bash
# 👑 Initialize Docker Swarm mode
docker swarm init

# 🩺 Verify swarm status
docker info | grep Swarm
```

**Expected Output:**

```
Swarm: active
```

### ✅ Subtask 1.2: Create Application Files

We'll create a simple web application with multiple versions to demonstrate rolling updates.

```bash
# 📁 Create project directory
mkdir ~/rolling-update-lab
cd ~/rolling-update-lab

# 📁 Create the first version of our web application
mkdir app-v1
cd app-v1
```

**Create the HTML file for version 1:**

```bash
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Rolling Update Demo</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; }
        .version { color: #2196F3; font-size: 48px; font-weight: bold; }
        .info { color: #666; font-size: 18px; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="version">Version 1.0</div>
    <div class="info">Initial Release - Blue Theme</div>
    <p>This is the first version of our application running in Docker Swarm.</p>
</body>
</html>
EOF
```

**Create Dockerfile for version 1:**

```dockerfile
# Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### ✅ Subtask 1.3: Build and Deploy Version 1

**Build the Docker image for version 1:**

```bash
# 🏗️ Build the first version
docker build -t webapp:v1.0 .

# 🔍 Verify the image was created
docker images | grep webapp
```

**Create a Docker service in swarm mode:**

```bash
# 🚀 Create a service with 3 replicas
docker service create \
  --name webapp \
  --replicas 3 \
  --publish 8080:80 \
  webapp:v1.0

# 🔍 Verify service creation
docker service ls
```

### ✅ Subtask 1.4: Verify Initial Deployment

Check that all replicas are running:

```bash
# 🔎 Check service status
docker service ps webapp

# 🧪 Test the application
curl http://localhost:8080
```

> You should see the HTML content with "Version 1.0" displayed.

---

## 🔁 Task 2: Perform a Rolling Update Using docker service update

### ✅ Subtask 2.1: Create Version 2 of the Application

Navigate back to the project directory and create version 2:

```bash
# 📁 Set up the version 2 folder
cd ~/rolling-update-lab
mkdir app-v2
cd app-v2
```

**Create the updated HTML file:**

```bash
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Rolling Update Demo</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; }
        .version { color: #4CAF50; font-size: 48px; font-weight: bold; }
        .info { color: #666; font-size: 18px; margin-top: 20px; }
        .features { background: #f0f0f0; padding: 20px; margin: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="version">Version 2.0</div>
    <div class="info">Updated Release - Green Theme</div>
    <div class="features">
        <h3>New Features:</h3>
        <ul style="text-align: left; display: inline-block;">
            <li>Enhanced UI with green theme</li>
            <li>Improved performance</li>
            <li>Better responsive design</li>
        </ul>
    </div>
    <p>This is the updated version deployed via rolling update!</p>
</body>
</html>
EOF
```

**Create Dockerfile for version 2:**

```dockerfile
# Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### ✅ Subtask 2.2: Build Version 2 Image

```bash
# 🏗️ Build version 2
docker build -t webapp:v2.0 .

# 🔍 Verify both versions exist
docker images | grep webapp
```

### ✅ Subtask 2.3: Configure Rolling Update Parameters

Before performing the update, let's configure the update parameters for controlled deployment:

```bash
# ⚙️ Configure update parameters
docker service update \
  --update-delay 10s \
  --update-parallelism 1 \
  --update-failure-action rollback \
  webapp
```

**🔧 Parameter Explanation:**

| Parameter | Purpose |
|---|---|
| `--update-delay 10s` | Wait 10 seconds between updating each replica |
| `--update-parallelism 1` | Update one replica at a time |
| `--update-failure-action rollback` | Automatically rollback if update fails |

---

## 🟢 Task 3: Ensure Zero Downtime During Updates

### ✅ Subtask 3.1: Monitor Service Before Update

Open a new terminal window to monitor the service continuously:

```bash
# 👀 In a new terminal, monitor the service
watch -n 1 'docker service ps webapp'
```

In another terminal, test continuous availability:

```bash
# 🔁 Continuous testing script
while true; do
  echo "$(date): $(curl -s http://localhost:8080 | grep -o 'Version [0-9.]*')"
  sleep 2
done
```

### ✅ Subtask 3.2: Perform the Rolling Update

In your main terminal, execute the rolling update:

```bash
# 🔁 Perform rolling update to version 2.0
docker service update --image webapp:v2.0 webapp

# 📊 Monitor the update progress
docker service ps webapp
```

### ✅ Subtask 3.3: Verify Zero Downtime

Observe the monitoring terminals:

- 👀 The `watch` command should show old replicas being replaced gradually
- 🔀 The `curl` loop should show a mix of Version 1.0 and Version 2.0 responses
- ✅ There should be no connection errors or timeouts

**Expected progression:**

```
2024-01-15 10:30:01: Version 1.0
2024-01-15 10:30:03: Version 1.0
2024-01-15 10:30:05: Version 2.0
2024-01-15 10:30:07: Version 1.0
2024-01-15 10:30:09: Version 2.0
2024-01-15 10:30:11: Version 2.0
```

---

## ⏪ Task 4: Roll Back to Previous Version

### ✅ Subtask 4.1: Simulate a Problem with Version 2

Let's create a problematic version 3 to demonstrate rollback:

```bash
# 📁 Set up the broken version 3 folder
cd ~/rolling-update-lab
mkdir app-v3
cd app-v3

# 💥 Create a broken version (returns 500 error)
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Broken Version</title>
</head>
<body>
    <h1>Version 3.0 - BROKEN!</h1>
    <script>
        // This will cause issues
        throw new Error("Simulated application error");
    </script>
</body>
</html>
EOF

cat > Dockerfile << 'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
# Simulate a configuration error
RUN echo "error_page 404 /50x.html;" >> /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF
```

Build the problematic version:

```bash
# 🏗️ Build the intentionally broken image
docker build -t webapp:v3.0 .
```

### ✅ Subtask 4.2: Deploy Problematic Version

```bash
# ⚠️ Update to the problematic version
docker service update --image webapp:v3.0 webapp

# 📊 Monitor the deployment
docker service ps webapp
```

### ✅ Subtask 4.3: Perform Rollback

When you notice issues (JavaScript errors in browser), perform a rollback:

```bash
# ⏪ Rollback to previous version
docker service rollback webapp

# 🔍 Verify rollback status
docker service ps webapp

# ✅ Check that we're back to version 2.0
curl http://localhost:8080 | grep "Version"
```

### ✅ Subtask 4.4: Manual Rollback to Specific Version

You can also rollback to a specific version:

```bash
# ⏪ Rollback to version 1.0 specifically
docker service update --image webapp:v1.0 webapp

# 🔍 Verify the rollback
curl http://localhost:8080 | grep "Version"
```

---

## 📊 Task 5: Monitor the Update Process

### ✅ Subtask 5.1: Create Monitoring Scripts

Create a comprehensive monitoring script:

```bash
cd ~/rolling-update-lab

cat > monitor-update.sh << 'EOF'
#!/bin/bash

echo "=== Docker Service Update Monitor ==="
echo "Starting monitoring at $(date)"
echo "======================================"

# Function to check service status
check_service_status() {
    echo -e "\n--- Service Status ---"
    docker service ls
    
    echo -e "\n--- Service Tasks ---"
    docker service ps webapp --no-trunc
    
    echo -e "\n--- Service Details ---"
    docker service inspect webapp --format '{{.Spec.TaskTemplate.ContainerSpec.Image}}'
}

# Function to test application availability
test_availability() {
    echo -e "\n--- Availability Test ---"
    for i in {1..5}; do
        response=$(curl -s -w "%{http_code}" http://localhost:8080 -o /dev/null)
        if [ "$response" = "200" ]; then
            version=$(curl -s http://localhost:8080 | grep -o 'Version [0-9.]*' | head -1)
            echo "Test $i: SUCCESS - $version"
        else
            echo "Test $i: FAILED - HTTP $response"
        fi
        sleep 1
    done
}

# Main monitoring loop
while true; do
    clear
    echo "=== Update Monitor - $(date) ==="
    check_service_status
    test_availability
    echo -e "\n--- Press Ctrl+C to stop monitoring ---"
    sleep 10
done
EOF

# 🔓 Make it executable
chmod +x monitor-update.sh
```

### ✅ Subtask 5.2: Use Docker Service Logs

Monitor service logs during updates:

```bash
# 📜 Follow service logs
docker service logs -f webapp

# 📜 In another terminal, check individual container logs
docker ps | grep webapp
docker logs -f <container_id>
```

### ✅ Subtask 5.3: Health Check Implementation

Create a version with health checks:

```bash
# 📁 Set up the health-check version folder
cd ~/rolling-update-lab
mkdir app-v4-health
cd app-v4-health

cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Health Check Version</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; }
        .version { color: #FF5722; font-size: 48px; font-weight: bold; }
        .health { color: #4CAF50; font-size: 24px; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="version">Version 4.0</div>
    <div class="health">✓ Health Check Enabled</div>
    <p>This version includes health monitoring for safer deployments.</p>
</body>
</html>
EOF

cat > health.html << 'EOF'
{
  "status": "healthy",
  "version": "4.0",
  "timestamp": "2024-01-15T10:30:00Z"
}
EOF
```

```dockerfile
# Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
COPY health.html /usr/share/nginx/html/health
EXPOSE 80

# 🩺 Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/health || exit 1

CMD ["nginx", "-g", "daemon off;"]
```

Build and deploy with health checks:

```bash
# 🏗️ Build the health-check-enabled image
docker build -t webapp:v4.0 .

# 🚀 Update service with health check awareness
docker service update \
  --image webapp:v4.0 \
  --health-cmd "curl -f http://localhost/health || exit 1" \
  --health-interval 30s \
  --health-timeout 3s \
  --health-retries 3 \
  webapp
```

### ✅ Subtask 5.4: Advanced Monitoring Commands

Use these commands to get detailed monitoring information:

```bash
# 🔎 Get detailed service information
docker service inspect webapp --pretty

# 📊 Monitor resource usage
docker stats $(docker ps -q --filter "label=com.docker.swarm.service.name=webapp")

# 📅 Check service events
docker system events --filter service=webapp

# 📜 Get service update history
docker service ps webapp --format "table {{.ID}}\t{{.Name}}\t{{.Image}}\t{{.CurrentState}}\t{{.Error}}"
```

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>⚠️ Issue 1: Update Stuck or Failing</summary>

```bash
# 🔎 Check service status
docker service ps webapp

# 🔁 Force remove failed tasks
docker service update --force webapp

# 📜 Check Docker daemon logs
sudo journalctl -u docker.service -f
```

</details>

<details>
<summary>⚠️ Issue 2: Port Already in Use</summary>

```bash
# 🔎 Check what's using the port
sudo netstat -tulpn | grep :8080

# 🛑 Kill process using the port
sudo kill -9 <process_id>

# 🔀 Or use a different port
docker service update --publish-rm 8080:80 --publish-add 8081:80 webapp
```

</details>

<details>
<summary>⚠️ Issue 3: Image Pull Failures</summary>

```bash
# 🔎 Check image availability
docker images | grep webapp

# ⬇️ Manually pull image
docker pull webapp:v2.0

# 🌐 Check Docker Hub connectivity
docker search nginx
```

</details>

---

## 🧹 Lab Cleanup

When you're finished with the lab, clean up the resources:

```bash
# 🗑️ Remove the service
docker service rm webapp

# 🚪 Leave swarm mode
docker swarm leave --force

# 🗑️ Remove images
docker rmi webapp:v1.0 webapp:v2.0 webapp:v3.0 webapp:v4.0

# 🧹 Clean up project directory
rm -rf ~/rolling-update-lab
```

---

## 🏁 Conclusion

Congratulations! You have successfully completed **Lab 78: Docker for Continuous Deployment - Rolling Updates**. In this lab, you accomplished the following:

### 🏆 Key Achievements

| Achievement | Description |
|---|---|
| 🐳 Deployed Multi-Container Applications | Used Docker Swarm mode to orchestrate multiple container replicas, providing high availability and load distribution |
| 🔁 Mastered Rolling Updates | Successfully performed zero-downtime updates by gradually replacing old containers with new versions |
| 📊 Implemented Monitoring | Created comprehensive monitoring solutions to track update progress, service health, and application availability |
| ⏪ Practiced Rollback Procedures | Learned how to quickly recover from problematic deployments by rolling back to previous stable versions |
| ✅ Applied Best Practices | Implemented proper update configurations including delays, parallelism controls, and health checks |

### 🌍 Why This Matters

Rolling updates are crucial for modern application deployment because they:

- 🟢 **Eliminate Downtime** — Users experience no service interruption during updates
- 🛡️ **Reduce Risk** — Gradual deployment allows early detection of issues
- ⏪ **Enable Rapid Recovery** — Quick rollback capabilities minimize impact of problems
- 🔄 **Support Continuous Delivery** — Automated, reliable deployment processes enable frequent releases
- 😊 **Improve User Experience** — Seamless updates maintain service quality and availability

### 🏗️ Real-World Applications

The skills you've learned apply directly to:

- 🛒 **Production Web Applications** — E-commerce sites, social media platforms, and web services
- 🧩 **Microservices Architecture** — Independent service updates in complex systems
- ⚙️ **DevOps Pipelines** — Automated deployment processes in CI/CD workflows
- ☁️ **Cloud-Native Applications** — Container orchestration in Kubernetes and other platforms

### 🔭 Next Steps

To further develop your continuous deployment skills, consider exploring:

- 🔐 Advanced Docker Swarm features like secrets and configs management
- 🔗 Integration with CI/CD tools like Jenkins, GitLab CI, or GitHub Actions
- ☸️ Kubernetes deployment strategies and rolling updates
- 🔵🟢 Blue-green deployment patterns for even safer updates
- 📈 Monitoring and observability tools for production environments

> You now have the foundational knowledge to implement reliable, zero-downtime deployment strategies using Docker in production environments. These skills are essential for maintaining robust, continuously updated applications in modern software development workflows.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1a1a2e?style=for-the-badge)

</div>
