<div align="center">

# ⛵ Docker and Kubernetes
## Implementing Helm Charts for App Deployment

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=helm&logoColor=white)
![Minikube](https://img.shields.io/badge/Minikube-2496ED?style=for-the-badge&logo=kubernetes&logoColor=white)
![kubectl](https://img.shields.io/badge/kubectl-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-CB171E?style=for-the-badge&logo=yaml&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Level](https://img.shields.io/badge/Level-Intermediate-orange?style=for-the-badge)

*Package, deploy, upgrade, roll back, and monitor Dockerized applications on Kubernetes using Helm — the Kubernetes package manager.*

</div>

---

## 📑 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [⛵ Task 1: Set Up Helm on a Kubernetes Cluster](#-task-1-set-up-helm-on-a-kubernetes-cluster)
- [🚀 Task 2: Deploy a Dockerized Application Using an Existing Helm Chart](#-task-2-deploy-a-dockerized-application-using-an-existing-helm-chart)
- [🎨 Task 3: Customize a Helm Chart for Your Application](#-task-3-customize-a-helm-chart-for-your-application)
- [🔄 Task 4: Use Helm to Upgrade and Roll Back Deployments](#-task-4-use-helm-to-upgrade-and-roll-back-deployments)
- [📊 Task 5: Monitor Helm Deployments Using Kubernetes Commands](#-task-5-monitor-helm-deployments-using-kubernetes-commands)
- [🧹 Lab Cleanup](#-lab-cleanup)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🧠 Key Concepts Summary](#-key-concepts-summary)
- [🎓 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1️⃣ | Install and configure Helm on a Kubernetes cluster |
| 2️⃣ | Deploy Dockerized applications using existing Helm charts |
| 3️⃣ | Create and customize Helm charts for specific applications |
| 4️⃣ | Perform application upgrades and rollbacks using Helm |
| 5️⃣ | Monitor and manage Helm deployments using Kubernetes commands |
| 6️⃣ | Understand the benefits of using Helm for Kubernetes application management |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker Concepts | Basic understanding of Docker containers and containerization concepts |
| ☸️ Kubernetes Fundamentals | Fundamental knowledge of Kubernetes architecture and components |
| 📄 YAML | Familiarity with YAML syntax and configuration files |
| 💻 CLI Experience | Basic command-line interface experience |
| 🚀 Deployment Concepts | Understanding of application deployment concepts |

**🧩 Required Knowledge Areas**

- 🐳 Docker container basics
- ☸️ Kubernetes pods, services, and deployments
- 💻 Command-line operations in Linux
- 🌐 Basic networking concepts
- 📄 YAML file structure and syntax

> 📝 **TODO:** If Kubernetes objects (Pods, Services, Deployments) feel unfamiliar, review the Introduction to Kubernetes lab before starting this one.

---

## 🖥️ Lab Environment Setup

> ☁️ **Ready-to-Use Cloud Machines**
> Al Nafi provides pre-configured Linux-based cloud machines with Docker and Kubernetes already installed. Simply click **Start Lab** to access your environment — no need to build your own virtual machine or install software.

**Your lab environment includes:**

| Component | Specification |
|---|---|
| 🐧 OS | Ubuntu 20.04 LTS with Docker installed |
| ☸️ Cluster | Kubernetes cluster (minikube) pre-configured |
| 🛠️ CLI Tool | `kubectl` command-line tool ready to use |
| 🌐 Network | Internet access for downloading Helm and charts |

---

## ⛵ Task 1: Set Up Helm on a Kubernetes Cluster

### ✅ Subtask 1.1: Verify Kubernetes Cluster Status

First, let's ensure your Kubernetes cluster is running properly.

```bash
# ☸️ Check if minikube is running
minikube status

# ▶️ If minikube is not running, start it
minikube start

# 🔗 Verify kubectl can connect to the cluster
kubectl cluster-info

# 🖥️ Check available nodes
kubectl get nodes
```

### 📦 Subtask 1.2: Install Helm

Helm is the package manager for Kubernetes that simplifies application deployment and management.

```bash
# ⬇️ Download and install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# ✅ Verify Helm installation
helm version

# 📚 Add the official Helm stable repository
helm repo add stable https://charts.helm.sh/stable

# 📚 Add the bitnami repository (commonly used)
helm repo add bitnami https://charts.bitnami.com/bitnami

# 🔄 Update repository information
helm repo update

# 📋 List available repositories
helm repo list
```

### 🔍 Subtask 1.3: Verify Helm Setup

```bash
# 🔗 Check Helm can communicate with Kubernetes
helm list

# 🔎 Search for available charts
helm search repo nginx

# ℹ️ Get information about a specific chart
helm show chart bitnami/nginx
```

> 💡 **TODO:** Confirm `helm version` shows a v3.x client before moving to Task 2 — Helm 2 uses a different (Tiller-based) architecture and the commands in this lab won't match.

---

## 🚀 Task 2: Deploy a Dockerized Application Using an Existing Helm Chart

### 🌐 Subtask 2.1: Deploy NGINX Web Server

We'll deploy NGINX as our first application using an existing Helm chart.

```bash
# 🗂️ Create a namespace for our applications
kubectl create namespace helm-demo

# 🚀 Deploy NGINX using Helm
helm install my-nginx bitnami/nginx --namespace helm-demo

# 📊 Check the deployment status
helm status my-nginx --namespace helm-demo

# ✅ Verify the deployment in Kubernetes
kubectl get all -n helm-demo
```

### 🔌 Subtask 2.2: Access the Deployed Application

```bash
# 🔍 Get the service details
kubectl get svc -n helm-demo

# 🔀 Port forward to access NGINX locally
kubectl port-forward -n helm-demo svc/my-nginx 8080:80 &

# 🧪 Test the application (open another terminal or run in background)
curl http://localhost:8080
```

### 📖 Subtask 2.3: Explore Helm Release Information

```bash
# 📋 List all Helm releases
helm list --namespace helm-demo

# 📄 Get detailed information about the release
helm get all my-nginx --namespace helm-demo

# ⚙️ View the values used in the deployment
helm get values my-nginx --namespace helm-demo
```

---

## 🎨 Task 3: Customize a Helm Chart for Your Application

### 📝 Subtask 3.1: Create a Custom Values File

Let's customize the NGINX deployment with our own configuration.

```yaml
# 📝 Create a custom values file
cat > custom-nginx-values.yaml << EOF
replicaCount: 2

image:
  tag: "1.21"

service:
  type: NodePort
  port: 80
  nodePort: 30080

resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 50m
    memory: 64Mi

ingress:
  enabled: false
EOF
```

### 🚀 Subtask 3.2: Deploy with Custom Values

```bash
# 🚀 Deploy a new release with custom values
helm install my-custom-nginx bitnami/nginx \
  --namespace helm-demo \
  --values custom-nginx-values.yaml

# ✅ Verify the custom deployment
kubectl get pods -n helm-demo
kubectl get svc -n helm-demo
```

### 🆕 Subtask 3.3: Create Your Own Helm Chart

Now let's create a completely custom Helm chart for a simple web application.

```bash
# 🆕 Create a new Helm chart
helm create my-webapp

# 🔍 Explore the chart structure
ls -la my-webapp/
tree my-webapp/
```

### ✏️ Subtask 3.4: Customize the Chart Templates

```yaml
# ✏️ Edit the deployment template
cat > my-webapp/templates/deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "my-webapp.fullname" . }}
  labels:
    {{- include "my-webapp.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "my-webapp.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "my-webapp.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
EOF
```

### ⚙️ Subtask 3.5: Update Chart Values

```yaml
# ⚙️ Edit the values file
cat > my-webapp/values.yaml << EOF
replicaCount: 1

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: "1.21"

service:
  type: ClusterIP
  port: 80

resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 50m
    memory: 64Mi

nodeSelector: {}
tolerations: []
affinity: {}
EOF
```

### 🚀 Subtask 3.6: Deploy Your Custom Chart

```bash
# ✅ Validate the chart
helm lint my-webapp

# 🚀 Deploy your custom chart
helm install my-custom-app ./my-webapp --namespace helm-demo

# 🔍 Verify the deployment
kubectl get all -n helm-demo -l app.kubernetes.io/name=my-webapp
```

> 💡 **TODO:** Add a `service.yaml` template to `my-webapp/templates/` that reads from `.Values.service.type` and `.Values.service.port` so your custom chart exposes the app, not just runs it.

---

## 🔄 Task 4: Use Helm to Upgrade and Roll Back Deployments

### ⬆️ Subtask 4.1: Upgrade an Existing Release

```bash
# 📋 Check current release version
helm list --namespace helm-demo
```

```yaml
# ⬆️ Upgrade the NGINX release with new values
cat > upgrade-values.yaml << EOF
replicaCount: 3

image:
  tag: "1.22"

resources:
  limits:
    cpu: 200m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi
EOF
```

```bash
# 🚀 Perform the upgrade
helm upgrade my-nginx bitnami/nginx \
  --namespace helm-demo \
  --values upgrade-values.yaml

# 📊 Check the upgrade status
helm status my-nginx --namespace helm-demo
```

### 🕓 Subtask 4.2: View Release History

```bash
# 🕓 View the release history
helm history my-nginx --namespace helm-demo

# 📄 Get detailed information about a specific revision
helm get all my-nginx --revision 1 --namespace helm-demo
```

### ⏪ Subtask 4.3: Perform a Rollback

```bash
# ⏪ Rollback to the previous version
helm rollback my-nginx 1 --namespace helm-demo

# ✅ Verify the rollback
helm history my-nginx --namespace helm-demo

# 🔍 Check that pods are using the original configuration
kubectl get pods -n helm-demo -o wide
```

### 🧪 Subtask 4.4: Test Upgrade and Rollback Process

```yaml
# ⚠️ Create a test upgrade with intentional issues
cat > problematic-values.yaml << EOF
replicaCount: 5

image:
  tag: "nonexistent-tag"

resources:
  limits:
    cpu: 2000m
    memory: 4Gi
EOF
```

```bash
# 🚀 Attempt the upgrade
helm upgrade my-nginx bitnami/nginx \
  --namespace helm-demo \
  --values problematic-values.yaml

# 🔍 Check if the upgrade caused issues
kubectl get pods -n helm-demo

# ⏪ Rollback if there are problems
helm rollback my-nginx --namespace helm-demo

# ✅ Verify the rollback worked
kubectl get pods -n helm-demo
```

> 💡 **TODO:** Note which `kubectl get pods` status (`ImagePullBackOff`, `Pending`, etc.) the bad `nonexistent-tag` image produces — this is one of the most common real-world Helm upgrade failures.

---

## 📊 Task 5: Monitor Helm Deployments Using Kubernetes Commands

### 👀 Subtask 5.1: Monitor Deployment Status

```bash
# 👀 Watch pod status in real-time
kubectl get pods -n helm-demo -w

# 📊 In another terminal, check deployment status
kubectl get deployments -n helm-demo

# 🔁 Check replica sets
kubectl get rs -n helm-demo
```

### 📜 Subtask 5.2: View Application Logs

```bash
# 📜 Get logs from NGINX pods
kubectl logs -n helm-demo -l app.kubernetes.io/name=nginx

# 🔄 Follow logs in real-time
kubectl logs -n helm-demo -l app.kubernetes.io/name=nginx -f

# 🎯 Get logs from a specific pod
POD_NAME=$(kubectl get pods -n helm-demo -l app.kubernetes.io/name=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl logs -n helm-demo $POD_NAME
```

### 📈 Subtask 5.3: Monitor Resource Usage

```bash
# 📈 Check resource usage of pods
kubectl top pods -n helm-demo

# 🖥️ Check node resource usage
kubectl top nodes

# 🔍 Describe a pod to see detailed information
kubectl describe pod -n helm-demo $POD_NAME
```

### 🔌 Subtask 5.4: Monitor Services and Endpoints

```bash
# 🔌 Check service status
kubectl get svc -n helm-demo

# 🎯 Check endpoints
kubectl get endpoints -n helm-demo

# 🔍 Describe service details
kubectl describe svc -n helm-demo my-nginx
```

### 🖥️ Subtask 5.5: Create Monitoring Dashboard Commands

```bash
# 🖥️ Create a script to monitor all Helm releases
cat > monitor-helm.sh << 'EOF'
#!/bin/bash

echo "=== Helm Releases ==="
helm list --all-namespaces

echo -e "\n=== Pod Status ==="
kubectl get pods -n helm-demo

echo -e "\n=== Service Status ==="
kubectl get svc -n helm-demo

echo -e "\n=== Recent Events ==="
kubectl get events -n helm-demo --sort-by='.lastTimestamp' | tail -10
EOF

chmod +x monitor-helm.sh

# ▶️ Run the monitoring script
./monitor-helm.sh
```

### 🔬 Advanced Monitoring and Troubleshooting

#### 🚨 Subtask 5.6: Troubleshooting Common Issues

```bash
# ❌ Check for failed pods
kubectl get pods -n helm-demo --field-selector=status.phase=Failed

# 📜 Check pod events for troubleshooting
kubectl get events -n helm-demo --sort-by='.lastTimestamp'

# 🔍 Debug a problematic pod
kubectl describe pod -n helm-demo <pod-name>

# 📝 Check Helm release notes
helm get notes my-nginx --namespace helm-demo
```

#### ⚡ Subtask 5.7: Performance Monitoring

```bash
# ⚡ Monitor resource consumption over time
watch kubectl top pods -n helm-demo

# 🖥️ Check cluster resource availability
kubectl describe nodes

# 💾 Monitor persistent volumes if used
kubectl get pv,pvc -n helm-demo
```

> 💡 **TODO:** Extend `monitor-helm.sh` to also print `kubectl top pods` output, so a single script covers releases, pods, services, events, *and* resource usage.

---

## 🧹 Lab Cleanup

Before concluding the lab, let's clean up the resources we created.

```bash
# 🗑️ Uninstall Helm releases
helm uninstall my-nginx --namespace helm-demo
helm uninstall my-custom-nginx --namespace helm-demo
helm uninstall my-custom-app --namespace helm-demo

# 🗑️ Delete the namespace
kubectl delete namespace helm-demo

# 🧹 Remove custom files
rm -f custom-nginx-values.yaml upgrade-values.yaml problematic-values.yaml
rm -f monitor-helm.sh
rm -rf my-webapp/

# ✅ Verify cleanup
helm list --all-namespaces
kubectl get namespaces
```

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>📦 <strong>Issue 1: Helm Installation Problems</strong></summary>

**Problem:** Helm command not found after installation

**Solution:**

```bash
# 🔍 Check if Helm is in PATH
which helm

# 🛠️ If not found, add to PATH or reinstall
export PATH=$PATH:/usr/local/bin
```

</details>

<details>
<summary>📚 <strong>Issue 2: Repository Access Issues</strong></summary>

**Problem:** Cannot access Helm repositories

**Solution:**

```bash
# 🔄 Update repository cache
helm repo update

# ♻️ Remove and re-add problematic repositories
helm repo remove bitnami
helm repo add bitnami https://charts.bitnami.com/bitnami
```

</details>

<details>
<summary>🚨 <strong>Issue 3: Deployment Failures</strong></summary>

**Problem:** Pods stuck in `Pending` or `CrashLoopBackOff` state

**Solution:**

```bash
# 🔍 Check pod details
kubectl describe pod <pod-name> -n helm-demo

# 📊 Check resource constraints
kubectl get nodes
kubectl top nodes

# 🖼️ Check for image pull issues
kubectl get events -n helm-demo
```

</details>

---

## 🧠 Key Concepts Summary

### ⛵ Helm Architecture

| Concept | Description |
|---|---|
| 📦 Charts | Packages of pre-configured Kubernetes resources |
| 🚀 Releases | Instances of charts deployed to clusters |
| ⚙️ Values | Configuration parameters for customizing deployments |
| 📝 Templates | Kubernetes manifest templates with placeholders |

### ✅ Best Practices

- 📁 Always use version control for custom charts
- 🧪 Test charts in development environments first
- 🏷️ Use meaningful release names and namespaces
- 🔄 Regularly update Helm repositories
- 📊 Monitor deployments after upgrades
- ⏪ Keep rollback strategies ready

---

## 🎓 Conclusion

In this comprehensive lab, you have successfully:

- ⛵ **Installed and configured Helm** on a Kubernetes cluster, establishing the foundation for efficient application deployment management
- 🚀 **Deployed applications using existing Helm charts**, learning how to leverage community-maintained packages for quick deployments
- 🎨 **Created and customized Helm charts**, gaining hands-on experience in tailoring deployments to specific requirements
- 🔄 **Performed upgrades and rollbacks**, mastering essential skills for maintaining applications in production environments
- 📊 **Implemented monitoring strategies**, ensuring you can track and troubleshoot Helm deployments effectively

### 💡 Why This Matters

Helm charts revolutionize Kubernetes application deployment by:

| Benefit | Impact |
|---|---|
| 🧩 Simplifying Complex Deployments | Converts multiple Kubernetes manifests into single, manageable packages |
| ♻️ Enabling Reusability | Templates usable across different environments with varying configurations |
| 🕓 Providing Version Control | Tracks deployment history and enables easy rollbacks when issues arise |
| 📏 Standardizing Deployments | Ensures consistent application deployment practices across teams |
| 🛡️ Reducing Human Error | Automates deployment processes and reduces manual configuration mistakes |

### 🌍 Real-World Applications

The skills you've developed in this lab are directly applicable to:

- 🏢 **Production Application Deployment** — managing enterprise applications with complex dependencies
- 🔁 **DevOps Pipeline Integration** — incorporating Helm into CI/CD workflows for automated deployments
- 🌐 **Multi-Environment Management** — deploying the same applications across dev, staging, and production
- 🧩 **Microservices Architecture** — managing multiple interconnected services efficiently
- ☁️ **Cloud-Native Development** — supporting modern application development practices

### 🔭 Next Steps

To further develop your Helm and Kubernetes expertise:

- 🪝 Explore advanced Helm features like hooks and tests
- 📦 Learn about Helm chart repositories and distribution
- 🔗 Study integration with GitOps workflows
- 🧩 Practice with more complex, multi-tier applications
- 🔐 Investigate Helm security best practices and RBAC integration

> 🎖️ This lab has provided you with practical, hands-on experience that directly supports **Docker Certified Associate (DCA)** certification objectives and prepares you for real-world container orchestration challenges in professional environments.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blue?style=for-the-badge)

</div>
