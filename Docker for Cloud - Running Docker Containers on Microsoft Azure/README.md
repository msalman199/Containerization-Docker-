<div align="center">

# 🐳☁️ Docker for Cloud — Running Docker Containers on Microsoft Azure

### Azure Container Registry, Container Instances & Monitoring

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft_Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Azure CLI](https://img.shields.io/badge/Azure_CLI-0078D4?style=for-the-badge&logo=powershell&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Level](https://img.shields.io/badge/Level-Intermediate-yellow?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🔑 Task 1: Create Azure Account and Set Up Azure CLI](#-task-1-create-azure-account-and-set-up-azure-cli)
- [📦 Task 2: Build Docker Image and Push to Azure Container Registry](#-task-2-build-docker-image-and-push-to-azure-container-registry)
- [🚀 Task 3: Deploy Docker Container to Azure Container Instances](#-task-3-deploy-docker-container-to-azure-container-instances)
- [🌐 Task 4: Expose Container to Internet Using Azure Networking](#-task-4-expose-container-to-internet-using-azure-networking)
- [📊 Task 5: Monitor Container Resource Usage Through Azure Monitor](#-task-5-monitor-container-resource-usage-through-azure-monitor)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🧹 Lab Cleanup](#-lab-cleanup)
- [📊 Key Concepts Summary](#-key-concepts-summary)
- [🎓 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | 🔑 Set up Azure CLI and authenticate with your Azure account |
| 2 | 📦 Create and configure Azure Container Registry (ACR) for storing Docker images |
| 3 | 🏗️ Build a Docker image and push it to Azure Container Registry |
| 4 | 🚀 Deploy Docker containers using Azure Container Instances (ACI) |
| 5 | 🌐 Configure networking to expose containers to the internet |
| 6 | 📊 Monitor container performance and resource usage through Azure Monitor |
| 7 | ☁️ Understand the fundamentals of containerized applications in cloud environments |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker Basics | Understanding of Docker concepts (containers, images, Dockerfile) |
| ⌨️ CLI Comfort | Familiarity with command-line interface operations |
| 🌐 Web Fundamentals | Basic knowledge of web applications and HTTP protocols |
| ☁️ Azure Account | An active Microsoft Azure account (free tier is sufficient) |
| 🔌 Networking | Understanding of basic networking concepts |

> **☁️ Note:** Al Nafi provides pre-configured Linux-based cloud machines for this lab. Simply click **Start Lab** to access your environment — no need to build your own virtual machine.

## 🖥️ Lab Environment Setup

**Your Al Nafi cloud machine comes pre-installed with:**

![Docker Engine](https://img.shields.io/badge/Docker_Engine-2496ED?style=flat-square&logo=docker&logoColor=white)
![Azure CLI](https://img.shields.io/badge/Azure_CLI-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=flat-square&logo=git&logoColor=white)
![nano/vim](https://img.shields.io/badge/nano%2Fvim-4EAA25?style=flat-square&logo=gnubash&logoColor=white)
![Dev Tools](https://img.shields.io/badge/Dev_Tools-000000?style=flat-square&logo=todoist&logoColor=white)

---

## 🔑 Task 1: Create Azure Account and Set Up Azure CLI

![Azure CLI](https://img.shields.io/badge/Azure_CLI-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)

### ✅ Subtask 1.1: Verify Azure CLI Installation

```bash
# ✅ Check Azure CLI version
az --version

# 📥 If Azure CLI is not installed, install it
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```
✅ **Sign of success:** `az --version` prints a version number instead of `command not found`.

### 🔐 Subtask 1.2: Login to Azure Account

```bash
# 🔐 Login to Azure (this will open a browser window)
az login

# 💻 If you're using a headless environment, use device code authentication
az login --use-device-code
```
Follow the authentication prompts in your browser or use the device code as instructed.
✅ **Sign of success:** the CLI prints your subscription details after a successful login.

### 🎯 Subtask 1.3: Set Default Subscription

```bash
# 📋 List available subscriptions
az account list --output table

# 🎯 Set default subscription (replace with your subscription ID)
az account set --subscription "your-subscription-id"
# TODO: Replace "your-subscription-id" with your actual subscription ID

# ✅ Verify current subscription
az account show --output table
```

### 📁 Subtask 1.4: Create Resource Group

```bash
# 📁 Create resource group
az group create \
    --name docker-lab-rg \
    --location eastus

# ✅ Verify resource group creation
az group show --name docker-lab-rg --output table
```
✅ **Sign of success:** `docker-lab-rg` shows `Succeeded` as its provisioning state.

---

## 📦 Task 2: Build Docker Image and Push to Azure Container Registry

![Azure Container Registry](https://img.shields.io/badge/Azure_Container_Registry-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)

### 🏗️ Subtask 2.1: Create Azure Container Registry

```bash
# 🏗️ Create Azure Container Registry
az acr create \
    --resource-group docker-lab-rg \
    --name dockerlabacr$(date +%s) \
    --sku Basic \
    --admin-enabled true

# 💾 Store ACR name in variable for later use
ACR_NAME=$(az acr list --resource-group docker-lab-rg --query "[0].name" --output tsv)
echo "ACR Name: $ACR_NAME"
```
✅ **Sign of success:** `$ACR_NAME` prints a non-empty registry name.

### 🌐 Subtask 2.2: Create Sample Web Application

```bash
# 📁 Create project directory
mkdir docker-web-app
cd docker-web-app

# 📄 Create package.json
cat > package.json << 'EOF'
{
  "name": "docker-web-app",
  "version": "1.0.0",
  "description": "Simple web app for Docker Azure lab",
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

```javascript
// 📄 server.js — minimal Express app with a health endpoint
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send(`
    <html>
      <head><title>Docker Azure Lab</title></head>
      <body style="font-family: Arial, sans-serif; text-align: center; padding: 50px;">
        <h1 style="color: #0078d4;">Hello from Azure Container Instance!</h1>
        <p>This application is running in a Docker container on Microsoft Azure.</p>
        <p>Container ID: ${process.env.HOSTNAME || 'unknown'}</p>
        <p>Current time: ${new Date().toISOString()}</p>
      </body>
    </html>
  `);
});

// 🩺 Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
// TODO: Add your own routes here
```

### 🐳 Subtask 2.3: Create Dockerfile

```dockerfile
# 🏗️ Use official Node.js runtime as base image
FROM node:18-alpine

# 📁 Set working directory in container
WORKDIR /usr/src/app

# 📋 Copy package.json and package-lock.json
COPY package*.json ./

# 📥 Install dependencies
RUN npm install --only=production

# 📂 Copy application code
COPY . .

# 🌐 Expose port 3000
EXPOSE 3000

# 🔒 Create non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001
USER nodejs

# ▶️ Start the application
CMD ["npm", "start"]
```

### 🧪 Subtask 2.4: Build and Test Docker Image Locally

```bash
# 🏗️ Build Docker image
docker build -t docker-web-app:v1.0 .

# ▶️ Run container locally to test
docker run -d -p 8080:3000 --name test-container docker-web-app:v1.0

# ✅ Test the application
curl http://localhost:8080

# 📜 Check container logs
docker logs test-container

# 🧹 Stop and remove test container
docker stop test-container
docker rm test-container
```
✅ **Sign of success:** `curl` returns the Azure Container Instance welcome page HTML.

### 🔐 Subtask 2.5: Login to Azure Container Registry

```bash
# 🔐 Login to ACR
az acr login --name $ACR_NAME

# 🔗 Get ACR login server
ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --query loginServer --output tsv)
echo "ACR Login Server: $ACR_LOGIN_SERVER"
```

### 🏷️ Subtask 2.6: Tag and Push Image to ACR

```bash
# 🏷️ Tag image for ACR
docker tag docker-web-app:v1.0 $ACR_LOGIN_SERVER/docker-web-app:v1.0

# 📤 Push image to ACR
docker push $ACR_LOGIN_SERVER/docker-web-app:v1.0

# ✅ Verify image in ACR
az acr repository list --name $ACR_NAME --output table
az acr repository show-tags --name $ACR_NAME --repository docker-web-app --output table
```
✅ **Sign of success:** `v1.0` appears in the repository's tag list.

---

## 🚀 Task 3: Deploy Docker Container to Azure Container Instances

![Azure Container Instances](https://img.shields.io/badge/Azure_Container_Instances-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)

### 🔑 Subtask 3.1: Get ACR Credentials

```bash
# 🔑 Get ACR credentials
ACR_USERNAME=$(az acr credential show --name $ACR_NAME --query username --output tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query passwords[0].value --output tsv)

echo "ACR Username: $ACR_USERNAME"
echo "ACR Password: [HIDDEN]"
```

### 🚀 Subtask 3.2: Deploy Container to ACI

```bash
# 🚀 Deploy container to ACI
az container create \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --image $ACR_LOGIN_SERVER/docker-web-app:v1.0 \
    --registry-login-server $ACR_LOGIN_SERVER \
    --registry-username $ACR_USERNAME \
    --registry-password $ACR_PASSWORD \
    --dns-name-label docker-web-app-$(date +%s) \
    --ports 3000 \
    --cpu 1 \
    --memory 1 \
    --restart-policy Always
# TODO: Tune --cpu/--memory to your workload's needs

# 🔎 Check deployment status
az container show \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --query "{Status:instanceView.state, FQDN:ipAddress.fqdn, IP:ipAddress.ip}" \
    --output table
```
✅ **Sign of success:** the container status shows `Running` with an assigned FQDN and IP.

### 🔍 Subtask 3.3: Verify Container Deployment

```bash
# 🔍 Get container details
az container show \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --output table

# 📜 Check container logs
az container logs \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci

# 🕒 Get container events
az container show \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --query instanceView.events \
    --output table
```
✅ **Sign of success:** logs show `Server running on port 3000` with no error events.

---

## 🌐 Task 4: Expose Container to Internet Using Azure Networking

![Networking](https://img.shields.io/badge/Azure_Networking-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)

### 🔗 Subtask 4.1: Get Container Public URL

```bash
# 🔗 Get container FQDN
CONTAINER_FQDN=$(az container show \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --query ipAddress.fqdn \
    --output tsv)

echo "Container URL: http://$CONTAINER_FQDN:3000"

# 📍 Get container IP address
CONTAINER_IP=$(az container show \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --query ipAddress.ip \
    --output tsv)

echo "Container IP: $CONTAINER_IP"
```

### ✅ Subtask 4.2: Test Internet Connectivity

```bash
# ✅ Test HTTP connectivity
curl -i http://$CONTAINER_FQDN:3000

# 🩺 Test health endpoint
curl -i http://$CONTAINER_FQDN:3000/health

# 🔁 Test with different HTTP methods
curl -X GET http://$CONTAINER_FQDN:3000/health
```
✅ **Sign of success:** both endpoints respond `HTTP/1.1 200 OK` from the public internet.

### 🌍 Subtask 4.3: Configure Custom Domain (Optional)

```bash
# 🌍 Display IP for DNS configuration
echo "Configure your DNS A record to point to: $CONTAINER_IP"
echo "Example DNS configuration:"
echo "Type: A"
echo "Name: docker-lab (or your preferred subdomain)"
echo "Value: $CONTAINER_IP"
echo "TTL: 300"
# TODO: Apply this A record in your DNS provider's dashboard
```

---

## 📊 Task 5: Monitor Container Resource Usage Through Azure Monitor

![Azure Monitor](https://img.shields.io/badge/Azure_Monitor-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![Log Analytics](https://img.shields.io/badge/Log_Analytics-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)

### 📈 Subtask 5.1: Enable Container Insights

```bash
# 📈 Get container resource usage
az container show \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --query "containers[0].instanceView.currentState" \
    --output table

# 🔍 Check resource limits and requests
az container show \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --query "containers[0].resources" \
    --output json
```

### 📊 Subtask 5.2: Monitor Container Metrics

```bash
# 📊 Get container metrics (CPU and Memory)
az monitor metrics list \
    --resource "/subscriptions/$(az account show --query id --output tsv)/resourceGroups/docker-lab-rg/providers/Microsoft.ContainerInstance/containerGroups/docker-web-app-aci" \
    --metric "CpuUsage,MemoryUsage" \
    --interval PT1M \
    --output table

# 📋 Get container group details
az container show \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --query "{Name:name, Status:instanceView.state, CPU:containers[0].resources.requests.cpu, Memory:containers[0].resources.requests.memoryInGb, RestartCount:containers[0].instanceView.restartCount}" \
    --output table
```
✅ **Sign of success:** `CpuUsage`/`MemoryUsage` data points are returned instead of empty results.

### 📜 Subtask 5.3: Set Up Log Analytics (Optional)

```bash
# 📜 Create Log Analytics workspace
az monitor log-analytics workspace create \
    --resource-group docker-lab-rg \
    --workspace-name docker-lab-logs \
    --location eastus

# 🆔 Get workspace ID
WORKSPACE_ID=$(az monitor log-analytics workspace show \
    --resource-group docker-lab-rg \
    --workspace-name docker-lab-logs \
    --query customerId \
    --output tsv)

# 🔑 Get workspace key
WORKSPACE_KEY=$(az monitor log-analytics workspace get-shared-keys \
    --resource-group docker-lab-rg \
    --workspace-name docker-lab-logs \
    --query primarySharedKey \
    --output tsv)

echo "Workspace ID: $WORKSPACE_ID"
echo "Workspace Key: [HIDDEN]"
```

### 🔥 Subtask 5.4: Generate Load for Monitoring

```bash
# 📝 Create a simple load test script
cat > load_test.sh << 'EOF'
#!/bin/bash
CONTAINER_URL=$1
echo "Starting load test on $CONTAINER_URL"

for i in {1..50}; do
    echo "Request $i"
    curl -s $CONTAINER_URL > /dev/null
    curl -s $CONTAINER_URL/health > /dev/null
    sleep 1
done

echo "Load test completed"
EOF

chmod +x load_test.sh

# ▶️ Run load test
./load_test.sh http://$CONTAINER_FQDN:3000

# 📜 Check container logs after load test
az container logs \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --tail 20
```
✅ **Sign of success:** the metrics from Subtask 5.2 now show non-zero CPU/memory activity after the load test.

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔴 Issue 1: Container Fails to Start</summary>

```bash
# 🔍 Check container events for errors
az container show \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --query instanceView.events \
    --output table

# 📜 Check container logs for application errors
az container logs \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci
```
</details>

<details>
<summary>🟠 Issue 2: Cannot Access Container from Internet</summary>

```bash
# ✅ Verify container is running
az container show \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --query instanceView.state \
    --output tsv

# 🔌 Check port configuration
az container show \
    --resource-group docker-lab-rg \
    --name docker-web-app-aci \
    --query ipAddress.ports \
    --output table
```
</details>

<details>
<summary>🟡 Issue 3: ACR Authentication Issues</summary>

```bash
# 🔐 Re-login to ACR
az acr login --name $ACR_NAME

# 🔑 Verify ACR credentials
az acr credential show --name $ACR_NAME --output table

# ✅ Test ACR connectivity
docker pull $ACR_LOGIN_SERVER/docker-web-app:v1.0
```
</details>

---

## 🧹 Lab Cleanup

```bash
# 🗑️ Delete the entire resource group (this removes all resources)
az group delete --name docker-lab-rg --yes --no-wait

# ✅ Verify deletion
az group list --query "[?name=='docker-lab-rg']" --output table

# 🧹 Clean up local Docker images
docker rmi docker-web-app:v1.0
docker rmi $ACR_LOGIN_SERVER/docker-web-app:v1.0
docker system prune -f
```
✅ **Sign of success:** `az group list` no longer includes `docker-lab-rg`.

---

## 📊 Key Concepts Summary

> This is a cloud-deployment lab with no detection targets, so a MITRE ATT&CK mapping is not applicable here — the table below covers the core Azure container concepts instead.

| Concept | Description |
|---|---|
| 📦 **Azure Container Registry (ACR)** | Private, managed registry for storing and versioning Docker images in Azure |
| 🚀 **Azure Container Instances (ACI)** | Serverless container hosting — no VM or orchestrator to manage |
| 🔑 **Registry Credentials** | Username/password pair ACI uses to pull private images from ACR |
| 🌐 **DNS Name Label** | Generates a public FQDN (`<label>.<region>.azurecontainer.io`) for the container group |
| 📊 **Azure Monitor Metrics** | `CpuUsage`/`MemoryUsage` time-series data queried via `az monitor metrics list` |
| 📜 **Log Analytics Workspace** | Centralized store for advanced querying and long-term retention of container logs |

---

## 🎓 Conclusion

Congratulations! You have successfully completed **Lab 103: Docker for Cloud — Running Docker Containers on Microsoft Azure**.

### 🏆 What You Accomplished
- 🔑 **Set up Azure CLI and authenticated** with your Azure account, establishing the foundation for cloud operations
- 📦 **Created Azure Container Registry** and learned how to securely store and manage Docker images in the cloud
- 🏗️ **Built and containerized a web application** using Docker best practices and security considerations
- 🚀 **Deployed containers to Azure Container Instances**, experiencing the simplicity of serverless container hosting
- 🌐 **Configured networking** to expose your application to the internet with automatic DNS resolution
- 📊 **Implemented monitoring** using Azure Monitor to track container performance and resource utilization

### 💡 Why This Matters
- 🖥️ **Serverless containers** — no need to manage underlying infrastructure
- ⚡ **Rapid deployment** — from code to production in minutes
- 📈 **Automatic scaling** — built-in capabilities for handling varying loads
- 💰 **Cost efficiency** — pay only for the resources you use
- 🛡️ **Enterprise security** — integration with Azure's security and compliance features

### 🌍 Real-World Applications
- 🧩 **Microservices architecture** — deploying individual services as containers
- 🔄 **CI/CD pipelines** — automated deployment of containerized applications
- 🧪 **Development environments** — quickly spinning up isolated testing environments
- 🏛️ **Legacy application modernization** — moving traditional apps to cloud-native architectures
- ☁️ **Multi-cloud strategies** — understanding container portability across cloud providers

### ➡️ Next Steps
- ☸️ Explore Azure Kubernetes Service (AKS) for orchestrating multiple containers
- ⚡ Learn about Azure Container Apps for event-driven container applications
- 🔄 Investigate Azure DevOps for building complete CI/CD pipelines
- 🛡️ Study container security best practices and Azure Security Center integration
- 🧩 Practice with multi-container applications using Docker Compose

> 🎖️ This foundational knowledge prepares you for the **Docker Certified Associate (DCA)** certification and advanced cloud container orchestration scenarios.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
