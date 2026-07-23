<div align="center">

# 🐳🔄 Docker for Continuous Integration — Integrating Docker with Travis CI

### Automated Builds, Testing & Deployment Pipelines

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Travis CI](https://img.shields.io/badge/Travis_CI-3EAAAF?style=for-the-badge&logo=travisci&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Docker Hub](https://img.shields.io/badge/Docker_Hub-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Jest](https://img.shields.io/badge/Jest-C21325?style=for-the-badge&logo=jest&logoColor=white)
![Level](https://img.shields.io/badge/Level-Intermediate-yellow?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment](#️-lab-environment)
- [🚀 Task 1: Set up Travis CI with a Dockerized Web Application](#-task-1-set-up-travis-ci-with-a-dockerized-web-application)
- [⚙️ Task 2: Configure .travis.yml to Build Docker Images Automatically](#️-task-2-configure-travisyml-to-build-docker-images-automatically)
- [📤 Task 3: Push the Built Image to Docker Hub](#-task-3-push-the-built-image-to-docker-hub)
- [🧪 Task 4: Set up Testing Steps Within the Docker Container](#-task-4-set-up-testing-steps-within-the-docker-container)
- [📈 Task 5: Monitor Travis CI Build Logs and Troubleshoot](#-task-5-monitor-travis-ci-build-logs-and-troubleshoot)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [📊 Key Concepts Summary](#-key-concepts-summary)
- [🎓 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | 🔄 Set up Travis CI for automated Docker builds and deployments |
| 2 | 📄 Configure `.travis.yml` file to build Docker images automatically |
| 3 | 📤 Push built Docker images to Docker Hub after successful builds |
| 4 | 🧪 Implement testing steps within Docker containers in Travis CI |
| 5 | 📈 Monitor Travis CI build logs and troubleshoot common issues |
| 6 | 🔧 Understand the fundamentals of CI/CD pipelines with Docker |

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker Basics | Understanding of Docker concepts and commands |
| 🌿 Git | Familiarity with Git version control |
| 🌐 Web Apps | Basic knowledge of web applications (HTML, JavaScript) |
| 📄 YAML | Understanding of YAML file format |
| 🐙 GitHub Account | A free GitHub account |
| 🐳 Docker Hub Account | A free Docker Hub account |

## 🖥️ Lab Environment

> **☁️ Ready-to-Use Cloud Machines**
> Al Nafi provides Linux-based cloud machines with all necessary tools pre-installed. Simply click **Start Lab** to begin — no need to build your own VM or install software locally.

**Included in your cloud machine:**

![Docker Engine](https://img.shields.io/badge/Docker_Engine-2496ED?style=flat-square&logo=docker&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=flat-square&logo=git&logoColor=white)
![Node.js/npm](https://img.shields.io/badge/Node.js%2Fnpm-339933?style=flat-square&logo=nodedotjs&logoColor=white)
![nano/vim](https://img.shields.io/badge/nano%2Fvim-4EAA25?style=flat-square&logo=gnubash&logoColor=white)
![Dev Tools](https://img.shields.io/badge/Dev_Tools-000000?style=flat-square&logo=todoist&logoColor=white)

---

## 🚀 Task 1: Set up Travis CI with a Dockerized Web Application

![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=white)
![Express](https://img.shields.io/badge/Express-000000?style=flat-square&logo=express&logoColor=white)
![Jest](https://img.shields.io/badge/Jest-C21325?style=flat-square&logo=jest&logoColor=white)

### 🏗️ Subtask 1.1: Create a Simple Web Application

```bash
# 📁 Create a new directory for your project
mkdir docker-travis-ci-lab
cd docker-travis-ci-lab

# 📦 Initialize a new Node.js project
npm init -y

# 📥 Install Express.js
npm install express
```

Create the main application file:
```bash
# 📝 Create the app entry point
nano app.js
```

```javascript
// 🌐 Minimal Express app with a health endpoint
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.json({
        message: 'Hello from Dockerized Node.js App!',
        version: '1.0.0',
        timestamp: new Date().toISOString()
    });
});

// 🩺 Health check endpoint used by Docker HEALTHCHECK and Travis tests
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        uptime: process.uptime()
    });
});

const server = app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

module.exports = { app, server };
// TODO: Add your own routes here
```

Create a test file:
```bash
# 🧪 Install testing dependencies
npm install --save-dev jest supertest

# 📝 Create the test file
nano app.test.js
```

```javascript
// ✅ Unit tests for the Express app
const request = require('supertest');
const { app, server } = require('./app');

describe('App Tests', () => {
    afterAll(() => {
        server.close();
    });

    test('GET / should return welcome message', async () => {
        const response = await request(app).get('/');
        expect(response.status).toBe(200);
        expect(response.body.message).toBe('Hello from Dockerized Node.js App!');
    });

    test('GET /health should return health status', async () => {
        const response = await request(app).get('/health');
        expect(response.status).toBe(200);
        expect(response.body.status).toBe('healthy');
    });
});
```

Update `package.json` with the test script:
```json
{
  "name": "docker-travis-ci-lab",
  "version": "1.0.0",
  "description": "",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "test": "jest",
    "test:watch": "jest --watch"
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "jest": "^29.7.0",
    "supertest": "^6.3.3"
  }
}
```
✅ **Sign of success:** `npm test` runs both test cases and reports `PASS`.

### 🐳 Subtask 1.2: Create a Dockerfile

```bash
# 📝 Create the Dockerfile
nano Dockerfile
```

```dockerfile
# 🏗️ Use official Node.js runtime as base image
FROM node:18-alpine

# 📁 Set working directory in container
WORKDIR /usr/src/app

# 📋 Copy package files
COPY package*.json ./

# 📥 Install dependencies
RUN npm ci --only=production

# 📂 Copy application code
COPY . .

# 🔒 Create non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# 🔑 Change ownership of app directory
RUN chown -R nodejs:nodejs /usr/src/app
USER nodejs

# 🌐 Expose port
EXPOSE 3000

# 🩺 Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# ▶️ Start application
CMD ["npm", "start"]
# TODO: Swap the base image or add build args for your own stack
```

Create a `.dockerignore` file:
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
.travis.yml
```

Test the Docker build locally:
```bash
# 🏗️ Build the image
docker build -t my-node-app:test .

# ▶️ Run the container
docker run -p 3000:3000 -d --name test-container my-node-app:test

# ✅ Verify the application is running
curl http://localhost:3000
curl http://localhost:3000/health

# 🧹 Clean up the test container
docker stop test-container
docker rm test-container
docker rmi my-node-app:test
```
✅ **Sign of success:** both `curl` calls return JSON with `200 OK` before cleanup.

### 🌿 Subtask 1.3: Initialize Git Repository

```bash
# 🌱 Initialize Git repository
git init

# 📝 Create .gitignore file
nano .gitignore
```

```
node_modules/
npm-debug.log*
.env
.DS_Store
coverage/
.nyc_output/
```

```bash
# 💾 Add and commit files
git add .
git commit -m "Initial commit: Dockerized Node.js app"
```
✅ **Sign of success:** `git log` shows the initial commit with all project files tracked.

---

## ⚙️ Task 2: Configure .travis.yml to Build Docker Images Automatically

![Travis CI](https://img.shields.io/badge/Travis_CI-3EAAAF?style=flat-square&logo=travisci&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white)

### 📄 Subtask 2.1: Create Travis CI Configuration

```bash
# 📝 Create .travis.yml file
nano .travis.yml
```

```yaml
# 🔤 Specify the programming language
language: node_js

# 🔢 Specify Node.js version
node_js:
  - "18"

# 🐳 Enable Docker service
services:
  - docker

# 🌍 Environment variables
env:
  global:
    - DOCKER_IMAGE_NAME=your-dockerhub-username/docker-travis-ci-lab
    - NODE_ENV=test

# ⚡ Cache node_modules for faster builds
cache:
  directories:
    - node_modules

# 📥 Install dependencies
install:
  - npm ci

# 🧪 Run tests before building Docker image
script:
  - npm test
  - docker build -t $DOCKER_IMAGE_NAME:$TRAVIS_BUILD_NUMBER .
  - docker build -t $DOCKER_IMAGE_NAME:latest .

# 🩺 Test the Docker image
before_deploy:
  - docker run -d -p 3000:3000 --name test-container $DOCKER_IMAGE_NAME:latest
  - sleep 10
  - docker exec test-container curl -f http://localhost:3000/health || exit 1
  - docker stop test-container
  - docker rm test-container

# 🚀 Deploy section (will be configured in next task)
deploy:
  provider: script
  script: echo "Deploy configuration will be added in next task"
  on:
    branch: main
# TODO: Replace your-dockerhub-username with your actual Docker Hub username

# 📧 Notification settings
notifications:
  email:
    on_success: change
    on_failure: always
```

### 🐙 Subtask 2.2: Set up GitHub Repository

**Create a new repository on GitHub:**
1. 🌐 Go to GitHub.com and sign in
2. ➕ Click the "+" icon and select "New repository"
3. 🏷️ Name it `docker-travis-ci-lab`
4. 🔓 Make it public
5. 🚫 Don't initialize with README (we already have files)

**Add GitHub remote and push:**
```bash
# 🔗 Add GitHub remote and push
git remote add origin https://github.com/YOUR-USERNAME/docker-travis-ci-lab.git
git branch -M main
git push -u origin main
# TODO: Replace YOUR-USERNAME with your actual GitHub username
```
✅ **Sign of success:** the repository files appear on GitHub under your account.

### ✅ Subtask 2.3: Enable Travis CI

**Go to Travis CI:**
1. 🌐 Visit [travis-ci.com](https://travis-ci.com)
2. 🔑 Sign in with your GitHub account
3. ✅ Authorize Travis CI to access your repositories

**Enable your repository:**
1. 🔍 Find your `docker-travis-ci-lab` repository
2. 🔛 Toggle the switch to enable Travis CI builds

**Trigger first build:**
```bash
# 🚦 Trigger the first Travis CI build
echo "# Docker Travis CI Lab" > README.md
git add README.md
git commit -m "Add README to trigger Travis CI build"
git push origin main
```
✅ **Sign of success:** a new build appears in the Travis CI dashboard and starts running.

---

## 📤 Task 3: Push the Built Image to Docker Hub

![Docker Hub](https://img.shields.io/badge/Docker_Hub-2496ED?style=flat-square&logo=docker&logoColor=white)
![Travis CI](https://img.shields.io/badge/Travis_CI-3EAAAF?style=flat-square&logo=travisci&logoColor=white)

### 🔑 Subtask 3.1: Set up Docker Hub Credentials

**Create Docker Hub repository:**
1. 🌐 Go to [hub.docker.com](https://hub.docker.com)
2. 🔑 Sign in to your account
3. ➕ Click "Create Repository"
4. 🏷️ Name it `docker-travis-ci-lab`
5. 🔓 Make it public
6. ✅ Click "Create"

**Add Docker Hub credentials to Travis CI:**
1. ⚙️ Go to your Travis CI repository settings
2. 🌍 Add environment variables:
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Your Docker Hub password (🔒 mark as hidden)

### 🔄 Subtask 3.2: Update Travis CI Configuration for Deployment

```bash
nano .travis.yml
```

```yaml
# 🔤 Specify the programming language
language: node_js

# 🔢 Specify Node.js version
node_js:
  - "18"

# 🐳 Enable Docker service
services:
  - docker

# 🌍 Environment variables
env:
  global:
    - DOCKER_IMAGE_NAME=$DOCKER_USERNAME/docker-travis-ci-lab
    - NODE_ENV=test

# ⚡ Cache node_modules for faster builds
cache:
  directories:
    - node_modules

# 📥 Install dependencies
install:
  - npm ci

# 🧪 Run tests and build Docker image
script:
  - npm test
  - docker build -t $DOCKER_IMAGE_NAME:$TRAVIS_BUILD_NUMBER .
  - docker build -t $DOCKER_IMAGE_NAME:latest .

# 🩺 Test the Docker image
before_deploy:
  - docker run -d -p 3000:3000 --name test-container $DOCKER_IMAGE_NAME:latest
  - sleep 10
  - docker exec test-container curl -f http://localhost:3000/health || exit 1
  - docker stop test-container
  - docker rm test-container

# 🚀 Deploy to Docker Hub
after_success:
  - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  - docker push $DOCKER_IMAGE_NAME:$TRAVIS_BUILD_NUMBER
  - docker push $DOCKER_IMAGE_NAME:latest

# 🌿 Only deploy on main branch
branches:
  only:
    - main

# 📧 Notification settings
notifications:
  email:
    on_success: change
    on_failure: always
```

```bash
# 💾 Commit and push the changes
git add .travis.yml
git commit -m "Configure Docker Hub deployment in Travis CI"
git push origin main
```
✅ **Sign of success:** the Travis build's `after_success` stage logs into Docker Hub without error.

### 📜 Subtask 3.3: Create Deployment Script (Alternative Method)

```bash
# 📝 Create deploy.sh script
nano deploy.sh
```

```bash
#!/bin/bash

# ⛔ Exit on any error
set -e

echo "Starting deployment process..."

# 🔑 Login to Docker Hub
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# 🏷️ Tag images
docker tag $DOCKER_IMAGE_NAME:latest $DOCKER_IMAGE_NAME:$TRAVIS_BUILD_NUMBER
docker tag $DOCKER_IMAGE_NAME:latest $DOCKER_IMAGE_NAME:build-$TRAVIS_BUILD_NUMBER

# 📤 Push images
echo "Pushing Docker images..."
docker push $DOCKER_IMAGE_NAME:latest
docker push $DOCKER_IMAGE_NAME:$TRAVIS_BUILD_NUMBER
docker push $DOCKER_IMAGE_NAME:build-$TRAVIS_BUILD_NUMBER

echo "Deployment completed successfully!"

# 🧹 Optional: Clean up local images to save space
docker rmi $DOCKER_IMAGE_NAME:build-$TRAVIS_BUILD_NUMBER || true

echo "Deployment process finished."
```

```bash
# 🔑 Make the script executable
chmod +x deploy.sh
```

Update `.travis.yml` to use the deployment script — replace the `after_success` section:
```yaml
# 🚀 Deploy using custom script
after_success:
  - ./deploy.sh
```

```bash
# 💾 Commit the changes
git add deploy.sh .travis.yml
git commit -m "Add custom deployment script"
git push origin main
```
✅ **Sign of success:** `deploy.sh` runs end-to-end and prints "Deployment process finished."

---

## 🧪 Task 4: Set up Testing Steps Within the Docker Container

![Docker](https://img.shields.io/badge/Multi--Stage_Build-2496ED?style=flat-square&logo=docker&logoColor=white)
![Jest](https://img.shields.io/badge/Jest-C21325?style=flat-square&logo=jest&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat-square&logo=docker&logoColor=white)

### 🏗️ Subtask 4.1: Create Multi-Stage Dockerfile for Testing

```bash
nano Dockerfile
```

```dockerfile
# 🏗️ Multi-stage build for testing and production

# 1️⃣ Stage 1: Testing stage
FROM node:18-alpine AS testing
WORKDIR /usr/src/app

# 📋 Copy package files
COPY package*.json ./

# 📥 Install all dependencies (including dev dependencies)
RUN npm ci

# 📂 Copy source code
COPY . .

# 🧪 Run tests
RUN npm test

# 2️⃣ Stage 2: Production stage
FROM node:18-alpine AS production

# 📁 Set working directory
WORKDIR /usr/src/app

# 📋 Copy package files
COPY package*.json ./

# 📥 Install only production dependencies
RUN npm ci --only=production && npm cache clean --force

# 📂 Copy application code
COPY --from=testing /usr/src/app/app.js ./

# 🔒 Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# 🔑 Change ownership
RUN chown -R nodejs:nodejs /usr/src/app
USER nodejs

# 🌐 Expose port
EXPOSE 3000

# 🩺 Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# ▶️ Start application
CMD ["npm", "start"]
```
✅ **Sign of success:** `docker build --target testing` fails the build if any test fails.

### ➕ Subtask 4.2: Add Integration Tests

```bash
nano integration.test.js
```

```javascript
// 🔗 Integration tests covering app behavior end-to-end
const request = require('supertest');
const { app, server } = require('./app');

describe('Integration Tests', () => {
    afterAll(() => {
        server.close();
    });

    test('Application should start successfully', async () => {
        const response = await request(app).get('/');
        expect(response.status).toBe(200);
    });

    test('Health endpoint should return correct format', async () => {
        const response = await request(app).get('/health');
        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('status');
        expect(response.body).toHaveProperty('uptime');
        expect(typeof response.body.uptime).toBe('number');
    });

    test('Root endpoint should return timestamp', async () => {
        const response = await request(app).get('/');
        expect(response.body).toHaveProperty('timestamp');
        expect(new Date(response.body.timestamp)).toBeInstanceOf(Date);
    });

    test('Application should handle invalid routes', async () => {
        const response = await request(app).get('/nonexistent');
        expect(response.status).toBe(404);
    });
    // TODO: Add tests for any additional routes you introduce
});
```

### 🔧 Subtask 4.3: Update Travis CI Configuration for Container Testing

```bash
nano .travis.yml
```

```yaml
# 🔤 Specify the programming language
language: node_js

# 🔢 Specify Node.js version
node_js:
  - "18"

# 🐳 Enable Docker service
services:
  - docker

# 🌍 Environment variables
env:
  global:
    - DOCKER_IMAGE_NAME=$DOCKER_USERNAME/docker-travis-ci-lab
    - NODE_ENV=test

# ⚡ Cache node_modules for faster builds
cache:
  directories:
    - node_modules

# 📥 Install dependencies
install:
  - npm ci

# 🧪 Run tests in multiple stages
script:
  # 1️⃣ Stage 1: Run unit tests locally
  - echo "Running unit tests..."
  - npm test

  # 2️⃣ Stage 2: Build Docker image (includes testing stage)
  - echo "Building Docker image with tests..."
  - docker build --target testing -t $DOCKER_IMAGE_NAME:test .

  # 3️⃣ Stage 3: Build production image
  - echo "Building production Docker image..."
  - docker build --target production -t $DOCKER_IMAGE_NAME:$TRAVIS_BUILD_NUMBER .
  - docker build --target production -t $DOCKER_IMAGE_NAME:latest .

# 🩺 Test the production Docker image
before_deploy:
  - echo "Testing production Docker image..."

  # ▶️ Start container
  - docker run -d -p 3000:3000 --name test-container $DOCKER_IMAGE_NAME:latest

  # ⏳ Wait for container to start
  - sleep 15

  # 🩺 Test health endpoint
  - docker exec test-container curl -f http://localhost:3000/health || exit 1

  # 🌐 Test main endpoint
  - docker exec test-container curl -f http://localhost:3000 || exit 1

  # 📜 Check container logs
  - docker logs test-container

  # 🖥️ Test from host machine
  - curl -f http://localhost:3000/health || exit 1

  # 🧹 Clean up
  - docker stop test-container
  - docker rm test-container

# 🚀 Deploy to Docker Hub
after_success:
  - echo "Deploying to Docker Hub..."
  - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  - docker push $DOCKER_IMAGE_NAME:$TRAVIS_BUILD_NUMBER
  - docker push $DOCKER_IMAGE_NAME:latest
  - echo "Deployment completed successfully!"

# 🌿 Only build main branch and pull requests
branches:
  only:
    - main

# 📧 Notification settings
notifications:
  email:
    on_success: change
    on_failure: always
```
✅ **Sign of success:** the Travis log shows all three script stages plus the container health/main-endpoint tests passing.

### 🧩 Subtask 4.4: Add Docker Compose for Local Testing

```bash
nano docker-compose.yml
```

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      target: production
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    restart: unless-stopped

  test:
    build:
      context: .
      target: testing
    environment:
      - NODE_ENV=test
    command: npm test
```

```bash
nano docker-compose.test.yml
```

```yaml
version: '3.8'

services:
  sut:
    build:
      context: .
      target: testing
    environment:
      - NODE_ENV=test
    command: npm test
```

```bash
# 💾 Commit all changes
git add .
git commit -m "Add comprehensive Docker testing setup"
git push origin main
```
✅ **Sign of success:** `docker-compose up --build` starts the app and passes its healthcheck locally.

---

## 📈 Task 5: Monitor Travis CI Build Logs and Troubleshoot

![Travis CI](https://img.shields.io/badge/Travis_CI-3EAAAF?style=flat-square&logo=travisci&logoColor=white)
![Slack](https://img.shields.io/badge/Slack_Notifications-4A154B?style=flat-square&logo=slack&logoColor=white)

### 📊 Subtask 5.1: Understanding Travis CI Build Logs

**Access Travis CI Dashboard:**
1. 🌐 Go to [travis-ci.com](https://travis-ci.com)
2. 🗂️ Navigate to your repository
3. 🖱️ Click on the latest build

**Understanding Build Stages** — the build log will show these stages:
| Stage | Purpose |
|---|---|
| 📥 Install | Installing dependencies |
| 🧪 Script | Running tests and building Docker images |
| 🩺 Before Deploy | Testing the Docker container |
| 🚀 After Success | Deploying to Docker Hub |

### 🛠️ Subtask 5.2: Common Issues and Troubleshooting

```bash
# 📝 Create a troubleshooting guide
nano TROUBLESHOOTING.md
```

```markdown
# Travis CI Docker Build Troubleshooting Guide

## Common Issues and Solutions

### 1. Docker Build Failures
**Issue**: Docker build fails with "COPY failed" error
**Solution**: Check .dockerignore file and ensure all required files are included

**Issue**: Node.js dependencies installation fails
**Solution**: Ensure package.json and package-lock.json are properly committed

### 2. Test Failures
**Issue**: Tests pass locally but fail in Travis CI
**Solution**: Check environment variables and ensure test database/services are available

**Issue**: Container health check fails
**Solution**: Increase sleep time in before_deploy section or adjust health check timeout

### 3. Docker Hub Push Failures
**Issue**: Authentication failed when pushing to Docker Hub
**Solution**: Verify DOCKER_USERNAME and DOCKER_PASSWORD environment variables in Travis CI settings

**Issue**: Repository not found error
**Solution**: Ensure Docker Hub repository exists and username is correct

### 4. Build Timeout Issues
**Issue**: Build times out during Docker operations
**Solution**: Optimize Dockerfile using multi-stage builds and .dockerignore

### 5. Environment Variable Issues
**Issue**: Environment variables not available in build
**Solution**: Check Travis CI repository settings and ensure variables are properly set
```

### 🏷️ Subtask 5.3: Add Build Status and Monitoring

```bash
nano README.md
```

```markdown
# Docker Travis CI Lab

[![Build Status](https://travis-ci.com/YOUR-USERNAME/docker-travis-ci-lab.svg?branch=main)](https://travis-ci.com/YOUR-USERNAME/docker-travis-ci-lab)
[![Docker Hub](https://img.shields.io/docker/pulls/YOUR-DOCKERHUB-USERNAME/docker-travis-ci-lab.svg)](https://hub.docker.com/r/YOUR-DOCKERHUB-USERNAME/docker-travis-ci-lab)

A sample Node.js application demonstrating Docker integration with Travis CI for continuous integration and deployment.

## Features
- Dockerized Node.js application
- Automated testing with Jest
- Multi-stage Docker builds
- Continuous integration with Travis CI
- Automated deployment to Docker Hub
- Health checks and monitoring

## Local Development

### Prerequisites
- Docker
- Node.js 18+
- npm

### Running Locally
1. Clone the repository:
   git clone https://github.com/YOUR-USERNAME/docker-travis-ci-lab.git
   cd docker-travis-ci-lab
2. Install dependencies: npm install
3. Run tests: npm test
4. Run with Docker: docker-compose up --build
5. Access the application:
   - Main endpoint: http://localhost:3000
   - Health check: http://localhost:3000/health

## CI/CD Pipeline
This project uses Travis CI for continuous integration and deployment:
1. Test Stage: Runs unit and integration tests
2. Build Stage: Creates Docker images
3. Test Stage: Tests the Docker container
4. Deploy Stage: Pushes images to Docker Hub

## Docker Hub
The built images are available at: https://hub.docker.com/r/YOUR-DOCKERHUB-USERNAME/docker-travis-ci-lab
```
> `# TODO:` Replace `YOUR-USERNAME` and `YOUR-DOCKERHUB-USERNAME` with your actual usernames.

### 📡 Subtask 5.4: Create Monitoring Script

```bash
nano monitor-build.sh
```

```bash
#!/bin/bash

# 📡 Travis CI Build Monitor Script

REPO_SLUG="YOUR-USERNAME/docker-travis-ci-lab"
TRAVIS_API="https://api.travis-ci.com"

echo "Monitoring Travis CI builds for $REPO_SLUG"
echo "=========================================="

# 📊 Get latest build status
curl -s -H "Travis-API-Version: 3" \
     "$TRAVIS_API/repo/$REPO_SLUG/builds?limit=5" | \
     jq -r '.builds[] | "Build #\(.number): \(.state) (\(.branch)) - \(.started_at)"'

echo ""
echo "For detailed logs, visit:"
echo "https://travis-ci.com/$REPO_SLUG"
```

```bash
# 🔑 Make it executable
chmod +x monitor-build.sh
```
✅ **Sign of success:** the script prints the last 5 builds with their state (`passed`/`failed`/`started`).

### 🚦 Subtask 5.5: Test the Complete Pipeline

```bash
# ✏️ Make a small change to trigger a build
echo "console.log('Build triggered at: ' + new Date());" >> app.js

# 💾 Commit and push
git add .
git commit -m "Trigger Travis CI build for testing"
git push origin main
```

**Monitor the build:**
1. 🌐 Go to Travis CI dashboard
2. 👀 Watch the build progress
3. 🔍 Check each stage for any issues

**Verify deployment:**
```bash
# 🐳 Check Docker Hub for the new image, then pull and test it locally
docker pull YOUR-DOCKERHUB-USERNAME/docker-travis-ci-lab:latest
docker run -p 3000:3000 -d YOUR-DOCKERHUB-USERNAME/docker-travis-ci-lab:latest
curl http://localhost:3000
```
✅ **Sign of success:** the pulled image runs and responds with the expected JSON payload.

### 🔔 Subtask 5.6: Set up Build Notifications

Update `.travis.yml` with Slack notifications (optional):
```yaml
notifications:
  email:
    on_success: change
    on_failure: always
  slack:
    rooms:
      - your-workspace:your-token#your-channel
    on_success: change
    on_failure: always
    template:
      - "Build <%{build_url}|#%{build_number}> (<%{compare_url}|%{commit}>) of %{repository_slug}@%{branch} by %{author} %{result} in %{duration}"
# TODO: Replace the Slack workspace/token/channel placeholders with your own
```

```bash
# 💾 Final commit
git add .
git commit -m "Complete Travis CI Docker integration setup"
git push origin main
```
✅ **Sign of success:** a Slack message (or email) arrives after the next build completes.

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔴 Issue 1: Docker Build Failures</summary>

**"COPY failed" error** → check your `.dockerignore` file and ensure all required files are included.

**Node.js dependency installation fails** → ensure `package.json` and `package-lock.json` are properly committed.
</details>

<details>
<summary>🟠 Issue 2: Test Failures</summary>

**Tests pass locally but fail in Travis CI** → check environment variables and ensure test database/services are available.

**Container health check fails** → increase sleep time in the `before_deploy` section or adjust the health check timeout.
</details>

<details>
<summary>🟡 Issue 3: Docker Hub Push Failures</summary>

**Authentication failed when pushing to Docker Hub** → verify `DOCKER_USERNAME` and `DOCKER_PASSWORD` environment variables in Travis CI settings.

**Repository not found error** → ensure the Docker Hub repository exists and the username is correct.
</details>

<details>
<summary>🔵 Issue 4: Build Timeout Issues</summary>

**Build times out during Docker operations** → optimize the Dockerfile using multi-stage builds and `.dockerignore`.
</details>

<details>
<summary>🟣 Issue 5: Environment Variable Issues</summary>

**Environment variables not available in build** → check Travis CI repository settings and ensure variables are properly set.
</details>

---

## 📊 Key Concepts Summary

> This is a CI/CD infrastructure lab with no detection targets, so a MITRE ATT&CK mapping is not applicable here — the table below covers the core pipeline concepts instead.

| Concept | Description |
|---|---|
| 🧪 **Multi-Stage Build** | Separates a `testing` stage (runs the test suite) from a lean `production` stage shipped to Docker Hub |
| 📄 **`.travis.yml`** | Declarative pipeline definition: `install` → `script` → `before_deploy` → `after_success` |
| 🔐 **Secured Env Vars** | `DOCKER_USERNAME`/`DOCKER_PASSWORD` stored as hidden Travis CI repository variables, never committed to Git |
| 🩺 **Container Health Gate** | `before_deploy` runs the built image and curls `/health` before anything is pushed |
| 🏷️ **Image Tagging Strategy** | Every build is tagged with `$TRAVIS_BUILD_NUMBER` alongside `latest` for traceable rollbacks |
| 📡 **Build Monitoring** | Travis CI dashboard + Slack/email notifications + a custom `monitor-build.sh` polling the Travis API |

---

## 🎓 Conclusion

Congratulations! You have successfully completed **Lab 97: Docker for Continuous Integration — Integrating Docker with Travis CI**.

### 🏆 What You Accomplished
- 🐳 **Created a Dockerized Web Application** — built a Node.js application with proper containerization using multi-stage Docker builds
- 🔄 **Set up Travis CI Integration** — configured automated builds triggered by Git commits
- 🧪 **Implemented Automated Testing** — created comprehensive test suites that run both locally and in Docker containers
- 📤 **Configured Automated Deployment** — set up automatic pushing of Docker images to Docker Hub after successful builds
- 📈 **Established Monitoring and Troubleshooting** — created monitoring tools and troubleshooting guides for the CI/CD pipeline

### 💡 Why This Matters
- ✅ **Continuous Integration** — automatically testing code changes prevents bugs from reaching production
- 📦 **Containerization** — Docker ensures consistent environments across development, testing, and production
- 🚀 **Automated Deployment** — reduces manual errors and speeds up the release process
- 📜 **Infrastructure as Code** — configuration files like `.travis.yml` make the build process reproducible and version-controlled

### 🔑 Key Takeaways
- 🏗️ **Docker Multi-Stage Builds** — optimize image size and separate testing from production environments
- 🧩 **CI/CD Pipeline Design** — structure builds with clear stages for testing, building, and deployment
- 🔐 **Environment Management** — properly handle secrets and environment variables in CI systems
- 📡 **Monitoring and Alerting** — set up proper monitoring to quickly identify and resolve issues

### ➡️ Next Steps
- 🔄 Explore other CI platforms like GitHub Actions or GitLab CI
- 🟢🔵 Implement more sophisticated deployment strategies (blue-green, canary)
- 🛡️ Add security scanning to your Docker images
- ☁️ Integrate with cloud platforms like AWS, Azure, or Google Cloud
- 📊 Set up monitoring and logging for production applications

> 🎖️ This foundation in Docker and Travis CI will serve you well as you continue to build and deploy modern applications using DevOps best practices.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
