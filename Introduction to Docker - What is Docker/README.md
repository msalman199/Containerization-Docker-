<div align="center">

# 🐳 Introduction to Docker - What is Docker?

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![DevOps](https://img.shields.io/badge/DevOps-000000?style=for-the-badge&logo=devdotto&logoColor=white)
![Level](https://img.shields.io/badge/Level-Beginner-brightgreen?style=for-the-badge)

**A hands-on, beginner-friendly lab introducing containerization with Docker**

</div>

---

## 📚 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🔧 Task 1: Install Docker on Linux Environment](#-task-1-install-docker-on-linux-environment)
- [📦 Task 2: Learn About Docker Containers and Images](#-task-2-learn-about-docker-containers-and-images)
- [🚀 Task 3: Run Your First Container](#-task-3-run-your-first-container)
- [⚖️ Task 4: Container vs Virtual Machine Differences](#️-task-4-container-vs-virtual-machine-differences)
- [⌨️ Task 5: Explore Docker CLI and Basic Commands](#️-task-5-explore-docker-cli-and-basic-commands)
- [📋 Essential Docker Commands Summary](#-essential-docker-commands-summary)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🏁 Lab Conclusion](#-lab-conclusion)
- [🎓 Certification Path](#-certification-path)

---

## 🎯 Lab Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | 🐳 Understand what Docker is and its core concepts |
| 2 | 🔍 Differentiate between Docker containers and images |
| 3 | ⚙️ Install Docker on a Linux environment |
| 4 | 💻 Execute basic Docker commands using the Docker CLI |
| 5 | ▶️ Run their first Docker container |
| 6 | ⚖️ Explain the key differences between containers and virtual machines |
| 7 | 🧭 Navigate the Docker ecosystem with confidence |

---

## ✅ Prerequisites

| Requirement | Status |
|---|---|
| Basic familiarity with Linux command line interface | Required |
| Understanding of fundamental computing concepts | Required |
| Prior Docker experience | ❌ Not required — beginner-friendly lab |

---

## 🖥️ Lab Environment Setup

> **☁️ Good News!** Al Nafi provides ready-to-use Linux-based cloud machines for this lab. Simply click **Start Lab** and you'll have access to a fully configured Ubuntu environment with internet connectivity. No need to build your own virtual machine or worry about system compatibility issues.

**Your cloud machine includes:**

- 🐧 Ubuntu 20.04 LTS or newer
- 🔑 Terminal access with sudo privileges
- 🌐 Internet connectivity for downloading Docker

---

## 🔧 Task 1: Install Docker on Linux Environment

### 1️⃣ Subtask 1.1: Update System Packages

First, let's ensure your system is up to date with the latest packages.

```bash
sudo apt update      # 🔄 refresh the package list from repositories
sudo apt upgrade -y  # ⬆️ install available updates automatically
```

**What's happening here?**
- `apt update` refreshes the package list from repositories
- `apt upgrade -y` installs available updates automatically

### 2️⃣ Subtask 1.2: Install Required Dependencies

Install packages that allow apt to use repositories over HTTPS:

```bash
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release  # 📦 HTTPS transport tools
```

### 3️⃣ Subtask 1.3: Add Docker's Official GPG Key

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg  # 🔐 import Docker's signing key
```

### 4️⃣ Subtask 1.4: Set Up Docker Repository

```bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null  # 🗂️ register Docker's repo
```

### 5️⃣ Subtask 1.5: Install Docker Engine

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io  # 🐳 install Docker Engine
```

### 6️⃣ Subtask 1.6: Verify Docker Installation

Check if Docker is installed and running:

```bash
sudo systemctl status docker  # ✅ confirm the daemon is active
```

You should see output indicating that Docker is `active (running)`.

### 7️⃣ Subtask 1.7: Add User to Docker Group

To run Docker commands without sudo, add your user to the docker group:

```bash
sudo usermod -aG docker $USER  # 👤 grant your user Docker permissions
```

> ⚠️ **Important:** Log out and log back in for this change to take effect, or run:
```bash
newgrp docker  # 🔁 refresh group membership in current session
```

### 8️⃣ Subtask 1.8: Test Docker Installation

```bash
docker --version  # 🔎 confirm installed version
```

You should see output similar to:
```
Docker version 24.0.x, build xxxxxxx
```

```
# TODO: Paste your actual `docker --version` output here as proof of installation
```

---

## 📦 Task 2: Learn About Docker Containers and Images

### 🖼️ Subtask 2.1: Understanding Docker Images

Docker Images are like blueprints or templates. Think of them as:

- 📄 A recipe for creating containers
- 🔒 Read-only templates containing application code, libraries, and dependencies
- 🧱 Stored in layers for efficiency

### 📦 Subtask 2.2: Understanding Docker Containers

Docker Containers are running instances of images. Think of them as:

- ▶️ A running application created from an image
- 🧩 Isolated processes with their own file system
- 🪶 Lightweight and portable across different environments

### 🍪 Subtask 2.3: The Relationship Between Images and Containers

> **Analogy:** If a Docker image is like a cookie cutter 🍪, then containers are the actual cookies made from that cutter. You can make many cookies (containers) from one cookie cutter (image).

---

## 🚀 Task 3: Run Your First Container

### ▶️ Subtask 3.1: Execute the Hello World Container

Let's run the classic first Docker command:

```bash
docker run hello-world  # 👋 pull and run the hello-world image
```

**What happens when you run this command?**
1. 🔍 Docker looks for the `hello-world` image locally
2. ⬇️ If not found, it downloads the image from Docker Hub
3. 🆕 Creates a new container from the image
4. ▶️ Runs the container
5. 💬 The container displays a welcome message and exits

### 🔬 Subtask 3.2: Analyze the Output

You should see output similar to:
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

**To generate this message, Docker took the following steps:**
1. 📡 The Docker client contacted the Docker daemon
2. ⬇️ The Docker daemon pulled the "hello-world" image from Docker Hub
3. 🏗️ The Docker daemon created a new container from that image, running the executable that produces the output
4. 🖥️ The Docker daemon streamed that output to the Docker client, which sent it to your terminal

🎉 **Congratulations!** You've successfully run your first Docker container.

```
# TODO: Paste a screenshot or copy of your "Hello from Docker!" output here
```

---

## ⚖️ Task 4: Container vs Virtual Machine Differences

### 📊 Subtask 4.1: Key Differences Overview

| Aspect | 🖥️ Virtual Machines | 🐳 Docker Containers |
|---|---|---|
| **Resource Usage** | Heavy (GB of RAM) | Lightweight (MB of RAM) |
| **Startup Time** | Minutes | Seconds |
| **Isolation** | Complete OS isolation | Process-level isolation |
| **Portability** | Limited | Highly portable |
| **Host OS** | Runs multiple full OS | Shares host OS kernel |

### 🧩 Subtask 4.2: Visual Understanding

**🖥️ Virtual Machines:**
- Each VM includes a full operating system
- Hypervisor manages multiple VMs
- Higher resource overhead

**🐳 Docker Containers:**
- Share the host OS kernel
- Docker Engine manages containers
- Minimal resource overhead

### 🤔 Subtask 4.3: When to Use Each

**Use Virtual Machines when:**
- 🔒 You need complete isolation
- 🖥️ Running different operating systems
- 🕰️ Legacy applications requiring specific OS versions

**Use Docker Containers when:**
- ⚡ You want fast deployment
- 🧩 Microservices architecture
- 🔁 Development environment consistency
- 🔄 CI/CD pipelines

---

## ⌨️ Task 5: Explore Docker CLI and Basic Commands

### 📋 Subtask 5.1: List Running Containers

```bash
docker ps  # 📋 list currently running containers
```

Since `hello-world` exited immediately, you'll likely see an empty list.

### 📜 Subtask 5.2: List All Containers (Including Stopped)

```bash
docker ps -a  # 📜 list all containers, including exited ones
```

Now you should see the `hello-world` container with status "Exited".

### 🖼️ Subtask 5.3: List Docker Images

```bash
docker images  # 🖼️ display all images stored locally
```

You should see the `hello-world` image.

### ℹ️ Subtask 5.4: Get Detailed Information About Docker

```bash
docker info  # ℹ️ comprehensive Docker installation info
```

### 💻 Subtask 5.5: Run an Interactive Container

Let's run a more interactive container:

```bash
docker run -it ubuntu:latest /bin/bash  # 💻 launch interactive Ubuntu shell
```

**Command breakdown:**
- `-i`: Interactive mode
- `-t`: Allocate a pseudo-TTY
- `ubuntu:latest`: Use the latest Ubuntu image
- `/bin/bash`: Run bash shell

You're now inside a Ubuntu container! Try some commands:

```bash
ls                     # 📂 list files
pwd                    # 📍 print working directory
cat /etc/os-release    # 🐧 show OS details
```

To exit the container:

```bash
exit  # 🚪 leave the container shell
```

### 🌐 Subtask 5.6: Run a Container in Background

```bash
docker run -d --name my-nginx nginx:latest  # 🌐 run Nginx in detached mode
```

**Command breakdown:**
- `-d`: Run in detached mode (background)
- `--name my-nginx`: Give the container a custom name
- `nginx:latest`: Use the latest Nginx web server image

### 🔎 Subtask 5.7: Check Running Containers Again

```bash
docker ps  # 🔎 verify Nginx is running
```

You should now see the Nginx container running.

### ⏹️ Subtask 5.8: Stop a Running Container

```bash
docker stop my-nginx  # ⏹️ stop the running container
```

### 🗑️ Subtask 5.9: Remove a Container

```bash
docker rm my-nginx  # 🗑️ delete the stopped container
```

### 🧹 Subtask 5.10: Remove an Image

```bash
docker rmi hello-world  # 🧹 delete an unused image
```

> **Note:** You can only remove images that aren't being used by any containers.

```
# TODO: Document any additional images/containers you experimented with here
```

---

## 📋 Essential Docker Commands Summary

| Command | Purpose |
|---|---|
| `docker run <image>` | ▶️ Create and run a new container |
| `docker ps` | 📋 List running containers |
| `docker ps -a` | 📜 List all containers |
| `docker images` | 🖼️ List local images |
| `docker stop <container>` | ⏹️ Stop a running container |
| `docker rm <container>` | 🗑️ Remove a container |
| `docker rmi <image>` | 🧹 Remove an image |
| `docker info` | ℹ️ Display system information |

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>❗ Issue 1: Permission Denied</summary>

**Problem:** Getting permission denied errors when running Docker commands.

**Solution:**
```bash
sudo usermod -aG docker $USER
newgrp docker
```
</details>

<details>
<summary>❗ Issue 2: Docker Daemon Not Running</summary>

**Problem:** Error message about Docker daemon not running.

**Solution:**
```bash
sudo systemctl start docker
sudo systemctl enable docker
```
</details>

<details>
<summary>❗ Issue 3: Image Download Fails</summary>

**Problem:** Cannot download images from Docker Hub.

**Solution:** Check internet connectivity and try again:
```bash
ping google.com
docker run hello-world
```
</details>

---

## 🏁 Lab Conclusion

🎉 **Congratulations!** You have successfully completed your introduction to Docker.

### ✅ Key Achievements
- ⚙️ Installed Docker on a Linux environment using official repositories
- 📦 Learned fundamental concepts of containers and images
- ▶️ Ran your first container using the hello-world image
- ⚖️ Understood the differences between containers and virtual machines
- ⌨️ Mastered basic Docker CLI commands for managing containers and images

### 🌍 Why This Matters

Docker has revolutionized how applications are developed, shipped, and deployed. The skills you've learned today form the foundation for:

- 🔧 Modern DevOps practices
- 🧩 Microservices architecture
- ☁️ Cloud-native development
- 🔁 Consistent development environments
- 🚀 Efficient application deployment

### 🚀 Next Steps

Now that you understand Docker basics, you're ready to:

- 🏗️ Explore creating custom Docker images
- 🧩 Learn about Docker Compose for multi-container applications
- 🌐 Understand Docker networking and volumes
- 📦 Practice with real-world application containerization

---

## 🎓 Certification Path

This lab aligns with the **Docker Certified Associate (DCA)** certification objectives, specifically:

| Domain | Exam Weight |
|---|---|
| 🧩 Domain 1: Orchestration | 25% |
| 🖼️ Domain 2: Image Creation, Management, and Registry | 20% |
| 💾 Domain 6: Storage and Volumes | 10% |

> Keep practicing these fundamental concepts as they are essential building blocks for advanced Docker topics and professional certification success.

---

<div align="center">

### 🐳 Well done on completing your first Docker lab!

You're now part of the containerization revolution that's transforming modern software development.

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Education-blueviolet?style=for-the-badge)

</div>
