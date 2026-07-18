<div align="center">

# 🐳Docker and Kubernetes Integration ☸️

### Building, Containerizing, and Orchestrating a Web Application from Docker to Kubernetes

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Minikube](https://img.shields.io/badge/Minikube-FFCC00?style=for-the-badge&logo=kubernetes&logoColor=black)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![DockerHub](https://img.shields.io/badge/Docker%20Hub-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![kubectl](https://img.shields.io/badge/kubectl-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)

![Level](https://img.shields.io/badge/Level-Intermediate-orange?style=for-the-badge)
![Duration](https://img.shields.io/badge/Duration-90%20min-informational?style=for-the-badge)
![Track](https://img.shields.io/badge/Track-DevOps%20%2F%20Cloud-blueviolet?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Objectives](#-objectives)
- [🧩 Prerequisites](#-prerequisites)
- [🛠️ Required Tools](#️-required-tools)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [1️⃣ Task 1: Set Up a Kubernetes Cluster Using Minikube](#1️⃣-task-1-set-up-a-kubernetes-cluster-using-minikube)
- [2️⃣ Task 2: Build a Docker Image for a Simple Web App](#2️⃣-task-2-build-a-docker-image-for-a-simple-web-app)
- [3️⃣ Task 3: Push the Docker Image to a Container Registry](#3️⃣-task-3-push-the-docker-image-to-a-container-registry)
- [4️⃣ Task 4: Deploy the Image to Kubernetes Using a Pod](#4️⃣-task-4-deploy-the-image-to-kubernetes-using-a-pod)
- [5️⃣ Task 5: Expose the Kubernetes Service Externally](#5️⃣-task-5-expose-the-kubernetes-service-externally)
- [✅ Verification and Testing](#-verification-and-testing)
- [📈 Bonus: Scaling Test](#-bonus-scaling-test)
- [🐛 Troubleshooting](#-troubleshooting)
- [🧹 Cleanup](#-cleanup)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | Set up a local Kubernetes cluster using Minikube |
| 2 | Build and containerize a simple web application using Docker |
| 3 | Push Docker images to the Docker Hub container registry |
| 4 | Deploy containerized applications to Kubernetes using Pods |
| 5 | Create and configure Kubernetes Services to expose applications |
| 6 | Access deployed applications externally through Kubernetes Services |
| 7 | Understand the integration workflow between Docker and Kubernetes |

---

## 🧩 Prerequisites

| Requirement | Description |
|-------------|-------------|
| 🧠 Containerization concepts | Basic understanding of what containers are and why they're used |
| ⌨️ CLI comfort | Familiarity with command-line interface operations |
| 🌐 Web app basics | Basic knowledge of web applications and networking |
| 📄 YAML structure | Understanding of YAML file structure |
| 🐳 Docker fundamentals | Comfort with images, containers, and Dockerfiles |

---

## 🛠️ Required Tools

> Pre-installed on your Al Nafi cloud machine — no manual setup needed.

- 🐳 Docker Engine
- ☸️ kubectl (Kubernetes command-line tool)
- 📦 Minikube (local Kubernetes cluster)
- 🔧 Git
- 📝 Text editor (nano/vim)
- 🌐 curl

---

## 🖥️ Lab Environment Setup

> 🖱️ **Al Nafi Cloud Machine Access:** Simply click **Start Lab** to access your pre-configured Linux-based cloud machine. All necessary tools are already installed and ready to use.

---

## 1️⃣ Task 1: Set Up a Kubernetes Cluster Using Minikube

### 🔹 Subtask 1.1: Start Minikube

Start your local Kubernetes cluster.

```bash
# 🚀 Start Minikube with Docker driver
minikube start --driver=docker

# 🔍 Verify Minikube status
minikube status
```

### 🔹 Subtask 1.2: Verify Kubernetes Cluster

Confirm the cluster is healthy.

```bash
# ℹ️ Check cluster information
kubectl cluster-info

# 🖥️ View cluster nodes
kubectl get nodes

# 📦 Check if all system pods are running
kubectl get pods -n kube-system
```

> ✅ **Expected Output:** Your Minikube node shows `Ready` status, and all system pods show `Running`.

### 🔹 Subtask 1.3: Configure Docker Environment

Point your shell's Docker client at Minikube's internal Docker daemon.

```bash
# 🔗 Configure Docker to use Minikube's Docker daemon
eval $(minikube docker-env)

# 🔍 Verify Docker is working with Minikube
docker ps
```

---

## 2️⃣ Task 2: Build a Docker Image for a Simple Web App

### 🔹 Subtask 2.1: Create Application Directory

```bash
# 📁 Create project directory
mkdir ~/webapp-k8s
cd ~/webapp-k8s

# 📁 Create application files directory
mkdir app
```

### 🔹 Subtask 2.2: Create a Simple Web Application

Build a small Python Flask app that reports its own container hostname.

```python
# 🐍 app/app.py
from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = socket.gethostname()
    return f'''
    <html>
        <head><title>Docker + Kubernetes Demo</title></head>
        <body style="font-family: Arial, sans-serif; text-align: center; margin-top: 50px;">
            <h1 style="color: #2196F3;">Welcome to Docker + Kubernetes Integration!</h1>
            <h2 style="color: #4CAF50;">Container Hostname: {hostname}</h2>
            <p>This application is running in a Docker container managed by Kubernetes.</p>
            <p style="color: #666;">Lab 31: Docker and Kubernetes Integration</p>
        </body>
    </html>
    '''

@app.route('/health')
def health():
    # 💓 Simple health endpoint used later by liveness/readiness probes
    return {'status': 'healthy', 'hostname': socket.gethostname()}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
```

### 🔹 Subtask 2.3: Create Requirements File

```text
# 📦 app/requirements.txt
Flask==2.3.3
Werkzeug==2.3.7
```

### 🔹 Subtask 2.4: Create Dockerfile

```dockerfile
# 🐳 Dockerfile

# 🏗️ Use official Python runtime as base image
FROM python:3.9-slim

# 📂 Set working directory in container
WORKDIR /app

# 📦 Copy requirements file
COPY app/requirements.txt .

# ⚙️ Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 📋 Copy application code
COPY app/ .

# 🌐 Expose port 5000
EXPOSE 5000

# 🔧 Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# ▶️ Run the application
CMD ["python", "app.py"]
```

### 🔹 Subtask 2.5: Build Docker Image

```bash
# 🏗️ Build Docker image
docker build -t webapp-k8s:v1.0 .

# 🔍 Verify image was created
docker images | grep webapp-k8s

# 🧪 Test the image locally (optional)
docker run -d -p 8080:5000 --name test-webapp webapp-k8s:v1.0

# 🌐 Test the application
curl http://localhost:8080

# 🛑 Stop and remove test container
docker stop test-webapp
docker rm test-webapp
```

---

## 3️⃣ Task 3: Push the Docker Image to a Container Registry

### 🔹 Subtask 3.1: Create Docker Hub Account and Login

> 📝 **Note:** You'll need a Docker Hub account for this step. If you don't have one, create it at [hub.docker.com](https://hub.docker.com).

```bash
# 🔐 Login to Docker Hub
docker login
# Enter your Docker Hub username and password when prompted
```

### 🔹 Subtask 3.2: Tag Image for Docker Hub

```bash
# ✏️ Replace 'yourusername' with your actual Docker Hub username
# TODO: set this to your own Docker Hub username
export DOCKER_USERNAME=yourusername

# 🏷️ Tag the image for Docker Hub
docker tag webapp-k8s:v1.0 $DOCKER_USERNAME/webapp-k8s:v1.0

# 🔍 Verify the tag
docker images | grep webapp-k8s
```

### 🔹 Subtask 3.3: Push Image to Docker Hub

```bash
# 📤 Push image to Docker Hub
docker push $DOCKER_USERNAME/webapp-k8s:v1.0

echo "✅ Image pushed successfully to Docker Hub!"
```

> 🔁 **Alternative for Lab Environment:** If you don't want to use Docker Hub, use Minikube's local registry instead.

```bash
# 🧩 Enable Minikube registry addon
minikube addons enable registry

# 🏷️ Tag image for local registry
docker tag webapp-k8s:v1.0 localhost:5000/webapp-k8s:v1.0

# 📤 Push to local registry
docker push localhost:5000/webapp-k8s:v1.0
```

---

## 4️⃣ Task 4: Deploy the Image to Kubernetes Using a Pod

### 🔹 Subtask 4.1: Create Pod Configuration

```yaml
# ☸️ webapp-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: webapp-pod
  labels:
    app: webapp
    version: v1.0
spec:
  containers:
  - name: webapp-container
    image: $DOCKER_USERNAME/webapp-k8s:v1.0   # TODO: substitute your Docker Hub username
    ports:
    - containerPort: 5000
      name: http
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
    livenessProbe:                # 💓 Restarts the container if it stops responding
      httpGet:
        path: /health
        port: 5000
      initialDelaySeconds: 30
      periodSeconds: 10
    readinessProbe:                # 🚦 Only routes traffic once the app is ready
      httpGet:
        path: /health
        port: 5000
      initialDelaySeconds: 5
      periodSeconds: 5
```

> 🔁 **For Local Registry Users:** if using Minikube's local registry, use this alternative Pod config instead.

```yaml
# ☸️ webapp-pod-local.yaml
apiVersion: v1
kind: Pod
metadata:
  name: webapp-pod
  labels:
    app: webapp
    version: v1.0
spec:
  containers:
  - name: webapp-container
    image: localhost:5000/webapp-k8s:v1.0
    ports:
    - containerPort: 5000
      name: http
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```

### 🔹 Subtask 4.2: Deploy Pod to Kubernetes

```bash
# ▶️ Apply pod configuration
kubectl apply -f webapp-pod.yaml

# 🔍 Verify pod creation
kubectl get pods

# 📋 Check pod details
kubectl describe pod webapp-pod

# 📜 View pod logs
kubectl logs webapp-pod
```

### 🔹 Subtask 4.3: Verify Pod Is Running

```bash
# ⏳ Wait for pod to be ready
kubectl wait --for=condition=Ready pod/webapp-pod --timeout=60s

# 🔍 Check pod status
kubectl get pod webapp-pod -o wide

# 🧪 Test application inside the pod
kubectl exec webapp-pod -- curl http://localhost:5000/health
```

---

## 5️⃣ Task 5: Expose the Kubernetes Service Externally

### 🔹 Subtask 5.1: Create Service Configuration

```yaml
# ☸️ webapp-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
  labels:
    app: webapp
spec:
  type: NodePort
  selector:
    app: webapp
  ports:
  - port: 80
    targetPort: 5000
    nodePort: 30080
    protocol: TCP
    name: http
```

### 🔹 Subtask 5.2: Deploy Service to Kubernetes

```bash
# ▶️ Apply service configuration
kubectl apply -f webapp-service.yaml

# 🔍 Verify service creation
kubectl get services

# 📋 Check service details
kubectl describe service webapp-service
```

### 🔹 Subtask 5.3: Access Application Externally

```bash
# 📍 Get Minikube IP
minikube ip

# 🔗 Get service URL
minikube service webapp-service --url

# 🧪 Test the application
curl $(minikube service webapp-service --url)

# 🖱️ Open in browser (if GUI available)
minikube service webapp-service
```

### 🔹 Subtask 5.4: Alternative Access Methods

```bash
# 🔀 Port forwarding method
kubectl port-forward pod/webapp-pod 8080:5000 &

# 🧪 Test with port forwarding
curl http://localhost:8080

# 🛑 Stop port forwarding
pkill -f "kubectl port-forward"

# 🌐 Using kubectl proxy
kubectl proxy --port=8001 &

# 🧪 Access through proxy
curl http://localhost:8001/api/v1/namespaces/default/pods/webapp-pod:5000/proxy/

# 🛑 Stop proxy
pkill -f "kubectl proxy"
```

---

## ✅ Verification and Testing

### 🔹 Complete Application Test

```bash
# 🧪 Test all endpoints
echo "Testing main endpoint:"
curl $(minikube service webapp-service --url)

echo -e "\n\nTesting health endpoint:"
curl $(minikube service webapp-service --url)/health

# 📊 Check resource usage
kubectl top pod webapp-pod

# 📜 View application logs
kubectl logs webapp-pod --tail=20
```

---

## 📈 Bonus: Scaling Test

Learn how to scale your application using a Deployment instead of a single Pod.

```yaml
# ☸️ webapp-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-deployment
  labels:
    app: webapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp-container
        image: $DOCKER_USERNAME/webapp-k8s:v1.0   # TODO: substitute your Docker Hub username
        ports:
        - containerPort: 5000
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
```

```bash
# ▶️ Deploy the deployment
kubectl apply -f webapp-deployment.yaml

# 🔍 Check deployment status
kubectl get deployments
kubectl get pods -l app=webapp

# ⚖️ Test load balancing across replicas
for i in {1..10}; do
  curl -s $(minikube service webapp-service --url) | grep "Container Hostname"
done
```

---

## 🐛 Troubleshooting

<details>
<summary>🔴 Issue 1: Pod Not Starting</summary>

```bash
# 📋 Check pod events
kubectl describe pod webapp-pod

# 📜 Check pod logs
kubectl logs webapp-pod
```

**Common solutions:**
- Verify image name and tag
- Check if image exists in registry
- Verify resource limits

</details>

<details>
<summary>🟠 Issue 2: Service Not Accessible</summary>

```bash
# 🔍 Verify service endpoints
kubectl get endpoints webapp-service

# 🏷️ Check if pod labels match service selector
kubectl get pod webapp-pod --show-labels

# 📋 Verify port configuration
kubectl describe service webapp-service
```

</details>

<details>
<summary>🟡 Issue 3: Image Pull Errors</summary>

```bash
# 🔐 For Docker Hub authentication issues
kubectl create secret docker-registry regcred \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=$DOCKER_USERNAME \
  --docker-password=your-password \
  --docker-email=your-email

# 🔗 Update pod to use secret
kubectl patch pod webapp-pod -p '{"spec":{"imagePullSecrets":[{"name":"regcred"}]}}'
```

</details>

---

## 🧹 Cleanup

```bash
# 🗑️ Delete service
kubectl delete service webapp-service

# 🗑️ Delete pod
kubectl delete pod webapp-pod

# 🗑️ Delete deployment (if created)
kubectl delete deployment webapp-deployment

# 🗑️ Remove local files
cd ~
rm -rf webapp-k8s

# 🛑 Stop Minikube (optional)
minikube stop
```

---

## 🏁 Conclusion

Congratulations! 🎉 You have successfully completed **Lab 31: Docker and Kubernetes Integration**.

### 🏆 Key Achievements

| Achievement | Description |
|-------------|-------------|
| ☸️ Kubernetes Cluster Setup | Deployed a local Kubernetes cluster using Minikube, providing a foundation for container orchestration |
| 🐳 Application Containerization | Built a Docker image for a Python Flask web application |
| 📦 Container Registry Integration | Pushed the Docker image to Docker Hub for sharing and distribution |
| 🚀 Kubernetes Deployment | Deployed the containerized app to Kubernetes using Pods |
| 🌐 Service Exposure | Created and configured a Kubernetes Service to make the app externally accessible |
| 🔄 End-to-End Integration | Demonstrated the full workflow from Docker image creation to Kubernetes deployment |

### 💡 Why This Matters

- **📈 Scalability** — Kubernetes can automatically scale Docker containers based on demand
- **🛡️ High Availability** — Applications stay available even if individual containers fail
- **⚙️ Resource Management** — Efficient resource allocation across your infrastructure
- **🏭 Production Readiness** — This workflow mirrors real production deployment pipelines
- **💼 Career Relevance** — Core skills for Docker Certified Associate (DCA) certification and modern DevOps roles

### 🔮 Next Steps

- 🚢 Explore Kubernetes Deployments and ReplicaSets for better application management
- 🌐 Learn about Kubernetes Ingress controllers for advanced routing
- 💾 Study Kubernetes Persistent Volumes for stateful applications
- ⎈ Practice with Helm charts for package management
- 📊 Investigate monitoring and logging solutions for Kubernetes clusters

> You now have hands-on experience with the core technologies that power modern containerized applications in production environments! 🚀

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
