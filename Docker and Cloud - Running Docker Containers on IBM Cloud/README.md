# ☁️ Docker and Cloud – Running Docker Containers on IBM Cloud

<p align="center">

![IBM Cloud](https://img.shields.io/badge/IBM_Cloud-1261FE?style=for-the-badge&logo=ibmcloud&logoColor=white)
![IBM Kubernetes Service](https://img.shields.io/badge/IBM_Kubernetes_Service-1261FE?style=for-the-badge&logo=kubernetes&logoColor=white)
![IBM Container Registry](https://img.shields.io/badge/IBM_Container_Registry-1261FE?style=for-the-badge&logo=docker&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![kubectl](https://img.shields.io/badge/kubectl-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Cloud Native](https://img.shields.io/badge/Cloud-Native-success?style=for-the-badge)

</p>

---

# 📖 Overview

This repository demonstrates how to deploy **Docker containers on IBM Cloud Kubernetes Service (IKS)** using **IBM Container Registry** and **Kubernetes**.

The project covers the complete cloud-native application deployment lifecycle—from creating an IBM Cloud account, provisioning a Kubernetes cluster, building Docker images, pushing them to IBM Container Registry, deploying applications using Kubernetes, and exposing services to the internet through Load Balancers.

This hands-on lab introduces real-world **Cloud Computing**, **Container Orchestration**, and **Kubernetes Deployment** workflows widely used in enterprise environments.

---

# 🎯 Learning Objectives

After completing this project, you will be able to:

- ✅ Configure an IBM Cloud account
- ✅ Install and configure IBM Cloud CLI
- ✅ Create Kubernetes clusters using IBM Kubernetes Service (IKS)
- ✅ Build Docker images
- ✅ Push container images to IBM Container Registry
- ✅ Deploy applications to Kubernetes
- ✅ Configure Kubernetes Deployments
- ✅ Expose applications using LoadBalancer Services
- ✅ Monitor containerized applications
- ✅ Apply cloud-native deployment best practices

---

# 🛠 Technologies Used

| Category | Technologies |
|-----------|--------------|
| Cloud Platform | IBM Cloud |
| Container Runtime | Docker |
| Container Registry | IBM Container Registry |
| Container Orchestration | IBM Kubernetes Service (IKS) |
| Programming Language | Node.js |
| Web Framework | Express.js |
| Kubernetes CLI | kubectl |
| IBM CLI | IBM Cloud CLI |
| Operating System | Ubuntu 20.04 LTS |
| Networking | Kubernetes LoadBalancer |

---

# ☁️ Solution Architecture

```text
                  Developer
                       │
                       ▼
              Docker Build Image
                       │
                       ▼
        IBM Container Registry (ICR)
                       │
                       ▼
        IBM Kubernetes Service (IKS)
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
      Replica 1    Replica 2    Replica N
          │            │            │
          └────────────┼────────────┘
                       │
             Kubernetes Service
             (LoadBalancer Type)
                       │
                       ▼
                 Internet Users
```

---

# 🚀 Lab Tasks

---

# 📌 Task 1 — Configure IBM Cloud Environment

Prepare the cloud environment.

### ✔ Create IBM Cloud Account

- Register IBM Cloud Account
- Verify Email
- Configure Default Region
- Access Cloud Dashboard

### ✔ Install IBM Cloud CLI

- IBM Cloud CLI
- Kubernetes Plugin
- Container Registry Plugin
- CLI Verification

### ✔ Login to IBM Cloud

- Authenticate User
- Select Region
- Configure Resource Group

---

# 📌 Task 2 — Create Kubernetes Cluster

Provision a managed Kubernetes cluster.

### Cluster Configuration

- IBM Kubernetes Service
- Free Kubernetes Cluster
- Worker Node
- Cluster Verification

### Validation

- kubectl Configuration
- Cluster Information
- Node Status
- Cluster Connectivity

---

# 📌 Task 3 — Develop Dockerized Application

Create a cloud-ready Node.js application.

### Application Features

- Express.js Server
- REST API
- Health Endpoint
- Dynamic Container Information
- Timestamp Display

### REST API Endpoints

| Endpoint | Method | Description |
|-----------|---------|-------------|
| `/` | GET | Application Home |
| `/health` | GET | Health Check |

---

# 📌 Task 4 — Build Docker Image

Containerize the application.

### Dockerfile Features

- Official Node.js Base Image
- Dependency Installation
- Application Packaging
- Port Exposure
- HEALTHCHECK Configuration
- Production Startup Command

---

# 📌 Task 5 — IBM Container Registry

Store container images securely.

### Registry Operations

- Configure Registry Region
- Create Namespace
- Login to Registry
- Push Docker Image
- Verify Image Repository

---

# 📌 Task 6 — Deploy to Kubernetes

Deploy the application to IBM Kubernetes Service.

### Kubernetes Resources

- Deployment
- ReplicaSet
- Pods
- Labels
- Selectors

### Deployment Features

- 2 Application Replicas
- CPU Requests
- Memory Requests
- Resource Limits
- Automatic Scheduling

---

# 📌 Task 7 — Configure Health Checks

Ensure application reliability.

### Health Monitoring

- Liveness Probe
- Readiness Probe
- HTTP Health Endpoint
- Automatic Recovery
- Traffic Readiness

---

# 📌 Task 8 — Expose Application

Publish the application to the internet.

### Kubernetes Service

- LoadBalancer Type
- External IP
- Port Mapping
- Traffic Distribution

### Connectivity

- HTTP Access
- Public Endpoint
- Browser Testing
- API Verification

---

# 📌 Task 9 — Monitor Kubernetes Resources

Monitor application health and performance.

### Monitoring Commands

- View Deployments
- View Pods
- View Services
- View Logs
- View Events
- View Endpoints

---

└── README.md
```

---

# ⚙️ Deployment Workflow

```text
Develop Application
        │
        ▼
Build Docker Image
        │
        ▼
IBM Container Registry
        │
        ▼
IBM Kubernetes Service
        │
        ▼
Deployment
        │
        ▼
Pods Running
        │
        ▼
LoadBalancer Service
        │
        ▼
Application Online
```

---

# ☸️ Kubernetes Deployment Workflow

```text
Deployment
      │
      ▼
ReplicaSet
      │
      ▼
Pods
      │
      ▼
Service
      │
      ▼
LoadBalancer
      │
      ▼
Internet Users
```

---

# 🌐 Cloud Deployment Features

✅ IBM Cloud Integration

✅ IBM Kubernetes Service

✅ IBM Container Registry

✅ Docker Containerization

✅ Kubernetes Deployment

✅ LoadBalancer Service

✅ Resource Limits

✅ Replica Management

✅ Liveness Probes

✅ Readiness Probes

---

# 📊 Kubernetes Resources

- 🚀 Deployment
- 📦 ReplicaSet
- 🖥 Pods
- 🌐 Service
- ☁ LoadBalancer
- 📑 Endpoints

---

# 🔒 Production Best Practices

- Container Registry
- Managed Kubernetes
- Resource Requests
- Resource Limits
- Health Checks
- Replica Scaling
- High Availability
- Infrastructure as Code
- Cloud Security
- Container Monitoring

---

# 🎓 Skills Gained

- IBM Cloud Administration
- IBM Cloud CLI
- Docker Image Creation
- IBM Container Registry
- Kubernetes Deployments
- Kubernetes Services
- Load Balancer Configuration
- Health Probes
- Container Networking
- Cloud Infrastructure
- Cloud-Native Deployment
- DevOps Best Practices

---

# 🌟 Key Highlights

- ☁ IBM Cloud Platform
- 🐳 Docker Containerization
- ☸ Kubernetes Orchestration
- 📦 IBM Container Registry
- 🌐 LoadBalancer Services
- 🚀 Cloud-Native Deployment
- 📊 High Availability
- 🔄 Scalable Applications
- 🛡 Health Monitoring
- ⚙ Enterprise Infrastructure

---

# 💼 Real-World Applications

The techniques demonstrated in this project are widely used in:

- Cloud Engineering
- DevOps Engineering
- Platform Engineering
- Site Reliability Engineering (SRE)
- Kubernetes Administration
- Enterprise Cloud Infrastructure
- Cloud-Native Application Development
- Container Platform Operations

---

# 🏆 Learning Outcomes

By completing this lab, you will understand how to:

- Configure IBM Cloud services
- Deploy Kubernetes clusters
- Build production-ready Docker images
- Push images to IBM Container Registry
- Deploy applications to Kubernetes
- Configure LoadBalancer services
- Implement Kubernetes health checks
- Manage cloud-native applications at scale

---

# ☁ Why IBM Cloud Kubernetes Service?

IBM Kubernetes Service (IKS) provides:

- Fully Managed Kubernetes
- Enterprise Security
- Integrated Container Registry
- High Availability
- Automatic Updates
- Horizontal Scaling
- Monitoring & Logging
- Cloud-Native Infrastructure

---

# 🏆 Conclusion

This repository demonstrates a complete end-to-end deployment workflow for **Docker containers on IBM Cloud** using **IBM Kubernetes Service (IKS)** and **IBM Container Registry (ICR)**. From creating cloud infrastructure and containerizing an application to deploying workloads on Kubernetes and exposing them through a LoadBalancer, this project follows modern cloud-native deployment practices.

The practical skills gained through this lab prepare learners for real-world roles in **Cloud Engineering**, **DevOps**, **Kubernetes Administration**, and **Platform Engineering**, while providing an excellent foundation for certifications such as the **Docker Certified Associate (DCA)**, **Certified Kubernetes Application Developer (CKAD)**, and **IBM Cloud Professional** certifications.

---

# 👨‍💻 Author

**Muhammad Salman**

Cloud DevOps Engineer | Linux Administrator | AI & Cybersecurity Enthusiast

⭐ If you found this project helpful, don't forget to **Star** this repository and support the project!
