<div align="center">

# 🐝 Introduction to Docker Swarm

### Cluster Orchestration, Multi-Node Scaling, and High Availability

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Swarm](https://img.shields.io/badge/Docker_Swarm-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-CB171E?style=for-the-badge&logo=yaml&logoColor=white)

</div>

---

## 📖 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🚀 Task 1: Initialize a Docker Swarm Cluster](#-task-1-initialize-a-docker-swarm-cluster)
- [➕ Task 2: Add Additional Nodes to the Cluster](#-task-2-add-additional-nodes-to-the-cluster)
- [📦 Task 3: Deploy a Multi-Container Service Using Docker Stack](#-task-3-deploy-a-multi-container-service-using-docker-stack)
- [📈 Task 4: Scale Services Within the Swarm](#-task-4-scale-services-within-the-swarm)
- [🔍 Task 5: Inspect the State of Services and Nodes](#-task-5-inspect-the-state-of-services-and-nodes)
- [🧪 Advanced Operations](#-advanced-operations)
- [🧹 Cleanup](#-cleanup)
- [🛠️ Troubleshooting Tips](#️-troubleshooting-tips)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

| # | Skill |
|---|-------|
| 1️⃣ | Understand the fundamentals of Docker Swarm orchestration |
| 2️⃣ | Initialize a Docker Swarm cluster using `docker swarm init` |
| 3️⃣ | Add worker nodes to a Swarm cluster using `docker swarm join` |
| 4️⃣ | Deploy multi-container applications using Docker Stack |
| 5️⃣ | Scale services within a Swarm cluster |
| 6️⃣ | Monitor and inspect Swarm services and nodes |
| 7️⃣ | Understand the benefits of container orchestration for production environments |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker Basics | Understanding of Docker containers and images |
| 💻 Docker CLI | Familiarity with Docker CLI commands |
| 📄 YAML | Knowledge of YAML file structure |
| 🌐 Networking | Understanding of basic networking concepts |
| 🐧 Linux CLI | Experience with Linux command line operations |

---

## 🖥️ Lab Environment Setup

> ℹ️ **Ready-to-Use Cloud Machines:** Al Nafi provides pre-configured Linux-based cloud machines for this lab. Simply click **"Start Lab"** to access your environment — no need to build your own virtual machines or install Docker manually.

Your lab environment includes:

- ✅ 3 Ubuntu Linux machines with Docker pre-installed
- 🧑‍✈️ **Machine 1:** `manager` (will serve as Swarm manager)
- 👷 **Machine 2:** `worker1` (will serve as Swarm worker)
- 👷 **Machine 3:** `worker2` (will serve as Swarm worker)
- 🌐 All necessary networking configured between machines

---

## 🚀 Task 1: Initialize a Docker Swarm Cluster

### 📚 Understanding Docker Swarm

Docker Swarm is Docker's native clustering and orchestration solution. It allows you to create and manage a cluster of Docker nodes, providing high availability, load balancing, and service discovery for your containerized applications.

### 🔹 Subtask 1.1: Connect to the Manager Node

1. Access your `manager` machine through the provided terminal
2. **Verify Docker is running and check the version:**
```bash
docker --version   # 🐳 version check
docker info         # ℹ️ daemon info
```
3. **Check the current Swarm status:**
```bash
docker info | grep Swarm   # 🔍 swarm status
```
> ℹ️ You should see `Swarm: inactive` indicating that Swarm mode is not yet enabled.

### 🔹 Subtask 1.2: Initialize the Swarm Cluster

**Initialize the Docker Swarm on the manager node:**
```bash
docker swarm init --advertise-addr $(hostname -I | awk '{print $1}')   # 🚀 initialize swarm
```

> 📝 **Note:** The `--advertise-addr` flag specifies the IP address that other nodes will use to connect to this manager.

**After successful initialization, you'll see output similar to:**
```
Swarm initialized: current node (abc123def456) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-xxxxx-xxxxx 192.168.1.100:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

> 💾 Save the join command displayed in your output — you'll need it for the next task.

### 🔹 Subtask 1.3: Verify Swarm Initialization

**Check the Swarm status:**
```bash
docker info | grep Swarm   # ✅ should now show active
```
> ℹ️ You should now see `Swarm: active`.

**List the nodes in your Swarm:**
```bash
docker node ls   # 📋 node listing
```
> ℹ️ You should see one node (the manager) with the status `Leader`.

> 📝 `# TODO:` Note down your manager's advertised IP — you'll reuse it for every `docker swarm join` command in Task 2.

---

## ➕ Task 2: Add Additional Nodes to the Cluster

### 🔹 Subtask 2.1: Retrieve Join Tokens

**On the manager node, get the worker join token:**
```bash
docker swarm join-token worker   # 🎟️ get worker token
```
Copy the complete join command from the output.

### 🔹 Subtask 2.2: Join Worker Node 1

1. Connect to your `worker1` machine
2. **Verify Docker is running:**
```bash
docker --version   # 🐳 version check
```
3. **Join the Swarm using the token from the manager:**
```bash
docker swarm join --token SWMTKN-1-xxxxx-xxxxx MANAGER_IP:2377   # ➕ join as worker
```
> 🔁 Replace `SWMTKN-1-xxxxx-xxxxx` with your actual token and `MANAGER_IP` with your manager's IP address.

> ✅ You should see confirmation: `This node joined a swarm as a worker.`

### 🔹 Subtask 2.3: Join Worker Node 2

1. Connect to your `worker2` machine
2. **Repeat the same join process:**
```bash
docker swarm join --token SWMTKN-1-xxxxx-xxxxx MANAGER_IP:2377   # ➕ join as worker
```

### 🔹 Subtask 2.4: Verify All Nodes Joined

1. Return to the manager node
2. **List all nodes in the cluster:**
```bash
docker node ls   # 📋 full cluster listing
```
> ℹ️ You should now see three nodes: one manager node with `Leader` status, and two worker nodes with `Ready` status.

> 📝 `# TODO:` If a worker doesn't appear in `docker node ls`, re-check firewall rules on ports 2377, 7946, and 4789 before retrying the join.

---

## 📦 Task 3: Deploy a Multi-Container Service Using Docker Stack

### 📚 Understanding Docker Stack

Docker Stack allows you to deploy and manage multi-service applications using a Compose file format. It's the recommended way to deploy applications in Swarm mode.

### 🔹 Subtask 3.1: Create a Docker Compose File

**On the manager node, create a directory for your stack:**
```bash
mkdir ~/swarm-lab   # 📁 stack workspace
cd ~/swarm-lab
```

**Create a Docker Compose file for a web application with a database:**
```yaml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    deploy:
      replicas: 3                        # 📈 three web replicas
      restart_policy:
        condition: on-failure
      placement:
        constraints:
          - node.role == worker          # 👷 pin to workers
    volumes:
      - web-content:/usr/share/nginx/html
    networks:
      - webnet

  redis:
    image: redis:alpine
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
    networks:
      - webnet

  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"   # 👁️ swarm visualizer
    deploy:
      placement:
        constraints:
          - node.role == manager         # 🧑‍✈️ pin to manager
    networks:
      - webnet

volumes:
  web-content:

networks:
  webnet:
    driver: overlay   # 🌐 overlay network across nodes
EOF
```

### 🔹 Subtask 3.2: Deploy the Stack

**Deploy the stack using Docker Stack:**
```bash
docker stack deploy -c docker-compose.yml webapp   # 🚀 deploy stack
```

**Verify the stack deployment:**
```bash
docker stack ls   # 📋 stack listing
```

**List the services in your stack:**
```bash
docker stack services webapp   # 📋 service listing
```

### 🔹 Subtask 3.3: Verify Service Deployment

**Check the status of all services:**
```bash
docker service ls   # 📊 service status
```

**Get detailed information about a specific service:**
```bash
docker service ps webapp_web   # 🔍 task-level detail
```

**Check which nodes are running the services:**
```bash
docker service ps webapp_web webapp_redis webapp_visualizer   # 🗺️ placement across nodes
```

> 📝 `# TODO:` Swap the `visualizer` image for your own monitoring tool of choice and confirm its manager-only placement constraint still holds.

---

## 📈 Task 4: Scale Services Within the Swarm

### 📚 Understanding Service Scaling

One of the key benefits of Docker Swarm is the ability to easily scale services up or down based on demand.

### 🔹 Subtask 4.1: Scale the Web Service

**Check the current number of replicas for the web service:**
```bash
docker service ls   # 📊 current replica count
```

**Scale the web service to 5 replicas:**
```bash
docker service scale webapp_web=5   # 📈 scale up
```

**Monitor the scaling process:**
```bash
docker service ps webapp_web   # 👀 watch tasks come up
```

**Verify the new replica count:**
```bash
docker service ls   # ✅ confirm 5/5
```

### 🔹 Subtask 4.2: Scale Multiple Services

**Scale both web and redis services simultaneously:**
```bash
docker service scale webapp_web=2 webapp_redis=2   # 📉 scale down together
```

**Check the updated service status:**
```bash
docker service ls
docker service ps webapp_web webapp_redis
```

### 🔹 Subtask 4.3: Test Service High Availability

**Identify which node is running a web service:**
```bash
docker service ps webapp_web   # 🗺️ locate a running task
```

**Simulate a node failure by stopping Docker on one of the worker nodes:**
```bash
# 💥 On worker1 or worker2 (whichever is running containers)
sudo systemctl stop docker
```

**Return to the manager and observe how Swarm handles the failure:**
```bash
docker service ps webapp_web   # 🔄 tasks rescheduled
docker node ls                 # ⚠️ node marked Down
```

**Restart Docker on the affected node:**
```bash
# ▶️ On the affected worker node
sudo systemctl start docker
```

**Check node status recovery:**
```bash
# ✅ On manager
docker node ls
```

> 📝 `# TODO:` Time how long it takes Swarm to reschedule tasks after the simulated failure, and note which node picked up the workload.

---

## 🔍 Task 5: Inspect the State of Services and Nodes

### 🔹 Subtask 5.1: Comprehensive Service Inspection

**List all services across all stacks:**
```bash
docker service ls   # 📋 all services
```

**Get detailed information about the web service:**
```bash
docker service inspect webapp_web   # 🔍 full JSON detail
```

**View service logs:**
```bash
docker service logs webapp_web   # 📜 aggregated logs
```

**Check service configuration:**
```bash
docker service inspect --pretty webapp_web   # 🖨️ human-readable
```

### 🔹 Subtask 5.2: Node Management and Inspection

**List all nodes with detailed information:**
```bash
docker node ls   # 📋 node overview
```

**Inspect a specific node:**
```bash
docker node inspect worker1   # 🔍 full JSON detail
```

**View node information in a readable format:**
```bash
docker node inspect --pretty worker1   # 🖨️ human-readable
```

**Check resource usage across nodes:**
```bash
docker system df            # 💾 disk usage
docker system events --since 10m   # 📡 recent events
```

### 🔹 Subtask 5.3: Network and Volume Inspection

**List Swarm networks:**
```bash
docker network ls   # 🌐 network listing
```

**Inspect the overlay network:**
```bash
docker network inspect webapp_webnet   # 🔍 overlay detail
```

**List volumes created by the stack:**
```bash
docker volume ls   # 💾 volume listing
```

### 🔹 Subtask 5.4: Access the Deployed Application

**Find the IP address of your manager node:**
```bash
hostname -I   # 📍 manager IP
```

**Open a web browser or use curl to access:**
- 🌐 Main application: `http://MANAGER_IP`
- 👁️ Visualizer: `http://MANAGER_IP:8080`

> 🔁 Test load balancing by refreshing the page multiple times and observing the container IDs.

> 📝 `# TODO:` Screenshot the visualizer while scaling `webapp_web` up and down to see task placement update live.

---

## 🧪 Advanced Operations

### 🔄 Rolling Updates

**Update the web service with a new image:**
```bash
docker service update --image nginx:latest webapp_web   # 🔄 rolling update
```

**Monitor the rolling update:**
```bash
docker service ps webapp_web   # 👀 watch old tasks replaced
```

### 🚰 Draining Nodes

**Drain a worker node for maintenance:**
```bash
docker node update --availability drain worker1   # 🚰 drain node
```

**Observe how services are redistributed:**
```bash
docker service ps webapp_web
docker node ls
```

**Return the node to active status:**
```bash
docker node update --availability active worker1   # ✅ reactivate node
```

> 📝 `# TODO:` Drain a node mid-scale-up and confirm Swarm reschedules pending replicas onto the remaining active nodes.

---

## 🧹 Cleanup

### 🗑️ Remove the Stack

**Remove the deployed stack:**
```bash
docker stack rm webapp   # 🗑️ remove stack
```

**Verify stack removal:**
```bash
docker stack ls
docker service ls
```

### 👋 Leave the Swarm (Optional)

**On worker nodes, leave the Swarm:**
```bash
docker swarm leave   # 👋 worker leaves
```

**On the manager node, remove the worker nodes:**
```bash
docker node rm worker1 worker2   # 🗑️ remove from cluster
```

**Leave Swarm mode on the manager:**
```bash
docker swarm leave --force   # 👋 disband swarm
```

---

## 🛠️ Troubleshooting Tips

<details>
<summary>➕ Issue: Node fails to join the Swarm</summary>

**Solution:** Check network connectivity between nodes and ensure ports `2377`, `7946`, and `4789` are open
</details>

<details>
<summary>🚫 Issue: Services not starting</summary>

**Solution:** Check service logs using `docker service logs SERVICE_NAME` and verify image availability
</details>

<details>
<summary>🔌 Issue: Cannot access deployed application</summary>

**Solution:** Verify port mappings and ensure services are running on expected nodes
</details>

<details>
<summary>🚀 Issue: Swarm initialization fails</summary>

**Solution:** Ensure Docker daemon is running and try specifying a different advertise address
</details>

### 🔎 Useful Commands for Debugging

```bash
# 🩺 Check Docker daemon status
sudo systemctl status docker

# 🔍 View detailed service information
docker service inspect --pretty SERVICE_NAME

# 📋 Check node connectivity
docker node ls

# ℹ️ View system-wide information
docker system info

# 📡 Monitor real-time events
docker system events
```

---

## 🏁 Conclusion

In this lab, you have successfully:

- 🚀 **Initialized a Docker Swarm cluster** and understood the role of manager and worker nodes
- ➕ **Added multiple nodes** to create a distributed container orchestration system
- 📦 **Deployed a multi-service application** using Docker Stack with proper networking and volume management
- 📈 **Scaled services dynamically** to handle varying workloads
- 🔍 **Inspected and monitored** the health and status of your Swarm cluster

### 💡 Why This Matters

Docker Swarm provides a production-ready orchestration platform that offers:

| Benefit | Description |
|---|---|
| 🛡️ High Availability | Automatic failover and service recovery |
| ⚖️ Load Balancing | Built-in load distribution across nodes |
| 🔎 Service Discovery | Automatic service registration and discovery |
| 🔄 Rolling Updates | Zero-downtime application updates |
| 📈 Scalability | Easy horizontal scaling of services |

### 🌍 Real-World Applications

These skills are essential for:

- ⚙️ **DevOps Engineers** managing containerized applications in production
- 🖥️ **System Administrators** implementing scalable infrastructure
- 👨‍💻 **Developers** understanding deployment and orchestration concepts
- 🎓 **Docker Certified Associate (DCA)** certification preparation

> 🎉 The knowledge gained in this lab provides a solid foundation for working with container orchestration platforms and prepares you for more advanced topics like Kubernetes, service mesh architectures, and cloud-native application development.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E90FF?style=for-the-badge)

</div>
