# 🐳 Docker for High Availability – Multi-Node Docker Swarm Cluster

<div align="center">

# 🚀 Docker Swarm High Availability Lab

### Build, Deploy & Manage Highly Available Containerized Applications with Docker Swarm

<img src="https://img.shields.io/badge/Level-Intermediate-blue?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Platform-Docker%20Swarm-2496ED?style=for-the-badge&logo=docker&logoColor=white"/>
<img src="https://img.shields.io/badge/Category-Container%20Orchestration-success?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Availability-High-red?style=for-the-badge"/>

</div>

---

# 📖 Overview

This repository contains a complete hands-on lab demonstrating how to build a **High Availability (HA)** environment using **Docker Swarm** across multiple Linux nodes.

The project covers cluster creation, service orchestration, automatic failover, health monitoring, load balancing, rolling updates, and production-ready deployment strategies.

By completing this lab, you will gain practical experience in deploying resilient applications that continue running even when servers or containers fail.

---

# 🎯 Lab Objectives

After completing this lab you will be able to:

- ✅ Build a Multi-Node Docker Swarm Cluster
- ✅ Configure Manager & Worker Nodes
- ✅ Deploy Highly Available Web Applications
- ✅ Configure Multiple Service Replicas
- ✅ Implement Automatic Failover
- ✅ Configure Health Checks
- ✅ Apply Restart Policies
- ✅ Deploy Rolling Updates
- ✅ Configure Overlay Networks
- ✅ Implement HAProxy Load Balancing
- ✅ Monitor Cluster Health
- ✅ Perform Load Testing
- ✅ Troubleshoot Swarm Clusters

---

# 🛠 Technologies Used

<div align="center">

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Swarm](https://img.shields.io/badge/Docker%20Swarm-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![NGINX](https://img.shields.io/badge/NGINX-009639?style=for-the-badge&logo=nginx&logoColor=white)
![HAProxy](https://img.shields.io/badge/HAProxy-106DA9?style=for-the-badge)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-1488C6?style=for-the-badge&logo=docker&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![HTTP](https://img.shields.io/badge/HTTP-005571?style=for-the-badge)
![Apache Bench](https://img.shields.io/badge/ApacheBench-CC0000?style=for-the-badge)

</div>

---

# 📂 Lab Architecture

```
                 Docker Swarm Cluster

                 ┌─────────────────────┐
                 │    Manager Node     │
                 │ 192.168.1.10        │
                 └─────────┬───────────┘
                           │
          ┌────────────────┴───────────────┐
          │                                │
          ▼                                ▼

 ┌────────────────────┐          ┌────────────────────┐
 │ Worker Node 1      │          │ Worker Node 2      │
 │192.168.1.11        │          │192.168.1.12        │
 └────────────────────┘          └────────────────────┘

             Overlay Network

          HAProxy Load Balancer

      Multiple Web Application Replicas
```

---

# 📋 Prerequisites

Before starting this lab, you should have:

- 🐳 Basic Docker Knowledge
- 🐧 Linux Command Line Experience
- 🌐 Networking Fundamentals
- 🌍 HTTP/Web Application Basics
- 📝 Text Editor (Nano/Vim)

---

# ☁️ Lab Environment

Al Nafi Cloud Environment includes:

- ✅ Ubuntu 20.04 LTS
- ✅ Docker Engine Installed
- ✅ 3 Linux Machines
- ✅ Docker Swarm Ready
- ✅ Internal Networking Configured

| Machine | Role |
|----------|------|
| Manager | 192.168.1.10 |
| Worker-1 | 192.168.1.11 |
| Worker-2 | 192.168.1.12 |

---

# 🚀 Task 1 – Build Docker Swarm Cluster

### ✔ Initialize Swarm Manager

- Initialize Docker Swarm
- Create Manager Node
- Generate Join Token

---

### ✔ Join Worker Nodes

- Add Worker-1
- Add Worker-2
- Verify Cluster Membership

---

### ✔ Configure Node Labels

- Assign Frontend Role
- Assign Backend Role
- Verify Node Labels

---

# 🌐 Task 2 – Deploy Highly Available Application

### ✔ Create Web Application

- HTML Web Page
- Dockerfile
- Docker Compose
- Overlay Network

---

### ✔ Deploy Stack

- Build Docker Image
- Deploy Stack
- Verify Services
- Inspect Tasks

---

### ✔ Verify Load Balancing

- Test Multiple Requests
- Observe Replica Distribution
- Access Docker Visualizer

---

# 🔄 Task 3 – Test High Availability

### ✔ Monitor Service Distribution

- Inspect Running Containers
- Monitor Nodes
- Watch Service Status

---

### ✔ Simulate Node Failure

- Stop Worker Node
- Observe Automatic Failover
- Verify Service Recovery

---

### ✔ Restore Cluster

- Restart Worker
- Confirm Node Rejoins
- Verify Replica Rebalancing

---

# ❤️ Task 4 – Health Checks & Restart Policies

### ✔ Configure Health Checks

- Custom Bash Health Script
- NGINX Monitoring
- HTTP Availability Testing
- Memory Usage Validation

---

### ✔ Configure Restart Policies

- Automatic Restart
- Failure Detection
- Rolling Updates
- Deployment Monitoring

---

### ✔ Test Self-Healing

- Kill Container
- Observe Automatic Recovery
- Verify Healthy Status

---

# ⚖️ Task 5 – HAProxy Load Balancer

### ✔ Configure HAProxy

- Round Robin Algorithm
- Backend Servers
- Health Checks
- Statistics Dashboard

---

### ✔ Deploy Load Balancer

- Dockerized HAProxy
- Swarm Deployment
- Overlay Network Integration

---

### ✔ Perform Load Testing

- Apache Bench
- Concurrent Requests
- Traffic Distribution
- Performance Validation

---

### ✔ Complete HA Testing

- Container Failure
- Scaling Services
- Traffic Validation
- Cluster Monitoring

---

# 📊 Features Implemented

- ✅ Multi-Node Docker Swarm
- ✅ Overlay Networking
- ✅ High Availability Deployment
- ✅ Automatic Failover
- ✅ Service Replication
- ✅ Health Checks
- ✅ Restart Policies
- ✅ Rolling Updates
- ✅ HAProxy Load Balancer
- ✅ Docker Visualizer
- ✅ Cluster Monitoring
- ✅ Load Testing

---


```

---

# 📈 Skills Gained

Throughout this lab you will gain experience with:

- Docker Swarm Administration
- Container Orchestration
- Cluster Management
- High Availability Architecture
- Overlay Networking
- Service Discovery
- Health Monitoring
- HAProxy Configuration
- Docker Compose
- Rolling Updates
- Production Deployments
- Load Testing
- DevOps Best Practices

---

# 🎓 Learning Outcomes

After completing this project, you will understand:

- Docker Swarm Architecture
- Manager & Worker Nodes
- Swarm Scheduling
- Overlay Networks
- Service Replication
- Load Balancing
- Failover Mechanisms
- Container Health Monitoring
- Rolling Deployments
- Production HA Design

---

# 🛡 Troubleshooting Covered

✔ Worker Nodes Not Joining

✔ Service Deployment Failures

✔ Health Check Issues

✔ Restart Policy Problems

✔ Overlay Network Errors

✔ HAProxy Configuration Issues

✔ Load Balancing Problems

✔ Cluster Connectivity Issues

---

# 🧹 Cleanup

After completing the lab:

- Remove Docker Stack
- Leave Docker Swarm
- Remove Containers
- Remove Images
- Clean Docker Resources

---

# 🌟 Key Takeaways

This project demonstrates real-world implementation of **Docker Swarm High Availability**, including:

- Production-grade Container Clusters
- Fault-Tolerant Architecture
- Automatic Service Recovery
- Container Health Monitoring
- Built-in & External Load Balancing
- Zero-Downtime Deployment Strategies
- Infrastructure Resilience
- Enterprise DevOps Practices

---

# 🚀 Future Improvements

- Kubernetes Migration
- Persistent Volumes
- Prometheus Monitoring
- Grafana Dashboards
- ELK Logging Stack
- Traefik Ingress
- CI/CD Integration
- Auto Scaling
- Secrets Management
- TLS & HTTPS

---

# 👨‍💻 Author

**Muhammad Salman**

Cloud DevOps Engineer | Linux Administrator | Docker | Kubernetes | AWS | DevOps | Cloud Infrastructure | Automation

---

<div align="center">

### ⭐ If you found this repository helpful, don't forget to Star it!

**Happy Learning! 🚀🐳**

</div>
