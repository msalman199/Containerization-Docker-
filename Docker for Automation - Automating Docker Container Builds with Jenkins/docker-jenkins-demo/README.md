<div align="center">

# 🤖 Docker for Automation - Automating Docker Container Builds with Jenkins

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![SonarQube](https://img.shields.io/badge/SonarQube-4E9BCD?style=for-the-badge&logo=sonarqube&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Docker Hub](https://img.shields.io/badge/Docker%20Hub-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-1904DA?style=for-the-badge&logo=aqua&logoColor=white)

**Lab 66 — Building a full Docker-Jenkins DevOps pipeline with quality gates, security scanning, and automated deployment**

</div>

---

## 📑 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [📋 Prerequisites](#-prerequisites)
- [☁️ Lab Environment Setup](#️-lab-environment-setup)
- [🐳 Task 1: Install Docker inside Jenkins and Configure Docker Plugin](#-task-1-install-docker-inside-jenkins-and-configure-docker-plugin)
- [⚙️ Task 2: Set up Jenkins Pipeline to Build Docker Images and Push to Docker Hub](#️-task-2-set-up-jenkins-pipeline-to-build-docker-images-and-push-to-docker-hub)
- [🔍 Task 3: Integrate Static Code Analysis with SonarQube](#-task-3-integrate-static-code-analysis-with-sonarqube)
- [☁️ Task 4: Configure Jenkins to Deploy Docker Containers to Cloud Service](#️-task-4-configure-jenkins-to-deploy-docker-containers-to-cloud-service)
- [🧪 Task 5: Automate Tests in CI/CD Pipeline with Docker Containers](#-task-5-automate-tests-in-cicd-pipeline-with-docker-containers)
- [✔️ Testing and Validation](#️-testing-and-validation)
- [🩹 Troubleshooting Common Issues](#-troubleshooting-common-issues)
- [✅ Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | 🐳 Install and configure Docker within Jenkins environment |
| 2 | ⚙️ Set up Jenkins pipelines to automate Docker image builds |
| 3 | 📦 Push Docker images to Docker Hub registry |
| 4 | 🔍 Integrate static code analysis using SonarQube in CI/CD pipelines |
| 5 | ☁️ Deploy Docker containers to cloud services |
| 6 | 🧪 Implement automated testing within Docker-based CI/CD workflows |
| 7 | 🔗 Understand the complete DevOps workflow using Docker and Jenkins |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker Basics | Basic understanding of Docker concepts (containers, images, Dockerfile) |
| ⚙️ Jenkins Fundamentals | Familiarity with Jenkins fundamentals |
| 💻 Linux CLI | Basic knowledge of Linux command line |
| 🔄 CI/CD Concepts | Understanding of CI/CD concepts |
| 🔑 GitHub Account | For source code management |
| 🔑 Docker Hub Account | For image registry |

## ☁️ Lab Environment Setup

> **💡 Note:** Al Nafi provides pre-configured Linux-based cloud machines with all necessary tools installed. Simply click **Start Lab** to access your environment — no need to build your own VM or install software locally.

Your lab environment includes:

- 🖥️ Ubuntu 20.04 LTS with Docker pre-installed
- ⚙️ Jenkins server ready to configure
- 🔀 Git and other development tools
- 🌐 Network access to Docker Hub and cloud services

---

## 🐳 Task 1: Install Docker inside Jenkins and Configure Docker Plugin

### 🔹 Subtask 1.1: Verify Docker Installation

```bash
# 🔎 Check Docker version
docker --version

# 🩺 Check Docker service status
sudo systemctl status docker

# ✅ Test Docker installation
docker run hello-world
```

### 🔹 Subtask 1.2: Install Jenkins Docker Plugin

1. 🌐 Access Jenkins web interface by opening your browser and navigating to `http://localhost:8080`
2. 🔑 Log in with your Jenkins credentials
3. 🧭 Navigate to **Manage Jenkins → Manage Plugins**
4. 🔎 Click on the **Available** tab and search for `"Docker"`
5. 📥 Install the following plugins:
   - Docker Pipeline
   - Docker plugin
   - Docker Commons Plugin

```bash
# ♻️ Restart Jenkins after installation
sudo systemctl restart jenkins
```

### 🔹 Subtask 1.3: Configure Docker in Jenkins

1. 🧭 Go to **Manage Jenkins → Global Tool Configuration**
2. 🔽 Scroll down to the **Docker** section
3. ➕ Click **Add Docker** and configure:
   - Name: `docker`
   - Installation root: `/usr/bin/docker`
   - Check **Install automatically** if needed
4. 💾 Save the configuration

### 🔹 Subtask 1.4: Add Jenkins User to Docker Group

```bash
# 👤 Add jenkins user to docker group
sudo usermod -aG docker jenkins

# ♻️ Restart Jenkins service
sudo systemctl restart jenkins

# ✅ Verify jenkins user can run docker commands
sudo -u jenkins docker ps
```

> **📌 TODO:** Confirm the `jenkins` user's Docker access persists after a full VM reboot, not just a service restart.

---

## ⚙️ Task 2: Set up Jenkins Pipeline to Build Docker Images and Push to Docker Hub

### 🔹 Subtask 2.1: Create Sample Application

```bash
# 📁 Create project directory
mkdir ~/docker-jenkins-demo
cd ~/docker-jenkins-demo

# 📦 Create package.json
cat > package.json << EOF
{
  "name": "docker-jenkins-demo",
  "version": "1.0.0",
  "description": "Demo app for Docker Jenkins pipeline",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "test": "echo \"Running tests...\" && exit 0"
  },
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF

# 🐍➡️🟢 Create app.js
cat > app.js << EOF
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.json({
    message: 'Hello from Docker Jenkins Pipeline!',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.listen(port, () => {
  console.log(\`App listening at http://localhost:\${port}\`);
});
EOF

# 🐳 Create Dockerfile
cat > Dockerfile << EOF
FROM node:16-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
EOF
```

### 🔹 Subtask 2.2: Create Jenkinsfile

**📝 Create a comprehensive Jenkins pipeline file:**

```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        IMAGE_NAME = 'your-dockerhub-username/docker-jenkins-demo'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Application') {
            steps {
                script {
                    echo 'Building Node.js application...'
                    sh 'npm install'
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    echo 'Running application tests...'
                    sh 'npm test'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    def image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo 'Pushing image to Docker Hub...'
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        def image = docker.image("${IMAGE_NAME}:${IMAGE_TAG}")
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }
        
        stage('Clean Up') {
            steps {
                script {
                    echo 'Cleaning up local images...'
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
                    sh "docker rmi ${IMAGE_NAME}:latest || true"
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed!'
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
```

### 🔹 Subtask 2.3: Configure Docker Hub Credentials in Jenkins

1. 🧭 In Jenkins, go to **Manage Jenkins → Manage Credentials**
2. 🌐 Click on **(global)** domain
3. ➕ Click **Add Credentials**
4. ⚙️ Configure the credential:
   - Kind: `Username with password`
   - Username: Your Docker Hub username
   - Password: Your Docker Hub password or access token
   - ID: `docker-hub-credentials`
   - Description: `Docker Hub Credentials`
5. 💾 Click **OK** to save

### 🔹 Subtask 2.4: Create Jenkins Pipeline Job

1. 🆕 In Jenkins dashboard, click **New Item**
2. ✍️ Enter job name: `docker-jenkins-pipeline`
3. 🔘 Select **Pipeline** and click **OK**
4. ⚙️ In the pipeline configuration:
   - Description: `Docker Jenkins automation pipeline`
   - Pipeline Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: Your Git repository URL
   - Script Path: `Jenkinsfile`
5. 💾 Save the configuration

---

## 🔍 Task 3: Integrate Static Code Analysis with SonarQube

### 🔹 Subtask 3.1: Set up SonarQube with Docker

```bash
# 📁 Create SonarQube directory
mkdir ~/sonarqube-data
chmod 777 ~/sonarqube-data

# 🚀 Run SonarQube container
docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  -v ~/sonarqube-data:/opt/sonarqube/data \
  sonarqube:community

# ⏳ Wait for SonarQube to start
echo "Waiting for SonarQube to start..."
sleep 60

# 🩺 Check SonarQube status
curl -f http://localhost:9000/api/system/status
```

### 🔹 Subtask 3.2: Configure SonarQube

1. 🌐 Access SonarQube at `http://localhost:9000`
2. 🔑 Login with default credentials:
   - Username: `admin`
   - Password: `admin`
3. 🔐 Change the default password when prompted
4. 🆕 Create a new project:
   - Project key: `docker-jenkins-demo`
   - Display name: `Docker Jenkins Demo`
5. 🎟️ Generate a token for Jenkins integration:
   - Go to **My Account → Security**
   - Generate token named `jenkins-integration`
   - Copy the token for later use

### 🔹 Subtask 3.3: Install SonarQube Scanner in Jenkins

1. 🧭 Go to **Manage Jenkins → Manage Plugins**
2. 📥 Install **SonarQube Scanner** plugin
3. 🧭 Go to **Manage Jenkins → Global Tool Configuration**
4. ➕ Add SonarQube Scanner:
   - Name: `sonar-scanner`
   - Check **Install automatically**
5. 🧭 Go to **Manage Jenkins → Configure System**
6. ➕ Add SonarQube server:
   - Name: `sonarqube`
   - Server URL: `http://localhost:9000`
   - Server authentication token: Add credential with SonarQube token

### 🔹 Subtask 3.4: Update Jenkinsfile with SonarQube Integration

```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        SONAR_TOKEN = credentials('sonarqube-token')
        IMAGE_NAME = 'your-dockerhub-username/docker-jenkins-demo'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Application') {
            steps {
                script {
                    echo 'Building Node.js application...'
                    sh 'npm install'
                }
            }
        }
        
        stage('Static Code Analysis') {
            steps {
                script {
                    echo 'Running SonarQube analysis...'
                    withSonarQubeEnv('sonarqube') {
                        sh '''
                            sonar-scanner \
                            -Dsonar.projectKey=docker-jenkins-demo \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.login=${SONAR_TOKEN}
                        '''
                    }
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                script {
                    echo 'Waiting for Quality Gate...'
                    timeout(time: 5, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    echo 'Running application tests...'
                    sh 'npm test'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    def image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    echo 'Scanning Docker image for vulnerabilities...'
                    sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo 'Pushing image to Docker Hub...'
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        def image = docker.image("${IMAGE_NAME}:${IMAGE_TAG}")
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }
        
        stage('Clean Up') {
            steps {
                script {
                    echo 'Cleaning up local images...'
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
                    sh "docker rmi ${IMAGE_NAME}:latest || true"
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed!'
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
```

---

## ☁️ Task 4: Configure Jenkins to Deploy Docker Containers to Cloud Service

### 🔹 Subtask 4.1: Set up Docker Compose for Deployment

**📝 Create a Docker Compose file for deployment:**

```yaml
version: '3.8'

services:
  app:
    image: your-dockerhub-username/docker-jenkins-demo:latest
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - app
    restart: unless-stopped

networks:
  default:
    driver: bridge
```

**📝 Create nginx configuration:**

```nginx
events {
    worker_connections 1024;
}

http {
    upstream app {
        server app:3000;
    }

    server {
        listen 80;
        
        location / {
            proxy_pass http://app;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
        
        location /health {
            proxy_pass http://app/health;
        }
    }
}
```

### 🔹 Subtask 4.2: Create Deployment Script

```bash
#!/bin/bash

set -e

echo "Starting deployment process..."

# 📥 Pull latest images
docker-compose pull

# 🛑 Stop existing containers
docker-compose down

# 🚀 Start new containers
docker-compose up -d

# ⏳ Wait for services to be healthy
echo "Waiting for services to be ready..."
sleep 30

# 🩺 Check application health
if curl -f http://localhost/health; then
    echo "Deployment successful!"
    echo "Application is running at http://localhost"
else
    echo "Deployment failed - health check failed"
    exit 1
fi

# 🧹 Clean up unused images
docker image prune -f

echo "Deployment completed successfully!"
```

```bash
# 🔐 Make the script executable
chmod +x deploy.sh
```

### 🔹 Subtask 4.3: Update Jenkinsfile with Deployment Stage

```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        SONAR_TOKEN = credentials('sonarqube-token')
        IMAGE_NAME = 'your-dockerhub-username/docker-jenkins-demo'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Application') {
            steps {
                script {
                    echo 'Building Node.js application...'
                    sh 'npm install'
                }
            }
        }
        
        stage('Static Code Analysis') {
            steps {
                script {
                    echo 'Running SonarQube analysis...'
                    withSonarQubeEnv('sonarqube') {
                        sh '''
                            sonar-scanner \
                            -Dsonar.projectKey=docker-jenkins-demo \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.login=${SONAR_TOKEN}
                        '''
                    }
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                script {
                    echo 'Waiting for Quality Gate...'
                    timeout(time: 5, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    echo 'Running application tests...'
                    sh 'npm test'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    def image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    echo 'Scanning Docker image for vulnerabilities...'
                    sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo 'Pushing image to Docker Hub...'
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        def image = docker.image("${IMAGE_NAME}:${IMAGE_TAG}")
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }
        
        stage('Deploy to Staging') {
            steps {
                script {
                    echo 'Deploying to staging environment...'
                    sh './deploy.sh'
                }
            }
        }
        
        stage('Integration Tests') {
            steps {
                script {
                    echo 'Running integration tests...'
                    sh '''
                        # Wait for application to be ready
                        sleep 10
                        
                        # Test application endpoints
                        curl -f http://localhost/health
                        curl -f http://localhost/ | grep "Hello from Docker"
                        
                        echo "Integration tests passed!"
                    '''
                }
            }
        }
        
        stage('Clean Up') {
            steps {
                script {
                    echo 'Cleaning up local images...'
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed!'
        }
        success {
            echo 'Pipeline succeeded!'
            echo 'Application deployed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
            sh 'docker-compose logs || true'
        }
    }
}
```

> **📌 TODO:** Parameterize `IMAGE_NAME` and the deployment target host so this Jenkinsfile can be reused across staging and production jobs without editing the file.

---

## 🧪 Task 5: Automate Tests in CI/CD Pipeline with Docker Containers

### 🔹 Subtask 5.1: Create Test Suite

```bash
# 📁 Create test directory
mkdir tests

# 🧪 Create unit tests
cat > tests/unit.test.js << EOF
const request = require('supertest');
const express = require('express');

// Mock the app
const app = express();
app.get('/', (req, res) => {
  res.json({
    message: 'Hello from Docker Jenkins Pipeline!',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

describe('Application Tests', () => {
  test('GET / should return welcome message', async () => {
    const response = await request(app).get('/');
    expect(response.status).toBe(200);
    expect(response.body.message).toBe('Hello from Docker Jenkins Pipeline!');
    expect(response.body.version).toBe('1.0.0');
  });

  test('GET /health should return healthy status', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('healthy');
  });
});
EOF

# 🔗 Create integration tests
cat > tests/integration.test.js << EOF
const axios = require('axios');

const BASE_URL = process.env.TEST_URL || 'http://localhost:3000';

describe('Integration Tests', () => {
  test('Application should be accessible', async () => {
    const response = await axios.get(BASE_URL);
    expect(response.status).toBe(200);
    expect(response.data.message).toContain('Hello from Docker');
  });

  test('Health endpoint should work', async () => {
    const response = await axios.get(\`\${BASE_URL}/health\`);
    expect(response.status).toBe(200);
    expect(response.data.status).toBe('healthy');
  });
});
EOF

# 📦 Update package.json with test dependencies
cat > package.json << EOF
{
  "name": "docker-jenkins-demo",
  "version": "1.0.0",
  "description": "Demo app for Docker Jenkins pipeline",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "test": "jest --testTimeout=10000",
    "test:unit": "jest tests/unit.test.js",
    "test:integration": "jest tests/integration.test.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "jest": "^29.0.0",
    "supertest": "^6.3.0",
    "axios": "^1.0.0"
  },
  "jest": {
    "testEnvironment": "node"
  }
}
EOF
```

### 🔹 Subtask 5.2: Create Test Docker Containers

```bash
# 🐳 Create test Dockerfile
cat > Dockerfile.test << EOF
FROM node:16-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source code and tests
COPY . .

# Run tests
CMD ["npm", "test"]
EOF

# 🧩 Create Docker Compose for testing
cat > docker-compose.test.yml << EOF
version: '3.8'

services:
  app-test:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3001:3000"
    environment:
      - NODE_ENV=test
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 10s

  unit-tests:
    build:
      context: .
      dockerfile: Dockerfile.test
    command: npm run test:unit
    volumes:
      - .:/app
      - /app/node_modules

  integration-tests:
    build:
      context: .
      dockerfile: Dockerfile.test
    command: npm run test:integration
    environment:
      - TEST_URL=http://app-test:3000
    depends_on:
      app-test:
        condition: service_healthy
    volumes:
      - .:/app
      - /app/node_modules
EOF
```

### 🔹 Subtask 5.3: Final Jenkinsfile with Complete Testing

```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        SONAR_TOKEN = credentials('sonarqube-token')
        IMAGE_NAME = 'your-dockerhub-username/docker-jenkins-demo'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Application') {
            steps {
                script {
                    echo 'Building Node.js application...'
                    sh 'npm install'
                }
            }
        }
        
        stage('Unit Tests') {
            steps {
                script {
                    echo 'Running unit tests in Docker container...'
                    sh 'docker-compose -f docker-compose.test.yml run --rm unit-tests'
                }
            }
        }
        
        stage('Static Code Analysis') {
            steps {
                script {
                    echo 'Running SonarQube analysis...'
                    withSonarQubeEnv('sonarqube') {
                        sh '''
                            sonar-scanner \
                            -Dsonar.projectKey=docker-jenkins-demo \
                            -Dsonar.sources=. \
                            -Dsonar.exclusions=node_modules/**,tests/** \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.login=${SONAR_TOKEN}
                        '''
                    }
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                script {
                    echo 'Waiting for Quality Gate...'
                    timeout(time: 5, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    def image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    echo 'Scanning Docker image for vulnerabilities...'
                    sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
        
        stage('Integration Tests') {
            steps {
                script {
                    echo 'Running integration tests...'
                    sh 'docker-compose -f docker-compose.test.yml up -d app-test'
                    sh 'sleep 30' // Wait for app to be ready
                    sh 'docker-compose -f docker-compose.test.yml run --rm integration-tests'
                }
            }
            post {
                always {
                    sh 'docker-compose -f docker-compose.test.yml down || true'
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo 'Pushing image to Docker Hub...'
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        def image = docker.image("${IMAGE_NAME}:${IMAGE_TAG}")
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }
        
        stage('Deploy to Staging') {
            steps {
                script {
                    echo 'Deploying to staging environment...'
                    sh './deploy.sh'
                }
            }
        }
        
        stage('Smoke Tests') {
            steps {
                script {
                    echo 'Running smoke tests on deployed application...'
                    sh '''
                        # Wait for deployment to complete
                        sleep 20
                        
                        # Run smoke tests
                        curl -f http://localhost/health
                        curl -f http://localhost/ | grep "Hello from Docker"
                        
                        # Test response time
                        response_time=$(curl -o /dev/null -s -w '%{time_total}' http://localhost/)
                        echo "Response time: ${response_time}s"
                        
                        echo "Smoke tests passed!"
                    '''
                }
            }
        }
        
        stage('Performance Tests') {
            steps {
                script {
                    echo 'Running performance tests...'
                    sh '''
                        # Install Apache Bench if not available
                        which ab || sudo apt-get update && sudo apt-get install -y apache2-utils
                        
                        # Run performance test
                        ab -n 100 -c 10 http://localhost/ > performance_results.txt
                        cat performance_results.txt
                        
                        echo "Performance tests completed!"
                    '''
                }
            }
        }
        
        stage('Clean Up') {
            steps {
                script {
                    echo 'Cleaning up local images...'
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
                    sh 'docker system prune -f'
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed!'
            archiveArtifacts artifacts: 'performance_results.txt', allowEmptyArchive: true
        }
        success {
            echo 'Pipeline succeeded!'
            echo 'Application deployed and tested successfully!'
            emailext (
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Good news! The pipeline succeeded. Application is deployed and running.",
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
        failure {
            echo 'Pipeline failed!'
            sh 'docker-compose logs || true'
            emailext (
                subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Bad news! The pipeline failed. Please check the logs.",
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
    }
}
```

### 🔹 Subtask 5.4: Create Git Repository and Push Code

```bash
# 🔀 Initialize git repository
git init
git add .
git commit -m "Initial commit: Docker Jenkins automation pipeline"

# 🔗 Add remote repository (replace with your GitHub repo URL)
git remote add origin https://github.com/your-username/docker-jenkins-demo.git
git branch -M main
git push -u origin main
```

> **📌 TODO:** Add a `.gitignore` excluding `node_modules/` and `performance_results.txt` before the first push.

---

## ✔️ Testing and Validation

**🔍 Verify Pipeline Execution:**

| Step | Action |
|---|---|
| 1️⃣ | 🚀 **Trigger Pipeline** — Go to Jenkins and run your pipeline job |
| 2️⃣ | 👀 **Monitor Stages** — Watch each stage execute in the Jenkins Blue Ocean interface |
| 3️⃣ | 📜 **Check Logs** — Review console output for each stage |
| 4️⃣ | ✅ **Verify Deployment** — Access your application at `http://localhost` |
| 5️⃣ | 📦 **Check Docker Hub** — Verify images are pushed to your Docker Hub repository |

---

## 🩹 Troubleshooting Common Issues

<details>
<summary><strong>❌ Docker Permission Issues</strong></summary>

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```
</details>

<details>
<summary><strong>❌ SonarQube Connection Issues</strong></summary>

```bash
# 🔎 Check SonarQube status
docker logs sonarqube
curl http://localhost:9000/api/system/status
```
</details>

<details>
<summary><strong>❌ Pipeline Failures</strong></summary>

- 🔎 Check Jenkins console logs
- 🔑 Verify all credentials are properly configured
- 🐳 Ensure Docker Hub username is correct in Jenkinsfile
- 🌐 Check network connectivity to external services
</details>

---

## ✅ Conclusion

Congratulations! You have successfully completed **Lab 66: Docker for Automation**. In this comprehensive lab, you have accomplished the following:

### 🏆 Key Achievements

- 🔗 **Docker-Jenkins Integration** — Successfully installed and configured Docker within Jenkins, enabling containerized CI/CD workflows
- ⚙️ **Automated Pipeline Creation** — Built a complete Jenkins pipeline that automatically builds Docker images and pushes them to Docker Hub registry
- 🔍 **Quality Assurance Integration** — Integrated SonarQube for static code analysis and implemented quality gates to ensure code quality standards
- ☁️ **Cloud Deployment Automation** — Configured automated deployment of Docker containers with health checks and monitoring
- 🧪 **Comprehensive Testing Strategy** — Implemented multiple testing layers including unit tests, integration tests, smoke tests, and performance tests, all running in Docker containers

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E3A8A?style=for-the-badge)

</div>
