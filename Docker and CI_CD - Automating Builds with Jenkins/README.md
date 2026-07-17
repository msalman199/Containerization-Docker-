<div align="center">

# 🔁 Docker and CI/CD
### Automating Builds with Jenkins, Docker & SonarQube

![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![SonarQube](https://img.shields.io/badge/SonarQube-4E9BCD?style=for-the-badge&logo=sonarqube&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-16-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04%20LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Level](https://img.shields.io/badge/Level-Intermediate-orange?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🧩 Technology Stack](#-technology-stack)
- [⚙️ Task 1: Install Jenkins on Linux Machine](#️-task-1-install-jenkins-on-linux-machine)
- [🐳 Task 2: Configure Jenkins to Use Docker for Building Images](#-task-2-configure-jenkins-to-use-docker-for-building-images)
- [🏗️ Task 3: Create a Jenkins Pipeline for Docker Image Building and Testing](#️-task-3-create-a-jenkins-pipeline-for-docker-image-building-and-testing)
- [🔍 Task 4: Integrate SonarQube for Static Code Analysis](#-task-4-integrate-sonarqube-for-static-code-analysis)
- [🔔 Task 5: Trigger Pipeline on Code Changes and View Build Results](#-task-5-trigger-pipeline-on-code-changes-and-view-build-results)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🔒 Best Practices Implemented](#-best-practices-implemented)
- [🎓 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | ⚙️ Install and configure Jenkins on a Linux machine |
| 2 | 🐳 Set up Docker integration with Jenkins for automated builds |
| 3 | 🏗️ Create and configure Jenkins pipelines for Docker image building and testing |
| 4 | 🔍 Integrate SonarQube for static code analysis in CI/CD pipelines |
| 5 | 🔔 Implement automated pipeline triggers based on code changes |
| 6 | 📊 Monitor and analyze build results in the Jenkins dashboard |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| ⌨️ Linux CLI | Basic understanding of Linux command line operations |
| 🐳 Docker basics | Familiarity with Docker concepts and basic commands |
| 🔀 Version control | Understanding of version control systems (Git) |
| 🔁 SDLC knowledge | Basic knowledge of the software development lifecycle |
| 📄 YAML syntax | Familiarity with YAML syntax for pipeline configuration |

---

## 🖥️ Lab Environment Setup

> **☁️ Ready-to-Use Cloud Machines**
> Al Nafi provides pre-configured Linux-based cloud machines for this lab. Simply click **Start Lab** to access your environment — no need to build your own VM or install an operating system.

Your lab environment includes:

- ✅ Ubuntu 20.04 LTS with Docker pre-installed
- ✅ Internet connectivity for downloading packages
- ✅ Sufficient resources for running Jenkins and SonarQube
- ✅ Git client pre-installed

---

## 🧩 Technology Stack

<div align="center">

| Technology | Role in This Lab |
|---|---|
| ![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=flat-square&logo=jenkins&logoColor=white) | Automation server orchestrating the CI/CD pipeline |
| ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white) | Builds, tests, and runs the containerized application |
| ![SonarQube](https://img.shields.io/badge/SonarQube-4E9BCD?style=flat-square&logo=sonarqube&logoColor=white) | Static code analysis and quality gate enforcement |
| ![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=node.js&logoColor=white) | Runtime for the sample Express application |
| ![Git](https://img.shields.io/badge/Git-F05032?style=flat-square&logo=git&logoColor=white) | Version control and pipeline trigger source |
| ![OpenJDK](https://img.shields.io/badge/OpenJDK%2011-ED8B00?style=flat-square&logo=openjdk&logoColor=white) | Runtime required by Jenkins |

</div>

---

## ⚙️ Task 1: Install Jenkins on Linux Machine

### ☕ Subtask 1.1: Update System and Install Java

Jenkins requires Java to run. Start by updating the system and installing OpenJDK.

```bash
# 🔄 Update package repository
sudo apt update

# ☕ Install OpenJDK 11 (required for Jenkins)
sudo apt install -y openjdk-11-jdk

# ✅ Verify Java installation
java -version
```

### 📦 Subtask 1.2: Add Jenkins Repository and Install Jenkins

```bash
# 🔑 Add Jenkins repository key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# 📋 Add Jenkins repository to sources list
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# 🔄 Update package repository
sudo apt update

# 📥 Install Jenkins
sudo apt install -y jenkins
```

### ▶️ Subtask 1.3: Start and Enable Jenkins Service

```bash
# ▶️ Start Jenkins service
sudo systemctl start jenkins

# 🔁 Enable Jenkins to start on boot
sudo systemctl enable jenkins

# ✅ Check Jenkins service status
sudo systemctl status jenkins
```

### 🔧 Subtask 1.4: Configure Jenkins Initial Setup

```bash
# 🔑 Get the initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

> 📝 **Note:** Copy this password — you'll need it for the web setup.

Open your browser and navigate to `http://localhost:8080` (or your server's IP address with port 8080):

1. 🔑 Enter the initial admin password you copied
2. 📦 Click **Install suggested plugins**
3. 👤 Create your first admin user:
   - Username: `admin`
   - Password: `admin123` <!-- TODO: replace with a strong, unique password outside of this lab environment -->
   - Full name: `Jenkins Administrator`
   - Email: `admin@example.com`
4. 🌐 Keep the default Jenkins URL
5. ✅ Click **Start using Jenkins**

---

## 🐳 Task 2: Configure Jenkins to Use Docker for Building Images

### 🔌 Subtask 2.1: Install Docker Plugin in Jenkins

1. In the Jenkins dashboard, go to **Manage Jenkins → Manage Plugins**
2. Click the **Available** tab
3. Search for **Docker** and install:
   - 🐳 Docker Pipeline
   - 🐳 Docker plugin
   - 🐳 Docker Commons Plugin
4. Click **Install without restart**
5. ✅ Check **Restart Jenkins when installation is complete**

### 👤 Subtask 2.2: Add Jenkins User to Docker Group

```bash
# 👤 Add jenkins user to docker group
sudo usermod -aG docker jenkins

# 🔁 Restart Jenkins service to apply changes
sudo systemctl restart jenkins

# ✅ Verify docker access for jenkins user
sudo -u jenkins docker ps
```

### 🛠️ Subtask 2.3: Configure Docker in Jenkins Global Tool Configuration

1. Go to **Manage Jenkins → Global Tool Configuration**
2. Scroll to the **Docker** section
3. Click **Add Docker**
4. Configure:
   - Name: `docker`
   - Installation root: `/usr/bin/docker`
5. ✅ Check **Install automatically** and select **Download from docker.com**
6. 💾 Click **Save**

---

## 🏗️ Task 3: Create a Jenkins Pipeline for Docker Image Building and Testing

### 📱 Subtask 3.1: Create Sample Application

```bash
# 📂 Create project directory
mkdir -p /home/ubuntu/sample-app
cd /home/ubuntu/sample-app

# 📄 Create package.json
cat > package.json << 'EOF'
{
  "name": "sample-node-app",
  "version": "1.0.0",
  "description": "Sample Node.js application for Jenkins CI/CD",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "test": "echo 'Running tests...' && exit 0"
  },
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF
```

```javascript
// app.js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.json({
    message: 'Hello from Docker CI/CD Pipeline!',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.listen(port, () => {
  console.log(`App running on port ${port}`);
});

module.exports = app;
```

```dockerfile
# 🐳 Dockerfile
FROM node:16-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
```

```text
# 🚫 .dockerignore
node_modules
npm-debug.log
.git
.gitignore
README.md
Dockerfile
.dockerignore
```

### 🔀 Subtask 3.2: Initialize Git Repository

```bash
# 🔀 Initialize git repository
git init

# 🚫 Create .gitignore
cat > .gitignore << 'EOF'
node_modules/
npm-debug.log*
.env
EOF

# ➕ Add files to git
git add .
git commit -m "Initial commit: Sample Node.js application"
```

### 🧱 Subtask 3.3: Create Jenkins Pipeline Job

1. In the Jenkins dashboard, click **New Item**
2. Enter item name: `docker-pipeline-demo`
3. Select **Pipeline** and click **OK**
4. Scroll to the **Pipeline** section and select **Pipeline script**, then enter:

```groovy
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'sample-node-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // 📥 For this demo, we'll copy files from local directory
                    sh '''
                        rm -rf workspace-temp
                        mkdir -p workspace-temp
                        cp -r /home/ubuntu/sample-app/* workspace-temp/
                        ls -la workspace-temp/
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir('workspace-temp') {
                        sh '''
                            echo "Building Docker image..."
                            docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                            docker build -t ${DOCKER_IMAGE}:latest .
                        '''
                    }
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    sh '''
                        echo "Testing Docker image..."
                        # ▶️ Run container in detached mode
                        docker run -d --name test-container-${BUILD_NUMBER} -p 3001:3000 ${DOCKER_IMAGE}:${DOCKER_TAG}

                        # ⏳ Wait for container to start
                        sleep 10

                        # ❤️ Test health endpoint
                        curl -f http://localhost:3001/health || exit 1

                        # 🌐 Test main endpoint
                        curl -f http://localhost:3001/ || exit 1

                        echo "Tests passed!"
                    '''
                }
            }
            post {
                always {
                    sh '''
                        # 🧹 Clean up test container
                        docker stop test-container-${BUILD_NUMBER} || true
                        docker rm test-container-${BUILD_NUMBER} || true
                    '''
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    sh '''
                        echo "Image built successfully: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                        docker images | grep ${DOCKER_IMAGE}
                    '''
                    // TODO: Add `docker push` steps once a registry + credentials are configured
                }
            }
        }
    }

    post {
        always {
            sh '''
                # 🧹 Clean up old images (keep last 5 builds)
                docker images ${DOCKER_IMAGE} --format "table {{.Repository}}:{{.Tag}}" | tail -n +2 | head -n -5 | xargs -r docker rmi || true
            '''
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
```

5. 💾 Click **Save**

### ▶️ Subtask 3.4: Run the Pipeline

1. ▶️ Click **Build Now** to trigger the pipeline
2. 📊 Monitor the build progress in **Build History**
3. 🔎 Click the build number to view detailed logs
4. ✅ Verify that all stages complete successfully

---

## 🔍 Task 4: Integrate SonarQube for Static Code Analysis

### 📥 Subtask 4.1: Install and Configure SonarQube

```bash
# 📂 Create SonarQube directory
sudo mkdir -p /opt/sonarqube
cd /opt/sonarqube

# 📥 Download SonarQube Community Edition
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip

# 📦 Install unzip if not available
sudo apt install -y unzip

# 📂 Extract SonarQube
sudo unzip sonarqube-9.9.0.65466.zip
sudo mv sonarqube-9.9.0.65466 sonarqube

# 👤 Create sonarqube user
sudo useradd -r -s /bin/false sonarqube

# 🔐 Set ownership
sudo chown -R sonarqube:sonarqube /opt/sonarqube

# ⚙️ Configure SonarQube service
sudo tee /etc/systemd/system/sonarqube.service > /dev/null << 'EOF'
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonarqube
Group=sonarqube
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

# ▶️ Start SonarQube service
sudo systemctl daemon-reload
sudo systemctl start sonarqube
sudo systemctl enable sonarqube

# ✅ Check service status
sudo systemctl status sonarqube
```

### 🔧 Subtask 4.2: Configure SonarQube Initial Setup

> ⏳ Wait for SonarQube to start (it may take a few minutes), then:

1. 🌐 Open your browser and navigate to `http://localhost:9000`
2. 🔑 Login with default credentials: `admin` / `admin`
3. 🔒 Change the password when prompted <!-- TODO: use a strong, unique password outside of this lab environment -->
4. ➕ Click **Create new project → Manually**
5. Configure the project:
   - Project key: `sample-node-app`
   - Display name: `Sample Node App`
6. ✅ Click **Set Up**
7. 🔑 Choose **Use global setting for token**, generate a token, and copy it (you'll need it shortly)

### 🔌 Subtask 4.3: Install SonarQube Plugin in Jenkins

1. Go to **Manage Jenkins → Manage Plugins**
2. Search for the **SonarQube Scanner** plugin
3. 📥 Install the plugin and restart Jenkins

### ⚙️ Subtask 4.4: Configure SonarQube in Jenkins

1. Go to **Manage Jenkins → Configure System**
2. Scroll to **SonarQube servers**
3. Click **Add SonarQube**
4. Configure:
   - Name: `SonarQube`
   - Server URL: `http://localhost:9000`
   - Server authentication token: **Add → Jenkins**
     - Kind: `Secret text`
     - Secret: *(paste the SonarQube token you generated)*
     - ID: `sonarqube-token`
     - Description: `SonarQube Authentication Token`
5. 💾 Click **Save**

### 🛠️ Subtask 4.5: Configure SonarQube Scanner Tool

1. Go to **Manage Jenkins → Global Tool Configuration**
2. Scroll to **SonarQube Scanner**
3. Click **Add SonarQube Scanner**
4. Configure:
   - Name: `SonarQube Scanner`
   - ✅ Check **Install automatically**
   - Version: select the latest version
5. 💾 Click **Save**

### 📄 Subtask 4.6: Create SonarQube Configuration File

```bash
# 📄 Create sonar-project.properties in the sample app directory
cd /home/ubuntu/sample-app

cat > sonar-project.properties << 'EOF'
sonar.projectKey=sample-node-app
sonar.projectName=Sample Node App
sonar.projectVersion=1.0
sonar.sources=.
sonar.exclusions=node_modules/**,coverage/**
sonar.javascript.lcov.reportPaths=coverage/lcov.info
EOF

# ➕ Add to git
git add sonar-project.properties
git commit -m "Add SonarQube configuration"
```

### 🔁 Subtask 4.7: Update Jenkins Pipeline with SonarQube Integration

```groovy
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'sample-node-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
        SONARQUBE_SERVER = 'SonarQube'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    sh '''
                        rm -rf workspace-temp
                        mkdir -p workspace-temp
                        cp -r /home/ubuntu/sample-app/* workspace-temp/
                        ls -la workspace-temp/
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    dir('workspace-temp') {
                        withSonarQubeEnv('SonarQube') {
                            sh '''
                                sonar-scanner \
                                -Dsonar.projectKey=sample-node-app \
                                -Dsonar.sources=. \
                                -Dsonar.host.url=http://localhost:9000 \
                                -Dsonar.exclusions=node_modules/**
                            '''
                        }
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir('workspace-temp') {
                        sh '''
                            echo "Building Docker image..."
                            docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                            docker build -t ${DOCKER_IMAGE}:latest .
                        '''
                    }
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    sh '''
                        echo "Testing Docker image..."
                        docker run -d --name test-container-${BUILD_NUMBER} -p 3001:3000 ${DOCKER_IMAGE}:${DOCKER_TAG}

                        sleep 10

                        curl -f http://localhost:3001/health || exit 1
                        curl -f http://localhost:3001/ || exit 1

                        echo "Tests passed!"
                    '''
                }
            }
            post {
                always {
                    sh '''
                        docker stop test-container-${BUILD_NUMBER} || true
                        docker rm test-container-${BUILD_NUMBER} || true
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh '''
                        echo "Deploying application..."
                        # 🛑 Stop existing container if running
                        docker stop sample-app-prod || true
                        docker rm sample-app-prod || true

                        # ▶️ Run new container
                        docker run -d --name sample-app-prod -p 3000:3000 ${DOCKER_IMAGE}:${DOCKER_TAG}

                        echo "Application deployed successfully!"
                        echo "Access the application at: http://localhost:3000"
                    '''
                }
            }
        }
    }

    post {
        always {
            sh '''
                docker images ${DOCKER_IMAGE} --format "table {{.Repository}}:{{.Tag}}" | tail -n +2 | head -n -5 | xargs -r docker rmi || true
            '''
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
```

---

## 🔔 Task 5: Trigger Pipeline on Code Changes and View Build Results

### 🪝 Subtask 5.1: Configure Webhook for Automatic Triggers

> Since we're working in a local environment, we'll simulate automatic triggers using Jenkins polling.

1. Go to your pipeline job configuration
2. In **Build Triggers**, check **Poll SCM**
3. ⏰ Set the schedule to: `H/2 * * * *` (polls every 2 minutes)
4. 💾 Click **Save**

### 📡 Subtask 5.2: Set Up Git Repository Monitoring

```bash
# 📂 Create a bare repository to simulate a remote repo
sudo mkdir -p /opt/git-repos
sudo git init --bare /opt/git-repos/sample-app.git
sudo chown -R jenkins:jenkins /opt/git-repos

# 🔗 Add remote to our existing repository
cd /home/ubuntu/sample-app
git remote add origin /opt/git-repos/sample-app.git
git push -u origin master
```

### 🔄 Subtask 5.3: Update Pipeline to Use Git Repository

1. Go to your pipeline job configuration
2. In **Pipeline**, change from **Pipeline script** to **Pipeline script from SCM**
3. Configure:
   - SCM: `Git`
   - Repository URL: `/opt/git-repos/sample-app.git`
   - Branch: `*/master`
   - Script Path: `Jenkinsfile`

### 📝 Subtask 5.4: Create Jenkinsfile in Repository

```bash
cd /home/ubuntu/sample-app

# 📝 Create Jenkinsfile with the complete pipeline
cat > Jenkinsfile << 'EOF'
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'sample-node-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
        SONARQUBE_SERVER = 'SonarQube'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=sample-node-app \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.exclusions=node_modules/**
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker build -t ${DOCKER_IMAGE}:latest .
                '''
            }
        }

        stage('Test Docker Image') {
            steps {
                sh '''
                    echo "Testing Docker image..."
                    docker run -d --name test-container-${BUILD_NUMBER} -p 3001:3000 ${DOCKER_IMAGE}:${DOCKER_TAG}

                    sleep 10

                    curl -f http://localhost:3001/health || exit 1
                    curl -f http://localhost:3001/ || exit 1

                    echo "Tests passed!"
                '''
            }
            post {
                always {
                    sh '''
                        docker stop test-container-${BUILD_NUMBER} || true
                        docker rm test-container-${BUILD_NUMBER} || true
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    echo "Deploying application..."
                    docker stop sample-app-prod || true
                    docker rm sample-app-prod || true

                    docker run -d --name sample-app-prod -p 3000:3000 ${DOCKER_IMAGE}:${DOCKER_TAG}

                    echo "Application deployed successfully!"
                '''
            }
        }
    }

    post {
        always {
            sh '''
                docker images ${DOCKER_IMAGE} --format "table {{.Repository}}:{{.Tag}}" | tail -n +2 | head -n -5 | xargs -r docker rmi || true
            '''
        }
        success {
            echo 'Pipeline completed successfully!'
            emailext (
                subject: "Build Success: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "The build completed successfully. Check console output at ${env.BUILD_URL}",
                to: "admin@example.com"
            )
        }
        failure {
            echo 'Pipeline failed!'
            emailext (
                subject: "Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "The build failed. Check console output at ${env.BUILD_URL}",
                to: "admin@example.com"
            )
        }
    }
}
EOF

# ➕ Commit and push Jenkinsfile
git add Jenkinsfile
git commit -m "Add Jenkinsfile for CI/CD pipeline"
git push origin master
```

### 🧪 Subtask 5.5: Test Automatic Pipeline Triggers

```bash
cd /home/ubuntu/sample-app

# 🔢 Update the application version
sed -i 's/"version": "1.0.0"/"version": "1.1.0"/' package.json
sed -i 's/version: '\''1.0.0'\''/version: '\''1.1.0'\''/' app.js

# ➕ Commit and push changes
git add .
git commit -m "Update application version to 1.1.0"
git push origin master
```

- ⏳ Wait for Jenkins to detect the change (up to 2 minutes)
- 👀 Observe the automatic pipeline execution

### 📊 Subtask 5.6: Monitor Build Results and Metrics

**📈 View Build History and Trends**
1. In the Jenkins dashboard, click your pipeline job
2. 🕒 Review the **Build History** section for recent builds
3. 📉 Click **Trend** to see build success/failure trends
4. 🔎 Click individual build numbers to view console output, artifacts, test results, and SonarQube analysis results

**🔍 Access SonarQube Dashboard**
1. Open `http://localhost:9000` in your browser
2. 🔑 Login with your SonarQube credentials
3. Click your project **sample-node-app**
4. Review code quality metrics, security vulnerabilities, code coverage, technical debt, and code smells/bugs

**✅ Verify Application Deployment**

```bash
# 🌐 Test the deployed application
curl http://localhost:3000/
curl http://localhost:3000/health

# 🔎 Check running containers
docker ps | grep sample-app
```

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔴 Jenkins Service Issues</summary>

```bash
# ❌ If Jenkins fails to start
sudo systemctl status jenkins
sudo journalctl -u jenkins

# 📜 Check Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log
```
</details>

<details>
<summary>🔴 Docker Permission Issues</summary>

```bash
# ❌ If Jenkins can't access Docker
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# ✅ Test Docker access
sudo -u jenkins docker ps
```
</details>

<details>
<summary>🔴 SonarQube Connection Issues</summary>

```bash
# ✅ Check SonarQube service
sudo systemctl status sonarqube

# 📜 Check SonarQube logs
sudo tail -f /opt/sonarqube/sonarqube/logs/sonar.log
```
</details>

<details>
<summary>🔴 Pipeline Failures</summary>

- 🔎 Check console output for specific error messages
- 🔌 Verify all required plugins are installed
- 🔑 Ensure proper credentials are configured
- 📂 Check file permissions and paths
</details>

---

## 🔒 Best Practices Implemented

### 🛡️ Security Best Practices
- 🔑 **Credential Management** — using Jenkins credential store for sensitive information
- 👤 **User Permissions** — proper user separation between Jenkins and system users
- 🔒 **Container Security** — running containers with non-root users where possible

### 🔁 CI/CD Best Practices
- 📝 **Pipeline as Code** — using a Jenkinsfile for version-controlled pipeline definitions
- 🧪 **Automated Testing** — including automated tests in the pipeline
- 🚦 **Quality Gates** — implementing SonarQube quality gates to prevent poor code deployment
- 🧹 **Artifact Management** — proper cleanup of old Docker images
- 📧 **Notification System** — email notifications for build status

### 🐳 Docker Best Practices
- 🏗️ **Multi-stage Builds** — using appropriate base images
- 📦 **Layer Optimization** — minimizing Docker image layers
- 🔍 **Security Scanning** — including security analysis in the pipeline
- ♻️ **Resource Management** — proper container lifecycle management

---

## 🎓 Conclusion

Congratulations! You have successfully completed **Lab 21: Docker and CI/CD - Automating Builds with Jenkins**.

### 🏆 What You Accomplished

- ⚙️ **Installed and Configured Jenkins** — a complete Jenkins environment on Linux with proper security configuration and plugin management
- 🐳 **Integrated Docker with Jenkins** — configured Jenkins to build, test, and deploy Docker containers automatically
- 🏗️ **Created Advanced CI/CD Pipelines** — multi-stage pipelines for checkout, build, test, and deployment with error handling and cleanup
- 🔍 **Implemented Code Quality Analysis** — integrated SonarQube for static code analysis and quality gates
- 🔔 **Automated Pipeline Triggers** — pipeline execution triggered automatically based on code changes
- 📊 **Monitored and Analyzed Results** — interpreted build results, quality metrics, and deployment status via Jenkins and SonarQube dashboards

### 🌍 Why This Matters

| Theme | Why It Matters |
|---|---|
| 🔗 DevOps Integration | Bridges development and operations through automated CI/CD pipelines |
| ✅ Quality Assurance | Automated quality checks prevent defective code from reaching production |
| ⚡ Efficiency | Automated builds and deployments reduce manual effort and human error |
| 📈 Scalability | Enables teams to deploy code more frequently and reliably |
| 🏭 Industry Relevance | Jenkins and Docker are industry-standard tools used by organizations worldwide |

### 🔭 Next Steps

- 🌊 Explore advanced Jenkins features like **Blue Ocean UI** and parallel pipeline execution
- ☸️ Learn about container orchestration with **Kubernetes**
- 🧪 Implement more sophisticated testing strategies, including integration and performance testing
- 🔁 Explore other CI/CD tools like **GitLab CI**, **GitHub Actions**, or **Azure DevOps**
- 🏗️ Study infrastructure as code with tools like **Terraform** or **Ansible**

### 📜 Certification Preparation

This lab provides a solid foundation in modern CI/CD practices supporting your journey toward the **Docker Certified Associate (DCA)** certification and a professional software development career.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blue?style=for-the-badge)

</div>
