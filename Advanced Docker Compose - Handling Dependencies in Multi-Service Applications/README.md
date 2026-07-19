# 🐳 Advanced Docker Compose — Handling Dependencies in Multi-Service Applications

<p align="center">

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![NGINX](https://img.shields.io/badge/NGINX-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![AWS EC2](https://img.shields.io/badge/AWS_EC2-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![DevOps](https://img.shields.io/badge/DevOps-Production-success?style=for-the-badge)

</p>

---

# 📖 Overview

This repository demonstrates how to build a **production-grade multi-service Docker Compose application** using **health-aware dependencies**, **automatic recovery**, and **graceful service degradation**.

The project focuses on orchestrating a complete application stack consisting of **PostgreSQL**, **Redis**, **Node.js**, and **NGINX**, where each service starts only after its dependencies become healthy. It also introduces resilience testing through automated failure injection and recovery validation.

This lab closely mirrors real-world production deployment patterns used in modern cloud-native and DevOps environments.

---

# 🎯 Learning Objectives

By completing this project, you will learn how to:

- ✅ Build health-aware Docker Compose stacks
- ✅ Configure multi-service application dependencies
- ✅ Implement Docker HEALTHCHECK instructions
- ✅ Use `.env` files for secure configuration
- ✅ Build resilient application architectures
- ✅ Implement graceful degradation
- ✅ Configure automatic restart policies
- ✅ Validate service recovery automatically
- ✅ Perform failure injection testing
- ✅ Apply production-grade dependency management

---

# 🛠 Technologies Used

| Category | Technologies |
|-----------|--------------|
| Container Runtime | Docker Engine |
| Orchestration | Docker Compose v2 |
| Reverse Proxy | NGINX |
| Backend | Node.js |
| Database | PostgreSQL |
| Cache | Redis |
| Operating System | Ubuntu Linux |
| Networking | Docker Networks |
| Automation | Bash |
| Utilities | curl, jq, netcat |

---

# 🏗 Solution Architecture

```text
                    Internet
                        │
                        ▼
                   NGINX Proxy
                        │
                        ▼
                  Node.js API
                  /health API
                 /api/users API
                  ┌────────────┐
                  │            │
                  ▼            ▼
            PostgreSQL      Redis
             Database       Cache
```

---

# 🚀 Lab Tasks

---

# 📌 Task 1 — Environment Setup

Prepare the Linux environment.

### ✔ Install Required Software

- Docker Engine
- Docker Compose v2
- curl
- jq
- netcat

### ✔ Verify Installation

- Docker Version
- Docker Compose Version
- Docker Daemon
- Hello World Container

---

# 📌 Task 2 — Design Multi-Service Architecture

Create a production-ready application stack.

### Application Services

- PostgreSQL Database
- Redis Cache
- Node.js API
- NGINX Reverse Proxy

### Service Responsibilities

| Service | Purpose |
|----------|----------|
| PostgreSQL | Persistent Data Storage |
| Redis | High-Speed Caching |
| Node.js API | Business Logic |
| NGINX | Reverse Proxy & Load Distribution |

---

# 📌 Task 3 — Configure Health Checks

Implement container-native readiness verification.

### Health Check Features

- PostgreSQL Availability
- Redis Connectivity
- API Health Endpoint
- NGINX Startup Validation

### Health Endpoint

```text
GET /health
```

Returns:

- Database Status
- Cache Status
- Overall Health
- HTTP Status

---

# 📌 Task 4 — Manage Service Dependencies

Configure dependency-aware startup.

### Dependency Chain

```text
PostgreSQL
      │
      ▼
Redis
      │
      ▼
Node.js API
      │
      ▼
NGINX
```

### Startup Logic

- Wait for Database
- Wait for Cache
- Wait for API Health
- Start Reverse Proxy

---

# 📌 Task 5 — Secure Configuration

Use environment variables for application configuration.

### Environment Variables

- Database Username
- Database Password
- Database Port
- Redis Port
- API Port
- NGINX Port

### Security Benefits

- No Hardcoded Credentials
- Environment Isolation
- Easier Configuration
- Production Ready

---

# 📌 Task 6 — Configure Docker Compose

Deploy the complete application stack.

### Docker Compose Features

- Multi-Service Deployment
- Health Checks
- Named Networks
- Volumes
- Restart Policies
- Dependency Conditions

---

# 📌 Task 7 — Graceful Failure Handling

Ensure predictable application behavior.

### Failure Scenarios

- Database Offline
- Cache Offline
- API Offline
- Proxy Failure

### Recovery Features

- Automatic Restart
- Graceful Degradation
- Service Recovery
- Dependency Reconnection

---

# 📌 Task 8 — Automated Resilience Testing

Create an automated validation script.

### validate-resilience.sh

The script validates:

- PostgreSQL Failure Recovery
- Redis Failure Recovery
- Web Application Failure Recovery

### Validation Output

```text
PASS Database Recovery

PASS Redis Recovery

PASS API Recovery
```

---

# 📌 Task 9 — Recovery Validation

Verify production readiness.

### Automated Validation

- Health Endpoint
- HTTP Status Codes
- Restart Policies
- Dependency Recovery
- Service Connectivity

---

# 📂 Project Structure

```text
Advanced-Docker-Compose/
│
├── docker-compose.yml
├── .env
├── Dockerfile
├── nginx.conf
│
├── app/
│   ├── app.js
│   ├── package.json
│   └── health.js
│
├── database/
│   └── init.sql
│
├── scripts/
│   ├── validate-resilience.sh
│   ├── startup.sh
│   ├── cleanup.sh
│   └── monitor.sh
│
├── logs/
│   └── application.log
│
└── README.md
```

---

# ⚙️ Dependency Workflow

```text
Docker Compose
        │
        ▼
PostgreSQL Healthy
        │
        ▼
Redis Healthy
        │
        ▼
API Healthy
        │
        ▼
NGINX Starts
```

---

# 🔄 Failure Recovery Workflow

```text
Service Failure
        │
        ▼
Health Check Fails
        │
        ▼
Restart Policy Triggered
        │
        ▼
Container Restarted
        │
        ▼
Health Check Passes
        │
        ▼
Application Restored
```

---

# 🌐 Multi-Service Communication

```text
Browser
   │
   ▼
NGINX
   │
   ▼
Node.js API
   │
   ├───────────────┐
   ▼               ▼
PostgreSQL      Redis
```

---

# 📊 Production Features

✅ Docker Compose v2

✅ Health Checks

✅ PostgreSQL

✅ Redis

✅ Node.js

✅ NGINX

✅ Dependency Conditions

✅ Restart Policies

✅ Environment Variables

✅ Automated Recovery

---

# 🔒 Production Best Practices

- Health-Based Startup
- Graceful Degradation
- Restart Policies
- Environment Variables
- Reverse Proxy
- Container Isolation
- Persistent Storage
- Dependency Management
- Automated Validation
- Production Monitoring

---

# 🎓 Skills Gained

- Docker Compose
- Multi-Container Applications
- Docker Networking
- PostgreSQL Administration
- Redis Integration
- Node.js Deployment
- NGINX Reverse Proxy
- Docker Health Checks
- Environment Configuration
- Failure Recovery
- Bash Automation
- Production Container Management

---

# 🌟 Key Highlights

- 🐳 Multi-Service Docker Compose
- ❤️ Health-Aware Dependencies
- ☁ Production-Ready Architecture
- ⚡ Redis Caching
- 🗄 PostgreSQL Integration
- 🌐 NGINX Reverse Proxy
- 🔄 Automatic Recovery
- 📊 Resilience Testing
- 🔒 Secure Configuration
- 🚀 Cloud-Native Design

---

# 💼 Real-World Applications

This project demonstrates enterprise practices used in:

- DevOps Engineering
- Cloud Engineering
- Platform Engineering
- Site Reliability Engineering (SRE)
- Microservices Deployment
- Enterprise Container Platforms
- Cloud-Native Infrastructure
- Production Application Hosting

---

# 🏆 Learning Outcomes

By completing this lab, you will understand how to:

- Build dependency-aware Docker Compose applications
- Configure production health checks
- Deploy multi-service architectures
- Implement graceful degradation
- Recover automatically from service failures
- Secure applications using environment variables
- Validate application resilience
- Prepare applications for Kubernetes migration

---

# 🚀 Why Advanced Docker Compose?

Docker Compose provides:

- Simple Multi-Container Management
- Health-Based Startup Ordering
- Built-in Networking
- Environment Configuration
- Volume Management
- Automatic Restart Policies
- Rapid Local Development
- Production-Like Testing

---

# 🏆 Conclusion

This repository demonstrates how to build a **resilient, production-ready Docker Compose application** by combining **PostgreSQL**, **Redis**, **Node.js**, and **NGINX** with health-aware dependency management. Instead of relying on arbitrary startup delays, services become available only after passing health checks, ensuring reliable initialization and improved fault tolerance.

The automated resilience testing further validates graceful degradation, service recovery, and restart behavior, providing hands-on experience with the same architectural patterns used in modern **microservices**, **container orchestration**, and **cloud-native** platforms. These skills provide an excellent foundation for **Docker Certified Associate (DCA)**, **Kubernetes**, **DevOps**, and **Cloud Engineering** careers.

---

# 👨‍💻 Author

**Muhammad Salman**

Cloud DevOps Engineer | Linux Administrator | AI & Cybersecurity Enthusiast

⭐ If you found this project helpful, don't forget to **Star** this repository and support the project!
