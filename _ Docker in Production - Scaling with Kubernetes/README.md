<div align="center">

# 🐳☸️ Docker in Production — Scaling with Kubernetes

### Container Orchestration & Horizontal Pod Autoscaling

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Minikube](https://img.shields.io/badge/Minikube-FF6D00?style=for-the-badge&logo=kubernetes&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-CB171E?style=for-the-badge&logo=yaml&logoColor=white)
![Level](https://img.shields.io/badge/Level-Intermediate-yellow?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment](#️-lab-environment)
- [🚀 Task 1: Initialize Kubernetes Cluster with Minikube](#-task-1-initialize-kubernetes-cluster-with-minikube)
- [📦 Task 2: Deploy a Dockerized Application to Kubernetes](#-task-2-deploy-a-dockerized-application-to-kubernetes)
- [📊 Task 3: Configure Horizontal Pod Autoscaling (HPA)](#-task-3-configure-horizontal-pod-autoscaling-hpa)
- [🔥 Task 4: Test Autoscaling by Simulating Load](#-task-4-test-autoscaling-by-simulating-load)
- [📈 Task 5: Monitor Scaling and Resource Usage](#-task-5-monitor-scaling-and-resource-usage)
- [✅ Verification and Testing](#-verification-and-testing)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🧹 Cleanup](#-cleanup)
- [📊 Key Concepts Summary](#-key-concepts-summary)
- [🎓 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | 🏗️ Set up a Kubernetes cluster using Minikube for local development |
| 2 | 📦 Deploy a Dockerized application to a Kubernetes cluster |
| 3 | 📊 Configure Horizontal Pod Autoscaling (HPA) based on CPU and memory usage |
| 4 | 🔥 Simulate application load to trigger autoscaling events |
| 5 | 📈 Monitor scaling behavior and resource utilization in Kubernetes |
| 6 | ☸️ Understand the fundamentals of container orchestration in production environments |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker Basics | Understanding of containers and images |
| ⌨️ CLI Comfort | Familiarity with command-line interface operations |
| 📄 YAML | Basic knowledge of YAML file structure |
| 🌐 Web Fundamentals | Understanding of web applications and HTTP requests |
| ☸️ Kubernetes | Not required — covered from the basics in this lab |

## 🖥️ Lab Environment

> **☁️ Ready-to-Use Cloud Machines**
> Al Nafi provides pre-configured Linux-based cloud machines with all necessary tools installed. Simply click **Start Lab** to access your environment — no need to build your own VM or install software locally.

**Included in your cloud machine:**

![Docker Engine](https://img.shields.io/badge/Docker_Engine-2496ED?style=flat-square&logo=docker&logoColor=white)
![Minikube](https://img.shields.io/badge/Minikube-FF6D00?style=flat-square&logo=kubernetes&logoColor=white)
![kubectl](https://img.shields.io/badge/kubectl-326CE5?style=flat-square&logo=kubernetes&logoColor=white)
![curl](https://img.shields.io/badge/curl-073551?style=flat-square&logo=curl&logoColor=white)
![nano/vim](https://img.shields.io/badge/nano%2Fvim-4EAA25?style=flat-square&logo=gnubash&logoColor=white)

---

## 🚀 Task 1: Initialize Kubernetes Cluster with Minikube

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat-square&logo=kubernetes&logoColor=white)
![Minikube](https://img.shields.io/badge/Minikube-FF6D00?style=flat-square&logo=kubernetes&logoColor=white)

### 🔧 Subtask 1.1: Start Minikube Cluster

```bash
# 🚀 Start Minikube with specific resource allocation
minikube start --cpus=2 --memory=4096 --driver=docker

# ✅ Verify cluster is running
minikube status
```

**Expected output:**
```
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```
✅ **Sign of success:** all four components report `Running`/`Configured`.

### 📡 Subtask 1.2: Enable Required Add-ons

```bash
# 📊 Enable metrics server for resource monitoring
minikube addons enable metrics-server

# ✅ Verify metrics server is running
kubectl get pods -n kube-system | grep metrics-server
```
✅ **Sign of success:** a `metrics-server` pod shows `Running` in the `kube-system` namespace — this is essential for autoscaling to function.

### ⚙️ Subtask 1.3: Configure kubectl Context

```bash
# 🔍 Check current context
kubectl config current-context

# ℹ️ Get cluster information
kubectl cluster-info

# 🖥️ List all nodes in the cluster
kubectl get nodes
```
✅ **Sign of success:** `kubectl` points to the `minikube` context and lists at least one `Ready` node.

---

## 📦 Task 2: Deploy a Dockerized Application to Kubernetes

![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat-square&logo=kubernetes&logoColor=white)

### 📝 Subtask 2.1: Create Application Deployment

```bash
# 📁 Create deployment directory
mkdir -p ~/k8s-lab
cd ~/k8s-lab

# 📄 Create deployment YAML file
cat > web-app-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web-app
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 256Mi
        env:
        - name: PORT
          value: "80"
        # TODO: Swap nginx:alpine for your own application image
EOF
```

### 🚢 Subtask 2.2: Deploy the Application

```bash
# 📤 Deploy the application
kubectl apply -f web-app-deployment.yaml

# 📋 Verify deployment status
kubectl get deployments

# 🔎 Check pod status
kubectl get pods -l app=web-app

# 🩺 Get detailed pod information
kubectl describe pods -l app=web-app
```
✅ **Sign of success:** `kubectl get deployments` shows `2/2` ready replicas.

### 🌐 Subtask 2.3: Create Service for Application Access

```bash
# 📄 Create service YAML file
cat > web-app-service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: web-app-service
spec:
  selector:
    app: web-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
EOF

# 📤 Apply the service
kubectl apply -f web-app-service.yaml

# ✅ Verify service creation
kubectl get services
```
✅ **Sign of success:** `web-app-service` appears with a `ClusterIP` and port `80`.

---

## 📊 Task 3: Configure Horizontal Pod Autoscaling (HPA)

![Kubernetes](https://img.shields.io/badge/Kubernetes_HPA-326CE5?style=flat-square&logo=kubernetes&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-CB171E?style=flat-square&logo=yaml&logoColor=white)

### 📐 Subtask 3.1: Create HPA Configuration

```bash
# 📄 Create HPA YAML file
cat > web-app-hpa.yaml << 'EOF'
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
    # TODO: Tune min/maxReplicas and thresholds to your workload's SLA
EOF
```

### 📤 Subtask 3.2: Apply HPA Configuration

```bash
# 📤 Apply HPA configuration
kubectl apply -f web-app-hpa.yaml

# ✅ Verify HPA creation
kubectl get hpa

# 🩺 Get detailed HPA information
kubectl describe hpa web-app-hpa
```
✅ **Sign of success:** `kubectl get hpa` lists `web-app-hpa` with target `2` minimum replicas.

### 👀 Subtask 3.3: Monitor Initial HPA Status

```bash
# 👁️ Watch HPA status (press Ctrl+C to stop)
kubectl get hpa web-app-hpa --watch

# 📊 In a separate terminal, check current resource usage
kubectl top pods -l app=web-app
```
✅ **Sign of success:** CPU/memory percentages appear instead of `<unknown>`.

---

## 🔥 Task 4: Test Autoscaling by Simulating Load

![Docker](https://img.shields.io/badge/BusyBox-000000?style=flat-square&logo=docker&logoColor=white)
![Load Testing](https://img.shields.io/badge/Load_Testing-FF6D00?style=flat-square&logo=speedtest&logoColor=white)

### 🐝 Subtask 4.1: Create Load Testing Pod

```bash
# 📄 Create load generator YAML
cat > load-generator.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: load-generator
spec:
  containers:
  - name: load-generator
    image: busybox
    command: ["/bin/sh"]
    args: ["-c", "while true; do wget -q -O- http://web-app-service/; done"]
    resources:
      requests:
        cpu: 10m
        memory: 16Mi
      limits:
        cpu: 50m
        memory: 32Mi
EOF

# 📤 Deploy load generator
kubectl apply -f load-generator.yaml

# ✅ Verify load generator is running
kubectl get pods load-generator
```
✅ **Sign of success:** `load-generator` shows `Running`.

### 💪 Subtask 4.2: Create CPU Stress Test

```bash
# 📄 Create CPU stress deployment
cat > cpu-stress.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cpu-stress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cpu-stress
  template:
    metadata:
      labels:
        app: cpu-stress
    spec:
      containers:
      - name: cpu-stress
        image: progrium/stress
        command: ["stress"]
        args: ["--cpu", "2", "--timeout", "300s"]
        resources:
          requests:
            cpu: 100m
            memory: 64Mi
          limits:
            cpu: 200m
            memory: 128Mi
EOF

# 📤 Deploy CPU stress test
kubectl apply -f cpu-stress.yaml
```
✅ **Sign of success:** CPU usage on `web-app` pods begins climbing in `kubectl top`.

### 📈 Subtask 4.3: Monitor Load Impact

```bash
# 👁️ Monitor HPA status during load test
kubectl get hpa web-app-hpa --watch

# 🔄 In another terminal, monitor pod scaling
watch kubectl get pods -l app=web-app

# 📊 Check resource usage
kubectl top pods -l app=web-app
```
✅ **Sign of success:** replica count under `web-app` climbs above `2` as load increases.

### 🌐 Subtask 4.4: Generate HTTP Load

```bash
# 🔁 Create multiple load generators
for i in {1..3}; do
cat > load-generator-$i.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: load-generator-$i
spec:
  containers:
  - name: load-generator
    image: alpine/curl
    command: ["/bin/sh"]
    args: ["-c", "while true; do curl -s http://web-app-service/ > /dev/null; sleep 0.1; done"]
EOF

kubectl apply -f load-generator-$i.yaml
done

# ✅ Verify all load generators are running
kubectl get pods | grep load-generator
```
✅ **Sign of success:** three additional `load-generator-N` pods report `Running`.

---

## 📈 Task 5: Monitor Scaling and Resource Usage

![Bash](https://img.shields.io/badge/Bash_Scripting-4EAA25?style=flat-square&logo=gnubash&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat-square&logo=kubernetes&logoColor=white)

### 🖥️ Subtask 5.1: Real-time Monitoring Setup

```bash
# 📄 Create monitoring script
cat > monitor-scaling.sh << 'EOF'
#!/bin/bash

echo "=== Kubernetes Autoscaling Monitor ==="
echo "Press Ctrl+C to stop monitoring"
echo

while true; do
    clear
    echo "=== Current Time: $(date) ==="
    echo

    echo "=== HPA Status ==="
    kubectl get hpa web-app-hpa
    echo

    echo "=== Pod Count and Status ==="
    kubectl get pods -l app=web-app -o wide
    echo

    echo "=== Resource Usage ==="
    kubectl top pods -l app=web-app 2>/dev/null || echo "Metrics not ready yet..."
    echo

    echo "=== Deployment Status ==="
    kubectl get deployment web-app
    echo

    sleep 10
done
EOF

# 🔑 Make script executable
chmod +x monitor-scaling.sh

# ▶️ Run monitoring script
./monitor-scaling.sh
```
✅ **Sign of success:** the dashboard refreshes every 10 seconds showing live HPA, pod, and resource data.

### 🔍 Subtask 5.2: Analyze Scaling Events

```bash
# 📋 View HPA events
kubectl describe hpa web-app-hpa

# 📋 Check deployment events
kubectl describe deployment web-app

# 🕒 View pod events
kubectl get events --sort-by=.metadata.creationTimestamp
```
✅ **Sign of success:** `SuccessfulRescale` events appear in the HPA description.

### 📉 Subtask 5.3: Test Scale-Down Behavior

```bash
# 🛑 Stop load generators to test scale-down
kubectl delete pod load-generator
kubectl delete pods -l app=cpu-stress
for i in {1..3}; do kubectl delete pod load-generator-$i; done

# 👁️ Monitor scale-down process
kubectl get hpa web-app-hpa --watch
```
✅ **Sign of success:** replica count gradually returns to `minReplicas: 2` after the `300s` stabilization window.

### 🧭 Subtask 5.4: Advanced Monitoring Commands

```bash
# 📊 Get detailed resource metrics
kubectl top nodes

# 🖥️ View cluster resource usage
kubectl describe nodes

# 📜 Check metrics server logs if needed
kubectl logs -n kube-system -l k8s-app=metrics-server

# 📜 View HPA controller logs
kubectl logs -n kube-system -l app=horizontal-pod-autoscaler
```
✅ **Sign of success:** node-level CPU/memory percentages are visible via `kubectl top nodes`.

---

## ✅ Verification and Testing

```bash
# 📄 Create verification script
cat > verify-autoscaling.sh << 'EOF'
#!/bin/bash

echo "=== Autoscaling Verification ==="

# 1️⃣ Check if HPA is configured
echo "1. Checking HPA configuration..."
if kubectl get hpa web-app-hpa &>/dev/null; then
    echo "✓ HPA is configured"
    kubectl get hpa web-app-hpa
else
    echo "✗ HPA not found"
    exit 1
fi

echo

# 2️⃣ Check current pod count
echo "2. Current pod status..."
CURRENT_PODS=$(kubectl get pods -l app=web-app --no-headers | wc -l)
echo "Current pod count: $CURRENT_PODS"

echo

# 3️⃣ Check if metrics are available
echo "3. Checking metrics availability..."
if kubectl top pods -l app=web-app &>/dev/null; then
    echo "✓ Metrics are available"
    kubectl top pods -l app=web-app
else
    echo "⚠ Metrics not ready yet (this is normal initially)"
fi

echo

# 4️⃣ Check service connectivity
echo "4. Testing service connectivity..."
if kubectl get service web-app-service &>/dev/null; then
    echo "✓ Service is accessible"
    kubectl get service web-app-service
else
    echo "✗ Service not found"
fi

echo
echo "=== Verification Complete ==="
EOF

chmod +x verify-autoscaling.sh
./verify-autoscaling.sh
```
✅ **Sign of success:** all four checks print `✓` with no `✗` lines.

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔴 Issue 1: Metrics Server Not Working</summary>

```bash
# 🔍 Check metrics server status
kubectl get pods -n kube-system | grep metrics-server

# 🔄 If metrics server is not running, restart it
minikube addons disable metrics-server
minikube addons enable metrics-server

# ⏳ Wait for metrics server to be ready
kubectl wait --for=condition=ready pod -l k8s-app=metrics-server -n kube-system --timeout=300s
```
</details>

<details>
<summary>🟠 Issue 2: HPA Shows Unknown Metrics</summary>

```bash
# 🔍 Check if resource requests are set in deployment
kubectl describe deployment web-app | grep -A 10 "Limits\|Requests"

# ✅ Verify metrics server is collecting data
kubectl top nodes
kubectl top pods -l app=web-app
```
</details>

<details>
<summary>🟡 Issue 3: Pods Not Scaling</summary>

```bash
# 🔍 Check HPA events for scaling decisions
kubectl describe hpa web-app-hpa

# 📊 Verify resource utilization is above threshold
kubectl top pods -l app=web-app

# 🖥️ Check if there are resource constraints
kubectl describe nodes
```
</details>

---

## 🧹 Cleanup

```bash
# 🗑️ Delete all created resources
kubectl delete -f web-app-hpa.yaml
kubectl delete -f web-app-service.yaml
kubectl delete -f web-app-deployment.yaml
kubectl delete -f cpu-stress.yaml 2>/dev/null || true

# 🗑️ Delete any remaining load generators
kubectl delete pods -l app=load-generator 2>/dev/null || true

# 🛑 Stop Minikube (optional)
minikube stop

# 🧹 Remove lab files
cd ~
rm -rf k8s-lab
```
✅ **Sign of success:** `kubectl get all` returns no `web-app` resources.

---

## 📊 Key Concepts Summary

> This is an infrastructure/orchestration lab with no detection targets, so a MITRE ATT&CK mapping is not applicable here — the table below covers the core HPA concepts instead.

| Concept | Description |
|---|---|
| 📏 **Utilization Target** | The average CPU/memory percentage HPA aims to maintain across pods |
| ⬆️ **Scale-Up Policy** | How aggressively HPA adds replicas (e.g., 100% increase per 15s) |
| ⬇️ **Scale-Down Policy** | How conservatively HPA removes replicas (5-minute stabilization window) |
| 🎚️ **Min/Max Replicas** | The floor and ceiling boundaries HPA will never cross |
| 📡 **Metrics Server** | Cluster add-on that supplies the CPU/memory data HPA reads from |
| 🩺 **Resource Requests/Limits** | Pod-level values HPA uses as the baseline for utilization percentage |

---

## 🎓 Conclusion

Congratulations! You have successfully completed **Lab 96: Docker in Production — Scaling with Kubernetes**.

### 🏆 Key Accomplishments
- 🏗️ Set up a local Kubernetes cluster using Minikube with proper resource allocation
- 📦 Deployed a Dockerized application with resource requests and limits
- 📊 Configured Horizontal Pod Autoscaling (HPA) based on CPU and memory metrics
- 🔥 Simulated realistic application load to trigger autoscaling events
- 📈 Monitored scaling behavior and resource utilization in real-time
- 🧠 Understood the relationship between resource usage and scaling decisions

### 💡 Why This Matters
- 🟢 **Ensures High Availability** — automatically scales applications based on demand
- 💰 **Optimizes Resource Usage** — prevents over-provisioning and reduces costs
- ⚡ **Improves Performance** — maintains response times during traffic spikes
- 🛡️ **Enables Resilience** — automatically recovers from failures by scaling appropriately

### 🌍 Real-World Applications
- 🛒 E-commerce websites handling variable traffic loads
- 🔌 API services that need to scale during peak usage
- 🧩 Microservices architectures requiring dynamic resource allocation
- ☁️ Cost-effective cloud deployments that scale based on actual demand

### ➡️ Next Steps
- 🎛️ Explore advanced HPA configurations with custom metrics
- 📐 Learn about Vertical Pod Autoscaling (VPA) for optimizing resource requests
- 🗺️ Study cluster autoscaling for node-level scaling
- 📊 Investigate monitoring solutions like Prometheus and Grafana for production environments

> 🎖️ This foundational knowledge of Kubernetes autoscaling prepares you for managing containerized applications in production environments and is essential for the **Docker Certified Associate (DCA)** certification.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
