<div align="center">

# ☁️Docker for Cloud
## Running Docker Containers on Heroku

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Heroku](https://img.shields.io/badge/Heroku-430098?style=for-the-badge&logo=heroku&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Express](https://img.shields.io/badge/Express-000000?style=for-the-badge&logo=express&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Level](https://img.shields.io/badge/Level-Intermediate-orange?style=for-the-badge)

*Containerize a Node.js web application with Docker and deploy it to Heroku's cloud platform — from CLI setup to monitoring and scaling.*

</div>

---

## 📑 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🔑 Task 1: Set Up Heroku Account and Install Heroku CLI](#-task-1-set-up-heroku-account-and-install-heroku-cli)
- [🐳 Task 2: Create a Dockerfile for a Web Application](#-task-2-create-a-dockerfile-for-a-web-application)
- [🚀 Task 3: Push Docker Image to Heroku and Deploy](#-task-3-push-docker-image-to-heroku-and-deploy)
- [⚙️ Task 4: Set Up Environment Variables and Configurations](#️-task-4-set-up-environment-variables-and-configurations)
- [📊 Task 5: Monitor and Scale Application Using Heroku Dashboard](#-task-5-monitor-and-scale-application-using-heroku-dashboard)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🎓 Lab Conclusion](#-lab-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1️⃣ | Set up a Heroku account and install the Heroku CLI |
| 2️⃣ | Create a Dockerfile for a web application |
| 3️⃣ | Build and deploy Docker containers to Heroku |
| 4️⃣ | Configure environment variables and application settings in Heroku |
| 5️⃣ | Monitor application performance and scale resources using the Heroku dashboard |
| 6️⃣ | Understand the fundamentals of cloud-based container deployment |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker Concepts | Basic understanding of Docker concepts and commands |
| 💻 CLI Experience | Familiarity with command-line interface operations |
| 🌐 Web/HTTP Basics | Basic knowledge of web applications and HTTP protocols |
| ⚙️ Configuration Management | Understanding of environment variables and configuration management |
| 📧 Heroku Account | A valid email address for creating a Heroku account |

> 📝 **TODO:** Have your email ready before starting Task 1 — account verification happens mid-lab and blocks CLI login until it's confirmed.

---

## 🖥️ Lab Environment Setup

> ☁️ **Ready-to-Use Cloud Machines**
> Al Nafi provides Linux-based cloud machines with Docker pre-installed. Simply click **Start Lab** to access your environment — no need to build your own VM or install Docker locally.

**Your cloud machine includes:**

| Component | Specification |
|---|---|
| 🐧 OS | Ubuntu Linux with Docker Engine |
| 🔧 Version Control | Git |
| ✏️ Text Editors | nano, vim |
| 🌐 Network | Connectivity for external services |

---

## 🔑 Task 1: Set Up Heroku Account and Install Heroku CLI

### 👤 Subtask 1.1: Create Heroku Account

1. 🌐 Open a web browser in your cloud machine
2. 🔗 Navigate to `https://signup.heroku.com/`
3. 📝 Fill out the registration form with the following information:
   - **First Name:** Your first name
   - **Last Name:** Your last name
   - **Email Address:** Your valid email address
   - **Company:** Student (or leave blank)
   - **Role:** Student
   - **Country:** United States
   - **Development Language:** Other
4. ✅ Click **Create Free Account**
5. 📧 Check your email and verify your account by clicking the verification link
6. 🔐 Set up your password when prompted

### 💻 Subtask 1.2: Install Heroku CLI

Open terminal in your cloud machine and download/install the Heroku CLI:

```bash
# 🔄 Update package list
sudo apt update

# 📦 Install curl if not already installed
sudo apt install curl -y

# ⬇️ Download and install Heroku CLI
curl https://cli-assets.heroku.com/install.sh | sh
```

```bash
# ✅ Verify the installation
heroku --version
```

> Expected output should show the Heroku CLI version number.

### 🔓 Subtask 1.3: Login to Heroku CLI

```bash
# 🔐 Login to your Heroku account through the CLI
heroku login
```

1. ⌨️ Press any key when prompted to open the browser
2. 🖱️ Click **Log In** in the browser window that opens
3. 🔙 Return to the terminal — you should see a confirmation message

> 💡 **TODO:** If you're on a headless/remote session and the browser can't open automatically, look for the alternate device-code login flow Heroku CLI prints to the terminal.

---

## 🐳 Task 2: Create a Dockerfile for a Web Application

### 📁 Subtask 2.1: Create Project Directory and Files

```bash
# 📂 Create a new directory for your project
mkdir heroku-docker-app
cd heroku-docker-app
```

Create the `package.json` file:

```bash
nano package.json
```

```json
{
  "name": "heroku-docker-app",
  "version": "1.0.0",
  "description": "Simple web app for Heroku Docker deployment",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "engines": {
    "node": "18.x"
  }
}
```

> 💾 Save and exit (`Ctrl+X`, then `Y`, then `Enter`)

### 🌐 Subtask 2.2: Create the Web Application

```bash
nano server.js
```

```javascript
// 🌐 Basic Express web application
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// 🧩 Middleware to parse JSON
app.use(express.json());

// 🏠 Basic route
app.get('/', (req, res) => {
    res.json({
        message: 'Hello from Docker on Heroku!',
        timestamp: new Date().toISOString(),
        environment: process.env.NODE_ENV || 'development'
    });
});

// 🩺 Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        uptime: process.uptime(),
        memory: process.memoryUsage()
    });
});

// ℹ️ API endpoint with environment variable
app.get('/api/info', (req, res) => {
    res.json({
        app_name: process.env.APP_NAME || 'Heroku Docker App',
        version: '1.0.0',
        author: process.env.AUTHOR_NAME || 'Student Developer'
    });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on port ${PORT}`);
    console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});
```

> 💾 Save and exit the file

### 🐋 Subtask 2.3: Create the Dockerfile

```bash
nano Dockerfile
```

```dockerfile
# 📦 Use official Node.js runtime as base image
FROM node:18-alpine

# 📁 Set working directory in container
WORKDIR /usr/src/app

# 📋 Copy package.json and package-lock.json (if available)
COPY package*.json ./

# ⬇️ Install application dependencies
RUN npm install --only=production

# 📤 Copy application source code
COPY . .

# 👤 Create non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# 🔐 Change ownership of app directory
RUN chown -R nodejs:nodejs /usr/src/app
USER nodejs

# 🔌 Expose port (Heroku will assign the actual port)
EXPOSE 3000

# ⚙️ Define environment variable
ENV NODE_ENV=production

# ▶️ Command to run the application
CMD ["npm", "start"]
```

> 💾 Save and exit the file

### 📝 Subtask 2.4: Create Additional Configuration Files

Create a `.dockerignore` file to exclude unnecessary files:

```bash
nano .dockerignore
```

```
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.nyc_output
coverage
.nyc_output
```

Create a `heroku.yml` file for Heroku container deployment:

```bash
nano heroku.yml
```

```yaml
build:
  docker:
    web: Dockerfile
run:
  web: npm start
```

> 💾 Save and exit

---

## 🚀 Task 3: Push Docker Image to Heroku and Deploy

### 🔧 Subtask 3.1: Initialize Git Repository

```bash
# 🌱 Initialize a Git repository in your project directory
git init
```

Create a `.gitignore` file:

```bash
nano .gitignore
```

```
node_modules/
npm-debug.log*
.env
.DS_Store
*.log
```

```bash
# 📤 Add all files to Git
git add .
git commit -m "Initial commit: Docker web app for Heroku"
```

### 🆕 Subtask 3.2: Create Heroku Application

```bash
# 🆕 Create a new Heroku application
heroku create your-docker-app-name-$(date +%s)
```

> 📝 **Note:** Replace with a unique name or let Heroku generate one automatically. The `$(date +%s)` adds a timestamp to ensure uniqueness.

```bash
# 🐳 Set the stack to container for Docker deployment
heroku stack:set container
```

### 📤 Subtask 3.3: Deploy to Heroku

```bash
# 🔗 Add the Heroku remote repository
heroku git:remote -a $(heroku apps --json | grep -o '"name":"[^"]*' | head -1 | cut -d'"' -f4)

# 🚀 Deploy your application to Heroku
git push heroku main
```

> 📝 **Note:** If you're using an older Git version, you might need to use `master` instead of `main`.

Wait for the build process to complete. You should see output similar to:

```
=== Building web (Dockerfile)
Sending build context to Docker daemon
Step 1/12 : FROM node:18-alpine
...
=== Pushing web (Dockerfile)
...
=== Releasing...
=== Deployed to Heroku
```

### ✅ Subtask 3.4: Verify Deployment

```bash
# 🌐 Open your application in the browser
heroku open
```

```bash
# 🔗 Alternatively, get the application URL
heroku apps:info
```

```bash
# 🧪 Test the application endpoints using curl
# 🔗 Get the app URL
APP_URL=$(heroku apps:info --json | grep -o '"web_url":"[^"]*' | cut -d'"' -f4)

# 🏠 Test main endpoint
curl $APP_URL

# 🩺 Test health endpoint
curl ${APP_URL}health

# ℹ️ Test API endpoint
curl ${APP_URL}api/info
```

> 💡 **TODO:** Save your `APP_URL` to a scratch file — you'll reuse it in Tasks 4 and 5.

---

## ⚙️ Task 4: Set Up Environment Variables and Configurations

### 🔧 Subtask 4.1: Configure Environment Variables

```bash
# 🏷️ Set application name
heroku config:set APP_NAME="My Heroku Docker App"

# 👤 Set author name
heroku config:set AUTHOR_NAME="Student Developer"

# ⚙️ Set Node environment
heroku config:set NODE_ENV="production"

# 🐞 Set custom configuration
heroku config:set DEBUG_MODE="false"
```

```bash
# 📋 View all configured environment variables
heroku config

# 🔍 View specific environment variable
heroku config:get APP_NAME
```

### ✏️ Subtask 4.2: Update Application to Use New Variables

```bash
nano server.js
```

```javascript
// ➕ Add this new endpoint before the app.listen() line
app.get('/api/env', (req, res) => {
    res.json({
        app_name: process.env.APP_NAME || 'Default App Name',
        author: process.env.AUTHOR_NAME || 'Unknown Author',
        node_env: process.env.NODE_ENV || 'development',
        debug_mode: process.env.DEBUG_MODE || 'true',
        port: process.env.PORT || 3000,
        heroku_app_name: process.env.HEROKU_APP_NAME || 'Not set'
    });
});
```

> 💾 Save and exit

### 🔁 Subtask 4.3: Redeploy with New Configuration

```bash
# 📤 Commit your changes
git add .
git commit -m "Add environment variables endpoint"

# 🚀 Deploy the updated application
git push heroku main
```

```bash
# 🧪 Test the new endpoint
APP_URL=$(heroku apps:info --json | grep -o '"web_url":"[^"]*' | cut -d'"' -f4)
curl ${APP_URL}api/env
```

---

## 📊 Task 5: Monitor and Scale Application Using Heroku Dashboard

### 🖥️ Subtask 5.1: Access Heroku Dashboard

```bash
# 🖥️ Open the Heroku dashboard in your browser
heroku dashboard
```

```bash
# 🎯 Alternatively, open your specific app dashboard
heroku dashboard --app $(heroku apps --json | grep -o '"name":"[^"]*' | head -1 | cut -d'"' -f4)
```

### 📈 Subtask 5.2: Monitor Application Metrics

```bash
# 📜 View application logs in real-time
heroku logs --tail

# 📜 View recent logs
heroku logs --num=100

# 🩺 Check application status
heroku ps

# ℹ️ View application information
heroku apps:info
```

### 🔥 Subtask 5.3: Performance Testing and Monitoring

```bash
# 🔗 Get app URL
APP_URL=$(heroku apps:info --json | grep -o '"web_url":"[^"]*' | cut -d'"' -f4)

# 🏋️ Create a simple load test script
cat > load_test.sh << 'EOF'
#!/bin/bash
APP_URL=$1
echo "Starting load test for $APP_URL"
for i in {1..50}; do
    curl -s $APP_URL > /dev/null &
    curl -s ${APP_URL}health > /dev/null &
    curl -s ${APP_URL}api/info > /dev/null &
    curl -s ${APP_URL}api/env > /dev/null &
    if [ $((i % 10)) -eq 0 ]; then
        echo "Completed $i requests"
    fi
done
wait
echo "Load test completed"
EOF

chmod +x load_test.sh
```

```bash
# ▶️ Run the load test
./load_test.sh $APP_URL
```

```bash
# 👀 Monitor the logs during the test
heroku logs --tail
```

### 📏 Subtask 5.4: Scale the Application

```bash
# 🔍 Check current dyno formation
heroku ps
```

```bash
# 📈 Scale up the application (note: this may incur charges on Heroku)
# heroku ps:scale web=2

# ℹ️ For this lab, we'll demonstrate the command without executing
echo "To scale to 2 dynos, you would run: heroku ps:scale web=2"
echo "This would incur charges, so we're not executing it in this lab"
```

```bash
# 💲 View dyno types and pricing
heroku ps:type
```

> ⚠️ **Note:** Scaling beyond a single free/eco dyno moves the app to a paid tier — the lab intentionally shows the command without running it.

### 🩺 Subtask 5.5: Application Health Monitoring

```bash
# 🩺 Set up a simple monitoring script
cat > monitor.sh << 'EOF'
#!/bin/bash
APP_URL=$1
echo "Monitoring application health..."
while true; do
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" ${APP_URL}health)
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    if [ "$RESPONSE" = "200" ]; then
        echo "[$TIMESTAMP] ✓ Application is healthy (HTTP $RESPONSE)"
    else
        echo "[$TIMESTAMP] ✗ Application issue detected (HTTP $RESPONSE)"
    fi
    sleep 30
done
EOF

chmod +x monitor.sh
```

```bash
# ⏱️ Run the monitor for a few cycles (press Ctrl+C to stop)
timeout 120 ./monitor.sh $APP_URL
```

> 💡 **TODO:** Capture one cycle of healthy output from `monitor.sh` for your lab submission.

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>❌ <strong>Issue 1: Build Failures</strong></summary>

If your Docker build fails:

```bash
# 📜 Check the build logs
heroku logs --tail

# 🧪 Verify your Dockerfile syntax
docker build -t test-build .
```

</details>

<details>
<summary>🚫 <strong>Issue 2: Application Won't Start</strong></summary>

If your application doesn't start:

- ✅ Check that your application listens on the correct port:
  ```javascript
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, '0.0.0.0', callback);
  ```
- ✅ Verify your `package.json` start script is correct

</details>

<details>
<summary>⚙️ <strong>Issue 3: Environment Variables Not Working</strong></summary>

If environment variables aren't being read:

```bash
# 🔍 Verify they're set
heroku config
```

- ✅ Check your application code references them correctly: `process.env.VARIABLE_NAME`

</details>

---

## 🎓 Lab Conclusion

Congratulations! 🎉 You have successfully completed **Lab 89: Docker for Cloud - Running Docker Containers on Heroku**.

### 🏆 What You Accomplished

- ☁️ **Set up Heroku Infrastructure** — created a Heroku account and installed the CLI tools necessary for cloud deployment
- 🐳 **Containerized a Web Application** — built a complete Docker container with a Node.js web application, including proper security practices and optimization
- 🚀 **Deployed to Production** — successfully pushed and deployed your Docker container to Heroku's cloud platform
- ⚙️ **Configured Cloud Environment** — set up environment variables and application configurations for production deployment
- 📊 **Implemented Monitoring** — used Heroku's dashboard and CLI tools to monitor application performance and health

### 💡 Why This Matters

This lab demonstrates critical skills for modern cloud development:

| Skill | Why It Matters |
|---|---|
| 📦 Container Orchestration | Understanding how to deploy containers in cloud environments is essential for scalable applications |
| 🔁 DevOps Practices | You've experienced the complete deployment pipeline from development to production |
| ☁️ Cloud Platform Management | Heroku represents Platform-as-a-Service (PaaS) solutions that abstract infrastructure complexity |
| 📈 Production Monitoring | Real-world applications require continuous monitoring and the ability to scale based on demand |
| ⚙️ Environment Management | Proper configuration management is crucial for maintaining applications across different environments |

### 🔭 Next Steps

To continue building on this knowledge:

- 🧩 Explore Heroku add-ons for databases, monitoring, and logging
- 🔁 Learn about CI/CD pipelines for automated deployments
- ☸️ Study container orchestration platforms like Kubernetes
- ☁️ Practice with other cloud providers like AWS, Google Cloud, or Azure
- 🗄️ Implement more complex applications with databases and external services

> 🎖️ This hands-on experience with Docker and Heroku provides a solid foundation for cloud-native application development and prepares you for the **Docker Certified Associate (DCA)** certification and real-world cloud deployment scenarios.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blue?style=for-the-badge)

</div>
