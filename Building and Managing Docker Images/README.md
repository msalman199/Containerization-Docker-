<div align="center">

# 🐳 Building and Managing Docker Images

### Optimize, Tag, Push, and Deploy Production-Ready Docker Images

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Hub](https://img.shields.io/badge/Docker_Hub-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Alpine Linux](https://img.shields.io/badge/Alpine_Linux-0D597F?style=for-the-badge&logo=alpinelinux&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Express.js](https://img.shields.io/badge/Express.js-000000?style=for-the-badge&logo=express&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

</div>

---

## 📖 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🐳 Task 1: Optimize Docker Images by Reducing Image Layers](#-task-1-optimize-docker-images-by-reducing-image-layers)
- [🚫 Task 2: Use .dockerignore to Exclude Unnecessary Files](#-task-2-use-dockerignore-to-exclude-unnecessary-files)
- [🏷️ Task 3: Build a Custom Image and Tag It Appropriately](#️-task-3-build-a-custom-image-and-tag-it-appropriately)
- [☁️ Task 4: Push the Image to Docker Hub](#️-task-4-push-the-image-to-docker-hub)
- [⬇️ Task 5: Pull and Run the Image on a Different Machine](#️-task-5-pull-and-run-the-image-on-a-different-machine)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🧹 Cleanup](#-cleanup)
- [✅ Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Skill |
|---|-------|
| 1️⃣ | Optimize Docker images by reducing image layers and size |
| 2️⃣ | Use `.dockerignore` files to exclude unnecessary files from the build context |
| 3️⃣ | Build custom Docker images with proper tagging strategies |
| 4️⃣ | Push Docker images to the Docker Hub registry |
| 5️⃣ | Pull and run Docker images on different machines |
| 6️⃣ | Understand best practices for Docker image management |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker Basics | Understanding of containers and images |
| 🐧 Linux CLI | Familiarity with Linux command line operations |
| 📝 Text Editors | Basic knowledge of `nano`, `vim`, or similar |
| 🌐 Web Apps | Understanding of HTML and basic programming concepts |

> ℹ️ **Note:** Al Nafi provides ready-to-use Linux-based cloud machines with Docker pre-installed. Simply click **"Start Lab"** to begin — no need to build your own VM or install Docker manually.

---

## 🖥️ Lab Environment Setup

Your Al Nafi cloud machine comes pre-configured with:

- ✅ Ubuntu Linux operating system
- ✅ Docker Engine pre-installed and configured
- ✅ Text editors (`nano`, `vim`)
- ✅ Internet connectivity for Docker Hub access

---

## 🐳 Task 1: Optimize Docker Images by Reducing Image Layers

### 📚 Understanding Docker Layers

Docker images are built in layers. Each instruction in a Dockerfile creates a new layer. Fewer layers generally mean smaller, more efficient images.

### 🔹 Subtask 1.1: Create a Non-Optimized Dockerfile

**Create a project directory:**
```bash
mkdir docker-optimization-lab   # 📁 project workspace
cd docker-optimization-lab
```

**Create a simple HTML file:**
```bash
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Docker Optimization Lab</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 600px; margin: 0 auto; }
        h1 { color: #2c3e50; }
        .info { background: #ecf0f1; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Docker Optimization Lab</h1>
        <div class="info">
            <p>This is a sample web application running in a Docker container.</p>
            <p>Image optimization techniques help reduce size and improve performance.</p>
        </div>
    </div>
</body>
</html>
EOF
```

**Create a non-optimized Dockerfile:**
```dockerfile
cat > Dockerfile.unoptimized << 'EOF'
FROM ubuntu:20.04

# 📦 Update package list
RUN apt-get update

# 🌐 Install nginx
RUN apt-get install -y nginx

# 🔧 Install curl for testing
RUN apt-get install -y curl

# ✏️ Install vim for editing
RUN apt-get install -y vim

# 🧹 Clean package cache
RUN apt-get clean

# 🗑️ Remove default nginx page
RUN rm /var/www/html/index.nginx-debian.html

# 📄 Copy our HTML file
COPY index.html /var/www/html/

# 🔌 Expose port 80
EXPOSE 80

# ▶️ Start nginx
CMD ["nginx", "-g", "daemon off;"]
EOF
```

**Build the non-optimized image:**
```bash
docker build -f Dockerfile.unoptimized -t webapp-unoptimized:v1 .   # 🏗️ build
```

**Check the image size:**
```bash
docker images webapp-unoptimized:v1   # 📏 inspect size
```

### 🔹 Subtask 1.2: Create an Optimized Dockerfile

**Create an optimized Dockerfile using a smaller base image:**
```dockerfile
cat > Dockerfile.optimized << 'EOF'
FROM nginx:alpine

# 📄 Copy our HTML file
COPY index.html /usr/share/nginx/html/

# 🔌 Expose port 80
EXPOSE 80

# nginx:alpine already has the correct CMD
EOF
```

**Build the optimized image:**
```bash
docker build -f Dockerfile.optimized -t webapp-optimized:v1 .   # ⚡ lean build
```

**Compare image sizes:**
```bash
docker images | grep webapp   # 🔍 side-by-side comparison
```

### 🔹 Subtask 1.3: Advanced Optimization with Multi-Stage Build

**Create a simple Node.js application:**
```json
cat > package.json << 'EOF'
{
  "name": "docker-optimization-demo",
  "version": "1.0.0",
  "description": "Demo app for Docker optimization",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF
```

**Create a simple Express server:**
```javascript
cat > server.js << 'EOF'
const express = require('express');
const path = require('path');
const app = express();
const PORT = 3000;

// 📁 Serve static files
app.use(express.static('.'));

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);   // ✅ ready
});
EOF
```

**Create a multi-stage Dockerfile:**
```dockerfile
cat > Dockerfile.multistage << 'EOF'
# 🏗️ Build stage
FROM node:16-alpine AS builder

WORKDIR /app

# 📦 Copy package files
COPY package*.json ./

# ⬇️ Install dependencies
RUN npm install --only=production

# 🚀 Production stage
FROM node:16-alpine AS production

WORKDIR /app

# 📄 Copy only necessary files from builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./
COPY server.js ./
COPY index.html ./

# 👤 Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

USER nodejs

EXPOSE 3000

CMD ["npm", "start"]
EOF
```

**Build the multi-stage image:**
```bash
docker build -f Dockerfile.multistage -t webapp-multistage:v1 .   # 🏗️ multi-stage build
```

**Compare all image sizes:**
```bash
docker images | grep webapp   # 📊 final comparison
```

> 📝 `# TODO:` Swap in your own base image / dependency list and re-run the size comparison to see how optimization choices affect your specific application.

---

## 🚫 Task 2: Use .dockerignore to Exclude Unnecessary Files

### 📚 Understanding .dockerignore

The `.dockerignore` file works similarly to `.gitignore`, excluding files and directories from the Docker build context.

### 🔹 Subtask 2.1: Create Files to Demonstrate .dockerignore

**Create various file types in your project:**
```bash
# 📄 Create some log files
mkdir logs
echo "Error log content" > logs/error.log
echo "Access log content" > logs/access.log

# ⏳ Create temporary files
echo "Temporary data" > temp.txt
echo "Cache data" > cache.tmp

# 🌿 Create development files
mkdir .git
echo "Git repository data" > .git/config

# 📚 Create documentation
mkdir docs
echo "# Documentation" > docs/README.md

# 📦 Create node_modules simulation
mkdir node_modules_dev
echo "Development dependencies" > node_modules_dev/dev-package.js
```

**Build without .dockerignore to see the problem:**
```bash
docker build -f Dockerfile.optimized -t webapp-with-junk:v1 .   # ⚠️ bloated context
```

### 🔹 Subtask 2.2: Create and Use .dockerignore

**Create a comprehensive .dockerignore file:**
```bash
cat > .dockerignore << 'EOF'
# 📄 Logs
logs/
*.log

# ⏳ Temporary files
*.tmp
temp.txt

# 🌿 Version control
.git/
.gitignore

# 📦 Development dependencies
node_modules_dev/

# 📚 Documentation (not needed in production)
docs/
README.md

# 🖊️ IDE files
.vscode/
.idea/

# 💻 OS generated files
.DS_Store
Thumbs.db

# 🐳 Docker files (don't include other Dockerfiles)
Dockerfile.*
!Dockerfile.optimized

# 🏗️ Build artifacts
dist/
build/
EOF
```

**Build the image with .dockerignore:**
```bash
docker build -f Dockerfile.optimized -t webapp-clean:v1 .   # ✨ clean build
```

**Verify the build context is smaller:**
```bash
# 🔍 Check what files are in the image
docker run --rm webapp-clean:v1 ls -la /usr/share/nginx/html/
```

> 📝 `# TODO:` Extend `.dockerignore` with any project-specific artifacts (test reports, coverage output, editor configs) you don't want shipped in your own images.

---

## 🏷️ Task 3: Build a Custom Image and Tag It Appropriately

### 📚 Understanding Docker Tagging

Proper tagging helps organize and version your Docker images effectively.

### 🔹 Subtask 3.1: Learn Tagging Best Practices

**Create a final optimized Dockerfile:**
```dockerfile
cat > Dockerfile << 'EOF'
FROM nginx:alpine

# 🏷️ Add metadata labels
LABEL maintainer="your-email@example.com"
LABEL version="1.0"
LABEL description="Optimized web application for Docker lab"

# 📄 Copy application files
COPY index.html /usr/share/nginx/html/

# ⚙️ Create custom nginx configuration
RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
    } \
    # 🔒 Security headers \
    add_header X-Frame-Options "SAMEORIGIN" always; \
    add_header X-Content-Type-Options "nosniff" always; \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF
```

### 🔹 Subtask 3.2: Build with Multiple Tags

**Build with semantic versioning:**
```bash
# 🏗️ Build with version tag
docker build -t mywebapp:1.0.0 .

# 🏷️ Tag the same image with different tags
docker tag mywebapp:1.0.0 mywebapp:1.0
docker tag mywebapp:1.0.0 mywebapp:latest
docker tag mywebapp:1.0.0 mywebapp:stable
```

**View all tags:**
```bash
docker images mywebapp   # 📋 tag listing
```

### 🔹 Subtask 3.3: Build with Environment-Specific Tags

**Create environment-specific tags:**
```bash
# 🧪 Development version
docker tag mywebapp:1.0.0 mywebapp:dev

# 🎭 Staging version
docker tag mywebapp:1.0.0 mywebapp:staging

# 🚀 Production version
docker tag mywebapp:1.0.0 mywebapp:prod
```

**Test the image locally:**
```bash
# ▶️ Run the container
docker run -d -p 8080:80 --name webapp-test mywebapp:latest

# 🌐 Test the application
curl http://localhost:8080

# 📜 Check container logs
docker logs webapp-test

# 🛑 Stop and remove the test container
docker stop webapp-test
docker rm webapp-test
```

> 📝 `# TODO:` Adopt a tagging convention (semver + environment suffix) for your own projects and document it in your team's contribution guide.

---

## ☁️ Task 4: Push the Image to Docker Hub

### 📚 Prerequisites for Docker Hub

You'll need a Docker Hub account. If you don't have one, create it at [hub.docker.com](https://hub.docker.com).

### 🔹 Subtask 4.1: Login to Docker Hub

```bash
docker login   # 🔑 authenticate
```
Enter your Docker Hub username and password when prompted.

### 🔹 Subtask 4.2: Tag Image for Docker Hub

```bash
# 🏷️ Replace 'yourusername' with your actual Docker Hub username
docker tag mywebapp:1.0.0 yourusername/mywebapp:1.0.0
docker tag mywebapp:1.0.0 yourusername/mywebapp:latest
```

### 🔹 Subtask 4.3: Push to Docker Hub

```bash
# ⬆️ Push specific version
docker push yourusername/mywebapp:1.0.0

# ⬆️ Push latest tag
docker push yourusername/mywebapp:latest
```

**Verify the push:**
```bash
# 🔍 Check your repositories
docker search yourusername/mywebapp
```

### 🔹 Subtask 4.4: Add Image Documentation

```markdown
cat > DOCKER_README.md << 'EOF'
# MyWebApp Docker Image

A simple, optimized web application built for Docker demonstration.

## Features
- Based on nginx:alpine for minimal size
- Optimized with multi-layer reduction
- Security headers included
- Production-ready configuration

## Usage
docker run -d -p 80:80 yourusername/mywebapp:latest

## Tags
- latest - Latest stable version
- 1.0.0 - Specific version
- stable - Stable release

## Size
Approximately 15MB (optimized from 200MB+ unoptimized version)
EOF
```

> 📝 `# TODO:` Replace `yourusername` with your real Docker Hub namespace before pushing, and add a screenshot or badge link to your published repository.

---

## ⬇️ Task 5: Pull and Run the Image on a Different Machine

### 📚 Simulating a Different Machine

We'll simulate pulling the image on a different machine by removing local images first.

### 🔹 Subtask 5.1: Clean Local Environment

```bash
# 🛑 Stop any running containers
docker stop $(docker ps -q) 2>/dev/null || true

# 🗑️ Remove local images (keep the pushed ones on Docker Hub)
docker rmi mywebapp:1.0.0 mywebapp:latest mywebapp:stable 2>/dev/null || true
docker rmi yourusername/mywebapp:1.0.0 yourusername/mywebapp:latest 2>/dev/null || true

# ✅ Verify images are removed
docker images | grep mywebapp
```

### 🔹 Subtask 5.2: Pull from Docker Hub

```bash
# ⬇️ Pull latest version
docker pull yourusername/mywebapp:latest

# ⬇️ Pull specific version
docker pull yourusername/mywebapp:1.0.0
```

**Verify the pulled images:**
```bash
docker images yourusername/mywebapp   # 📋 confirm pull
```

### 🔹 Subtask 5.3: Run the Pulled Image

```bash
# ▶️ Run in detached mode
docker run -d -p 8080:80 --name production-webapp yourusername/mywebapp:latest
```

**Test the application:**
```bash
# 🌐 Test with curl
curl http://localhost:8080

# 🔎 Check if HTML content is served correctly
curl -s http://localhost:8080 | grep "Docker Optimization Lab"
```

**Monitor the container:**
```bash
# 📋 Check container status
docker ps

# 📜 View container logs
docker logs production-webapp

# 📊 Check resource usage
docker stats production-webapp --no-stream
```

### 🔹 Subtask 5.4: Advanced Deployment Scenarios

**Run with custom configuration:**
```bash
# ⚙️ Run with environment variables
docker run -d -p 8081:80 \
  --name webapp-custom \
  -e NGINX_HOST=localhost \
  -e NGINX_PORT=80 \
  yourusername/mywebapp:latest
```

**Run with volume mounting:**
```bash
# 📁 Create custom content
mkdir custom-content
echo "<h1>Custom Content</h1>" > custom-content/custom.html

# 💾 Run with volume
docker run -d -p 8082:80 \
  --name webapp-volume \
  -v $(pwd)/custom-content:/usr/share/nginx/html/custom \
  yourusername/mywebapp:latest
```

**Test all deployments:**
```bash
# 🌐 Test original deployment
curl http://localhost:8080

# 🌐 Test custom deployment
curl http://localhost:8081

# 🌐 Test volume deployment
curl http://localhost:8082/custom/custom.html
```

> 📝 `# TODO:` Point the volume mount at your own static assets to confirm persistence works independently of the image itself.

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔑 Issue 1: Docker Login Problems</summary>

```bash
# If login fails, try:
docker logout
docker login --username yourusername
```
</details>

<details>
<summary>🚫 Issue 2: Push Permission Denied</summary>

```bash
# Ensure you're pushing to your own repository
docker tag mywebapp:latest yourusername/mywebapp:latest
docker push yourusername/mywebapp:latest
```
</details>

<details>
<summary>🔌 Issue 3: Port Already in Use</summary>

```bash
# Find what's using the port
sudo netstat -tulpn | grep :8080

# Use a different port
docker run -d -p 8090:80 --name webapp-alt yourusername/mywebapp:latest
```
</details>

<details>
<summary>💥 Issue 4: Container Won't Start</summary>

```bash
# Check container logs
docker logs container-name

# Run interactively for debugging
docker run -it yourusername/mywebapp:latest /bin/sh
```
</details>

---

## 🧹 Cleanup

After completing the lab, clean up your environment:

```bash
# 🛑 Stop all containers
docker stop $(docker ps -q)

# 🗑️ Remove containers
docker rm $(docker ps -aq)

# 🗑️ Remove images (optional)
docker rmi $(docker images -q)

# 🧽 Clean up build cache
docker system prune -f
```

---

## ✅ Conclusion

In this lab, you have successfully:

- 🐳 **Optimized Docker images** by reducing layers from multiple `RUN` commands into single commands and using smaller base images (`nginx:alpine` vs `ubuntu:20.04`), achieving significant size reduction
- 🚫 **Implemented `.dockerignore`** to exclude unnecessary files like logs, temporary files, and development dependencies from the build context, making builds faster and images cleaner
- 🏷️ **Built and tagged custom images** using semantic versioning and environment-specific tags, following Docker best practices for image organization
- ☁️ **Pushed images to Docker Hub** registry, making them available for distribution and deployment across different environments
- ⬇️ **Pulled and ran images** on simulated different machines, demonstrating the portability and consistency of containerized applications

### 🔑 Key Takeaways

| Insight | Impact |
|---|---|
| 📉 Image optimization | Can reduce image sizes by 80–90%, improving deployment speed and reducing storage costs |
| 🏷️ Tagging strategy | Helps manage different versions and environments effectively |
| ☁️ Docker Hub | Provides a centralized registry for sharing and distributing images |
| 🔁 Portability | Ensures applications run consistently across different environments |
| 🚫 `.dockerignore` | Essential for excluding unnecessary files and improving build performance |

### 🌍 Real-World Applications

These skills are essential for:

- ⚙️ **DevOps pipelines** where optimized images reduce deployment time
- 🧩 **Microservices architecture** where image size affects scaling performance
- 🔄 **CI/CD processes** where proper tagging enables automated deployments
- 🔒 **Production environments** where security and efficiency are paramount

> 🎓 This knowledge prepares you for the **Docker Certified Associate (DCA)** certification and real-world container management scenarios.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E90FF?style=for-the-badge)

</div>
