<div align="center">

# 🌐 Docker Networking Basics

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Networking](https://img.shields.io/badge/Networking-4A90D9?style=for-the-badge&logo=cisco&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Alpine](https://img.shields.io/badge/Alpine%20Linux-0D597F?style=for-the-badge&logo=alpinelinux&logoColor=white)
![DCA](https://img.shields.io/badge/DCA-Certification%20Aligned-blue?style=for-the-badge)
![Level](https://img.shields.io/badge/Level-Intermediate-brightgreen?style=for-the-badge)

**A hands-on lab exploring Docker's bridge networks, custom networks, and container communication**

</div>

---

## 📚 Table of Contents

- [🎯 Objectives](#-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🌉 Task 1: Understanding Docker's Default Bridge Network](#-task-1-understanding-dockers-default-bridge-network)
- [👥 Task 2: Running Multiple Containers on the Same Network](#-task-2-running-multiple-containers-on-the-same-network)
- [🛠️ Task 3: Creating and Managing Custom Networks](#️-task-3-creating-and-managing-custom-networks)
- [🏷️ Task 4: Using --network Flag to Specify Networks](#️-task-4-using---network-flag-to-specify-networks)
- [🔗 Task 5: Advanced Container Communication and Network Management](#-task-5-advanced-container-communication-and-network-management)
- [🚨 Troubleshooting Common Issues](#-troubleshooting-common-issues)
- [📖 Key Networking Commands Reference](#-key-networking-commands-reference)
- [✅ Best Practices for Docker Networking](#-best-practices-for-docker-networking)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | 🌉 Understand Docker's default bridge network and how it works |
| 2 | 🛠️ Create and manage custom Docker networks |
| 3 | 👥 Connect multiple containers to the same network |
| 4 | 🔎 Use Docker networking commands to inspect and manage networks |
| 5 | 📡 Configure container communication using internal networking |
| 6 | 🚨 Troubleshoot basic Docker networking issues |

---

## ✅ Prerequisites

| Requirement | Status |
|---|---|
| Basic understanding of Docker containers and images | Required |
| Familiarity with command-line interface (CLI) | Required |
| Completed previous Docker labs or equivalent knowledge | Required |
| Understanding of basic networking concepts (IP addresses, ports) | Required |

---

## 🖥️ Lab Environment Setup

> **☁️ Al Nafi Cloud Machines:** This lab uses Al Nafi's pre-configured Linux-based cloud machines. Simply click **Start Lab** to access your environment — no need to build your own VM or install Docker manually.

**Your cloud machine comes with:**

- 🐳 Docker Engine pre-installed and configured
- 🌐 All necessary networking tools
- 🔑 Root/sudo access for Docker commands

---

## 🌉 Task 1: Understanding Docker's Default Bridge Network

### 1️⃣ Subtask 1.1: Explore the Default Bridge Network

Docker automatically creates a default bridge network when installed. Let's examine this network.

**Step 1:** List all Docker networks
```bash
docker network ls  # 📋 list all networks
```

You should see output similar to:
```
NETWORK ID     NAME      DRIVER    SCOPE
abcd1234efgh   bridge    bridge    local
ijkl5678mnop   host      host      local
qrst9012uvwx   none      null      local
```

**Step 2:** Inspect the default bridge network
```bash
docker network inspect bridge  # 🔬 detailed network info
```

This command shows detailed information about the bridge network, including:
- 📐 **Subnet:** The IP range assigned to containers
- 🚪 **Gateway:** The gateway IP address
- 📦 **Connected containers:** Currently running containers on this network

### 2️⃣ Subtask 1.2: Run a Container on the Default Network

**Step 1:** Run a simple container on the default bridge network
```bash
docker run -d --name web-server-1 nginx:alpine  # 🌐 launch nginx on bridge network
```

**Step 2:** Verify the container is running
```bash
docker ps  # ✅ confirm it's running
```

**Step 3:** Inspect the bridge network again to see the connected container
```bash
docker network inspect bridge  # 🔬 view connected containers
```

Look for the `Containers` section to see your `web-server-1` container listed with its assigned IP address.

```
# TODO: Record web-server-1's assigned IP address here
```

---

## 👥 Task 2: Running Multiple Containers on the Same Network

### 1️⃣ Subtask 2.1: Create Multiple Containers on Default Network

**Step 1:** Run a second nginx container
```bash
docker run -d --name web-server-2 nginx:alpine  # 🌐 second nginx container
```

**Step 2:** Run a third container with a different image (Alpine Linux)
```bash
docker run -d --name alpine-client alpine:latest sleep 3600  # 🏔️ Alpine client container
```

**Step 3:** Verify all containers are running
```bash
docker ps  # ✅ confirm all three are up
```

**Step 4:** Check the bridge network to see all connected containers
```bash
docker network inspect bridge  # 🔬 view all connections
```

### 2️⃣ Subtask 2.2: Test Container Communication

**Step 1:** Get the IP address of web-server-1
```bash
docker inspect web-server-1 | grep IPAddress  # 🔎 find its IP
```

**Step 2:** Test connectivity from alpine-client to web-server-1
```bash
docker exec alpine-client ping -c 3 <IP_ADDRESS_OF_WEB_SERVER_1>  # 📡 ping test
```
Replace `<IP_ADDRESS_OF_WEB_SERVER_1>` with the actual IP address from Step 1.

**Step 3:** Test HTTP connectivity
```bash
docker exec alpine-client wget -qO- http://<IP_ADDRESS_OF_WEB_SERVER_1>  # 🌐 HTTP test
```

You should see the default nginx welcome page HTML content. 🎉

---

## 🛠️ Task 3: Creating and Managing Custom Networks

### 1️⃣ Subtask 3.1: Create a Custom Bridge Network

**Step 1:** Create a custom network named `app-network`
```bash
docker network create app-network  # 🆕 create custom bridge network
```

**Step 2:** List networks to confirm creation
```bash
docker network ls  # 📋 confirm app-network exists
```

You should now see your `app-network` in the list.

**Step 3:** Inspect the custom network
```bash
docker network inspect app-network  # 🔬 view configuration
```

### 2️⃣ Subtask 3.2: Create Additional Network Types

**Step 1:** Create a custom network with specific subnet
```bash
docker network create --driver bridge --subnet=192.168.100.0/24 custom-subnet-network  # 📐 custom subnet
```

**Step 2:** Verify the network creation
```bash
docker network inspect custom-subnet-network  # 🔬 view subnet config
```

Notice the custom subnet configuration in the `IPAM` section.

```
# TODO: Note the gateway address assigned to custom-subnet-network
```

---

## 🏷️ Task 4: Using --network Flag to Specify Networks

### 1️⃣ Subtask 4.1: Run Containers on Custom Network

**Step 1:** Run a container on the custom app-network
```bash
docker run -d --name app-server-1 --network app-network nginx:alpine  # 🌐 first app server
```

**Step 2:** Run a second container on the same custom network
```bash
docker run -d --name app-server-2 --network app-network nginx:alpine  # 🌐 second app server
```

**Step 3:** Run a client container on the custom network
```bash
docker run -d --name app-client --network app-network alpine:latest sleep 3600  # 🏔️ client container
```

### 2️⃣ Subtask 4.2: Test Custom Network Communication

**Step 1:** Test connectivity using container names (DNS resolution)
```bash
docker exec app-client ping -c 3 app-server-1  # 📡 ping by name
```

**Step 2:** Test HTTP connectivity using container names
```bash
docker exec app-client wget -qO- http://app-server-1  # 🌐 HTTP by name
```

> **⚠️ Important Note:** On custom networks, containers can communicate using container names as hostnames, which is not available on the default bridge network.

### 3️⃣ Subtask 4.3: Compare Network Isolation

**Step 1:** Try to ping a container on the default network from custom network
```bash
docker exec app-client ping -c 3 web-server-1  # 🚫 cross-network ping
```

This should fail, demonstrating network isolation between different Docker networks. 🔒

---

## 🔗 Task 5: Advanced Container Communication and Network Management

### 1️⃣ Subtask 5.1: Connect Containers to Multiple Networks

**Step 1:** Connect an existing container to an additional network
```bash
docker network connect app-network alpine-client  # 🔗 attach to second network
```

**Step 2:** Verify the connection
```bash
docker network inspect app-network  # 🔬 confirm connection
```

**Step 3:** Test connectivity from the multi-network container
```bash
docker exec alpine-client ping -c 3 app-server-1  # 📡 test new connection
```

### 2️⃣ Subtask 5.2: Port Mapping and External Access

**Step 1:** Run a container with port mapping
```bash
docker run -d --name web-public --network app-network -p 8080:80 nginx:alpine  # 🚪 map host port 8080
```

**Step 2:** Test external access (from host)
```bash
curl http://localhost:8080  # 🌐 access from host machine
```

**Step 3:** Test internal network access
```bash
docker exec app-client wget -qO- http://web-public  # 🔗 access via container name
```

### 3️⃣ Subtask 5.3: Network Cleanup and Management

**Step 1:** Disconnect a container from a network
```bash
docker network disconnect app-network alpine-client  # ✂️ disconnect container
```

**Step 2:** Remove containers
```bash
docker stop web-server-1 web-server-2 alpine-client app-server-1 app-server-2 app-client web-public  # ⏹️ stop all
docker rm web-server-1 web-server-2 alpine-client app-server-1 app-server-2 app-client web-public     # 🗑️ remove all
```

**Step 3:** Remove custom networks
```bash
docker network rm app-network custom-subnet-network  # 🗑️ remove custom networks
```

**Step 4:** Verify cleanup
```bash
docker network ls  # ✅ confirm networks removed
docker ps -a        # ✅ confirm containers removed
```

```
# TODO: Confirm your environment is fully cleaned up before ending the lab
```

---

## 🚨 Troubleshooting Common Issues

<details>
<summary>❗ Issue 1: Container Cannot Communicate</summary>

**Symptoms:** Ping or HTTP requests fail between containers.

**Solutions:**
- Verify containers are on the same network: `docker network inspect <network_name>`
- Check container names and IP addresses
- Ensure containers are running: `docker ps`
</details>

<details>
<summary>❗ Issue 2: Network Already Exists Error</summary>

**Symptoms:** Error when creating network with existing name.

**Solutions:**
- List existing networks: `docker network ls`
- Use a different network name
- Remove existing network if not needed: `docker network rm <network_name>`
</details>

<details>
<summary>❗ Issue 3: Cannot Remove Network</summary>

**Symptoms:** Error when trying to remove network.

**Solutions:**
- Check for connected containers: `docker network inspect <network_name>`
- Stop and remove connected containers first
- Disconnect containers: `docker network disconnect <network_name> <container_name>`
</details>

---

## 📖 Key Networking Commands Reference

```bash
# Network Management
docker network ls                          # 📋 List all networks
docker network create <network_name>       # 🆕 Create new network
docker network rm <network_name>           # 🗑️ Remove network
docker network inspect <network_name>      # 🔬 Inspect network details

# Container Network Operations
docker run --network <network_name>        # 🌐 Run container on specific network
docker network connect <network> <container>     # 🔗 Connect container to network
docker network disconnect <network> <container>  # ✂️ Disconnect container from network

# Container Inspection
docker inspect <container_name>            # 🔎 Get container details including IP
docker exec <container> <command>          # ⌨️ Execute command in container
```

---

## ✅ Best Practices for Docker Networking

| Practice | Description |
|---|---|
| 🛠️ **Use Custom Networks** | Always create custom networks for multi-container applications instead of relying on the default bridge |
| 🏷️ **Meaningful Names** | Use descriptive names for networks and containers |
| 🧩 **Network Segmentation** | Separate different application tiers using different networks |
| 🔗 **DNS Resolution** | Leverage container name-based DNS resolution on custom networks |
| 🚪 **Port Mapping** | Only expose ports that need external access |
| 🧹 **Cleanup** | Regularly remove unused networks and containers |

---

## 🏁 Conclusion

🎉 In this lab, you have successfully learned the fundamentals of Docker networking. You explored Docker's default bridge network, created custom networks, and demonstrated container communication both within and across networks.

### ✅ Key Accomplishments
- 🌉 Understood how Docker's default bridge network operates
- 🛠️ Created and managed custom Docker networks
- 👥 Connected multiple containers to the same network
- 🔗 Used container names for DNS resolution on custom networks
- 🔒 Implemented network isolation and security
- 🚪 Managed port mapping for external access

### 🌍 Why This Matters

Docker networking is crucial for building scalable, secure containerized applications. Understanding these concepts enables you to design proper network architectures for microservices, implement security through network segmentation, and troubleshoot connectivity issues in containerized environments.

These skills are essential for the **Docker Certified Associate (DCA)** certification and real-world container orchestration scenarios. In production environments, proper networking configuration ensures your applications can communicate securely and efficiently while maintaining isolation between different services and environments.

---

<div align="center">

### 🐳 Well done on completing this networking lab!

You're now equipped to design secure, well-connected container architectures.

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Education-blueviolet?style=for-the-badge)

</div>
