<div align="center">

# ☁️ Docker and AWS ECS
### Running Docker Containers on Amazon Elastic Container Service

![AWS ECS](https://img.shields.io/badge/AWS%20ECS-FF9900?style=for-the-badge&logo=amazonecs&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![AWS ALB](https://img.shields.io/badge/Elastic%20Load%20Balancing-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![CloudWatch](https://img.shields.io/badge/Amazon%20CloudWatch-FF4F8B?style=for-the-badge&logo=amazoncloudwatch&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Level](https://img.shields.io/badge/Level-Intermediate-orange?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Ready-to-Use Cloud Machines](#️-ready-to-use-cloud-machines)
- [🧩 Technology Stack](#-technology-stack)
- [🧱 Task 1: Create an ECS Cluster and Configure Task Definitions](#-task-1-create-an-ecs-cluster-and-configure-task-definitions)
- [🚀 Task 2: Run a Docker Container in ECS Using AWS Management Console](#-task-2-run-a-docker-container-in-ecs-using-aws-management-console)
- [⚖️ Task 3: Configure a Load Balancer for Your ECS Service](#️-task-3-configure-a-load-balancer-for-your-ecs-service)
- [📈 Task 4: Scale the ECS Service and Manage Container Tasks](#-task-4-scale-the-ecs-service-and-manage-container-tasks)
- [📊 Task 5: Monitor ECS Services with Amazon CloudWatch](#-task-5-monitor-ecs-services-with-amazon-cloudwatch)
- [🛠️ Troubleshooting Tips](#️-troubleshooting-tips)
- [🐛 Useful Commands for Debugging](#-useful-commands-for-debugging)
- [🧹 Cleanup Instructions](#-cleanup-instructions)
- [🎓 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | 🧱 Create and configure an Amazon ECS cluster |
| 2 | 📝 Define and deploy task definitions for containerized applications |
| 3 | 🚀 Run Docker containers in ECS using the AWS Management Console |
| 4 | ⚖️ Configure an Application Load Balancer for ECS services |
| 5 | 📈 Scale ECS services and manage container tasks effectively |
| 6 | 📊 Monitor ECS services using Amazon CloudWatch |
| 7 | 📖 Understand the fundamentals of container orchestration in AWS |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker basics | Basic understanding of Docker containers and containerization concepts |
| ☁️ AWS familiarity | Familiarity with AWS services and the AWS Management Console |
| 🌐 Networking basics | Knowledge of basic networking concepts (load balancers, security groups) |
| 📄 JSON knowledge | Understanding of JSON format for configuration files |
| ⌨️ CLI experience | Basic command-line interface experience |

---

## 🖥️ Ready-to-Use Cloud Machines

> **☁️ Everything is Ready to Use!**
> Al Nafi provides pre-configured Linux-based cloud machines for this lab. Simply click **Start Lab** to access your environment — no need to build or configure your own virtual machine.

Your lab environment includes:

- ✅ AWS CLI pre-installed and configured
- ✅ Docker installed and running
- ✅ All necessary permissions configured
- ✅ Sample application files ready for deployment

---

## 🧩 Technology Stack

<div align="center">

| Technology | Role in This Lab |
|---|---|
| ![AWS ECS](https://img.shields.io/badge/ECS-FF9900?style=flat-square&logo=amazonecs&logoColor=white) | Managed cluster running the containerized Nginx service |
| ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white) | Container runtime for the `nginx:latest` image |
| ![ALB](https://img.shields.io/badge/Application%20Load%20Balancer-FF9900?style=flat-square&logo=amazonaws&logoColor=white) | Distributes traffic across running ECS tasks |
| ![CloudWatch](https://img.shields.io/badge/CloudWatch-FF4F8B?style=flat-square&logo=amazoncloudwatch&logoColor=white) | Metrics, dashboards, alarms, and Container Insights |
| ![AWS CLI](https://img.shields.io/badge/AWS%20CLI-232F3E?style=flat-square&logo=amazonaws&logoColor=white) | Service inspection and debugging from the terminal |

</div>

---

## 🧱 Task 1: Create an ECS Cluster and Configure Task Definitions

### 🖱️ Subtask 1.1: Create an ECS Cluster

**☁️ Access the AWS Management Console**
1. Open your web browser and navigate to the AWS Management Console
2. 🔎 Search for "ECS" in the services search bar
3. Click on **Elastic Container Service**

**🧱 Create a New Cluster**
1. Click **Clusters** in the left navigation panel
2. Click the **Create Cluster** button
3. Choose **EC2 Linux + Networking** as the cluster template
4. Click **Next step**

**⚙️ Configure Cluster Settings**

| Setting | Value |
|---|---|
| Cluster name | `my-ecs-cluster` |
| EC2 instance type | `t3.micro` (free tier eligible) |
| Number of instances | `2` |
| Key pair | Select an existing key pair or create a new one |
| VPC | Use the default VPC |
| Subnets | Select at least two subnets in different availability zones |
| Security group | Create a new security group or use the default |

5. Click **Create**

**✅ Verify Cluster Creation**
- ⏳ Wait for the cluster creation to complete (this may take 5-10 minutes)
- ✅ Verify that your cluster shows as `ACTIVE` status
- 📝 Note the cluster ARN for future reference

### 📝 Subtask 1.2: Create a Task Definition

**📂 Navigate to Task Definitions**
1. In the ECS console, click **Task Definitions** in the left panel
2. Click **Create new Task Definition**

**🚀 Select Launch Type**
1. Choose **EC2** as the launch type compatibility
2. Click **Next step**

**⚙️ Configure Task Definition**

| Setting | Value |
|---|---|
| Task Definition Name | `nginx-task-definition` |
| Task Role | Leave blank for now |
| Network Mode | `bridge` |
| Task execution role | `ecsTaskExecutionRole` |
| Task memory (MiB) | `512` |
| Task CPU (unit) | `256` |

**🐳 Add Container Definition**
1. Click **Add container**
2. Configure:
   - Container name: `nginx-container`
   - Image: `nginx:latest`
   - Memory Limits (MiB): Soft limit `256`
   - Port mappings — Host port: `0` (dynamic port mapping), Container port: `80`, Protocol: `tcp`
3. Click **Add**

**✅ Create Task Definition**
1. Review all settings
2. Click **Create**
3. Verify the task definition is created successfully

---

## 🚀 Task 2: Run a Docker Container in ECS Using AWS Management Console

### 🧱 Subtask 2.1: Create an ECS Service

**📂 Navigate to Your Cluster**
1. Go back to **Clusters** and click on `my-ecs-cluster`
2. Click the **Services** tab
3. Click **Create**

**⚙️ Configure Service**

| Setting | Value |
|---|---|
| Launch type | `EC2` |
| Task Definition | `nginx-task-definition:1` |
| Platform version | `LATEST` |
| Cluster | `my-ecs-cluster` |
| Service name | `nginx-service` |
| Service type | `REPLICA` |
| Number of tasks | `2` |

**📐 Configure Deployments**
- Minimum healthy percent: `50`
- Maximum percent: `200`
- Leave other settings as default
- Click **Next step**

**🌐 Configure Network**
- Load balancer type: skip for now (added in Task 3)
- Service discovery: uncheck **Enable service discovery**
- Click **Next step**

**📈 Set Auto Scaling**
- Service Auto Scaling: **Do not adjust the service's desired count**
- Click **Next step**

**✅ Review and Create**
1. Review all configurations
2. Click **Create Service**
3. Click **View Service** to monitor the deployment

### 🔎 Subtask 2.2: Verify Container Deployment

**✅ Check Service Status**
- Monitor the service until it shows `RUNNING` status
- Verify that 2 tasks are running successfully

**📦 View Running Tasks**
1. Click the **Tasks** tab within your service
2. Click on one of the running tasks to view details
3. 📝 Note the public IP address and dynamic port assigned

**🧪 Test the Application**
1. Copy the public IP address from the task details
2. Note the port number from the port mapping
3. Open a new browser tab and navigate to `http://[PUBLIC_IP]:[PORT]`
4. ✅ You should see the default Nginx welcome page

---

## ⚖️ Task 3: Configure a Load Balancer for Your ECS Service

### 🏗️ Subtask 3.1: Create an Application Load Balancer

**📂 Navigate to EC2 Console**
1. Open a new tab and go to the EC2 console
2. Click **Load Balancers** in the left navigation panel
3. Click **Create Load Balancer**

**⚖️ Select Load Balancer Type**
1. Choose **Application Load Balancer**
2. Click **Create**

**⚙️ Configure Load Balancer**

| Setting | Value |
|---|---|
| Name | `ecs-nginx-alb` |
| Scheme | Internet-facing |
| IP address type | IPv4 |
| VPC | Same as your ECS cluster |
| Availability Zones | At least 2 AZs with public subnets |
| Security groups | Allow HTTP (port 80) from anywhere (`0.0.0.0/0`) |

**🎯 Configure Target Group**

| Setting | Value |
|---|---|
| Target group name | `ecs-nginx-targets` |
| Target type | Instance |
| Protocol | HTTP |
| Port | `80` |
| VPC | Same as load balancer |
| Health check path | `/` |

- Click **Next**

**📋 Register Targets**
1. Don't register targets manually (ECS will handle this)
2. Click **Next**
3. Review and click **Create**

### 🔄 Subtask 3.2: Update ECS Service with Load Balancer

**🔄 Update the Service**
1. Go back to your ECS cluster
2. Select `nginx-service`
3. Click **Update**

**⚖️ Configure Load Balancer Integration**

| Setting | Value |
|---|---|
| Load balancer type | Application Load Balancer |
| Load balancer name | `ecs-nginx-alb` |
| Container to load balance | `nginx-container:80:0` |
| Target group name | `ecs-nginx-targets` |
| Target group protocol | HTTP |
| Target group port | `80` |
| Path pattern | `/*` |
| Health check grace period | `30 seconds` |

**✅ Complete the Update**
1. Click **Next step** through the remaining screens
2. Click **Update Service**
3. ⏳ Wait for the service to stabilize

### 🧪 Subtask 3.3: Test Load Balancer

**🔗 Get Load Balancer DNS Name**
1. Go to EC2 console → Load Balancers
2. Select `ecs-nginx-alb`
3. Copy the DNS name from the description

**🧪 Test the Application**
1. Open a browser and navigate to the load balancer DNS name
2. ✅ You should see the Nginx welcome page
3. 🔄 Refresh the page multiple times to verify load balancing

---

## 📈 Task 4: Scale the ECS Service and Manage Container Tasks

### 📐 Subtask 4.1: Manual Scaling

**📈 Scale Up the Service**
1. Navigate to your ECS service
2. Click **Update**
3. Change **Number of tasks** from `2` to `4`
4. Click through the update process
5. Monitor the deployment of new tasks

**✅ Verify Scaling**
- Check that 4 tasks are now running
- Verify all tasks are healthy in the target group
- Test the load balancer to ensure traffic distribution

### 🤖 Subtask 4.2: Configure Auto Scaling

**⚙️ Set Up Service Auto Scaling**
1. In your ECS service, click **Update**
2. Navigate to **Set Auto Scaling**
3. Service Auto Scaling: **Adjust the service's desired count**

| Setting | Value |
|---|---|
| Minimum number of tasks | `2` |
| Desired number of tasks | `4` |
| Maximum number of tasks | `8` |

**📊 Create Scaling Policies**

*Scale-out policy:*
| Setting | Value |
|---|---|
| Policy name | `scale-out-policy` |
| Metric type | `ECSServiceAverageCPUUtilization` |
| Target value | `70` |
| Scale-out cooldown | `300 seconds` |

*Scale-in policy:*
| Setting | Value |
|---|---|
| Policy name | `scale-in-policy` |
| Metric type | `ECSServiceAverageCPUUtilization` |
| Target value | `70` |
| Scale-in cooldown | `300 seconds` |

**✅ Apply Auto Scaling Configuration**
1. Review the settings
2. Click **Update Service**

### 🧪 Subtask 4.3: Test Auto Scaling

> 🏋️ **Generate Load (Optional)** — use a load testing tool or script to generate traffic, monitor CPU utilization in CloudWatch, and observe auto scaling behavior.

```bash
# 🏋️ Simple load generation script (run from your lab machine)
for i in {1..1000}; do
  curl -s http://[YOUR-LOAD-BALANCER-DNS] > /dev/null
  sleep 0.1
done
```

---

## 📊 Task 5: Monitor ECS Services with Amazon CloudWatch

### 📡 Subtask 5.1: Access CloudWatch Metrics

**📂 Navigate to CloudWatch**
1. Open the CloudWatch console
2. Click **Metrics** in the left navigation panel
3. Click **All metrics**

**🔎 Find ECS Metrics**
1. Click the **ECS** namespace
2. Select **ClusterName, ServiceName**
3. Choose your cluster and service metrics

**📊 Key Metrics to Monitor**

| Metric | What It Shows |
|---|---|
| `CPUUtilization` | CPU usage across tasks |
| `MemoryUtilization` | Memory consumption |
| `RunningTaskCount` | Number of running tasks |
| `PendingTaskCount` | Tasks waiting to be scheduled |

### 📈 Subtask 5.2: Create CloudWatch Dashboard

**🆕 Create a New Dashboard**
1. In CloudWatch, click **Dashboards**
2. Click **Create dashboard**
3. Dashboard name: `ECS-Monitoring-Dashboard`

**📊 Add Widgets**
1. Click **Add widget**
2. Choose **Line** chart
3. Select ECS metrics for your service: CPU Utilization, Memory Utilization, Running Task Count
4. Configure the time range and refresh interval

**🎨 Customize Dashboard**
- Add multiple widgets for different metrics
- Arrange widgets for optimal viewing
- 💾 Save the dashboard

### 🚨 Subtask 5.3: Set Up CloudWatch Alarms

**🌡️ Create CPU Utilization Alarm**
1. Go to CloudWatch → Alarms
2. Click **Create alarm**
3. Select ECS CPU utilization metric

| Setting | Value |
|---|---|
| Threshold | Greater than 80% |
| Period | 5 minutes |
| Datapoints to alarm | 2 out of 3 |
| Alarm name | `ECS-High-CPU-Utilization` |

**📉 Create Task Count Alarm**
- Create another alarm for running task count
- Threshold: less than `2`
- Alarm name: `ECS-Low-Task-Count`

**📧 Configure Notifications (Optional)**
- Set up SNS topics for alarm notifications
- Configure email or SMS alerts

### 🔍 Subtask 5.4: View Container Insights

**✅ Enable Container Insights**
1. In the ECS console, go to your cluster
2. Click the **Metrics** tab
3. Enable Container Insights if not already enabled

**🔎 Explore Container Insights**
- View cluster-level metrics
- Drill down to service and task-level metrics
- Analyze performance patterns and trends

---

## 🛠️ Troubleshooting Tips

<details>
<summary>🔴 Tasks Not Starting</summary>

- 🔎 Check task definition for correct image name
- 📏 Verify sufficient resources (CPU/memory) on cluster instances
- 📜 Review CloudWatch logs for error messages
</details>

<details>
<summary>🔴 Load Balancer Health Checks Failing</summary>

- 🔒 Ensure security groups allow traffic on the correct ports
- 🔎 Verify the health check path is accessible
- 🔌 Check that containers are listening on the expected port
</details>

<details>
<summary>🔴 Auto Scaling Not Working</summary>

- 📊 Verify CloudWatch metrics are being published
- 🔎 Check scaling policies and thresholds
- 🔑 Ensure proper IAM permissions for auto scaling
</details>

<details>
<summary>🔴 Service Update Stuck</summary>

- 📏 Check for resource constraints
- ✅ Verify task definition is valid
- 🔎 Review deployment configuration settings
</details>

---

## 🐛 Useful Commands for Debugging

```bash
# 📜 Check ECS agent logs on cluster instances
sudo docker logs ecs-agent

# 📦 View running containers on an instance
docker ps

# 📜 Check container logs
docker logs [container-id]

# 🔎 Describe ECS service
aws ecs describe-services --cluster my-ecs-cluster --services nginx-service

# 📋 List running tasks
aws ecs list-tasks --cluster my-ecs-cluster --service-name nginx-service
```

---

## 🧹 Cleanup Instructions

> 💰 To avoid ongoing charges, clean up the resources created in this lab:

1. **🗑️ Delete ECS Service**
   - Scale service down to 0 tasks
   - Delete the service
2. **⚖️ Delete Load Balancer**
   - Delete the Application Load Balancer
   - Delete the target group
3. **🧱 Delete ECS Cluster**
   - Ensure no services are running
   - Delete the cluster (this will terminate EC2 instances)
4. **📊 Delete CloudWatch Resources**
   - Delete custom dashboards
   - Delete alarms
   - Clean up log groups if needed

---

## 🎓 Conclusion

Congratulations! You have successfully completed **Lab 29: Docker and AWS ECS - Running Docker Containers on Amazon ECS**.

### 🏆 What You Accomplished

- 🧱 Created and configured an Amazon ECS cluster with EC2 instances
- 📝 Defined and deployed task definitions for containerized applications
- 🚀 Successfully ran Docker containers in ECS using the AWS Management Console
- ⚖️ Configured an Application Load Balancer to distribute traffic across container instances
- 📈 Implemented both manual and automatic scaling for your ECS services
- 📊 Set up comprehensive monitoring using Amazon CloudWatch with custom dashboards and alarms

### 🔑 Key Takeaways

This lab demonstrates the power of container orchestration in the cloud. Amazon ECS provides a managed service that eliminates the complexity of running your own container orchestration infrastructure. You've learned how to:

- ☁️ Leverage AWS managed services for container deployment
- 🌍 Implement high availability through load balancing and multi-AZ deployment
- 📈 Use auto scaling to handle varying workloads efficiently
- 🔍 Monitor and troubleshoot containerized applications in production

### 🌍 Real-World Applications

| Theme | Why It Matters |
|---|---|
| 🧩 Microservices Architecture | Deploy and manage multiple containerized services |
| 🔁 DevOps Practices | Implement continuous deployment pipelines with ECS |
| 💰 Cost Optimization | Use auto scaling to optimize resource usage and costs |
| 🛡️ High Availability | Design resilient applications that can handle failures gracefully |

### 🔭 Next Steps

- ☸️ Explore **Amazon EKS** (Elastic Kubernetes Service) for Kubernetes-based orchestration
- 🔁 Implement CI/CD pipelines with **AWS CodePipeline** and ECS
- 🕸️ Learn about service mesh technologies like **AWS App Mesh**
- 🚀 Study advanced ECS features like **Fargate** for serverless containers

> 🏁 This foundational knowledge of ECS will serve you well as you continue your journey in cloud computing and containerization technologies.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blue?style=for-the-badge)

</div>
