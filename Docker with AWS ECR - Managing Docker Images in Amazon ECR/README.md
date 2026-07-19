<div align="center">

# 🐳 Docker with AWS ECR
## Managing Docker Images in Amazon ECR

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Amazon ECR](https://img.shields.io/badge/Amazon%20ECR-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![AWS CLI](https://img.shields.io/badge/AWS%20CLI-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white)
![Amazon EC2](https://img.shields.io/badge/Amazon%20EC2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![IAM](https://img.shields.io/badge/AWS%20IAM-DD344C?style=for-the-badge&logo=amazoniam&logoColor=white)

**Difficulty:** Intermediate &nbsp;|&nbsp; **Duration:** ~2 hours &nbsp;|&nbsp; **Track:** DevOps / Cloud Infrastructure

</div>

---

## 📋 Table of Contents

- [🎯 Objectives](#-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🗄️ Task 1: Set up Amazon ECR and Create a Repository](#️-task-1-set-up-amazon-ecr-and-create-a-repository)
- [🔐 Task 2: Authenticate Docker to ECR using AWS CLI](#-task-2-authenticate-docker-to-ecr-using-aws-cli)
- [📤 Task 3: Push a Docker Image to ECR](#-task-3-push-a-docker-image-to-ecr)
- [📥 Task 4: Pull the Image from ECR on a Different EC2 Instance](#-task-4-pull-the-image-from-ecr-on-a-different-ec2-instance)
- [🛡️ Task 5: Set up Automated Image Scanning for Vulnerabilities](#️-task-5-set-up-automated-image-scanning-for-vulnerabilities)
- [⚙️ Additional ECR Management Tasks](#️-additional-ecr-management-tasks)
- [🔧 Troubleshooting Common Issues](#-troubleshooting-common-issues)
- [🌟 Best Practices for ECR](#-best-practices-for-ecr)
- [🧹 Cleanup](#-cleanup)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Understand the fundamentals of Amazon Elastic Container Registry (ECR) |
| 2 | Create and configure an ECR repository |
| 3 | Authenticate Docker with ECR using AWS CLI |
| 4 | Build, tag, and push Docker images to ECR |
| 5 | Pull Docker images from ECR on different instances |
| 6 | Configure automated vulnerability scanning for container images |
| 7 | Implement basic ECR security and access management |

---

## ✅ Prerequisites

| Category | Requirement |
|----------|-------------|
| 🐳 Conceptual | Basic understanding of Docker concepts and commands |
| ☁️ Cloud | Familiarity with AWS services and the AWS Management Console |
| 💻 Skills | Basic knowledge of Linux command line operations |
| 📦 Conceptual | Understanding of container concepts and containerization benefits |
| 🔑 Account | AWS account with appropriate permissions for ECR and EC2 services |

---

## 🖥️ Lab Environment Setup

> **☁️ Ready-to-Use Cloud Machines**
> Al Nafi provides pre-configured Linux-based cloud machines for this lab. Simply click **Start Lab** to access your environment — no need to build your own VM or configure additional infrastructure.

**Your lab environment includes:**

- 🖥️ Primary EC2 instance with Docker and AWS CLI pre-installed
- 🖥️ Secondary EC2 instance for testing image pulls
- 🔑 Appropriate IAM roles and permissions configured
- 🌐 All necessary networking and security groups set up

---

## 🗄️ Task 1: Set up Amazon ECR and Create a Repository

### 🌐 Subtask 1.1: Access AWS Management Console

1. Open your web browser and navigate to the AWS Management Console
2. Sign in using your provided AWS credentials
3. Ensure you are in the correct AWS region (`us-east-1` recommended for this lab)

### 🔍 Subtask 1.2: Navigate to Amazon ECR

1. In the AWS Management Console, search for **ECR** in the services search bar
2. Click on **Elastic Container Registry** from the search results
3. You will see the ECR dashboard with options to create repositories

### ➕ Subtask 1.3: Create Your First ECR Repository

1. Click the **Create repository** button
2. Configure the repository settings:
   - **Visibility settings:** Select `Private`
   - **Repository name:** Enter `my-web-app`
   - **Tag immutability:** Leave as `Mutable` (default)
   - **Image scan settings:** Enable `Scan on push` (we'll configure this further in Task 5)
   - **Encryption settings:** Leave as `AES-256` (default)
3. Click **Create repository**
4. Note the repository URI displayed (format: `account-id.dkr.ecr.region.amazonaws.com/my-web-app`)

> TODO: Record your account ID and region somewhere handy — you'll paste them into almost every command below

### ✅ Subtask 1.4: Verify Repository Creation

1. Confirm your repository appears in the ECR repositories list
2. Click on the repository name to view its details
3. Note the **Push commands** tab — we'll use these commands later

---

## 🔐 Task 2: Authenticate Docker to ECR using AWS CLI

### 🔌 Subtask 2.1: Connect to Your Primary EC2 Instance

```bash
# 🔌 Access your primary EC2 instance terminal (provided in your lab environment)
# 🐳 Verify Docker is installed and running
docker --version
docker info
```

### ⚙️ Subtask 2.2: Configure AWS CLI

```bash
# 🔍 Check if AWS CLI is configured
aws --version
aws sts get-caller-identity
```

```bash
# 🛠️ If not configured, set up AWS CLI with your credentials
aws configure
```

Enter your:
- 🔑 AWS Access Key ID
- 🔑 AWS Secret Access Key
- 🌍 Default region (e.g., `us-east-1`)
- 📄 Default output format (`json`)

### 🔑 Subtask 2.3: Authenticate Docker with ECR

```bash
# 🔐 Get the authentication token and authenticate Docker to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.us-east-1.amazonaws.com
```

> Replace `<your-account-id>` with your actual AWS account ID.

Verify successful authentication by checking for the success message: `Login Succeeded`

### 🧪 Subtask 2.4: Test ECR Access

```bash
# 📋 List your ECR repositories to confirm access
aws ecr describe-repositories
```

You should see your `my-web-app` repository in the output.

---

## 📤 Task 3: Push a Docker Image to ECR

### 🌐 Subtask 3.1: Create a Sample Web Application

```bash
# 📁 Create a project directory
mkdir ~/my-web-app
cd ~/my-web-app
```

```html
<!-- 🖋️ Create a simple HTML file (index.html) -->
<!DOCTYPE html>
<html>
<head>
    <title>My ECR Web App</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        .container { max-width: 600px; margin: 0 auto; }
        h1 { color: #232F3E; }
        p { color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to My ECR Web Application</h1>
        <p>This application is running from a Docker image stored in Amazon ECR!</p>
        <p>Lab 47: Docker with AWS ECR</p>
    </div>
</body>
</html>
```

### 🐳 Subtask 3.2: Create a Dockerfile

```dockerfile
# 🖼️ Use official nginx image as base
FROM nginx:alpine

# 📋 Copy our HTML file to nginx html directory
COPY index.html /usr/share/nginx/html/

# 🌐 Expose port 80
EXPOSE 80

# ▶️ Start nginx
CMD ["nginx", "-g", "daemon off;"]

# TODO: Add a HEALTHCHECK instruction that curls localhost:80
```

### 🏗️ Subtask 3.3: Build the Docker Image

```bash
# 🏗️ Build the Docker image
docker build -t my-web-app .

# ✅ Verify the image was created
docker images | grep my-web-app

# 🧪 Test the image locally (optional)
docker run -d -p 8080:80 --name test-app my-web-app
curl http://localhost:8080
docker stop test-app
docker rm test-app
```

### 🏷️ Subtask 3.4: Tag the Image for ECR

```bash
# 🏷️ Tag your image with the ECR repository URI
docker tag my-web-app:latest <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:latest

# 🏷️ Also create a version tag
docker tag my-web-app:latest <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:v1.0

# ✅ Verify the tags
docker images | grep my-web-app
```

### 📤 Subtask 3.5: Push the Image to ECR

```bash
# 📤 Push the latest tag
docker push <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:latest

# 📤 Push the version tag
docker push <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:v1.0

# ✅ Verify the push was successful by checking the AWS ECR console or using CLI
aws ecr list-images --repository-name my-web-app
```

---

## 📥 Task 4: Pull the Image from ECR on a Different EC2 Instance

### 🔌 Subtask 4.1: Connect to Your Secondary EC2 Instance

```bash
# 🔌 Access your secondary EC2 instance terminal (provided in your lab environment)
# 🐳 Verify Docker is installed
docker --version
```

### ⚙️ Subtask 4.2: Configure AWS CLI on Secondary Instance

```bash
# 🛠️ Configure AWS CLI with the same credentials
aws configure

# ✅ Verify configuration
aws sts get-caller-identity
```

### 🔑 Subtask 4.3: Authenticate Docker with ECR

```bash
# 🔐 Authenticate Docker to ECR on this instance
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.us-east-1.amazonaws.com
```

### 📥 Subtask 4.4: Pull and Run the Image

```bash
# 📥 Pull the image from ECR
docker pull <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:latest

# ✅ Verify the image was pulled
docker images | grep my-web-app

# ▶️ Run the container
docker run -d -p 80:80 --name my-ecr-app <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:latest

# 🌐 Test the application
curl http://localhost

# 🔍 Check container status
docker ps

# TODO: Add a docker logs check here to confirm nginx started cleanly
```

### 🏷️ Subtask 4.5: Test Different Image Tags

```bash
# 📥 Pull the versioned image
docker pull <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:v1.0

# 🔍 Compare image details
docker inspect <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:latest
docker inspect <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:v1.0
```

---

## 🛡️ Task 5: Set up Automated Image Scanning for Vulnerabilities

### 🖱️ Subtask 5.1: Enable Image Scanning via AWS Console

1. Return to the AWS ECR console
2. Navigate to your `my-web-app` repository
3. Click on the repository name to view details
4. Go to the **Image scanning** tab
5. Click **Edit** and ensure **Scan on push** is enabled
6. Save the configuration

### ⚡ Subtask 5.2: Configure Enhanced Scanning (Optional)

1. In the ECR console, go to **Private registry settings**
2. Click on **Scanning configuration**
3. Enable **Enhanced scanning** for more comprehensive vulnerability detection
4. Configure scanning rules:
   - **Scan frequency:** Continuous scanning
   - **Scan filters:** All repositories or specific repositories

### 📤 Subtask 5.3: Push a New Image to Trigger Scanning

```bash
# 🔌 Return to your primary EC2 instance
cd ~/my-web-app
```

```html
<!-- ✏️ Make a small change to your application (index.html) -->
<!DOCTYPE html>
<html>
<head>
    <title>My ECR Web App - Updated</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        .container { max-width: 600px; margin: 0 auto; }
        h1 { color: #232F3E; }
        p { color: #666; }
        .update { color: #FF9900; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to My ECR Web Application</h1>
        <p>This application is running from a Docker image stored in Amazon ECR!</p>
        <p class="update">Updated version with vulnerability scanning enabled!</p>
        <p>Lab 47: Docker with AWS ECR</p>
    </div>
</body>
</html>
```

```bash
# 🏗️ Build and push the updated image
docker build -t my-web-app:v2.0 .
docker tag my-web-app:v2.0 <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:v2.0
docker push <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:v2.0
```

### 📊 Subtask 5.4: View Scanning Results

1. In the ECR console, navigate to your repository
2. Click on the **Images** tab
3. Wait for the scan to complete (this may take a few minutes)
4. View the scan results by clicking on the image digest
5. Review any vulnerabilities found and their severity levels

### 🔍 Subtask 5.5: Use CLI to Check Scan Results

```bash
# 📋 List images with scan status
aws ecr describe-images --repository-name my-web-app

# 🔍 Get detailed scan results
aws ecr describe-image-scan-findings --repository-name my-web-app --image-id imageTag=v2.0

# ⚠️ Filter for high-severity vulnerabilities
aws ecr describe-image-scan-findings --repository-name my-web-app --image-id imageTag=v2.0 --query 'imageScanFindings.findings[?severity==`HIGH`]'

# TODO: Pipe the HIGH-severity findings into a report file for the security team
```

---

## ⚙️ Additional ECR Management Tasks

### 📜 Managing Repository Policies

```json
// 🔐 Create a repository policy for controlled access (ecr-policy.json)
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPushPull",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<your-account-id>:root"
      },
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ]
    }
  ]
}
```

```bash
# ✅ Apply the policy
aws ecr set-repository-policy --repository-name my-web-app --policy-text file://ecr-policy.json
```

### ♻️ Lifecycle Policies

```json
// ♻️ Create a lifecycle policy to manage image retention (lifecycle-policy.json)
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
```

```bash
# ✅ Apply the lifecycle policy
aws ecr put-lifecycle-policy --repository-name my-web-app --lifecycle-policy-text file://lifecycle-policy.json

# TODO: Adjust countNumber to match your team's rollback window
```

---

## 🔧 Troubleshooting Common Issues

<details>
<summary>❗ Authentication Issues</summary>

**Problem:** Docker login fails with authentication error

```bash
# ✅ Ensure AWS CLI is properly configured
aws configure list

# 🔐 Re-authenticate with ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
```

</details>

<details>
<summary>❗ Push/Pull Issues</summary>

**Problem:** Image push fails with "repository does not exist" error

```bash
# 🔍 Verify repository exists
aws ecr describe-repositories --repository-names my-web-app

# 🔍 Check repository URI format
aws ecr describe-repositories --repository-names my-web-app --query 'repositories[0].repositoryUri'
```

</details>

<details>
<summary>❗ Permission Issues</summary>

**Problem:** Access denied when performing ECR operations

```bash
# 🔍 Check current IAM identity
aws sts get-caller-identity

# 🔍 Verify ECR permissions
aws iam list-attached-user-policies --user-name <your-username>
```

</details>

---

## 🌟 Best Practices for ECR

### 🛡️ Security Best Practices

| Practice | Description |
|----------|--------------|
| 🔒 Use Private Repositories | Always use private repositories for proprietary applications |
| 🔍 Enable Image Scanning | Always enable vulnerability scanning for production images |
| 🔑 Implement Least Privilege | Use IAM policies to grant minimal required permissions |
| 🏷️ Use Image Tags Wisely | Implement consistent tagging strategies (semantic versioning) |

### ⚙️ Operational Best Practices

| Practice | Description |
|----------|--------------|
| ♻️ Lifecycle Policies | Implement lifecycle policies to manage storage costs |
| 🌍 Multi-Region Replication | Consider cross-region replication for disaster recovery |
| 📊 Monitoring | Set up CloudWatch alarms for repository metrics |
| 🔄 Automation | Use CI/CD pipelines for automated image builds and pushes |

---

## 🧹 Cleanup

### 🗑️ Remove Local Docker Images

```bash
# 🗑️ Remove local images
docker rmi my-web-app:latest
docker rmi my-web-app:v2.0
docker rmi <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:latest
docker rmi <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:v1.0
docker rmi <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-web-app:v2.0

# ⏹️ Stop and remove containers
docker stop my-ecr-app
docker rm my-ecr-app
```

### ☁️ Clean Up AWS Resources

```bash
# 🗑️ Delete images from ECR repository
aws ecr batch-delete-image --repository-name my-web-app --image-ids imageTag=latest
aws ecr batch-delete-image --repository-name my-web-app --image-ids imageTag=v1.0
aws ecr batch-delete-image --repository-name my-web-app --image-ids imageTag=v2.0

# 🗑️ Delete the repository (optional)
aws ecr delete-repository --repository-name my-web-app --force
```

---

## 🏁 Conclusion

Congratulations! 🎉 You have successfully completed **Lab 47: Docker with AWS ECR**. In this comprehensive lab, you have accomplished the following:

### 🏆 Key Achievements

| ✅ | Achievement |
|----|-------------|
| 🗄️ | **ECR Repository Management** — created and configured a private ECR repository with proper settings for security and scanning |
| 🔐 | **Docker Authentication** — successfully authenticated Docker with ECR using AWS CLI across multiple instances |
| 🔁 | **Image Lifecycle Management** — built, tagged, pushed, and pulled Docker images using ECR as your container registry |
| 🖥️ | **Cross-Instance Deployment** — demonstrated the portability of containerized applications by pulling and running images on different EC2 instances |
| 🛡️ | **Security Implementation** — configured automated vulnerability scanning to identify potential security issues in your container images |
| 🌟 | **Best Practices** — learned industry-standard practices for container registry management, including lifecycle policies and access controls |

### 💡 Why This Matters

Amazon ECR provides a secure, scalable, and reliable container registry service that integrates seamlessly with other AWS services. The skills you've developed in this lab are essential for:

- 🏭 **Production Container Deployments** — ECR serves as the foundation for container-based applications in AWS
- 🔄 **DevOps Workflows** — ECR integrates with CI/CD pipelines for automated application deployment
- 🛡️ **Security Compliance** — automated vulnerability scanning helps maintain security standards in production environments
- 💰 **Cost Optimization** — lifecycle policies and efficient image management reduce storage costs
- 🌍 **Multi-Environment Deployments** — the ability to pull images across different instances enables consistent deployments

### 🔭 Next Steps

- ☸️ Explore integration with Amazon ECS and EKS for container orchestration
- 🔄 Implement automated CI/CD pipelines using AWS CodePipeline and CodeBuild
- 🌍 Learn about ECR cross-region replication for disaster recovery scenarios
- 🔑 Study advanced IAM policies for fine-grained access control

This lab has provided you with practical, hands-on experience with Amazon ECR that directly applies to real-world container management scenarios. The knowledge gained here forms a solid foundation for pursuing **Docker Certified Associate (DCA)** certification and advancing your containerization expertise.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
