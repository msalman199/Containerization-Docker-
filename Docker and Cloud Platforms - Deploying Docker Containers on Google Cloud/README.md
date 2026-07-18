<div align="center">

# ☁️Docker and Cloud Platforms 🚢

### Deploying Docker Containers on Google Cloud with GKE, GCR, and Cloud Load Balancing

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![GoogleCloud](https://img.shields.io/badge/Google%20Cloud-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)
![GKE](https://img.shields.io/badge/GKE-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![GCR](https://img.shields.io/badge/Container%20Registry-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)
![NodeJS](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![kubectl](https://img.shields.io/badge/kubectl-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![gcloud](https://img.shields.io/badge/gcloud%20CLI-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)

![Level](https://img.shields.io/badge/Level-Intermediate-orange?style=for-the-badge)
![Duration](https://img.shields.io/badge/Duration-120%20min-informational?style=for-the-badge)
![Track](https://img.shields.io/badge/Track-Cloud%20%2F%20DevOps-blueviolet?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [🧩 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [1️⃣ Task 1: Set Up GCP Account and Configure Google Cloud SDK](#1️⃣-task-1-set-up-gcp-account-and-configure-google-cloud-sdk)
- [2️⃣ Task 2: Create a Google Kubernetes Engine (GKE) Cluster](#2️⃣-task-2-create-a-google-kubernetes-engine-gke-cluster)
- [3️⃣ Task 3: Build Docker Image and Push to Google Container Registry](#3️⃣-task-3-build-docker-image-and-push-to-google-container-registry)
- [4️⃣ Task 4: Deploy Docker Image to GKE and Expose Externally](#4️⃣-task-4-deploy-docker-image-to-gke-and-expose-externally)
- [5️⃣ Task 5: Scale Application and Monitor Using Google Cloud Tools](#5️⃣-task-5-scale-application-and-monitor-using-google-cloud-tools)
- [🐛 Troubleshooting](#-troubleshooting)
- [🧹 Cleanup Resources](#-cleanup-resources)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | Set up and configure Google Cloud Platform (GCP) account and Google Cloud SDK |
| 2 | Create and manage a Google Kubernetes Engine (GKE) cluster |
| 3 | Build Docker images and push them to Google Container Registry (GCR) |
| 4 | Deploy containerized applications to GKE with external access |
| 5 | Scale applications and monitor them using Google Cloud's native tools |
| 6 | Understand the fundamentals of container orchestration in cloud environments |

---

## 🧩 Prerequisites

| Requirement | Description |
|-------------|-------------|
| 🐳 Docker basics | Understanding of Docker containers and containerization concepts |
| ⌨️ CLI comfort | Familiarity with command-line interface (CLI) operations |
| ☸️ Kubernetes basics | Basic knowledge of pods, services, and deployments |
| 🌐 Web/HTTP basics | Understanding of web applications and HTTP protocols |
| 🔑 Google account | A valid Google account for accessing Google Cloud Platform |

---

## 🖥️ Lab Environment Setup

> 🖱️ **Ready-to-Use Cloud Machines:** Al Nafi provides pre-configured Linux-based cloud machines with all necessary tools installed. Simply click **Start Lab** to begin — no need to build your own VM or install additional software.

Your cloud machine includes:

- 🐳 Docker Engine (latest stable version)
- ☁️ Google Cloud SDK (`gcloud` CLI)
- ☸️ kubectl (Kubernetes command-line tool)
- 📝 Text editors (nano, vim)
- 🔧 All required dependencies

---

## 1️⃣ Task 1: Set Up GCP Account and Configure Google Cloud SDK

### 🔹 Subtask 1.1: Initialize Google Cloud SDK

1. 💻 Open the terminal on your Al Nafi cloud machine
2. ▶️ Initialize gcloud configuration:

```bash
# 🚀 Initialize gcloud configuration
gcloud init
```

**📋 Follow the interactive prompts:**
- 1️⃣ Choose option 1 to log in with a new account
- 🔗 Copy the provided URL and paste it into a web browser
- 🔑 Sign in with your Google account
- 📋 Copy the authorization code back to the terminal

```bash
# ✅ Verify your authentication
gcloud auth list
```

### 🔹 Subtask 1.2: Create a New GCP Project

```bash
# 🆕 Create a new project (replace PROJECT_ID with your unique project name)
export PROJECT_ID="docker-gke-lab-$(date +%s)"
gcloud projects create $PROJECT_ID --name="Docker GKE Lab"

# 🎯 Set the project as default
gcloud config set project $PROJECT_ID

# 🔌 Enable required APIs
gcloud services enable container.googleapis.com
gcloud services enable containerregistry.googleapis.com

# ✅ Verify project configuration
gcloud config get-value project
```

### 🔹 Subtask 1.3: Set Default Region and Zone

```bash
# 🗺️ Set default compute region
gcloud config set compute/region us-central1

# 📍 Set default compute zone
gcloud config set compute/zone us-central1-a

# ✅ Verify configuration
gcloud config list
```

---

## 2️⃣ Task 2: Create a Google Kubernetes Engine (GKE) Cluster

### 🔹 Subtask 2.1: Create the GKE Cluster

```bash
# ☸️ Create a GKE cluster with basic configuration
gcloud container clusters create docker-lab-cluster \
    --zone=us-central1-a \
    --num-nodes=3 \
    --machine-type=e2-medium \
    --disk-size=20GB \
    --enable-autorepair \
    --enable-autoupgrade
```

> ⏳ **Note:** this process takes approximately 3–5 minutes to complete.

```bash
# ✅ Verify cluster creation
gcloud container clusters list
```

### 🔹 Subtask 2.2: Configure kubectl

```bash
# 🔗 Get cluster credentials
gcloud container clusters get-credentials docker-lab-cluster --zone=us-central1-a

# ✅ Verify kubectl configuration
kubectl cluster-info

# 🖥️ Check cluster nodes
kubectl get nodes
```

> ✅ **Expected Output:** you should see 3 nodes in `Ready` status.

---

## 3️⃣ Task 3: Build Docker Image and Push to Google Container Registry

### 🔹 Subtask 3.1: Create a Sample Web Application

```bash
# 📁 Create a project directory
mkdir ~/docker-gke-app
cd ~/docker-gke-app
```

```javascript
// 🟢 app.js — simple Node.js Express application
const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
    res.json({
        message: 'Hello from Docker on Google Cloud!',
        timestamp: new Date().toISOString(),
        hostname: require('os').hostname()
    });
});

app.get('/health', (req, res) => {
    // 💓 Health endpoint used later by liveness/readiness probes
    res.status(200).json({ status: 'healthy' });
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
```

```json
{
  "name": "docker-gke-app",
  "version": "1.0.0",
  "description": "Sample app for Docker GKE deployment",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

### 🔹 Subtask 3.2: Create Dockerfile

```dockerfile
# 🐳 Dockerfile

# 🏗️ Use official Node.js runtime as base image
FROM node:18-alpine

# 📂 Set working directory in container
WORKDIR /usr/src/app

# 📦 Copy package files
COPY package*.json ./

# ⚙️ Install dependencies
RUN npm install --only=production

# 📋 Copy application code
COPY . .

# 🌐 Expose port 8080
EXPOSE 8080

# 👤 Create non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001
USER nodejs

# ▶️ Start the application
CMD ["npm", "start"]
```

### 🔹 Subtask 3.3: Build and Test Docker Image Locally

```bash
# 🏗️ Build the Docker image
docker build -t docker-gke-app:v1.0 .

# 🚀 Test the image locally
docker run -d -p 8080:8080 --name test-app docker-gke-app:v1.0

# 🧪 Test the application
curl http://localhost:8080
curl http://localhost:8080/health

# 🛑 Stop and remove test container
docker stop test-app
docker rm test-app
```

### 🔹 Subtask 3.4: Push Image to Google Container Registry

```bash
# 🔐 Configure Docker to use gcloud as credential helper
gcloud auth configure-docker

# 🏷️ Tag the image for GCR
docker tag docker-gke-app:v1.0 gcr.io/$PROJECT_ID/docker-gke-app:v1.0

# 📤 Push the image to GCR
docker push gcr.io/$PROJECT_ID/docker-gke-app:v1.0

# ✅ Verify image in registry
gcloud container images list
```

---

## 4️⃣ Task 4: Deploy Docker Image to GKE and Expose Externally

### 🔹 Subtask 4.1: Create Kubernetes Deployment

```yaml
# ☸️ deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: docker-gke-app
  labels:
    app: docker-gke-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: docker-gke-app
  template:
    metadata:
      labels:
        app: docker-gke-app
    spec:
      containers:
      - name: docker-gke-app
        image: gcr.io/$PROJECT_ID/docker-gke-app:v1.0   # TODO: substitute your $PROJECT_ID
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
        livenessProbe:                # 💓 Restarts the container if it stops responding
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:                # 🚦 Only routes traffic once the app is ready
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

```bash
# ✏️ Replace PROJECT_ID in the deployment file
sed -i "s/\$PROJECT_ID/$PROJECT_ID/g" deployment.yaml

# ▶️ Apply the deployment
kubectl apply -f deployment.yaml

# ✅ Verify deployment
kubectl get deployments
kubectl get pods
```

### 🔹 Subtask 4.2: Create Service to Expose Application

```yaml
# ☸️ service.yaml
apiVersion: v1
kind: Service
metadata:
  name: docker-gke-app-service
  labels:
    app: docker-gke-app
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
  selector:
    app: docker-gke-app
```

```bash
# ▶️ Apply the service
kubectl apply -f service.yaml

# ⏳ Wait for external IP assignment (this may take 2-3 minutes)
kubectl get services --watch
# 🛑 Press Ctrl+C when you see an external IP assigned

# 📍 Get the external IP
EXTERNAL_IP=$(kubectl get service docker-gke-app-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "External IP: $EXTERNAL_IP"
```

### 🔹 Subtask 4.3: Test External Access

```bash
# 🧪 Test the application via external IP
curl http://$EXTERNAL_IP
curl http://$EXTERNAL_IP/health
```

**🌐 Test in web browser (if available):**
1. Open your web browser
2. Navigate to `http://[EXTERNAL_IP]`
3. ✅ You should see the JSON response from your application

---

## 5️⃣ Task 5: Scale Application and Monitor Using Google Cloud Tools

### 🔹 Subtask 5.1: Scale the Application

```bash
# ⬆️ Scale up the deployment to 5 replicas
kubectl scale deployment docker-gke-app --replicas=5

# ✅ Verify scaling
kubectl get pods

# 🔍 Check deployment status
kubectl rollout status deployment/docker-gke-app

# ⬇️ Scale down to 2 replicas
kubectl scale deployment docker-gke-app --replicas=2
```

### 🔹 Subtask 5.2: Monitor Application Performance

```bash
# 📜 View pod logs
kubectl logs -l app=docker-gke-app --tail=50

# 📋 Get detailed pod information
kubectl describe pods -l app=docker-gke-app

# 📊 Monitor resource usage
kubectl top nodes
kubectl top pods
```

### 🔹 Subtask 5.3: Use Google Cloud Console for Monitoring

```bash
# 🌐 Access GKE workloads in Cloud Console
echo "Visit: https://console.cloud.google.com/kubernetes/workload?project=$PROJECT_ID"
```

**📊 View key metrics:**
- ⚙️ CPU utilization
- 🧠 Memory usage
- 🌐 Network traffic
- ❤️ Pod status and health

### 🔹 Subtask 5.4: Test Load Balancing

```bash
# ⚖️ Generate multiple requests to test load balancing
for i in {1..10}; do
  echo "Request $i:"
  curl -s http://$EXTERNAL_IP | jq '.hostname'
  sleep 1
done
```

> ✅ **Expected Output:** you should see different hostnames, indicating requests are being distributed across multiple pods.

### 🔹 Subtask 5.5: Update Application (Rolling Update)

```bash
# ✏️ Modify the application
sed -i 's/Hello from Docker on Google Cloud!/Hello from Updated Docker App on GKE!/g' app.js

# 🏗️ Build new version
docker build -t docker-gke-app:v2.0 .

# 🏷️ Tag and push new version
docker tag docker-gke-app:v2.0 gcr.io/$PROJECT_ID/docker-gke-app:v2.0
docker push gcr.io/$PROJECT_ID/docker-gke-app:v2.0

# 🔄 Update deployment with new image
kubectl set image deployment/docker-gke-app docker-gke-app=gcr.io/$PROJECT_ID/docker-gke-app:v2.0

# 👀 Monitor rolling update
kubectl rollout status deployment/docker-gke-app

# 🧪 Test updated application
curl http://$EXTERNAL_IP
```

---

## 🐛 Troubleshooting

<details>
<summary>🔴 Issue 1: Authentication Problems</summary>

**Problem:** `gcloud` authentication fails

```bash
# 🔐 Solution
gcloud auth revoke --all
gcloud auth login
```

</details>

<details>
<summary>🟠 Issue 2: Cluster Creation Fails</summary>

**Problem:** Insufficient quota or permissions

```bash
# 🔍 Solution
gcloud compute project-info describe --project=$PROJECT_ID
gcloud services enable compute.googleapis.com
```

</details>

<details>
<summary>🟡 Issue 3: Image Push Fails</summary>

**Problem:** Docker not configured for GCR

```bash
# 🔧 Solution
gcloud auth configure-docker --quiet
docker system prune -f
```

</details>

<details>
<summary>🟢 Issue 4: Pods Not Starting</summary>

**Problem:** Image pull errors

```bash
# 🔍 Solution
kubectl describe pod [POD_NAME]
kubectl logs [POD_NAME]
```

</details>

<details>
<summary>🔵 Issue 5: External IP Not Assigned</summary>

**Problem:** LoadBalancer service stuck in pending

```bash
# 🔍 Solution
kubectl describe service docker-gke-app-service
gcloud compute addresses list
```

</details>

---

## 🧹 Cleanup Resources

> 💰 To avoid ongoing charges, clean up the resources created in this lab.

```bash
# 🗑️ Delete the service
kubectl delete service docker-gke-app-service

# 🗑️ Delete the deployment
kubectl delete deployment docker-gke-app

# 🗑️ Delete the GKE cluster
gcloud container clusters delete docker-lab-cluster --zone=us-central1-a --quiet

# 🗑️ Delete container images
gcloud container images delete gcr.io/$PROJECT_ID/docker-gke-app:v1.0 --quiet
gcloud container images delete gcr.io/$PROJECT_ID/docker-gke-app:v2.0 --quiet

# 🗑️ Delete the project (optional)
gcloud projects delete $PROJECT_ID --quiet
```

---

## 🏁 Conclusion

Congratulations! 🎉 You have successfully completed **Lab 35: Docker and Cloud Platforms — Deploying Docker Containers on Google Cloud**.

### 🏆 What You Accomplished

| Achievement | Description |
|-------------|-------------|
| ☁️ GCP Setup | Configured GCP account, enabled necessary APIs, and established proper authentication |
| ☸️ GKE Cluster Created | Deployed a managed Kubernetes cluster with multiple nodes for container orchestration |
| 🐳 Built and Containerized Application | Created a Node.js web application, containerized it with Docker, and pushed it to Google Container Registry |
| 🚀 Deployed to Production | Successfully deployed the containerized application to GKE with external load balancer access |
| 📈 Implemented Scaling | Demonstrated horizontal scaling and performed rolling updates without downtime |
| 📊 Monitored Applications | Used both command-line tools and Google Cloud Console to monitor application performance and health |

### 💡 Why This Matters

- **☸️ Container Orchestration** — Understanding how Kubernetes manages containerized applications at scale
- **☁️ Cloud Integration** — Learning how cloud platforms provide managed services that simplify deployment and operations
- **⚙️ DevOps Practices** — Implementing continuous deployment, scaling, and monitoring practices
- **🏭 Production Readiness** — Configuring health checks, resource limits, and load balancing for production workloads

### 🔮 Next Steps

- 🗺️ Explore advanced Kubernetes features like ConfigMaps, Secrets, and Persistent Volumes
- 🏗️ Implement CI/CD pipelines using Google Cloud Build
- 🕸️ Learn about service mesh technologies like Istio
- 🌍 Study multi-region deployments and disaster recovery strategies
- ☁️ Practice with other cloud platforms like AWS EKS or Azure AKS

> These skills are essential for the Docker Certified Associate (DCA) certification and are highly valued in modern software development and DevOps roles! 🚀

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
