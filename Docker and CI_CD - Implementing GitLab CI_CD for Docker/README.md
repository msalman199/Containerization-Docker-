# 🚀 Implementing GitLab CI/CD for Docker

<p align="center">

![GitLab](https://img.shields.io/badge/GitLab-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Hub](https://img.shields.io/badge/Docker_Hub-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![AWS EC2](https://img.shields.io/badge/AWS_EC2-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI/CD-Automation-success?style=for-the-badge)

</p>

---

# 📖 Overview

This repository demonstrates how to build a **production-ready GitLab CI/CD pipeline** for Dockerized applications. The project automates the complete software delivery lifecycle by building Docker images, executing automated container-based tests, publishing verified images to Docker Hub, and deploying updated containers automatically to a production server.

The lab introduces modern **DevOps**, **Continuous Integration (CI)**, and **Continuous Deployment (CD)** practices using **GitLab CI/CD**, **Docker**, and **Docker Hub**.

---

# 🎯 Learning Objectives

After completing this project, you will be able to:

- ✅ Install Docker, Git, Node.js, and supporting tools
- ✅ Configure a GitLab CI/CD pipeline
- ✅ Build Docker images automatically
- ✅ Execute automated containerized testing
- ✅ Validate REST API endpoints
- ✅ Push versioned images to Docker Hub
- ✅ Secure credentials using GitLab CI/CD variables
- ✅ Automate production deployments
- ✅ Perform post-deployment health checks
- ✅ Implement enterprise CI/CD workflows

---

# 🛠 Technologies Used

| Category | Technologies |
|-----------|--------------|
| Version Control | Git |
| Source Repository | GitLab |
| Container Platform | Docker |
| Image Registry | Docker Hub |
| Programming | Node.js |
| CI/CD Platform | GitLab CI/CD |
| Cloud Platform | AWS EC2 |
| Operating System | Ubuntu Linux |
| Testing | Container Health Checks |
| Automation | GitLab Runners |

---

# 🏗 CI/CD Architecture

```text
             Developer
                  │
           Git Push (main)
                  │
                  ▼
         GitLab Repository
                  │
                  ▼
        GitLab CI/CD Pipeline
                  │
     ┌────────────┼────────────┐
     ▼            ▼            ▼
 Build Stage  Test Stage   Push Stage
     │            │            │
     ▼            ▼            ▼
Docker Image   Container    Docker Hub
   Build        Testing      Registry
                                  │
                                  ▼
                           Deploy Stage
                                  │
                                  ▼
                            AWS EC2 Server
                                  │
                                  ▼
                        Running Docker Container
```

---

# 🚀 Lab Tasks

---

# 📌 Task 1 — Environment Setup

Prepare the development environment.

### ✔ Install Required Software

- Docker Engine
- Git
- curl
- Node.js
- npm

### ✔ Configure Docker

- Enable Docker Service
- Add User to Docker Group
- Verify Docker Installation
- Run Test Container

---

# 📌 Task 2 — Build Dockerized Application

Create a production-ready containerized application.

### Application Features

- Node.js Web Server
- Dockerfile
- REST API
- Health Endpoint

### Required Endpoints

| Endpoint | Method | Description |
|----------|---------|-------------|
| `/` | GET | Application Home |
| `/health` | GET | Health Status |

---

# 📌 Task 3 — Configure GitLab CI/CD Pipeline

Implement a fully automated multi-stage pipeline.

### Pipeline Stages

- 🏗 Build
- 🧪 Test
- 📦 Push
- 🚀 Deploy

### Pipeline Features

- Docker-in-Docker (DinD)
- Automatic Execution
- Stage Dependencies
- Branch Protection
- Pipeline Validation

---

# 📌 Task 4 — Build Stage

Automatically build Docker images.

### Build Process

- Validate Dockerfile
- Build Docker Image
- Detect Build Errors
- Generate Image Artifacts

### Image Tags

- Git Commit SHA
- Latest

---

# 📌 Task 5 — Test Stage

Validate the application inside Docker containers.

### Automated Tests

- Launch Container
- Wait for Startup
- Verify Root Endpoint
- Verify Health Endpoint
- Validate HTTP 200 Responses
- Validate JSON Output

---

# 📌 Task 6 — Push Images to Docker Hub

Publish verified images.

### Registry Features

- Secure Authentication
- Versioned Images
- Latest Tag
- Commit SHA Tag
- Automated Push

---

# 📌 Task 7 — Secure Credentials

Protect sensitive information.

### GitLab Variables

- Docker Hub Username
- Docker Hub Password
- Access Tokens
- Environment Variables

### Security Best Practices

- Masked Variables
- Protected Variables
- No Hardcoded Credentials
- Secure Authentication

---

# 📌 Task 8 — Automatic Deployment

Deploy the application automatically.

### Deployment Workflow

- Pull Latest Image
- Stop Previous Container
- Remove Old Container
- Launch New Container
- Verify Deployment

---

# 📌 Task 9 — Health Verification

Ensure production stability.

### Validation Checks

- Container Running
- HTTP 200 Response
- JSON Response
- Docker Health Status

---

# 📂 Project Structure

```text
GitLab-Docker-CICD/
│
├── .gitlab-ci.yml
├── Dockerfile
├── package.json
├── package-lock.json
├── app.js
├── server.js
├── healthcheck.sh
│
├── tests/
│   ├── api.test.js
│   ├── health.test.js
│   └── docker.test.js
│
├── scripts/
│   ├── build.sh
│   ├── deploy.sh
│   ├── cleanup.sh
│   └── verify.sh
│
└── README.md
```

---

# ⚙️ CI/CD Workflow

```text
Developer Commit
        │
        ▼
Git Push
        │
        ▼
GitLab Pipeline
        │
        ▼
Docker Build
        │
        ▼
Container Tests
        │
        ▼
Docker Hub Push
        │
        ▼
Production Deployment
        │
        ▼
Health Verification
```

---

# 📦 Docker Image Lifecycle

```text
Source Code
      │
      ▼
Docker Build
      │
      ▼
Image Validation
      │
      ▼
Docker Hub
      │
      ▼
Production Server
      │
      ▼
Running Container
```

---

# 🚀 Deployment Workflow

```text
Pipeline Success
       │
       ▼
Pull Latest Image
       │
       ▼
Stop Old Container
       │
       ▼
Start New Container
       │
       ▼
Health Check
       │
       ▼
Deployment Complete
```

---

# 🔒 Security Features

✅ GitLab Protected Variables

✅ Masked Secrets

✅ Secure Docker Login

✅ No Hardcoded Passwords

✅ Environment Variables

✅ Branch Protection

✅ Stage Validation

---

# 📊 Pipeline Stages

| Stage | Purpose |
|---------|----------|
| 🏗 Build | Build Docker Image |
| 🧪 Test | Validate Container & API |
| 📦 Push | Upload Image to Docker Hub |
| 🚀 Deploy | Deploy Application to Production |

---

# 🛡 Best Practices Implemented

- Multi-Stage Pipeline
- Docker-in-Docker
- Automated Testing
- Secure Secret Management
- Versioned Docker Images
- Automated Deployments
- Health Checks
- Pipeline Gating
- Artifact Promotion
- Continuous Delivery

---

# 🎓 Skills Gained

- GitLab CI/CD
- Docker Image Building
- Docker Hub Integration
- Git Workflows
- Container Testing
- REST API Validation
- CI/CD Automation
- Secure Credential Management
- Continuous Deployment
- Production Monitoring
- DevOps Best Practices
- Cloud Deployment

---

# 🌟 Key Highlights

- 🚀 Fully Automated CI/CD Pipeline
- 🐳 Docker Containerization
- 📦 Docker Hub Integration
- 🔄 Continuous Integration
- 🚀 Continuous Deployment
- 🔒 Secure Secret Management
- 🧪 Automated Testing
- 📊 Health Monitoring
- ☁ AWS EC2 Deployment
- ⚙ Production-Ready Automation

---

# 💼 Real-World Applications

This project demonstrates workflows commonly used in:

- DevOps Engineering
- Cloud Engineering
- Platform Engineering
- Site Reliability Engineering (SRE)
- Software Release Engineering
- Containerized Application Delivery
- Enterprise CI/CD Pipelines
- Cloud-Native Development

---

# 🏆 Learning Outcomes

By completing this lab, you will understand how to:

- Configure GitLab CI/CD pipelines
- Build Docker images automatically
- Execute automated application testing
- Push versioned images to Docker Hub
- Deploy containers automatically
- Secure credentials using GitLab Variables
- Validate deployments using health checks
- Build production-grade CI/CD workflows

---

# 🚀 Why GitLab CI/CD?

GitLab CI/CD is a powerful DevOps platform because it provides:

- Integrated Source Control
- Automated Pipelines
- Secure Secret Management
- Docker Integration
- Deployment Tracking
- Environment Management
- Pipeline Visualization
- Continuous Delivery Automation

---

# 🏆 Conclusion

This repository demonstrates how to implement a complete **GitLab CI/CD pipeline** for Dockerized applications, covering the entire software delivery lifecycle—from source code management and automated Docker builds to container testing, Docker Hub publishing, and production deployment on AWS EC2.

By integrating **GitLab CI/CD**, **Docker**, and **Docker Hub**, this project follows modern DevOps practices that ensure reliable, secure, and repeatable application delivery. The hands-on experience gained through this lab provides a strong foundation for careers in **DevOps Engineering**, **Cloud Engineering**, **Platform Engineering**, and **Site Reliability Engineering (SRE)**.

---

# 👨‍💻 Author

**Muhammad Salman**

Cloud DevOps Engineer | Linux Administrator | AI & Cybersecurity Enthusiast

⭐ If you found this project helpful, don't forget to **Star** this repository and support the project!
