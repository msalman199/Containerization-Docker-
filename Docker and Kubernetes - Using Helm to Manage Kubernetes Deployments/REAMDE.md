# 🚀 Docker & Kubernetes – Managing Kubernetes Deployments with Helm

<p align="center">

![Helm](https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=helm&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Minikube](https://img.shields.io/badge/Minikube-326CE5?style=for-the-badge)
![kubectl](https://img.shields.io/badge/kubectl-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-CB171E?style=for-the-badge&logo=yaml&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

</p>

---

# 📖 Overview

This repository demonstrates how to **use Helm, the Kubernetes Package Manager**, to simplify the deployment, management, upgrading, and rollback of applications running on Kubernetes clusters.

Throughout this hands-on lab, you will learn how to install Helm, deploy existing Helm charts, create custom Helm charts, customize deployments using Helm values, perform upgrades, and safely roll back application releases.

This project introduces modern **Cloud-Native** deployment practices used in DevOps, Platform Engineering, and Kubernetes administration.

---

# 🎯 Learning Objectives

After completing this lab, you will be able to:

- ✅ Understand Helm architecture and components
- ✅ Install and configure Helm CLI
- ✅ Add and manage Helm repositories
- ✅ Deploy applications using existing Helm charts
- ✅ Create custom Helm charts
- ✅ Customize application configuration using values.yaml
- ✅ Upgrade Kubernetes applications
- ✅ Roll back failed deployments
- ✅ Manage the complete lifecycle of Kubernetes applications

---

# 🛠 Technologies Used

| Category | Technologies |
|----------|--------------|
| Containerization | Docker |
| Orchestration | Kubernetes |
| Package Manager | Helm 3 |
| Kubernetes CLI | kubectl |
| Local Kubernetes | Minikube |
| Operating System | Ubuntu Linux |
| Configuration | YAML |
| Version Control | Git |

---

# ☸️ Helm Architecture

```text
             Developer
                  │
                  ▼
            Helm CLI Commands
                  │
                  ▼
            Helm Repository
                  │
                  ▼
             Helm Chart
                  │
                  ▼
          Kubernetes Cluster
                  │
      ┌───────────┼───────────┐
      ▼           ▼           ▼
 Deployment    Service     ConfigMap
      │
      ▼
     Pods
```

---

# 🚀 Lab Tasks

---

# 📌 Task 1 — Install Helm CLI

Prepare the Kubernetes environment and install Helm.

### ✔ Verify Kubernetes Cluster

- Check Minikube status
- Verify cluster connectivity
- Inspect cluster nodes

### ✔ Install Helm

- Download Helm installation script
- Install Helm CLI
- Verify Helm version

### ✔ Configure Helm Repositories

- Add Stable Repository
- Add Bitnami Repository
- Update repositories
- Search available charts

---

# 📌 Task 2 — Deploy Applications with Helm

Deploy production-ready applications using official Helm charts.

### Deploy NGINX

- Search available charts
- Install Bitnami NGINX
- Verify deployment
- Access application
- Inspect created resources

### Explore Helm Charts

- View Chart metadata
- Explore values.yaml
- Inspect templates

---

# 📌 Task 3 — Create a Custom Helm Chart

Create your own reusable Helm package.

### Chart Components

- Chart.yaml
- values.yaml
- templates/
- Deployment
- Service
- ConfigMap

### Customize Application

- Python Web Application
- Environment Variables
- ConfigMap Injection
- Resource Limits
- Replica Configuration

---

# 📌 Task 4 — Upgrade Applications

Modify Helm values and perform upgrades.

### Configuration Updates

- Increase replicas
- Change application messages
- Update CPU & Memory
- Apply custom values.yaml

### Helm Upgrade

- Upgrade release
- Verify rollout
- Test updated application

---

# 📌 Task 5 — Roll Back Deployments

Recover applications quickly after failed updates.

### Rollback Operations

- View release history
- Roll back to previous revision
- Verify deployment health
- Restore application functionality

---



---

# ⚙️ Deployment Workflow

```text
Create Helm Chart
        │
        ▼
Configure values.yaml
        │
        ▼
Helm Install
        │
        ▼
Kubernetes Resources
        │
        ▼
Pods Running
        │
        ▼
Application Available
```

---

# 🔄 Helm Release Lifecycle

```text
Create Chart
      │
      ▼
helm install
      │
      ▼
Application Running
      │
      ▼
helm upgrade
      │
      ▼
New Release
      │
      ▼
helm rollback
      │
      ▼
Previous Stable Version
```

---

# 📦 Kubernetes Resources Created

- 📄 Deployment
- 🌐 Service
- ⚙️ ConfigMap
- 📦 ReplicaSet
- 🚀 Pods

---

# 🛡 Features Implemented

✅ Helm Charts

✅ Helm Repositories

✅ Chart Templates

✅ Configurable values.yaml

✅ Kubernetes Deployments

✅ Kubernetes Services

✅ ConfigMaps

✅ Version Management

✅ Application Upgrades

✅ Rollback Support

✅ Multi-Release Management

---

# 📊 Helm Commands Practiced

### Installation

- helm install
- helm repo add
- helm repo update

### Management

- helm list
- helm status
- helm history
- helm get values

### Upgrades

- helm upgrade
- helm rollback

### Validation

- helm lint
- helm template

### Cleanup

- helm uninstall

---

# ☸️ Kubernetes Commands Practiced

- kubectl get pods
- kubectl get services
- kubectl describe pods
- kubectl logs
- kubectl get deployments
- kubectl get endpoints
- kubectl cluster-info

---

# 🎓 Skills Gained

- Helm Installation
- Helm Repository Management
- Helm Chart Development
- Kubernetes Application Deployment
- YAML Configuration
- Kubernetes Resource Management
- Helm Upgrades
- Helm Rollbacks
- ConfigMap Management
- Kubernetes Troubleshooting
- Cloud-Native Application Deployment
- DevOps Best Practices

---

# 🌟 Key Highlights

- 🚀 Kubernetes Package Management
- ☸️ Helm Chart Development
- 📦 Reusable Application Templates
- 🔄 Version Control for Deployments
- ⚙️ Configuration Management
- 📊 Release History Tracking
- 🛡 Safe Rollback Operations
- 🌐 Production-Ready Deployments
- 📈 Scalable Kubernetes Applications

---

# 🏆 Learning Outcomes

By completing this lab, you will understand how to:

- Deploy applications using Helm
- Build reusable Helm charts
- Customize deployments with values.yaml
- Upgrade Kubernetes workloads safely
- Roll back failed deployments
- Manage multiple Helm releases
- Apply cloud-native deployment strategies
- Simplify Kubernetes application lifecycle management

---

# 💼 Real-World Applications

The knowledge gained from this project is directly applicable to:

- Kubernetes Administration
- DevOps Engineering
- Platform Engineering
- Cloud Infrastructure
- Site Reliability Engineering (SRE)
- CI/CD Pipelines
- GitOps Workflows
- Enterprise Kubernetes Operations

---

# 🎯 Why Helm?

Helm is considered the **package manager for Kubernetes** because it:

- Simplifies complex Kubernetes deployments
- Enables reusable application templates
- Supports environment-specific configurations
- Provides versioned application releases
- Makes upgrades and rollbacks effortless
- Standardizes deployments across teams
- Accelerates cloud-native application delivery

---

# 🏆 Conclusion

This repository provides a complete hands-on guide to **Helm and Kubernetes application management**. From installing Helm and deploying existing charts to creating custom charts, performing upgrades, and rolling back failed releases, this project covers the complete lifecycle of Kubernetes applications.

The practical experience gained through this lab reflects real-world DevOps and Kubernetes workflows used by modern cloud engineering teams and serves as an excellent foundation for **Docker Certified Associate (DCA)**, **Certified Kubernetes Application Developer (CKAD)**, and **Certified Kubernetes Administrator (CKA)** certifications.

---

# 👨‍💻 Author

**Muhammad Salman**

Cloud DevOps Engineer | Linux Administrator | AI & Cybersecurity Enthusiast

⭐ If you found this project helpful, don't forget to **Star** this repository and support the project!

```
