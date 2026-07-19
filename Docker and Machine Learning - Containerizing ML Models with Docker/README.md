# 🤖 Docker and Machine Learning – Containerizing ML Models with Docker

<p align="center">

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask)
![Scikit-Learn](https://img.shields.io/badge/Scikit--Learn-F7931E?style=for-the-badge&logo=scikitlearn&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Gunicorn](https://img.shields.io/badge/Gunicorn-499848?style=for-the-badge)
![REST API](https://img.shields.io/badge/REST-API-success?style=for-the-badge)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

</p>

---

# 📖 Overview

This repository demonstrates how to **containerize Machine Learning applications using Docker**, expose trained ML models through a **Flask REST API**, connect them with a **PostgreSQL database**, and deploy everything to **Kubernetes** for production-ready machine learning workloads.

The project follows modern **MLOps** practices by combining Machine Learning, Docker, Kubernetes, REST APIs, and cloud-native deployment strategies.

---

# 🎯 Learning Objectives

After completing this project, you will be able to:

- ✅ Build Docker images for Machine Learning applications
- ✅ Train and package ML models using Scikit-Learn
- ✅ Serve predictions through Flask REST APIs
- ✅ Connect Docker containers with PostgreSQL
- ✅ Deploy ML workloads to Kubernetes
- ✅ Scale ML services using Kubernetes Deployments
- ✅ Implement health checks and readiness probes
- ✅ Understand production-ready MLOps workflows

---

# 🛠 Technologies Used

| Category | Technologies |
|----------|--------------|
| Programming | Python 3.9 |
| Machine Learning | Scikit-Learn |
| API Framework | Flask |
| Database | PostgreSQL |
| Containerization | Docker |
| Orchestration | Kubernetes |
| WSGI Server | Gunicorn |
| Package Manager | pip |
| Version Control | Git |
| Operating System | Linux |

---

# 📂 Project Architecture

```text
                    Client
                       │
              HTTP REST Requests
                       │
                 Flask API
                       │
             House Price Predictor
                       │
          Scikit-Learn ML Model
                       │
          Store Prediction Results
                       │
                PostgreSQL Database
                       │
              Docker Containers
                       │
                Kubernetes Cluster
```

---

# 🚀 Lab Tasks

---

# 📌 Task 1 — Create a Machine Learning Model

### ✔ Generate sample dataset

- Create synthetic housing data
- Generate training labels
- Prepare features

### ✔ Train the ML model

- Linear Regression
- Train/Test Split
- Evaluate MSE

### ✔ Save trained model

- Joblib serialization
- Persistent model storage

---

# 🐳 Task 2 — Containerize the Application

Create a production-ready Docker image.

### Included Components

- Python Runtime
- Flask API
- ML Model
- Dependencies
- Gunicorn
- Health Checks

### Docker Features

- Non-root user
- Slim Python image
- Optimized layers
- Cached dependency installation

---

# 🌐 Task 3 — Build REST API

Expose the ML model through Flask.

## API Endpoints

| Endpoint | Method | Purpose |
|-----------|----------|---------|
| / | GET | API Documentation |
| /health | GET | Health Status |
| /predict | POST | Predict House Price |
| /train | POST | Retrain Model |
| /predictions | GET | View Stored Predictions |

---

# 🗄 Task 4 — PostgreSQL Integration

The ML application stores prediction history inside PostgreSQL.

Features include:

- Database connectivity
- SQL queries
- Persistent prediction storage
- Historical prediction retrieval
- Docker networking

---

# ☸️ Task 5 — Kubernetes Deployment

Deploy the application into Kubernetes.

Resources created include:

- Deployment
- Service
- ConfigMap
- Replica Sets
- Pods

### Kubernetes Features

- Auto Scaling
- Load Balancing
- Health Checks
- Readiness Probes
- Rolling Updates
- Service Discovery

---


---

# ⚙️ Machine Learning Workflow

```text
Generate Dataset
       │
       ▼
Train Model
       │
       ▼
Save Model
       │
       ▼
Docker Container
       │
       ▼
Flask API
       │
       ▼
PostgreSQL Storage
       │
       ▼
Kubernetes Deployment
```

---

# 📡 REST API Workflow

```text
Client Request
      │
      ▼
 Flask API
      │
      ▼
 ML Model
      │
      ▼
 Prediction
      │
      ▼
 PostgreSQL
      │
      ▼
 JSON Response
```

---

# 🔒 Production Features

✅ Docker Containerization

✅ REST API

✅ PostgreSQL Integration

✅ Gunicorn Production Server

✅ Health Monitoring

✅ Kubernetes Deployment

✅ Load Balancing

✅ Scalability

✅ Model Persistence

✅ Database Persistence

---

# 📊 Skills Gained

- Docker Image Creation
- Docker Networking
- Flask Development
- REST API Design
- Machine Learning Deployment
- PostgreSQL Integration
- Kubernetes Deployments
- Kubernetes Services
- Kubernetes Scaling
- MLOps Fundamentals
- Production ML Systems

---

# 🎓 Learning Outcomes

After completing this lab, you will understand how to:

- Build production-ready ML applications
- Containerize AI workloads
- Deploy Machine Learning models
- Connect databases with containers
- Build scalable APIs
- Manage Kubernetes deployments
- Apply cloud-native DevOps practices

---

# 🌟 Key Highlights

- 🤖 Machine Learning Model Deployment
- 🐳 Docker Containerization
- 🌐 Flask REST API
- 🗄 PostgreSQL Integration
- ☸ Kubernetes Orchestration
- 📦 Production Image Creation
- 📊 Persistent Predictions
- 🚀 Scalable Cloud-Native Architecture

---

# 🏆 Conclusion

This project provides a complete hands-on introduction to **Machine Learning deployment using Docker and Kubernetes**. Starting from training a Scikit-Learn model, exposing it as a Flask REST API, integrating PostgreSQL for persistence, and finally deploying it into Kubernetes, this repository demonstrates real-world **MLOps** workflows used by modern AI and cloud engineering teams.

By completing this project, learners gain practical experience in **Docker**, **Flask**, **Machine Learning**, **PostgreSQL**, and **Kubernetes**, making it an excellent foundation for careers in **MLOps**, **Cloud Engineering**, **DevOps**, and **AI Infrastructure**.

---

# 👨‍💻 Author

**Muhammad Salman**

Cloud DevOps Engineer | Linux Administrator | AI & Cybersecurity Enthusiast

⭐ If you found this project helpful, don't forget to **Star** this repository!
