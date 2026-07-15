<div align="center">

# 📝 Writing a Simple Dockerfile

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![DCA](https://img.shields.io/badge/DCA-Certification%20Aligned-blue?style=for-the-badge)
![Level](https://img.shields.io/badge/Level-Intermediate-brightgreen?style=for-the-badge)

**A hands-on lab building custom Docker images from a Dockerfile, with environment variables and best practices**

</div>

---

## 📚 Table of Contents

- [🎯 Objectives](#-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🐍 Task 1: Create a Simple Dockerfile for a Python App](#-task-1-create-a-simple-dockerfile-for-a-python-app)
- [🏗️ Task 2: Build the Image Using docker build](#️-task-2-build-the-image-using-docker-build)
- [🚀 Task 3: Run a Container from the Custom Image](#-task-3-run-a-container-from-the-custom-image)
- [🔧 Task 4: Modify the Dockerfile to Add Environment Variables](#-task-4-modify-the-dockerfile-to-add-environment-variables)
- [🏗️ Task 5: Build and Run the Modified Image](#️-task-5-build-and-run-the-modified-image)
- [🚨 Troubleshooting Common Issues](#-troubleshooting-common-issues)
- [✅ Best Practices Learned](#-best-practices-learned)
- [🧹 Cleanup](#-cleanup)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | 📝 Understand the purpose and structure of a Dockerfile |
| 2 | 🐍 Create a simple Dockerfile for a Python application |
| 3 | 🏗️ Build custom Docker images using the `docker build` command |
| 4 | 🚀 Run containers from custom-built images |
| 5 | 🔧 Implement environment variables in Dockerfiles |
| 6 | 🔄 Modify and rebuild Docker images with updated configurations |
| 7 | ✅ Apply best practices for writing efficient Dockerfiles |

---

## ✅ Prerequisites

| Requirement | Status |
|---|---|
| Basic understanding of Docker concepts (containers, images) | Required |
| Familiarity with command-line interface (CLI) | Required |
| Basic knowledge of Python programming | Required |
| Understanding of text editors (nano, vim, or any preferred editor) | Required |
| Completion of previous Docker labs covering basic container operations | Required |

---

## 🖥️ Lab Environment Setup

> **☁️ Ready-to-Use Cloud Machines:** Al Nafi provides pre-configured Linux-based cloud machines with Docker already installed. Simply click **Start Lab** to access your environment — no need to build your own VM or install Docker manually.

**Your lab environment includes:**

- 🐧 Ubuntu Linux machine
- 🐳 Docker Engine pre-installed
- ✏️ Text editors (nano, vim)
- 🐍 Python runtime environment
- 🔑 All necessary permissions configured

---

## 🐍 Task 1: Create a Simple Dockerfile for a Python App

### 1️⃣ Subtask 1.1: Create the Project Directory Structure

First, let's create an organized directory structure for our Python application.

```bash
# Create a new directory for our Docker project
mkdir ~/docker-python-app  # 📁 project root

# Navigate to the project directory
cd ~/docker-python-app

# Create a subdirectory for our Python application
mkdir app  # 📁 app source folder

# Verify the directory structure
ls -la  # 👀 confirm structure
```

### 2️⃣ Subtask 1.2: Create a Simple Python Application

Now we'll create a basic Python web application that we can containerize.

```bash
# Navigate to the app directory
cd app

# Create a simple Python web application using nano editor
nano app.py  # ✏️ open editor
```

Copy and paste the following Python code into the file:

```python
#!/usr/bin/env python3

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        
        response_data = {
            "message": "Hello from Dockerized Python App!",
            "status": "success",
            "container_info": {
                "hostname": os.environ.get('HOSTNAME', 'unknown'),
                "python_version": "3.x"
            }
        }
        
        self.wfile.write(json.dumps(response_data, indent=2).encode())

def run_server():
    port = int(os.environ.get('PORT', 8080))
    server = HTTPServer(('0.0.0.0', port), SimpleHandler)
    print(f"Starting server on port {port}...")
    print(f"Access the application at http://localhost:{port}")
    server.serve_forever()

if __name__ == '__main__':
    run_server()
```

Save and exit the editor (in nano: `Ctrl+X`, then `Y`, then `Enter`). 💾

### 3️⃣ Subtask 1.3: Create a Requirements File

Create a `requirements.txt` file for Python dependencies:

```bash
# Create requirements file (even though our app doesn't need external packages)
nano requirements.txt  # ✏️ open editor
```

Add the following content:

```
# No external dependencies required for this simple app
# This file is included as a best practice for Python projects
```

Save and exit the editor. 💾

### 4️⃣ Subtask 1.4: Write the Dockerfile

Now let's create our first Dockerfile:

```bash
# Navigate back to the project root directory
cd ~/docker-python-app

# Create the Dockerfile
nano Dockerfile  # ✏️ open editor
```

Add the following content to create a comprehensive Dockerfile:

```dockerfile
# Use official Python runtime as base image
FROM python:3.11-slim

# Set metadata for the image
LABEL maintainer="student@alnafi.com"
LABEL description="Simple Python web application for Docker learning"
LABEL version="1.0"

# Set working directory inside the container
WORKDIR /usr/src/app

# Copy requirements file first (for better layer caching)
COPY app/requirements.txt ./

# Install Python dependencies (if any)
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app/ .

# Make the Python script executable
RUN chmod +x app.py

# Expose the port the app runs on
EXPOSE 8080

# Define the command to run the application
CMD ["python", "app.py"]
```

Save and exit the editor. 💾

### 5️⃣ Subtask 1.5: Verify Project Structure

Let's verify our project structure is correct:

```bash
# Check the overall project structure
tree ~/docker-python-app  # 🌳 visualize structure
```

If `tree` is not available, use:

```bash
# Alternative way to view structure
find ~/docker-python-app -type f -exec ls -la {} \;  # 🔎 list all files
```

Expected structure:
```
docker-python-app/
├── Dockerfile
└── app/
    ├── app.py
    └── requirements.txt
```

```
# TODO: Confirm your directory structure matches the expected layout above
```

---

## 🏗️ Task 2: Build the Image Using docker build

### 1️⃣ Subtask 2.1: Build the Docker Image

Now let's build our custom Docker image:

```bash
# Ensure you're in the project root directory
cd ~/docker-python-app

# Build the Docker image with a custom tag
docker build -t myimage .  # 🏗️ build the image
```

**Understanding the command:**
- `docker build`: Command to build a Docker image
- `-t myimage`: Tags the image with the name "myimage"
- `.`: Specifies the build context (current directory)

### 2️⃣ Subtask 2.2: Monitor the Build Process

Watch the build output carefully. You should see steps like:

```
Step 1/8 : FROM python:3.11-slim
Step 2/8 : LABEL maintainer="student@alnafi.com"
Step 3/8 : LABEL description="Simple Python web application for Docker learning"
...
Successfully built [image-id]
Successfully tagged myimage:latest
```

### 3️⃣ Subtask 2.3: Verify the Image was Created

Check that your image was successfully built:

```bash
# List all Docker images
docker images  # 📋 list all images

# Look specifically for your image
docker images myimage  # 🔎 filter by name
```

You should see output similar to:
```
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
myimage      latest    abc123def456   2 minutes ago   125MB
```

### 4️⃣ Subtask 2.4: Inspect the Image Details

Get detailed information about your built image:

```bash
# Inspect the image configuration
docker inspect myimage  # 🔬 full metadata

# View the image history (layers)
docker history myimage  # 📜 layer history
```

---

## 🚀 Task 3: Run a Container from the Custom Image

### 1️⃣ Subtask 3.1: Run the Container

Let's run a container from our custom image:

```bash
# Run the container in detached mode with port mapping
docker run -d -p 8080:8080 --name my-python-app myimage  # 🚀 launch the app

# Verify the container is running
docker ps  # ✅ confirm running
```

**Command explanation:**
- `-d`: Run in detached mode (background)
- `-p 8080:8080`: Map host port 8080 to container port 8080
- `--name my-python-app`: Assign a name to the container
- `myimage`: The image to run

### 2️⃣ Subtask 3.2: Test the Application

Test that your application is working:

```bash
# Test the application using curl
curl http://localhost:8080  # 🌐 test the endpoint

# Alternative: Test with wget if curl is not available
wget -qO- http://localhost:8080
```

Expected output:
```json
{
  "message": "Hello from Dockerized Python App!",
  "status": "success",
  "container_info": {
    "hostname": "container-id",
    "python_version": "3.x"
  }
}
```

### 3️⃣ Subtask 3.3: View Container Logs

Check the application logs:

```bash
# View container logs
docker logs my-python-app  # 📜 view logs

# Follow logs in real-time
docker logs -f my-python-app  # 👀 live tail
```

Press `Ctrl+C` to stop following logs.

### 4️⃣ Subtask 3.4: Access Container Shell (Optional)

Explore inside the running container:

```bash
# Execute bash inside the container
docker exec -it my-python-app bash  # ⌨️ interactive shell

# Once inside, explore the filesystem
ls -la
pwd
ps aux

# Exit the container shell
exit  # 🚪 leave the shell
```

---

## 🔧 Task 4: Modify the Dockerfile to Add Environment Variables

### 1️⃣ Subtask 4.1: Stop and Remove Current Container

First, let's clean up the current container:

```bash
# Stop the running container
docker stop my-python-app  # ⏹️ stop it

# Remove the container
docker rm my-python-app  # 🗑️ remove it

# Verify removal
docker ps -a  # ✅ confirm removal
```

### 2️⃣ Subtask 4.2: Create an Enhanced Python Application

Let's modify our Python application to use more environment variables:

```bash
# Navigate to the app directory
cd ~/docker-python-app/app

# Create a backup of the original app
cp app.py app.py.backup  # 💾 backup original

# Edit the application to use more environment variables
nano app.py  # ✏️ open editor
```

Replace the content with this enhanced version:

```python
#!/usr/bin/env python3

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os
from datetime import datetime

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        
        # Get environment variables with defaults
        app_name = os.environ.get('APP_NAME', 'Docker Python App')
        app_version = os.environ.get('APP_VERSION', '1.0.0')
        environment = os.environ.get('ENVIRONMENT', 'development')
        debug_mode = os.environ.get('DEBUG', 'false').lower() == 'true'
        
        response_data = {
            "application": {
                "name": app_name,
                "version": app_version,
                "environment": environment,
                "debug_mode": debug_mode
            },
            "message": f"Hello from {app_name}!",
            "timestamp": datetime.now().isoformat(),
            "status": "success",
            "container_info": {
                "hostname": os.environ.get('HOSTNAME', 'unknown'),
                "python_version": "3.11",
                "port": os.environ.get('PORT', '8080')
            }
        }
        
        self.wfile.write(json.dumps(response_data, indent=2).encode())

def run_server():
    port = int(os.environ.get('PORT', 8080))
    app_name = os.environ.get('APP_NAME', 'Docker Python App')
    
    server = HTTPServer(('0.0.0.0', port), SimpleHandler)
    print(f"Starting {app_name} on port {port}...")
    print(f"Environment: {os.environ.get('ENVIRONMENT', 'development')}")
    print(f"Debug mode: {os.environ.get('DEBUG', 'false')}")
    print(f"Access the application at http://localhost:{port}")
    server.serve_forever()

if __name__ == '__main__':
    run_server()
```

Save and exit the editor. 💾

### 3️⃣ Subtask 4.3: Update the Dockerfile with Environment Variables

Now let's modify our Dockerfile to include environment variables:

```bash
# Navigate back to project root
cd ~/docker-python-app

# Create a backup of the original Dockerfile
cp Dockerfile Dockerfile.backup  # 💾 backup original

# Edit the Dockerfile
nano Dockerfile  # ✏️ open editor
```

Replace the content with this enhanced version:

```dockerfile
# Use official Python runtime as base image
FROM python:3.11-slim

# Set metadata for the image
LABEL maintainer="student@alnafi.com"
LABEL description="Enhanced Python web application with environment variables"
LABEL version="2.0"

# Set environment variables
ENV APP_NAME="Dockerized Python Web App"
ENV APP_VERSION="2.0.0"
ENV ENVIRONMENT="production"
ENV DEBUG="false"
ENV PORT="8080"
ENV PYTHONUNBUFFERED="1"

# Set working directory inside the container
WORKDIR /usr/src/app

# Copy requirements file first (for better layer caching)
COPY app/requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app/ .

# Make the Python script executable
RUN chmod +x app.py

# Create a non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser
RUN chown -R appuser:appuser /usr/src/app
USER appuser

# Expose the port the app runs on
EXPOSE $PORT

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:$PORT/ || exit 1

# Define the command to run the application
CMD ["python", "app.py"]
```

Save and exit the editor. 💾

### 4️⃣ Subtask 4.4: Create a Docker Compose File (Optional Enhancement)

For better environment variable management, let's create a `docker-compose.yml` file:

```bash
# Create docker-compose.yml file
nano docker-compose.yml  # ✏️ open editor
```

Add the following content:

```yaml
version: '3.8'

services:
  python-app:
    build: .
    image: myimage:v2
    container_name: my-python-app-v2
    ports:
      - "8080:8080"
    environment:
      - APP_NAME=Enhanced Docker Python App
      - APP_VERSION=2.1.0
      - ENVIRONMENT=staging
      - DEBUG=true
      - PORT=8080
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

Save and exit the editor. 💾

```
# TODO: Note which environment variables you changed and why
```

---

## 🏗️ Task 5: Build and Run the Modified Image

### 1️⃣ Subtask 5.1: Build the Enhanced Image

Build the new version of our image:

```bash
# Build the enhanced image with a new tag
docker build -t myimage:v2 .  # 🏗️ build v2

# Also tag it as latest
docker build -t myimage:latest .  # 🏷️ tag as latest
```

### 2️⃣ Subtask 5.2: Verify the New Image

Check that both versions of your image exist:

```bash
# List all images
docker images myimage  # 📋 list both versions

# Compare the sizes and creation times
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"  # 📊 compare
```

### 3️⃣ Subtask 5.3: Run the Enhanced Container

Run a container from the new image:

```bash
# Run with default environment variables
docker run -d -p 8080:8080 --name my-python-app-v2 myimage:v2  # 🚀 launch v2

# Verify it's running
docker ps  # ✅ confirm running
```

### 4️⃣ Subtask 5.4: Test the Enhanced Application

Test the new functionality:

```bash
# Test the enhanced application
curl http://localhost:8080  # 🌐 test endpoint

# Pretty print the JSON response
curl -s http://localhost:8080 | python3 -m json.tool  # 🎨 formatted output
```

### 5️⃣ Subtask 5.5: Run with Custom Environment Variables

Let's run another container with custom environment variables:

```bash
# Stop the current container
docker stop my-python-app-v2  # ⏹️ stop v2

# Run with custom environment variables
docker run -d -p 8081:8080 \
  --name my-python-app-custom \
  -e APP_NAME="Custom Docker App" \
  -e APP_VERSION="3.0.0" \
  -e ENVIRONMENT="development" \
  -e DEBUG="true" \
  myimage:v2  # 🔧 custom-configured container

# Test the custom configuration
curl http://localhost:8081  # 🌐 test custom port
```

### 6️⃣ Subtask 5.6: Compare Different Configurations

Let's run multiple containers with different configurations:

```bash
# Production configuration
docker run -d -p 8082:8080 \
  --name production-app \
  -e APP_NAME="Production App" \
  -e ENVIRONMENT="production" \
  -e DEBUG="false" \
  myimage:v2  # 🏭 prod config

# Development configuration
docker run -d -p 8083:8080 \
  --name development-app \
  -e APP_NAME="Development App" \
  -e ENVIRONMENT="development" \
  -e DEBUG="true" \
  myimage:v2  # 🧪 dev config

# Test both configurations
echo "Production App Response:"
curl -s http://localhost:8082 | python3 -m json.tool

echo -e "\nDevelopment App Response:"
curl -s http://localhost:8083 | python3 -m json.tool
```

### 7️⃣ Subtask 5.7: Monitor All Running Containers

Check all running containers:

```bash
# List all running containers
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}"  # 📋 formatted list

# Check resource usage
docker stats --no-stream  # 📊 resource snapshot
```

```
# TODO: Compare the JSON responses from the production and development containers
```

---

## 🚨 Troubleshooting Common Issues

<details>
<summary>❗ Issue 1: Build Fails with Permission Errors</summary>

If you encounter permission errors during build:

```bash
# Check Docker daemon status
sudo systemctl status docker

# Ensure your user is in the docker group
sudo usermod -aG docker $USER

# Restart your session or run
newgrp docker
```
</details>

<details>
<summary>❗ Issue 2: Port Already in Use</summary>

If you get "port already in use" errors:

```bash
# Check what's using the port
sudo netstat -tulpn | grep :8080

# Stop containers using the port
docker stop $(docker ps -q --filter "publish=8080")
```
</details>

<details>
<summary>❗ Issue 3: Container Exits Immediately</summary>

If containers exit immediately:

```bash
# Check container logs
docker logs container-name

# Run container interactively for debugging
docker run -it --rm myimage:v2 bash
```
</details>

<details>
<summary>❗ Issue 4: Application Not Accessible</summary>

If the application is not accessible:

```bash
# Check if container is running
docker ps

# Check container logs
docker logs container-name

# Test from inside the container
docker exec -it container-name curl http://localhost:8080
```
</details>

---

## ✅ Best Practices Learned

Throughout this lab, we've implemented several Docker best practices:

| # | Practice | Description |
|---|---|---|
| 1 | 🧱 **Layer Optimization** | Copying `requirements.txt` before application code for better caching |
| 2 | 🔒 **Security** | Creating and using a non-root user |
| 3 | 🔧 **Environment Variables** | Using `ENV` instructions and runtime overrides |
| 4 | ❤️ **Health Checks** | Implementing container health monitoring |
| 5 | 🏷️ **Metadata** | Adding labels for image documentation |
| 6 | 🚪 **Port Management** | Proper port exposure and mapping |
| 7 | 🪶 **Resource Management** | Using slim base images to reduce size |

---

## 🧹 Cleanup

Clean up the lab environment:

```bash
# Stop all containers
docker stop $(docker ps -q)  # ⏹️ stop everything running

# Remove all containers
docker rm $(docker ps -aq)  # 🗑️ remove everything

# Remove images (optional)
docker rmi myimage:latest myimage:v2  # 🧹 remove built images

# Clean up unused resources
docker system prune -f  # 🧹 broader cleanup
```

---

## 🏁 Conclusion

🎉 **Congratulations!** You have successfully completed **Lab 6: Writing a Simple Dockerfile**.

### ✅ Key Achievements
- 📝 **Created a Dockerfile:** You learned how to write a well-structured Dockerfile with proper syntax, best practices, and comprehensive configuration options
- 🏗️ **Built Custom Images:** You successfully used the `docker build` command to create custom Docker images from your Dockerfile, understanding the build process and layer creation
- 🚀 **Deployed Applications:** You ran containers from your custom images and verified they work correctly, demonstrating the complete containerization workflow
- 🔧 **Implemented Environment Variables:** You enhanced your Dockerfile and application to use environment variables, making your containers more flexible and configurable
- ✅ **Applied Best Practices:** You implemented security measures (non-root user), health checks, proper labeling, and efficient layer management

### 🧠 Skills Developed
- 📝 **Dockerfile Syntax:** Understanding of all major Dockerfile instructions (`FROM`, `COPY`, `RUN`, `ENV`, `EXPOSE`, `CMD`, etc.)
- 🏗️ **Image Building:** Proficiency with `docker build` command and build context management
- 🔧 **Environment Configuration:** Ability to create flexible, configurable containerized applications
- 🚀 **Container Management:** Skills in running, monitoring, and troubleshooting containerized applications
- 🔒 **Security Awareness:** Implementation of container security best practices

### 🌍 Real-World Applications

The skills you've learned in this lab are directly applicable to:

- 🚀 **Application Deployment:** Containerizing web applications, APIs, and microservices
- 🔁 **Development Workflows:** Creating consistent development environments across teams
- 🔄 **CI/CD Pipelines:** Building automated deployment pipelines with custom images
- ☁️ **Cloud Migration:** Preparing applications for cloud-native deployment
- 🔧 **DevOps Practices:** Implementing infrastructure as code and immutable deployments

### 🚀 Next Steps

With these foundational Dockerfile skills, you're now prepared to:

- 🏗️ Explore multi-stage builds for optimized production images
- 🧩 Learn Docker Compose for multi-container applications
- 🌐 Implement advanced networking and storage configurations
- ☸️ Study container orchestration with Kubernetes
- 🎓 Pursue Docker Certified Associate (DCA) certification

### 🌍 Why This Matters

Understanding how to create custom Docker images is fundamental to modern software development and deployment. These skills enable you to:

- 📦 Package applications with all their dependencies
- 🎯 Ensure consistent behavior across different environments
- 📈 Implement scalable, maintainable deployment strategies
- 🔧 Contribute effectively to DevOps and cloud-native initiatives

You now have the practical experience and knowledge to create, customize, and deploy containerized applications using Docker, a critical skill in today's technology landscape.

---

<div align="center">

### 🐳 Well done on completing Lab 6!

You've built and deployed your very own custom Docker image from scratch.

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Education-blueviolet?style=for-the-badge)

</div>
