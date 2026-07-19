# 🔵🟢 Blue-Green Deployment with Docker & NGINX

<div align="center">

# 🚀 Zero-Downtime Deployment using Docker & NGINX

### Build Production-Ready Blue-Green Deployments with Automated Rollback & Canary Releases

<img src="https://img.shields.io/badge/Level-Advanced-red?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Deployment-Blue--Green-00C853?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Zero-Downtime-success?style=for-the-badge"/>
<img src="https://img.shields.io/badge/CI/CD-Deployment-blue?style=for-the-badge"/>

</div>

---

# 📖 Overview

This repository demonstrates how to build a **Production-Ready Blue-Green Deployment Architecture** using **Docker** and **NGINX** to achieve **Zero-Downtime Deployments**.

The project simulates a real-world Continuous Delivery workflow where two application environments (**Blue** and **Green**) run simultaneously. NGINX acts as a reverse proxy and traffic router, enabling seamless deployment switching without interrupting users.

The repository also includes an automated deployment pipeline capable of:

- 🔄 Zero-Downtime Deployments
- ❤️ Health Validation
- 🚦 Canary Releases
- 🔙 Automatic Rollback
- ⚡ Traffic Switching in Under 5 Seconds

---

# 🎯 Lab Objectives

After completing this lab, you will be able to:

- ✅ Design Blue-Green Deployment Architecture
- ✅ Deploy Multiple Docker Application Versions
- ✅ Configure NGINX Reverse Proxy
- ✅ Perform Zero-Downtime Deployments
- ✅ Automate Deployment Pipelines
- ✅ Validate Container Health
- ✅ Implement Canary Releases
- ✅ Automate Rollback Logic
- ✅ Persist Deployment State
- ✅ Simulate Production Deployment Failures

---

# 🛠 Technologies Used

<div align="center">

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-1488C6?style=for-the-badge&logo=docker&logoColor=white)
![NGINX](https://img.shields.io/badge/NGINX-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Shell Script](https://img.shields.io/badge/Bash_Scripting-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Docker Network](https://img.shields.io/badge/Docker-Network-2496ED?style=for-the-badge)
![JSON](https://img.shields.io/badge/JSON-000000?style=for-the-badge)
![HTTP](https://img.shields.io/badge/HTTP-005571?style=for-the-badge)

</div>

---

# 🏗 Architecture

```
                    Users
                      │
                      ▼
             ┌────────────────┐
             │     NGINX      │
             │ Reverse Proxy  │
             └───────┬────────┘
                     │
       ┌─────────────┴─────────────┐
       │                           │
       ▼                           ▼

 ┌───────────────┐          ┌───────────────┐
 │ Blue Version  │          │ Green Version │
 │ App v1.0      │          │ App v2.0      │
 └───────────────┘          └───────────────┘

      Docker Bridge Network

        Automated Pipeline

 Deploy ➜ Health Check ➜ Switch ➜ Rollback
```

---

# 🎯 Project Features

- 🔵 Blue Environment
- 🟢 Green Environment
- 🌐 NGINX Reverse Proxy
- ⚡ Zero Downtime Switching
- ❤️ Health Checks
- 🔄 Automated Deployments
- 🚦 Canary Releases
- 🔙 Automatic Rollback
- 📊 Deployment Status
- 📁 Persistent Active Environment Tracking

---

# 📋 Prerequisites

Before starting this project, you should have:

- 🐧 Linux Command Line Knowledge
- 🐳 Docker Fundamentals
- 🌐 HTTP & Reverse Proxy Concepts
- 📦 Container Networking Basics
- ⚙️ Shell Scripting Experience

---

# ☁️ Lab Environment

This lab runs on an **AWS EC2 Ubuntu Instance** provided by **Al Nafi**.

Environment includes:

- Ubuntu Linux
- AWS EC2
- Internet Access
- Docker Installation
- Docker Compose
- Node.js
- NGINX

---

# 🚀 Task 1 – Install the Toolchain

### ✔ Install Docker Engine

- Docker Engine
- Docker CLI
- Containerd
- Docker Compose Plugin

---

### ✔ Install Supporting Utilities

- Node.js
- npm
- curl
- jq
- GPG
- Docker Repository

---

### ✔ Verify Installation

Confirm:

- Docker Version
- Docker Compose Version
- Node.js Version
- jq Version
- curl Version

---

# 🔵🟢 Task 2 – Build Blue-Green Infrastructure

### ✔ Create Blue Environment

- Dockerfile
- Version 1.0 Application
- JSON API
- Health Endpoint

---

### ✔ Create Green Environment

- Dockerfile
- Version 2.0 Application
- Independent Container
- Health Endpoint

---

### ✔ Configure Docker Network

- Bridge Network
- Internal Communication
- Secure Container Isolation

---

### ✔ Configure NGINX

- Reverse Proxy
- Runtime Configuration Reload
- Traffic Switching
- No Container Restart Required

---

### ✔ Validate Deployment

Verify:

- Blue Application
- Green Application
- JSON Responses
- Health Endpoints
- Zero Downtime Switching

---

# ⚙️ Task 3 – Build Automated Deployment Pipeline

### ✔ Deploy Command

Pipeline automatically:

- Detect Active Environment
- Build Standby Version
- Perform Health Checks
- Switch Live Traffic
- Stop Old Environment

---

### ✔ Status Command

Display:

- Active Environment
- Blue Status
- Green Status
- Container Health

---

### ✔ Rollback Command

Automatically:

- Restore Previous Version
- Reload NGINX
- Recover Live Traffic
- Preserve Availability

---

### ✔ Canary Deployment

Support:

- 10% Traffic
- 20% Traffic
- 30% Traffic
- 50% Traffic
- Weighted Routing

---

### ✔ Persistent State

Pipeline stores:

- Current Active Environment
- Previous Deployment
- Deployment History

---

# ❤️ Health Monitoring

The deployment pipeline validates:

- Container Running
- HTTP Status
- Response Time
- Health Endpoint
- Retry Logic
- Timeout Handling

---

# 🚦 Canary Releases

Canary deployment enables:

- Partial Traffic Routing
- Gradual Rollout
- Risk Reduction
- Production Validation
- Live Testing

Example:

```
Blue  ➜ 70%

Green ➜ 30%
```

---

# 🔙 Automatic Rollback

If deployment fails:

- Detect Failure
- Stop Faulty Deployment
- Restore Previous Version
- Reload NGINX
- Resume Traffic
- Prevent Downtime

---

# 📊 Deployment Workflow

```
Build New Version
        │
        ▼

Deploy Standby Container
        │
        ▼

Health Check
        │
        ▼

Traffic Switch
        │
        ▼

Monitor
        │
   ┌────┴────┐
   │         │
Healthy   Failed
   │         │
   ▼         ▼

Complete  Rollback
```

---

# 📁 Project Structure

```
Blue-Green-Deployment/
│
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
├── pipeline.sh
├── blue/
│   ├── app.js
│   └── Dockerfile
│
├── green/
│   ├── app.js
│   └── Dockerfile
│
├── state/
│   └── active_environment
│
├── scripts/
│   ├── deploy.sh
│   ├── rollback.sh
│   ├── healthcheck.sh
│   └── canary.sh
│
└── README.md
```

---

# 🛡 Deployment Features

- ✅ Zero Downtime
- ✅ Blue-Green Deployment
- ✅ Canary Releases
- ✅ Health Checks
- ✅ Rollback Automation
- ✅ Deployment Status
- ✅ Runtime NGINX Reload
- ✅ Docker Networking
- ✅ Container Isolation
- ✅ Deployment Persistence

---

# 📈 Skills Gained

By completing this lab you will learn:

- Docker Networking
- Docker Image Building
- Docker Compose
- NGINX Reverse Proxy
- Blue-Green Deployments
- Canary Deployments
- Zero Downtime Releases
- Shell Automation
- CI/CD Fundamentals
- Health Monitoring
- Production Deployment Strategies

---

# 🎓 Learning Outcomes

After completing this project you will understand:

- Blue-Green Architecture
- Reverse Proxy Routing
- Deployment Automation
- Container Health Validation
- Canary Traffic Splitting
- Automated Rollbacks
- High Availability Deployments
- Continuous Delivery Principles

---

# 🛠 Troubleshooting

Common issues covered:

✔ Docker Installation Errors

✔ Docker Compose Issues

✔ Container Networking Problems

✔ NGINX Configuration Errors

✔ Health Check Failures

✔ Traffic Routing Issues

✔ Deployment Rollback Failures

✔ Pipeline Execution Problems

---

# 🌟 Key Highlights

This project demonstrates:

- Production-Ready Deployment Architecture
- Enterprise CI/CD Concepts
- Safe Software Releases
- Automated Deployment Pipelines
- High Availability Applications
- Runtime Traffic Switching
- Continuous Delivery Workflows
- Infrastructure Automation

---

# 🚀 Future Enhancements

- GitHub Actions Integration
- Jenkins Pipeline
- Kubernetes Deployment
- Helm Charts
- ArgoCD
- Prometheus Monitoring
- Grafana Dashboards
- TLS/SSL Support
- Docker Swarm Integration
- Kubernetes Canary Deployments

---

# 👨‍💻 Author

**Muhammad Salman**

Cloud DevOps Engineer | Linux Administrator | Docker | Kubernetes | AWS | DevOps | CI/CD | Cloud Infrastructure

---

<div align="center">

## ⭐ If you found this repository helpful, don't forget to Star it!

### 🚀 Happy Learning & Happy Deploying! 🔵🟢

</div>
