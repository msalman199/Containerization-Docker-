<div align="center">

# ☸️ Docker and Kubernetes — Introduction to Kubernetes

### Minikube Clusters, Pods, Deployments, and Service Discovery

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Minikube](https://img.shields.io/badge/Minikube-2496ED?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-CB171E?style=for-the-badge&logo=yaml&logoColor=white)

</div>

---

## 📖 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [⚙️ Task 1: Install and Configure Kubernetes Cluster using Minikube](#️-task-1-install-and-configure-kubernetes-cluster-using-minikube)
- [📦 Task 2: Deploy a Simple Multi-Container Application using Kubernetes Pods](#-task-2-deploy-a-simple-multi-container-application-using-kubernetes-pods)
- [🌐 Task 3: Expose a Service and Access it Externally using LoadBalancer](#-task-3-expose-a-service-and-access-it-externally-using-loadbalancer)
- [🔄 Task 4: Understand Kubernetes Workload Management](#-task-4-understand-kubernetes-workload-management)
- [⌨️ Task 5: Use kubectl to Interact with Kubernetes Clusters and Resources](#️-task-5-use-kubectl-to-interact-with-kubernetes-clusters-and-resources)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [✅ Lab Verification](#-lab-verification)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, students will be able to:

| # | Skill |
|---|-------|
| 1️⃣ | Understand the fundamental concepts of Kubernetes and its role in container orchestration |
| 2️⃣ | Install and configure a local Kubernetes cluster using minikube |
| 3️⃣ | Deploy multi-container applications using Kubernetes pods |
| 4️⃣ | Create and manage Kubernetes services to expose applications |
| 5️⃣ | Use `kubectl` command-line tool to interact with Kubernetes clusters |
| 6️⃣ | Understand how Kubernetes manages containerized workloads across nodes |
| 7️⃣ | Implement basic load balancing and service discovery in Kubernetes |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker Basics | Understanding of Docker containers and images |
| 🐧 Linux CLI | Familiarity with Linux command line operations |
| 📄 YAML | Basic knowledge of YAML file structure |
| 🌐 Networking | Understanding of networking concepts (ports, IP addresses) |
| 🎓 Prior Labs | Completed previous Docker labs in this series |

**Required Knowledge Areas:**
- 🐳 Docker fundamentals
- 🔄 Container lifecycle management
- 🌐 Basic networking concepts
- 💻 Command-line interface usage

---

## 🖥️ Lab Environment Setup

> ℹ️ **Good News!** Al Nafi provides you with ready-to-use Linux-based cloud machines. Simply click **"Start Lab"** to access your pre-configured environment — no need to build your own virtual machine or worry about system compatibility issues.

Your lab environment includes:

- ✅ Ubuntu 20.04 LTS or later
- ✅ Docker pre-installed and configured
- ✅ Internet connectivity for downloading Kubernetes components
- ✅ Sufficient resources (2 CPU cores, 4GB RAM minimum)

---

## ⚙️ Task 1: Install and Configure Kubernetes Cluster using Minikube

### 🔹 Subtask 1.1: Install Minikube

Minikube is a tool that creates a single-node Kubernetes cluster on your local machine, perfect for learning and development.

**Step 1: Update your system packages**
```bash
sudo apt update && sudo apt upgrade -y   # 📦 refresh packages
```

**Step 2: Install required dependencies**
```bash
sudo apt install -y curl wget apt-transport-https   # 🔧 dependencies
```

**Step 3: Download and install minikube**
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64   # ⬇️ download
sudo install minikube-linux-amd64 /usr/local/bin/minikube   # 📥 install to PATH
```

**Step 4: Verify minikube installation**
```bash
minikube version   # ✅ confirm install
```

### 🔹 Subtask 1.2: Install kubectl

`kubectl` is the command-line tool for interacting with Kubernetes clusters.

**Step 1: Download kubectl**
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"   # ⬇️ latest stable kubectl
```

**Step 2: Make kubectl executable and move to PATH**
```bash
chmod +x kubectl   # 🔓 executable
sudo mv kubectl /usr/local/bin/   # 📥 install to PATH
```

**Step 3: Verify kubectl installation**
```bash
kubectl version --client   # ✅ confirm install
```

### 🔹 Subtask 1.3: Start Minikube Cluster

**Step 1: Start minikube with Docker driver**
```bash
minikube start --driver=docker   # 🚀 spin up cluster
```

**Step 2: Verify cluster status**
```bash
minikube status   # ✅ status check
```

**Step 3: Check cluster information**
```bash
kubectl cluster-info   # ℹ️ cluster endpoints
```

**Step 4: View cluster nodes**
```bash
kubectl get nodes   # 📋 node listing
```

You should see output similar to:
```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   2m    v1.28.3
```

> 📝 `# TODO:` Try `minikube start --driver=docker --nodes=2` to see how a multi-node local cluster differs from the single-node default.

---

## 📦 Task 2: Deploy a Simple Multi-Container Application using Kubernetes Pods

### 🔹 Subtask 2.1: Create a Simple Web Application Pod

**Step 1: Create a directory for your Kubernetes manifests**
```bash
mkdir ~/k8s-lab && cd ~/k8s-lab   # 📁 manifests workspace
```

**Step 2: Create a simple nginx pod manifest**
```yaml
cat > nginx-pod.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80   # 🔌 exposed container port
EOF
```

**Step 3: Deploy the pod**
```bash
kubectl apply -f nginx-pod.yaml   # 🚀 create pod
```

**Step 4: Verify pod creation**
```bash
kubectl get pods   # 📋 pod listing
```

**Step 5: Get detailed pod information**
```bash
kubectl describe pod nginx-pod   # 🔍 full detail
```

### 🔹 Subtask 2.2: Create a Multi-Container Pod

**Step 1: Create a multi-container pod with nginx and redis**
```yaml
cat > multi-container-pod.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-pod
  labels:
    app: multi-app
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80    # 🌐 web container
  - name: redis
    image: redis:latest
    ports:
    - containerPort: 6379   # 🗄️ cache container
EOF
```

**Step 2: Deploy the multi-container pod**
```bash
kubectl apply -f multi-container-pod.yaml   # 🚀 create pod
```

**Step 3: Check both pods are running**
```bash
kubectl get pods   # 📋 confirm both running
```

**Step 4: View logs from specific container**
```bash
kubectl logs multi-container-pod -c nginx   # 📜 nginx container logs
kubectl logs multi-container-pod -c redis   # 📜 redis container logs
```

### 🔹 Subtask 2.3: Create a Deployment for Better Management

**Step 1: Create a deployment manifest**
```yaml
cat > nginx-deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3               # 📈 three managed replicas
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
EOF
```

**Step 2: Deploy the application**
```bash
kubectl apply -f nginx-deployment.yaml   # 🚀 create deployment
```

**Step 3: Verify deployment**
```bash
kubectl get deployments        # 📋 deployment status
kubectl get pods -l app=nginx   # 📋 managed pods
```

> 📝 `# TODO:` Delete one of the three replica pods directly with `kubectl delete pod <name>` and watch the Deployment recreate it automatically.

---

## 🌐 Task 3: Expose a Service and Access it Externally using LoadBalancer

### 🔹 Subtask 3.1: Create a ClusterIP Service

**Step 1: Create a service manifest for internal access**
```yaml
cat > nginx-service-clusterip.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx-service-clusterip
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP   # 🔒 internal-only access
EOF
```

**Step 2: Apply the service**
```bash
kubectl apply -f nginx-service-clusterip.yaml   # 🚀 create service
```

**Step 3: View the service**
```bash
kubectl get services   # 📋 service listing
```

### 🔹 Subtask 3.2: Create a NodePort Service

**Step 1: Create a NodePort service for external access**
```yaml
cat > nginx-service-nodeport.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx-service-nodeport
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30080   # 🔌 external-facing node port
  type: NodePort
EOF
```

**Step 2: Apply the NodePort service**
```bash
kubectl apply -f nginx-service-nodeport.yaml   # 🚀 create service
```

**Step 3: Get service details**
```bash
kubectl get services   # 📋 service listing
```

### 🔹 Subtask 3.3: Access the Application Externally

**Step 1: Get minikube IP address**
```bash
minikube ip   # 📍 cluster node IP
```

**Step 2: Access the application using NodePort**
```bash
curl http://$(minikube ip):30080   # 🌐 test access
```

**Step 3: Use minikube service command for easy access**
```bash
minikube service nginx-service-nodeport --url   # 🔗 quick URL
```

**Step 4: Open in browser (if GUI available)**
```bash
minikube service nginx-service-nodeport   # 🖥️ open in browser
```

### 🔹 Subtask 3.4: Create a LoadBalancer Service (Minikube Tunnel)

**Step 1: Create LoadBalancer service**
```yaml
cat > nginx-service-loadbalancer.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx-service-loadbalancer
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer   # ⚖️ external load balancer
EOF
```

**Step 2: Apply the LoadBalancer service**
```bash
kubectl apply -f nginx-service-loadbalancer.yaml   # 🚀 create service
```

**Step 3: Start minikube tunnel (in a new terminal)**
```bash
minikube tunnel   # 🚇 expose LoadBalancer externally
```

**Step 4: Check external IP assignment**
```bash
kubectl get services nginx-service-loadbalancer   # 📍 confirm external IP
```

**Step 5: Access via LoadBalancer IP**
```bash
curl http://<EXTERNAL-IP>   # 🌐 test access
```

> 📝 `# TODO:` Compare the three service types (ClusterIP, NodePort, LoadBalancer) side by side and note which layer of your network stack each one operates at.

---

## 🔄 Task 4: Understand Kubernetes Workload Management

### 🔹 Subtask 4.1: Explore Pod Lifecycle

**Step 1: Watch pods in real-time**
```bash
kubectl get pods -w   # 👀 live pod status
```

**Step 2: Delete a pod and observe recreation**
```bash
kubectl delete pod <pod-name>   # 🗑️ delete
kubectl get pods                # 🔄 watch it recreate
```

**Step 3: Scale the deployment**
```bash
kubectl scale deployment nginx-deployment --replicas=5   # 📈 scale up
kubectl get pods
```

**Step 4: Scale down**
```bash
kubectl scale deployment nginx-deployment --replicas=2   # 📉 scale down
kubectl get pods
```

### 🔹 Subtask 4.2: Understand Resource Management

**Step 1: Check resource usage**
```bash
kubectl top nodes   # 📊 node resource usage
kubectl top pods    # 📊 pod resource usage
```

**Step 2: Describe deployment for resource information**
```bash
kubectl describe deployment nginx-deployment   # 🔍 full detail
```

**Step 3: View events**
```bash
kubectl get events --sort-by=.metadata.creationTimestamp   # 📜 chronological events
```

### 🔹 Subtask 4.3: Rolling Updates

**Step 1: Update the nginx image**
```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.21   # 🔄 rolling update
```

**Step 2: Watch the rolling update**
```bash
kubectl rollout status deployment/nginx-deployment   # 👀 progress
```

**Step 3: Check rollout history**
```bash
kubectl rollout history deployment/nginx-deployment   # 📜 revision history
```

**Step 4: Rollback if needed**
```bash
kubectl rollout undo deployment/nginx-deployment   # ↩️ revert to previous
```

> 📝 `# TODO:` Trigger a rolling update to a deliberately bad image tag, watch it fail, then practice `kubectl rollout undo` to recover.

---

## ⌨️ Task 5: Use kubectl to Interact with Kubernetes Clusters and Resources

### 🔹 Subtask 5.1: Basic kubectl Commands

**Step 1: List all resources in default namespace**
```bash
kubectl get all   # 📋 everything at a glance
```

**Step 2: Get detailed information about resources**
```bash
kubectl describe deployment nginx-deployment
kubectl describe service nginx-service-nodeport
```

**Step 3: View resource definitions in YAML**
```bash
kubectl get deployment nginx-deployment -o yaml   # 📄 full manifest
kubectl get service nginx-service-nodeport -o yaml
```

**Step 4: Get resources with labels**
```bash
kubectl get pods -l app=nginx   # 🏷️ label-filtered
kubectl get all -l app=nginx
```

### 🔹 Subtask 5.2: Advanced kubectl Operations

**Step 1: Execute commands in pods**
```bash
kubectl exec -it nginx-pod -- /bin/bash   # 💻 interactive shell
# Inside the pod:
# nginx -v
# exit
```

**Step 2: Port forwarding for local access**
```bash
kubectl port-forward pod/nginx-pod 8080:80   # 🔌 local tunnel
# Test in another terminal: curl http://localhost:8080
```

**Step 3: Copy files to/from pods**
```bash
echo "Hello Kubernetes" > test.txt
kubectl cp test.txt nginx-pod:/tmp/test.txt   # 📤 copy into pod
kubectl exec nginx-pod -- cat /tmp/test.txt    # ✅ confirm
```

**Step 4: View logs with different options**
```bash
kubectl logs nginx-pod                # 📜 standard logs
kubectl logs -f nginx-pod             # 📡 follow logs
kubectl logs --tail=10 nginx-pod      # 🔟 last 10 lines
```

### 🔹 Subtask 5.3: Working with Namespaces

**Step 1: Create a new namespace**
```bash
kubectl create namespace test-namespace   # 🗂️ new namespace
```

**Step 2: List all namespaces**
```bash
kubectl get namespaces   # 📋 namespace listing
```

**Step 3: Deploy resources in specific namespace**
```bash
kubectl apply -f nginx-pod.yaml -n test-namespace   # 🚀 scoped deploy
```

**Step 4: List resources in specific namespace**
```bash
kubectl get pods -n test-namespace
kubectl get all -n test-namespace
```

**Step 5: Set default namespace context**
```bash
kubectl config set-context --current --namespace=test-namespace   # 🔀 switch context
kubectl get pods  # Now shows test-namespace pods
```

**Step 6: Switch back to default namespace**
```bash
kubectl config set-context --current --namespace=default   # ↩️ restore default
```

### 🔹 Subtask 5.4: Resource Management and Cleanup

**Step 1: View resource quotas and limits**
```bash
kubectl describe node minikube   # 🔍 node capacity detail
```

**Step 2: Delete specific resources**
```bash
kubectl delete pod nginx-pod
kubectl delete service nginx-service-clusterip
```

**Step 3: Delete resources by label**
```bash
kubectl delete pods -l app=nginx   # 🏷️ label-based delete
```

**Step 4: Delete all resources from files**
```bash
kubectl delete -f nginx-deployment.yaml
kubectl delete -f nginx-service-nodeport.yaml
kubectl delete -f nginx-service-loadbalancer.yaml
```

**Step 5: Clean up namespace**
```bash
kubectl delete namespace test-namespace   # 🧹 full namespace removal
```

> 📝 `# TODO:` Practice `kubectl port-forward` against a pod of your own and confirm you can reach it on `localhost` without any Service object at all.

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>⚙️ Issue 1: Minikube Won't Start</summary>

**Solution:**
```bash
minikube delete
minikube start --driver=docker --force
```
</details>

<details>
<summary>⏳ Issue 2: Pods Stuck in Pending State</summary>

**Check:**
```bash
kubectl describe pod <pod-name>
kubectl get events
```
</details>

<details>
<summary>🔌 Issue 3: Service Not Accessible</summary>

**Verify:**
```bash
kubectl get endpoints
kubectl describe service <service-name>
```
</details>

<details>
<summary>📥 Issue 4: Image Pull Errors</summary>

**Check:**
```bash
kubectl describe pod <pod-name>
# Look for image pull policy and repository access
```
</details>

---

## ✅ Lab Verification

**Step 1: Verify cluster is running**
```bash
kubectl cluster-info
kubectl get nodes
```

**Step 2: Verify deployments are working**
```bash
kubectl get deployments
kubectl get pods
kubectl get services
```

**Step 3: Test external access**
```bash
curl http://$(minikube ip):30080
```

**Step 4: Verify kubectl functionality**
```bash
kubectl version
kubectl get all
```

---

## 🏁 Conclusion

Congratulations! You have successfully completed the Introduction to Kubernetes lab. Here's what you accomplished:

### 🔑 Key Achievements

- ⚙️ **Kubernetes Cluster Setup** — You installed and configured a local Kubernetes cluster using minikube, providing you with a complete container orchestration environment
- 📦 **Container Orchestration** — You learned how Kubernetes manages containerized applications through pods, deployments, and services, understanding the fundamental building blocks of container orchestration
- 🧩 **Multi-Container Applications** — You deployed both single and multi-container pods, experiencing how Kubernetes handles complex application architectures
- 🌐 **Service Discovery and Load Balancing** — You created different types of services (ClusterIP, NodePort, LoadBalancer) to expose applications and understand how Kubernetes handles networking and external access
- ⌨️ **kubectl Mastery** — You gained hands-on experience with `kubectl`, the primary tool for interacting with Kubernetes clusters, learning essential commands for managing resources
- 🔄 **Workload Management** — You explored how Kubernetes automatically manages application lifecycle, scaling, rolling updates, and self-healing capabilities

### 💡 Why This Matters

| Aspect | Impact |
|---|---|
| 🏭 Industry Relevance | Kubernetes is the de facto standard for container orchestration in production environments, used by organizations worldwide |
| 📈 Career Advancement | These skills are essential for DevOps engineers, cloud architects, and software developers working with modern containerized applications |
| 📊 Scalability Understanding | You now understand how applications can be scaled and managed across multiple nodes and environments |
| 🧱 Foundation for Advanced Topics | This lab provides the groundwork for more advanced Kubernetes concepts like persistent storage, security, and multi-cluster management |

### 🔮 Next Steps

- 💾 Explore Kubernetes persistent volumes and storage
- 🔒 Learn about Kubernetes security and RBAC
- 🌐 Study advanced networking with ingress controllers
- ⛵ Practice with Helm package manager
- 📊 Investigate monitoring and logging solutions

> 🎉 You now have the fundamental knowledge to work with Kubernetes in development environments and are prepared to tackle more advanced container orchestration challenges. This foundation will serve you well as you continue your journey in modern application deployment and management.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E90FF?style=for-the-badge)

</div>
