<div align="center">

# 🖼️ Understanding Docker Images

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Hub](https://img.shields.io/badge/Docker%20Hub-1D63ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Level](https://img.shields.io/badge/Level-Beginner--Intermediate-brightgreen?style=for-the-badge)

**A hands-on lab exploring Docker Hub, image pulling, tagging, and layered architecture**

</div>

---

## 📚 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🔍 Task 1: Exploring Docker Hub](#-task-1-exploring-docker-hub)
- [⬇️ Task 2: Pulling Docker Images](#️-task-2-pulling-docker-images)
- [🗂️ Task 3: Managing Docker Images](#️-task-3-managing-docker-images)
- [🏷️ Task 4: Working with Image Tags](#️-task-4-working-with-image-tags)
- [🧱 Task 5: Inspecting Docker Image Layers](#-task-5-inspecting-docker-image-layers)
- [🧹 Task 6: Best Practices and Cleanup](#-task-6-best-practices-and-cleanup)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🧪 Lab Verification](#-lab-verification)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | 🖼️ Understand the concept of Docker images and their role in containerization |
| 2 | 🔍 Navigate and search Docker Hub for available images |
| 3 | ⬇️ Pull Docker images from Docker Hub to their local machine |
| 4 | 📋 List, inspect, and manage Docker images on their system |
| 5 | 🧹 Remove unused Docker images to manage storage space |
| 6 | 🏷️ Use specific image tags when running containers |
| 7 | 🧱 Examine the layered architecture of Docker images |
| 8 | ✅ Apply best practices for Docker image management |

---

## ✅ Prerequisites

| Requirement | Status |
|---|---|
| Basic understanding of command-line interface (CLI) operations | Required |
| Completion of Lab 1 or equivalent Docker installation knowledge | Required |
| Familiarity with basic Linux commands | Required |
| Understanding of what containers are conceptually | Required |

---

## 🖥️ Lab Environment Setup

> **☁️ Good News:** Al Nafi provides ready-to-use Linux-based cloud machines with Docker pre-installed. Simply click **Start Lab** to access your environment — no need to build your own virtual machine or install Docker manually.

**Your cloud machine includes:**

- 🐧 Ubuntu Linux operating system
- 🐳 Docker Engine pre-installed and configured
- 🔑 Terminal access with sudo privileges
- 🌐 Internet connectivity for downloading images

---

## 🔍 Task 1: Exploring Docker Hub

### 1️⃣ Subtask 1.1: Understanding Docker Hub

Docker Hub is the world's largest repository of container images. Think of it as an **app store for Docker images** where developers share pre-built applications and operating systems.

**Step 1:** Open your web browser and navigate to Docker Hub 🌐
```
https://hub.docker.com
```

**Step 2:** Explore the interface without logging in
- 🔎 Notice the search bar at the top
- ⭐ Observe the featured repositories
- 🗂️ Look at the categories of available images

### 2️⃣ Subtask 1.2: Searching for Images via Web Interface

**Step 1:** Search for popular images using the web interface
- Search for `ubuntu` in the search bar
- Click on the official Ubuntu repository
- Examine the repository details:
  - 📄 Description and documentation
  - 🏷️ Available tags (versions)
  - 📥 Pull command
  - 📊 Number of downloads

**Step 2:** Explore other popular images
- Search for `nginx` (web server) 🌐
- Search for `mysql` (database) 🗄️
- Search for `python` (programming language) 🐍

### 3️⃣ Subtask 1.3: Searching for Images via Command Line

**Step 1:** Open your terminal in the cloud machine 💻

**Step 2:** Search for images using Docker CLI
```bash
docker search ubuntu  # 🔍 search Docker Hub from the terminal
```

**Step 3:** Understand the output columns
- **NAME:** Repository name
- **DESCRIPTION:** Brief description of the image
- **STARS:** Community rating (like GitHub stars) ⭐
- **OFFICIAL:** Whether it's an official image ✅
- **AUTOMATED:** Whether it's automatically built 🤖

**Step 4:** Search for other images
```bash
docker search nginx              # 🌐 search for the Nginx image
docker search --limit 5 python   # 🐍 limit results to top 5
```

---

## ⬇️ Task 2: Pulling Docker Images

### 🏷️ Subtask 2.1: Understanding Image Tags

Docker images use tags to specify versions. The `latest` tag refers to the most recent version, but it's better to use specific version tags for production environments.

### 🐧 Subtask 2.2: Pulling the Ubuntu Image

**Step 1:** Pull the latest Ubuntu image
```bash
docker pull ubuntu  # ⬇️ pull the latest Ubuntu image
```

**Step 2:** Observe the download process
- 🧱 Notice the different layers being downloaded
- 📝 Each layer represents a filesystem change
- ⚡ Layers are cached for efficiency

**Step 3:** Pull a specific Ubuntu version
```bash
docker pull ubuntu:20.04  # 🎯 pull Ubuntu 20.04 specifically
```

**Step 4:** Pull another specific version
```bash
docker pull ubuntu:22.04  # 🎯 pull Ubuntu 22.04 specifically
```

### 📦 Subtask 2.3: Pulling Other Popular Images

**Step 1:** Pull an Nginx web server image
```bash
docker pull nginx:alpine  # 🌐 pull the lightweight Alpine-based Nginx image
```

**Step 2:** Pull a Python runtime image
```bash
docker pull python:3.9-slim  # 🐍 pull the slim Python 3.9 image
```

**Step 3:** Understanding why we chose specific tags
- `alpine`: Smaller, security-focused Linux distribution 🔒
- `slim`: Reduced size version with fewer packages 🪶
- `3.9`: Specific Python version for consistency 🎯

```
# TODO: Note the download size and layer count for each image you pulled
```

---

## 🗂️ Task 3: Managing Docker Images

### 📋 Subtask 3.1: Listing Docker Images

**Step 1:** List all images on your system
```bash
docker images  # 📋 list all local images
```

**Step 2:** Understand the output columns
- **REPOSITORY:** Image name
- **TAG:** Version or variant
- **IMAGE ID:** Unique identifier (first 12 characters)
- **CREATED:** When the image was built
- **SIZE:** Disk space used

**Step 3:** List images with additional formatting
```bash
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"  # 🎨 custom formatted output
```

### 🔎 Subtask 3.2: Filtering and Sorting Images

**Step 1:** Filter images by repository name
```bash
docker images ubuntu  # 🔎 filter by repository name
```

**Step 2:** Show only image IDs
```bash
docker images -q  # 🆔 quiet mode — IDs only
```

**Step 3:** Show all images including intermediate layers
```bash
docker images -a  # 🧱 show intermediate layers too
```

### 🗑️ Subtask 3.3: Removing Docker Images

**Step 1:** Remove a specific image by name and tag
```bash
docker rmi ubuntu:20.04  # 🗑️ remove by name:tag
```

**Step 2:** Remove an image by IMAGE ID
```bash
# First, get the IMAGE ID
docker images python:3.9-slim   # 🔎 find the image ID

# Then remove using the ID (use first few characters)
docker rmi [IMAGE_ID]           # 🗑️ remove by ID
```

**Step 3:** Force remove an image (if containers are using it)
```bash
docker rmi -f nginx:alpine  # 💥 force removal
```

**Step 4:** Remove multiple images at once
```bash
docker rmi ubuntu:22.04 python:3.9-slim  # 🗑️ batch removal
```

**Step 5:** Remove all unused images
```bash
docker image prune  # 🧹 clean up dangling images
```

**Step 6:** Remove all images (use with caution)
```bash
docker rmi $(docker images -q)  # ⚠️ remove everything — use carefully
```

---

## 🏷️ Task 4: Working with Image Tags

### 📌 Subtask 4.1: Understanding Tag Importance

Tags help you:
- 🎯 Specify exact versions for reproducibility
- 🪶 Choose optimized variants (`alpine`, `slim`)
- 🚫 Avoid unexpected changes from `latest` tag updates

### ▶️ Subtask 4.2: Running Containers with Specific Tags

**Step 1:** Pull multiple versions of the same image
```bash
docker pull ubuntu:18.04
docker pull ubuntu:20.04
docker pull ubuntu:22.04
```

**Step 2:** Run containers with different Ubuntu versions
```bash
# Run Ubuntu 18.04
docker run -it ubuntu:18.04 /bin/bash  # 💻 launch 18.04 shell
```

**Step 3:** Check the Ubuntu version inside the container
```bash
cat /etc/os-release  # 🐧 confirm OS version
exit                  # 🚪 leave the container
```

**Step 4:** Run Ubuntu 22.04 and compare
```bash
docker run -it ubuntu:22.04 /bin/bash  # 💻 launch 22.04 shell
cat /etc/os-release                    # 🐧 confirm OS version
exit                                    # 🚪 leave the container
```

### 🎨 Subtask 4.3: Creating Custom Tags

**Step 1:** Tag an existing image with a custom name
```bash
docker tag ubuntu:22.04 my-ubuntu:production  # 🏷️ create a custom tag
```

**Step 2:** Verify the new tag was created
```bash
docker images | grep my-ubuntu  # 🔎 confirm the custom tag exists
```

**Step 3:** Both tags point to the same image (same IMAGE ID)
```bash
docker images ubuntu:22.04
docker images my-ubuntu:production
```

```
# TODO: Record the shared IMAGE ID to confirm both tags reference the same image
```

---

## 🧱 Task 5: Inspecting Docker Image Layers

### 📚 Subtask 5.1: Understanding Docker Image Layers

Docker images are built in layers, like a stack of transparent sheets 📄📄📄. Each layer represents a change to the filesystem. This layered approach enables:

- ⚡ **Efficiency:** Shared layers between images
- 🗃️ **Caching:** Faster builds and pulls
- 💾 **Storage optimization:** Reduced disk usage

### 🔬 Subtask 5.2: Inspecting Image Details

**Step 1:** Get detailed information about an image
```bash
docker inspect ubuntu:22.04  # 🔬 full image metadata
```

**Step 2:** Extract specific information using formatting
```bash
# Get just the architecture
docker inspect --format='{{.Architecture}}' ubuntu:22.04  # 🖥️ architecture

# Get the creation date
docker inspect --format='{{.Created}}' ubuntu:22.04        # 📅 creation date

# Get the size
docker inspect --format='{{.Size}}' ubuntu:22.04            # 💾 image size
```

### 📜 Subtask 5.3: Viewing Image History and Layers

**Step 1:** View the build history of an image
```bash
docker history ubuntu:22.04  # 📜 view build history
```

**Step 2:** Understand the history output
- **IMAGE:** Layer ID
- **CREATED:** When the layer was created
- **CREATED BY:** Command that created the layer
- **SIZE:** Size added by this layer
- **COMMENT:** Additional information

**Step 3:** View history without truncation
```bash
docker history --no-trunc ubuntu:22.04  # 🔍 full untruncated history
```

**Step 4:** Compare histories of different images
```bash
docker history nginx:alpine
docker history python:3.9-slim
```

### 📈 Subtask 5.4: Analyzing Layer Efficiency

**Step 1:** Pull a larger image to see more layers
```bash
docker pull node:16  # 📦 pull Node.js 16 image
```

**Step 2:** Compare the layer structure
```bash
docker history node:16
docker history ubuntu:22.04
```

**Step 3:** Notice how the Node.js image builds upon base layers
- 🧱 Base operating system layers
- 📦 Package manager updates
- 🟢 Node.js installation layers
- ⚙️ Configuration layers

```
# TODO: List the layer count and total size for node:16 vs ubuntu:22.04
```

---

## 🧹 Task 6: Best Practices and Cleanup

### ✅ Subtask 6.1: Image Management Best Practices

**Key Principles:**
- 🎯 Use specific tags instead of `latest` for production
- 🧹 Regularly clean up unused images
- 🪶 Choose minimal base images (`alpine`, `slim`) when possible
- 🧱 Understand the layers you're adding to images

### 🗑️ Subtask 6.2: System Cleanup

**Step 1:** Check current disk usage
```bash
docker system df  # 💾 check Docker disk usage
```

**Step 2:** Clean up unused images
```bash
docker image prune  # 🧹 remove dangling images
```

**Step 3:** Clean up everything unused (images, containers, networks)
```bash
docker system prune  # 🧹 broader cleanup
```

**Step 4:** Aggressive cleanup (remove all unused images, not just dangling ones)
```bash
docker system prune -a  # 💥 aggressive cleanup
```

### 📊 Subtask 6.3: Monitoring Image Usage

**Step 1:** List images sorted by size
```bash
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | sort -k3 -h  # 📊 sort by size
```

**Step 2:** Find large images consuming space
```bash
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | head -10  # 🔎 top 10 largest
```

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>❗ Issue 1: Permission Denied</summary>

**Problem:** Getting permission denied when running Docker commands.

**Solution:**
```bash
sudo docker [command]
# Or add user to docker group (requires logout/login)
sudo usermod -aG docker $USER
```
</details>

<details>
<summary>❗ Issue 2: Image Pull Fails</summary>

**Problem:** Network issues or repository not found.

**Solution:**
```bash
# Check internet connectivity
ping docker.io

# Verify image name spelling
docker search [image-name]
```
</details>

<details>
<summary>❗ Issue 3: Cannot Remove Image</summary>

**Problem:** Image is being used by a container.

**Solution:**
```bash
# List containers using the image
docker ps -a

# Remove containers first, then image
docker rm [container-id]
docker rmi [image-name]
```
</details>

<details>
<summary>❗ Issue 4: Disk Space Issues</summary>

**Problem:** Running out of disk space.

**Solution:**
```bash
# Check Docker disk usage
docker system df

# Clean up aggressively
docker system prune -a --volumes
```
</details>

---

## 🧪 Lab Verification

To verify you've completed the lab successfully, run these commands:

```bash
# Should show multiple images
docker images

# Should show image details
docker inspect ubuntu:latest

# Should show layer history
docker history ubuntu:latest

# Should show system usage
docker system df
```

```
# TODO: Paste your verification command outputs here as proof of completion
```

---

## 🏁 Conclusion

🎉 **Congratulations!** You have successfully completed **Lab 2: Understanding Docker Images**.

### ✅ Key Achievements
- 🔍 **Explored Docker Hub:** You learned how to search for and evaluate Docker images both through the web interface and command line
- 🗂️ **Mastered Image Management:** You can now pull, list, tag, and remove Docker images efficiently
- 🧱 **Understood Image Layers:** You gained insight into Docker's layered architecture and how it optimizes storage and performance
- ✅ **Applied Best Practices:** You learned how to use specific tags, manage disk space, and maintain a clean Docker environment

### 🌍 Why This Matters

Docker images are the foundation of containerization. Understanding how to work with images effectively is crucial because:

- 🎯 **Consistency:** Using specific image tags ensures your applications run the same way across different environments
- ⚡ **Efficiency:** Understanding layers helps you optimize image sizes and build times
- 🔒 **Security:** Knowing how to manage and update images helps maintain secure deployments
- 💾 **Resource Management:** Proper image cleanup prevents disk space issues in production environments

### 🚀 Next Steps

With this foundation in Docker images, you're now ready to:

- 🏗️ Create your own custom Docker images using Dockerfiles
- 🧩 Build multi-stage images for optimized production deployments
- 🔒 Implement image scanning and security practices
- 🔐 Work with private image registries

The skills you've learned in this lab are directly applicable to the **Docker Certified Associate (DCA)** certification and real-world container deployments. You now have the knowledge to make informed decisions about image selection, management, and optimization in your containerization journey.

---

<div align="center">

### 🐳 Well done on completing Lab 2!

You're building the core skills of the containerization revolution.

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Education-blueviolet?style=for-the-badge)

</div>
