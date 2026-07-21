<div align="center">

# ☁️ Docker and Cloud — Deploying Docker Containers on Azure Kubernetes Service (AKS)

### Lab 76 · Build, push, deploy, expose, and autoscale a containerized app on AKS

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft%20Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![AKS](https://img.shields.io/badge/Azure%20Kubernetes%20Service-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

</div>

---

## 📑 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [☁️ Ready-to-Use Cloud Machines](#️-ready-to-use-cloud-machines)
- [🧭 Lab Environment Setup](#-lab-environment-setup)
- [🏗️ Task 1: Create an AKS Cluster on Azure](#️-task-1-create-an-aks-cluster-on-azure)
- [📦 Task 2: Push a Docker Image to Azure Container Registry (ACR)](#-task-2-push-a-docker-image-to-azure-container-registry-acr)
- [🚀 Task 3: Create a Kubernetes Deployment for the Docker Image in AKS](#-task-3-create-a-kubernetes-deployment-for-the-docker-image-in-aks)
- [🌐 Task 4: Expose the Application Using an Azure Load Balancer](#-task-4-expose-the-application-using-an-azure-load-balancer)
- [📈 Task 5: Scale the Application and Monitor it Using Azure Monitor](#-task-5-scale-the-application-and-monitor-it-using-azure-monitor)
- [🛠️ Troubleshooting Tips](#️-troubleshooting-tips)
- [🧹 Lab Cleanup](#-lab-cleanup)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | ☸️ Create and configure an Azure Kubernetes Service (AKS) cluster |
| 2 | 📦 Set up Azure Container Registry (ACR) for storing Docker images |
| 3 | 🏗️ Build and push Docker images to ACR |
| 4 | 🚀 Deploy containerized applications to AKS using Kubernetes manifests |
| 5 | 🌐 Expose applications using Azure Load Balancer |
| 6 | 📈 Scale applications horizontally in AKS |
| 7 | 📊 Monitor application performance using Azure Monitor and kubectl commands |

---

## 📋 Prerequisites

Before starting this lab, you should have:

| Requirement | Details |
|---|---|
| 🐳 Docker Fundamentals | Basic understanding of Docker containers and images |
| ☸️ Kubernetes Concepts | Familiarity with Kubernetes concepts (pods, deployments, services) |
| ⌨️ CLI Comfort | Basic knowledge of command-line interface operations |
| 📄 YAML Literacy | Understanding of YAML file structure |
| ☁️ Azure Access | An active Azure subscription (provided by Al Nafi) |

---

## ☁️ Ready-to-Use Cloud Machines

> **💡 Note:** Al Nafi provides pre-configured Linux-based cloud machines with all necessary tools installed. Simply click **Start Lab** to access your environment — no need to build your own VM or install additional software!

The machine includes:

- 🔷 Azure CLI pre-installed and configured
- 🐳 Docker Engine ready to use
- ☸️ `kubectl` command-line tool
- 📝 Text editors (nano, vim)
- 🧰 All required dependencies

---

## 🧭 Lab Environment Setup

Your cloud machine comes with the following tools pre-configured:

| Tool | Purpose |
|---|---|
| 🔷 Azure CLI | For managing Azure resources |
| 🐳 Docker | For building and managing containers |
| ☸️ kubectl | For interacting with Kubernetes clusters |
| 🌿 Git | For version control operations |

---

## 🏗️ Task 1: Create an AKS Cluster on Azure

### ✅ Subtask 1.1: Verify Azure CLI Installation and Login

First, let's verify that Azure CLI is properly installed and log into your Azure account.

```bash
# 🔍 Check Azure CLI version
az --version

# 🔑 Login to Azure (follow the prompts)
az login

# 📋 Set your subscription (if you have multiple)
az account list --output table
az account set --subscription "your-subscription-id"
# TODO: Replace 'your-subscription-id' with your actual Azure subscription ID
```

### ✅ Subtask 1.2: Create Resource Group

Create a resource group to organize all your Azure resources.

```bash
# 🗂️ Create a resource group
az group create \
    --name myAKSResourceGroup \
    --location eastus

# 🔍 Verify resource group creation
az group show --name myAKSResourceGroup --output table
```

### ✅ Subtask 1.3: Create AKS Cluster

Now, let's create the AKS cluster. This process may take 10-15 minutes.

```bash
# ☸️ Create AKS cluster
az aks create \
    --resource-group myAKSResourceGroup \
    --name myAKSCluster \
    --node-count 2 \
    --node-vm-size Standard_B2s \
    --enable-addons monitoring \
    --generate-ssh-keys \
    --attach-acr myContainerRegistry

# ⚠️ Note: The above command will fail initially because ACR doesn't exist yet
# We'll create ACR first, then create AKS cluster
```

Let's create the cluster without ACR attachment first:

```bash
# ☸️ Create AKS cluster without ACR
az aks create \
    --resource-group myAKSResourceGroup \
    --name myAKSCluster \
    --node-count 2 \
    --node-vm-size Standard_B2s \
    --enable-addons monitoring \
    --generate-ssh-keys
```

### ✅ Subtask 1.4: Configure kubectl

Configure kubectl to connect to your AKS cluster.

```bash
# 🔑 Get AKS credentials
az aks get-credentials \
    --resource-group myAKSResourceGroup \
    --name myAKSCluster

# 🔍 Verify connection to cluster
kubectl get nodes

# 🩺 Check cluster information
kubectl cluster-info
```

---

## 📦 Task 2: Push a Docker Image to Azure Container Registry (ACR)

### ✅ Subtask 2.1: Create Azure Container Registry

Create an Azure Container Registry to store your Docker images.

```bash
# 📦 Create ACR (name must be globally unique)
az acr create \
    --resource-group myAKSResourceGroup \
    --name mycontainerregistry$(date +%s) \
    --sku Basic

# 💾 Store ACR name in variable for later use
ACR_NAME=$(az acr list --resource-group myAKSResourceGroup --query "[0].name" --output tsv)
echo "ACR Name: $ACR_NAME"
```

### ✅ Subtask 2.2: Attach ACR to AKS Cluster

Connect your ACR to the AKS cluster for seamless image pulling.

```bash
# 🔗 Attach ACR to AKS cluster
az aks update \
    --resource-group myAKSResourceGroup \
    --name myAKSCluster \
    --attach-acr $ACR_NAME

# 🔍 Verify attachment
az aks show \
    --resource-group myAKSResourceGroup \
    --name myAKSCluster \
    --query "servicePrincipalProfile"
```

### ✅ Subtask 2.3: Create a Sample Application

Let's create a simple Node.js web application to containerize.

```bash
# 📁 Create application directory
mkdir ~/sample-app
cd ~/sample-app

# 📝 Create package.json
cat > package.json << 'EOF'
{
  "name": "sample-app",
  "version": "1.0.0",
  "description": "Sample Node.js app for AKS deployment",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF
```

```bash
# 📝 Create server.js
cat > server.js << 'EOF'
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({
    message: 'Hello from AKS!',
    timestamp: new Date().toISOString(),
    hostname: require('os').hostname()
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
EOF
```

```dockerfile
# 🐳 Create Dockerfile
# Dockerfile
FROM node:16-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
```

### ✅ Subtask 2.4: Build and Push Docker Image

Build the Docker image and push it to ACR.

```bash
# 🔑 Login to ACR
az acr login --name $ACR_NAME

# 🌐 Get ACR login server
ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --query loginServer --output tsv)
echo "ACR Login Server: $ACR_LOGIN_SERVER"

# 🏗️ Build Docker image
docker build -t sample-app:v1 .

# 🏷️ Tag image for ACR
docker tag sample-app:v1 $ACR_LOGIN_SERVER/sample-app:v1

# ⬆️ Push image to ACR
docker push $ACR_LOGIN_SERVER/sample-app:v1

# 🔍 Verify image in ACR
az acr repository list --name $ACR_NAME --output table
az acr repository show-tags --name $ACR_NAME --repository sample-app --output table
```

---

## 🚀 Task 3: Create a Kubernetes Deployment for the Docker Image in AKS

### ✅ Subtask 3.1: Create Kubernetes Deployment Manifest

Create a deployment manifest for your application.

```bash
# 📁 Create kubernetes manifests directory
mkdir ~/k8s-manifests
cd ~/k8s-manifests

# 📝 Create deployment.yaml
cat > deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-app-deployment
  labels:
    app: sample-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: sample-app
  template:
    metadata:
      labels:
        app: sample-app
    spec:
      containers:
      - name: sample-app
        image: \$ACR_LOGIN_SERVER/sample-app:v1
        ports:
        - containerPort: 3000
        env:
        - name: PORT
          value: "3000"
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
EOF
# TODO: Pin the image tag to a specific build/commit SHA instead of a static 'v1' for production
```

### ✅ Subtask 3.2: Deploy Application to AKS

Deploy your application to the AKS cluster.

```bash
# 🚀 Apply deployment
kubectl apply -f deployment.yaml

# 🔍 Check deployment status
kubectl get deployments

# 🔍 Check pods
kubectl get pods

# 🔎 Check pod details
kubectl describe pods

# 📜 View pod logs
kubectl logs -l app=sample-app --tail=50
```

### ✅ Subtask 3.3: Verify Deployment

Verify that your deployment is running correctly.

```bash
# 🩺 Check deployment rollout status
kubectl rollout status deployment/sample-app-deployment

# 🔎 Get detailed deployment information
kubectl describe deployment sample-app-deployment

# 🔍 Check replica sets
kubectl get replicasets
```

---

## 🌐 Task 4: Expose the Application Using an Azure Load Balancer

### ✅ Subtask 4.1: Create Service Manifest

Create a service to expose your application externally.

```bash
# 📝 Create service.yaml
cat > service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: sample-app-service
  labels:
    app: sample-app
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 3000
    protocol: TCP
  selector:
    app: sample-app
EOF
```

### ✅ Subtask 4.2: Deploy Service

Deploy the service to create an Azure Load Balancer.

```bash
# 🚀 Apply service
kubectl apply -f service.yaml

# 🔍 Check service status
kubectl get services

# ⏳ Wait for external IP (this may take a few minutes)
kubectl get services --watch
```

### ✅ Subtask 4.3: Test Application Access

Once the external IP is assigned, test your application.

```bash
# 🌐 Get external IP
EXTERNAL_IP=$(kubectl get service sample-app-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "External IP: $EXTERNAL_IP"

# 🧪 Test application (wait until IP is available)
curl http://$EXTERNAL_IP

# 🩺 Test health endpoint
curl http://$EXTERNAL_IP/health

# 🖥️ Test from browser (if available)
echo "Access your application at: http://$EXTERNAL_IP"
```

---

## 📈 Task 5: Scale the Application and Monitor it Using Azure Monitor

### ✅ Subtask 5.1: Scale Application Horizontally

Scale your application to handle more traffic.

```bash
# 📈 Scale deployment to 5 replicas
kubectl scale deployment sample-app-deployment --replicas=5

# 👀 Check scaling progress
kubectl get pods --watch

# 🔍 Verify scaling
kubectl get deployment sample-app-deployment
kubectl get pods -l app=sample-app
```

### ✅ Subtask 5.2: Configure Horizontal Pod Autoscaler

Set up automatic scaling based on CPU usage.

```bash
# 📝 Create HPA manifest
cat > hpa.yaml << 'EOF'
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: sample-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: sample-app-deployment
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
EOF

# 🚀 Apply HPA
kubectl apply -f hpa.yaml

# 🔍 Check HPA status
kubectl get hpa
kubectl describe hpa sample-app-hpa
# TODO: Tune minReplicas/maxReplicas and target utilization to match expected production traffic
```

### ✅ Subtask 5.3: Monitor Application Performance

Use kubectl and Azure CLI to monitor your application.

```bash
# 📊 Check cluster resource usage
kubectl top nodes
kubectl top pods

# 📜 View application logs
kubectl logs -l app=sample-app --tail=100

# 🔍 Check service endpoints
kubectl get endpoints sample-app-service

# 👀 Monitor HPA behavior
kubectl get hpa --watch
```

### ✅ Subtask 5.4: Generate Load for Testing Autoscaling

Create a simple load test to trigger autoscaling.

```bash
# 🧪 Create a load testing pod
kubectl run load-test --image=busybox --restart=Never --rm -it -- /bin/sh

# 🔁 Inside the pod, run this command to generate load:
# while true; do wget -q -O- http://sample-app-service; done

# 👀 In another terminal, monitor the scaling:
kubectl get hpa --watch
kubectl get pods --watch
```

### ✅ Subtask 5.5: Access Azure Monitor

View detailed monitoring information in Azure portal.

```bash
# 🆔 Get AKS resource ID for Azure Monitor
az aks show \
    --resource-group myAKSResourceGroup \
    --name myAKSCluster \
    --query "id" \
    --output tsv

# 🔗 View cluster insights URL
echo "Access Azure Monitor at:"
echo "https://portal.azure.com/#blade/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/resourceId/$(az aks show --resource-group myAKSResourceGroup --name myAKSCluster --query 'id' --output tsv)/overview"
```

---

## 🛠️ Troubleshooting Tips

<details>
<summary>⚠️ Issue 1: ACR Authentication Problems</summary>

```bash
# 🔑 Re-authenticate with ACR
az acr login --name $ACR_NAME

# 🔍 Check ACR permissions
az acr show --name $ACR_NAME --query "adminUserEnabled"
```

</details>

<details>
<summary>⚠️ Issue 2: Pods Not Starting</summary>

```bash
# 🔎 Check pod events
kubectl describe pod <pod-name>

# 📜 Check image pull status
kubectl get events --sort-by=.metadata.creationTimestamp
```

</details>

<details>
<summary>⚠️ Issue 3: Service External IP Pending</summary>

```bash
# 🔎 Check service events
kubectl describe service sample-app-service

# 🔍 Verify load balancer provisioning
kubectl get events --field-selector involvedObject.name=sample-app-service
```

</details>

<details>
<summary>⚠️ Issue 4: HPA Not Scaling</summary>

```bash
# 🔍 Check metrics server
kubectl get pods -n kube-system | grep metrics-server

# 🔎 Verify resource requests are set
kubectl describe deployment sample-app-deployment
```

</details>

---

## 🧹 Lab Cleanup

When you're finished with the lab, clean up resources to avoid charges.

```bash
# 🗑️ Delete Kubernetes resources
kubectl delete -f hpa.yaml
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml

# 🗑️ Delete Azure resources
az group delete --name myAKSResourceGroup --yes --no-wait

# 🔍 Verify deletion
az group list --output table
```

---

## 🏁 Conclusion

Congratulations! You have successfully completed **Lab 76**. In this lab, you accomplished the following:

### 🏆 Key Achievements

| Achievement | Description |
|---|---|
| ☸️ Created an AKS Cluster | Set up a fully managed Kubernetes cluster on Azure with monitoring enabled |
| 📦 Configured Container Registry | Created and configured Azure Container Registry for secure image storage |
| 🐳 Containerized an Application | Built a Node.js application, containerized it with Docker, and pushed it to ACR |
| 🚀 Deployed to Kubernetes | Created Kubernetes deployment manifests and successfully deployed your application |
| 🌐 Exposed with Load Balancer | Configured an Azure Load Balancer to make your application accessible from the internet |
| 📈 Implemented Scaling | Manually scaled your application and set up automatic horizontal pod autoscaling |
| 📊 Monitored Performance | Used both kubectl commands and Azure Monitor to track application performance |

### 🌍 Why This Matters

This lab demonstrates real-world cloud-native application deployment patterns used by organizations worldwide. The skills you've learned are essential for:

- ⚙️ **DevOps Engineers** — Managing containerized applications in production environments
- 🏛️ **Cloud Architects** — Designing scalable, resilient application architectures
- 🧑‍💻 **Software Developers** — Understanding how applications behave in cloud environments
- 🛡️ **Site Reliability Engineers** — Monitoring and maintaining application performance

### 🔭 Next Steps

Consider exploring these advanced topics:

- 🔄 Implementing CI/CD pipelines with Azure DevOps
- ⛵ Using Helm charts for complex application deployments
- 🕸️ Implementing service mesh with Istio
- 📊 Setting up advanced monitoring with Prometheus and Grafana
- 🔒 Implementing security best practices with Azure Policy and Pod Security Standards

> You now have hands-on experience with one of the most popular container orchestration platforms, preparing you for the Docker Certified Associate certification and real-world cloud deployments.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1a1a2e?style=for-the-badge)

</div>
