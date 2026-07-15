<div align="center">

# 📦 Working with Containers

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![DevOps](https://img.shields.io/badge/DevOps-000000?style=for-the-badge&logo=devdotto&logoColor=white)
![DCA](https://img.shields.io/badge/DCA-Certification%20Aligned-blue?style=for-the-badge)
![Level](https://img.shields.io/badge/Level-Intermediate-brightgreen?style=for-the-badge)

**A hands-on lab covering container creation, access, inspection, and lifecycle management**

</div>

---

## 📚 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🆕 Task 1: Create a New Container from an Image](#-task-1-create-a-new-container-from-an-image)
- [⌨️ Task 2: Access the Container Using Docker Exec](#️-task-2-access-the-container-using-docker-exec)
- [🔬 Task 3: Inspect Container Details](#-task-3-inspect-container-details)
- [🗑️ Task 4: Stop and Remove Containers](#️-task-4-stop-and-remove-containers)
- [🔄 Task 5: Restart a Container and Explore Its State](#-task-5-restart-a-container-and-explore-its-state)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🧹 Lab Cleanup](#-lab-cleanup)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | 🆕 Create and run Docker containers from images |
| 2 | ⌨️ Access running containers using interactive commands |
| 3 | 🔬 Inspect container details and configurations |
| 4 | 🔄 Manage container lifecycle (start, stop, remove) |
| 5 | 📊 Understand container states and their implications |
| 6 | 🎓 Apply fundamental container management skills for Docker Certified Associate (DCA) certification |

---

## ✅ Prerequisites

| Requirement | Status |
|---|---|
| Basic understanding of Docker concepts (images, containers, Docker daemon) | Required |
| Familiarity with Linux command-line interface | Required |
| Completion of previous Docker labs or equivalent knowledge | Required |
| Understanding of basic system administration concepts | Required |

> **☁️ Note:** Al Nafi provides pre-configured Linux-based cloud machines with Docker already installed. Simply click **Start Lab** to access your environment — no need to build your own VM or install Docker manually.

---

## 🖥️ Lab Environment Setup

**Your Al Nafi cloud machine comes with:**

- 🐧 Ubuntu Linux operating system
- 🐳 Docker Engine pre-installed and configured
- 🔑 All necessary permissions configured for the lab user
- 🌐 Internet connectivity for downloading Docker images

To verify your environment is ready, run:

```bash
docker --version  # 🔎 confirm Docker CLI version
docker info        # ℹ️ confirm daemon and system details
```

---

## 🆕 Task 1: Create a New Container from an Image

### 1️⃣ Subtask 1.1: Understanding the Docker Run Command

The `docker run` command creates and starts a new container from a specified image. The `-d` flag runs the container in detached mode (in the background).

### 2️⃣ Subtask 1.2: Create an Ubuntu Container

Execute the following command to create a new Ubuntu container:

```bash
docker run -d --name my-ubuntu-container ubuntu sleep 3600  # 🆕 create a detached, long-running container
```

**Command Breakdown:**
- `docker run`: Creates and starts a new container
- `-d`: Runs container in detached mode (background)
- `--name my-ubuntu-container`: Assigns a custom name to the container
- `ubuntu`: Specifies the Ubuntu image to use
- `sleep 3600`: Keeps the container running for 1 hour (3600 seconds)

### 3️⃣ Subtask 1.3: Verify Container Creation

Check that your container is running:

```bash
docker ps  # ✅ list running containers
```

You should see output similar to:
```
CONTAINER ID   IMAGE     COMMAND        CREATED         STATUS         PORTS     NAMES
abc123def456   ubuntu    "sleep 3600"   2 minutes ago   Up 2 minutes             my-ubuntu-container
```

### 4️⃣ Subtask 1.4: Alternative Container Creation

Create another container without the sleep command to see different behavior:

```bash
docker run -d --name short-lived-ubuntu ubuntu  # ⚡ no long-running process
```

Check the status:
```bash
docker ps -a  # 📜 view all containers, including exited ones
```

> **Note:** This container will exit immediately because Ubuntu containers need a running process to stay active.

```
# TODO: Explain in your own words why short-lived-ubuntu exited immediately
```

---

## ⌨️ Task 2: Access the Container Using Docker Exec

### 1️⃣ Subtask 2.1: Understanding Docker Exec

The `docker exec` command allows you to run commands inside a running container. This is essential for debugging, maintenance, and interactive work.

### 2️⃣ Subtask 2.2: Access the Running Container

Connect to your running Ubuntu container:

```bash
docker exec -it my-ubuntu-container /bin/bash  # ⌨️ open an interactive shell
```

**Command Breakdown:**
- `docker exec`: Executes a command in a running container
- `-it`: Combines `-i` (interactive) and `-t` (pseudo-TTY) for terminal access
- `my-ubuntu-container`: The name of your target container
- `/bin/bash`: The command to execute (Bash shell)

### 3️⃣ Subtask 2.3: Explore Inside the Container

Once inside the container, try these commands:

```bash
# Check the operating system
cat /etc/os-release   # 🐧 OS details

# List current directory contents
ls -la                 # 📂 list files

# Check running processes
ps aux                 # ⚙️ view processes

# Create a test file
echo "Hello from inside the container" > /tmp/test.txt   # 📝 write test file

# Verify the file was created
cat /tmp/test.txt      # 👀 confirm file content

# Exit the container
exit                    # 🚪 leave the shell
```

### 4️⃣ Subtask 2.4: Execute Single Commands

You can also execute single commands without entering interactive mode:

```bash
# Check container's hostname
docker exec my-ubuntu-container hostname          # 🏷️ hostname check

# List files in /tmp directory
docker exec my-ubuntu-container ls -la /tmp        # 📂 list /tmp contents

# Display the test file we created earlier
docker exec my-ubuntu-container cat /tmp/test.txt  # 👀 view file content
```

---

## 🔬 Task 3: Inspect Container Details

### 1️⃣ Subtask 3.1: Understanding Docker Inspect

The `docker inspect` command provides detailed information about containers, including configuration, network settings, and runtime details.

### 2️⃣ Subtask 3.2: Inspect Your Container

Get detailed information about your container:

```bash
docker inspect my-ubuntu-container  # 🔬 full JSON metadata
```

This command returns a JSON object with comprehensive container details.

### 3️⃣ Subtask 3.3: Extract Specific Information

Use formatting options to extract specific details:

```bash
# Get container's IP address
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my-ubuntu-container  # 🌐 IP address

# Get container's state
docker inspect --format='{{.State.Status}}' my-ubuntu-container   # 📊 current state

# Get container's image
docker inspect --format='{{.Config.Image}}' my-ubuntu-container   # 🖼️ source image

# Get container's creation time
docker inspect --format='{{.Created}}' my-ubuntu-container         # 📅 creation timestamp
```

### 4️⃣ Subtask 3.4: Inspect Multiple Containers

You can inspect multiple containers simultaneously:

```bash
docker inspect my-ubuntu-container short-lived-ubuntu  # 🔬 inspect several at once
```

```
# TODO: Record the IP address and state of my-ubuntu-container here
```

---

## 🗑️ Task 4: Stop and Remove Containers

### 1️⃣ Subtask 4.1: Understanding Container Lifecycle

Containers have several states:
- ▶️ **Running:** Container is actively executing
- ⏹️ **Stopped:** Container has been stopped but still exists
- 🗑️ **Removed:** Container has been deleted from the system

### 2️⃣ Subtask 4.2: Stop a Running Container

Stop your running container:

```bash
docker stop my-ubuntu-container  # ⏹️ stop the container
```

Verify the container is stopped:
```bash
docker ps -a  # 📜 confirm status
```

The STATUS column should show `Exited` for your container.

### 3️⃣ Subtask 4.3: Remove a Stopped Container

Remove the stopped container:

```bash
docker rm my-ubuntu-container  # 🗑️ remove the stopped container
```

Verify the container is removed:
```bash
docker ps -a  # 📜 confirm removal
```

The container should no longer appear in the list.

### 4️⃣ Subtask 4.4: Force Remove a Running Container

Create a new container and remove it while running:

```bash
# Create a new container
docker run -d --name test-container ubuntu sleep 1800  # 🆕 new test container

# Force remove the running container
docker rm -f test-container  # 💥 force remove

# Verify removal
docker ps -a  # 📜 confirm removal
```

> **Note:** The `-f` flag forces removal of running containers by stopping them first.

### 5️⃣ Subtask 4.5: Clean Up Multiple Containers

Remove multiple containers at once:

```bash
# Create several test containers
docker run -d --name container1 ubuntu sleep 300
docker run -d --name container2 ubuntu sleep 300
docker run -d --name container3 ubuntu sleep 300

# Remove all three containers
docker rm -f container1 container2 container3  # 🗑️ batch removal
```

---

## 🔄 Task 5: Restart a Container and Explore Its State

### 1️⃣ Subtask 5.1: Create a Persistent Container

Create a new container that we'll use to demonstrate restart functionality:

```bash
docker run -d --name persistent-container ubuntu sleep 7200  # 🆕 long-running container
```

### 2️⃣ Subtask 5.2: Create Data Inside the Container

Add some data to the container:

```bash
# Access the container
docker exec -it persistent-container /bin/bash  # ⌨️ enter the container

# Inside the container, create some files
echo "This is persistent data" > /home/data.txt              # 📝 file 1
echo "Container restart test" > /home/restart-test.txt        # 📝 file 2
mkdir /home/test-directory                                     # 📁 new directory
echo "Directory content" > /home/test-directory/file.txt      # 📝 file 3

# Exit the container
exit  # 🚪 leave the shell
```

### 3️⃣ Subtask 5.3: Stop the Container

Stop the container:

```bash
docker stop persistent-container  # ⏹️ stop it
```

Verify it's stopped:
```bash
docker ps -a  # 📜 confirm stopped state
```

### 4️⃣ Subtask 5.4: Restart the Container

Restart the stopped container:

```bash
docker start persistent-container  # ▶️ start it back up
```

Verify it's running:
```bash
docker ps  # ✅ confirm running state
```

### 5️⃣ Subtask 5.5: Verify Data Persistence

Check if the data we created earlier still exists:

```bash
# Check if files still exist
docker exec persistent-container ls -la /home/  # 📂 list /home contents

# Display file contents
docker exec persistent-container cat /home/data.txt              # 👀 file 1
docker exec persistent-container cat /home/restart-test.txt      # 👀 file 2
docker exec persistent-container ls -la /home/test-directory/    # 📂 directory contents
```

> **🔑 Key Observation:** Data created in the container's filesystem persists across container stops and starts, but will be lost if the container is removed.

### 6️⃣ Subtask 5.6: Explore Container State Changes

Monitor how container states change:

```bash
# Check current state
docker inspect --format='{{.State.Status}}' persistent-container  # 📊 state check

# Stop the container
docker stop persistent-container  # ⏹️ stop

# Check state after stopping
docker inspect --format='{{.State.Status}}' persistent-container  # 📊 state check

# Start the container again
docker start persistent-container  # ▶️ start

# Check state after starting
docker inspect --format='{{.State.Status}}' persistent-container  # 📊 state check
```

### 7️⃣ Subtask 5.7: Understanding Container Restart Policies

Create containers with different restart policies:

```bash
# Container that restarts automatically
docker run -d --name auto-restart --restart=always ubuntu sleep 60  # 🔁 always restart

# Container that restarts on failure
docker run -d --name restart-on-failure --restart=on-failure ubuntu sleep 60  # ⚠️ restart on failure only

# Check restart policies
docker inspect --format='{{.HostConfig.RestartPolicy.Name}}' auto-restart          # 🔎 policy check
docker inspect --format='{{.HostConfig.RestartPolicy.Name}}' restart-on-failure    # 🔎 policy check
```

```
# TODO: Note the difference in behavior between the two restart policies
```

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>❗ Issue 1: Container Exits Immediately</summary>

**Problem:** Container stops right after creation.

**Solution:** Ensure the container has a long-running process
```bash
# Instead of this (exits immediately)
docker run -d ubuntu

# Use this (stays running)
docker run -d ubuntu sleep 3600
```
</details>

<details>
<summary>❗ Issue 2: Cannot Access Container with Exec</summary>

**Problem:** `docker exec` fails with "container not running".

**Solution:** Verify container is running first
```bash
# Check container status
docker ps -a

# If stopped, start it first
docker start container-name

# Then use exec
docker exec -it container-name /bin/bash
```
</details>

<details>
<summary>❗ Issue 3: Permission Denied Errors</summary>

**Problem:** Cannot perform certain operations inside container.

**Solution:** Some operations require root privileges
```bash
# Run exec as root user
docker exec -it --user root container-name /bin/bash
```
</details>

<details>
<summary>❗ Issue 4: Container Name Already Exists</summary>

**Problem:** Error when creating container with existing name.

**Solution:** Remove the existing container or use a different name
```bash
# Remove existing container
docker rm container-name

# Or use a different name
docker run -d --name new-container-name ubuntu sleep 3600
```
</details>

---

## 🧹 Lab Cleanup

Before finishing the lab, clean up all created containers:

```bash
# Stop all running containers
docker stop $(docker ps -q)  # ⏹️ stop everything running

# Remove all containers
docker rm $(docker ps -aq)  # 🗑️ remove everything

# Verify cleanup
docker ps -a  # ✅ confirm clean state
```

---

## 🏁 Conclusion

🎉 In this lab, you have successfully learned fundamental container management skills in Docker.

### ✅ Key Skills Developed
- 🆕 Created containers from images using `docker run` with various options
- ⌨️ Accessed running containers interactively using `docker exec`
- 🔬 Inspected container details and extracted specific information using `docker inspect`
- 🔄 Managed container lifecycle through stop, start, and remove operations
- 📊 Understood container state persistence and restart behavior

### 🌍 Why This Matters

Container management is a core skill for modern DevOps and cloud computing. These fundamental operations form the foundation for:

- 🚀 **Application Deployment:** Running applications in isolated, portable environments
- 🔁 **Development Workflows:** Creating consistent development environments
- 🧩 **Microservices Architecture:** Managing multiple containerized services
- ☁️ **Cloud Migration:** Moving applications to container-based cloud platforms
- 🎓 **Docker Certification:** These skills are essential for Docker Certified Associate (DCA) certification

### 🚀 Next Steps

With these container management skills, you're prepared to explore more advanced topics such as:

- 🌐 Container networking and port mapping
- 💾 Volume management and data persistence
- 🧩 Multi-container applications with Docker Compose
- ☸️ Container orchestration with Kubernetes
- 🚀 Production deployment strategies

The hands-on experience gained in this lab provides a solid foundation for working with containerized applications in real-world scenarios.

---

<div align="center">

### 🐳 Well done on completing Lab 3!

You're mastering the container lifecycle — one of Docker's most essential skills.

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Education-blueviolet?style=for-the-badge)

</div>
