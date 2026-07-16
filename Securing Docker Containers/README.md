<div align="center">

# 🔒 Securing Docker Containers

### Non-Root Users, Content Trust, Vulnerability Scanning, and Privilege Hardening

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![Alpine Linux](https://img.shields.io/badge/Alpine_Linux-0D597F?style=for-the-badge&logo=alpinelinux&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

</div>

---

## 📖 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [👤 Task 1: Run Containers as Non-Root Users](#-task-1-run-containers-as-non-root-users)
- [✍️ Task 2: Implement Docker Content Trust](#️-task-2-implement-docker-content-trust)
- [🔍 Task 3: Security Scanning with Docker Scout](#-task-3-security-scanning-with-docker-scout)
- [🚫 Task 4: Limit Container Privileges](#-task-4-limit-container-privileges)
- [📁 Task 5: Use Read-Only File Systems](#-task-5-use-read-only-file-systems)
- [🛡️ Task 6: Comprehensive Security Implementation](#️-task-6-comprehensive-security-implementation)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🧹 Lab Cleanup](#-lab-cleanup)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

| # | Skill |
|---|-------|
| 1️⃣ | Implement Docker security best practices for containerized applications |
| 2️⃣ | Configure containers to run as non-root users using the `USER` directive |
| 3️⃣ | Set up Docker Content Trust and sign images for enhanced security |
| 4️⃣ | Use security scanning tools to identify vulnerabilities in container images |
| 5️⃣ | Limit container privileges using security options and capability dropping |
| 6️⃣ | Implement read-only file systems for containers to enhance security posture |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker Basics | Understanding of Docker concepts (containers, images, Dockerfile) |
| 🐧 Linux CLI | Familiarity with Linux command line operations |
| 🔒 Security Concepts | Knowledge of basic security concepts |
| 🔑 Permissions | Understanding of user permissions and file systems in Linux |

---

## 🖥️ Lab Environment Setup

> ℹ️ **Ready-to-Use Cloud Machines:** Al Nafi provides Linux-based cloud machines with Docker pre-installed. Simply click **"Start Lab"** to begin — no need to build your own VM or install Docker manually.

Your lab environment includes:

- ✅ Ubuntu 20.04 LTS with Docker Engine installed
- ✅ Docker Compose pre-configured
- ✅ All necessary security scanning tools
- ✅ Sample applications for testing

---

## 👤 Task 1: Run Containers as Non-Root Users

### 📚 Understanding the Security Risk

Running containers as root poses significant security risks. If an attacker compromises your container, they gain root access to the host system. This task demonstrates how to create and run containers with non-privileged users.

### 🔹 Subtask 1.1: Create a Dockerfile with Non-Root User

First, let's create a simple web application that runs as a non-root user.

**Create a new directory for your secure application:**
```bash
mkdir secure-app   # 📁 project workspace
cd secure-app
```

**Create a simple Python web application:**
```python
cat > app.py << 'EOF'
from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return f"Hello from secure container! Running as user: {os.getuid()}"   # 👤 report UID

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
EOF
```

**Create a requirements file:**
```bash
cat > requirements.txt << 'EOF'
Flask==2.3.3
EOF
```

**Create a secure Dockerfile:**
```dockerfile
cat > Dockerfile << 'EOF'
FROM python:3.9-slim

# 👤 Create a non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# 📁 Set working directory
WORKDIR /app

# 📦 Copy requirements and install dependencies as root
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 📄 Copy application files
COPY app.py .

# 🔐 Change ownership of the app directory to appuser
RUN chown -R appuser:appuser /app

# 👤 Switch to non-root user
USER appuser

# 🔌 Expose port
EXPOSE 8080

# ▶️ Run the application
CMD ["python", "app.py"]
EOF
```

### 🔹 Subtask 1.2: Build and Test the Secure Image

**Build the Docker image:**
```bash
docker build -t secure-app:v1 .   # 🏗️ build
```

**Run the container and verify it's running as non-root:**
```bash
docker run -d -p 8080:8080 --name secure-app-container secure-app:v1   # ▶️ run
```

**Check the running processes inside the container:**
```bash
docker exec secure-app-container ps aux   # ⚙️ process check
```

**Test the application:**
```bash
curl http://localhost:8080   # 🌐 endpoint test
```

**Verify the user ID (should not be 0 for root):**
```bash
docker exec secure-app-container id   # 👤 confirm non-root
```

**Clean up:**
```bash
docker stop secure-app-container
docker rm secure-app-container
```

> 📝 `# TODO:` Try removing the `USER appuser` line, rebuild, and compare the `id` output — confirm you can see the difference a non-root user makes.

---

## ✍️ Task 2: Implement Docker Content Trust

### 📚 Understanding Docker Content Trust

Docker Content Trust provides cryptographic signing of Docker images, ensuring image integrity and authenticity. This prevents tampering and ensures you're running trusted images.

### 🔹 Subtask 2.1: Enable Docker Content Trust

**Enable Docker Content Trust globally:**
```bash
export DOCKER_CONTENT_TRUST=1   # ✍️ enable signing enforcement
```

**Verify the environment variable is set:**
```bash
echo $DOCKER_CONTENT_TRUST   # ✅ confirm
```

### 🔹 Subtask 2.2: Generate Signing Keys

**Create a directory for trust data:**
```bash
mkdir -p ~/.docker/trust   # 📁 trust data dir
```

**Initialize trust for your repository (replace 'yourusername' with your actual username):**
```bash
docker trust key generate mykey   # 🔑 generate signing key
```

**Add the key to your repository:**
```bash
docker trust signer add --key mykey.pub mykey secure-app   # ➕ register signer
```

### 🔹 Subtask 2.3: Sign and Push Images

**Tag your image for signing:**
```bash
docker tag secure-app:v1 localhost:5000/secure-app:signed   # 🏷️ tag for registry
```

**Start a local registry for testing:**
```bash
docker run -d -p 5000:5000 --name registry registry:2   # 🗄️ local registry
```

**Push the signed image:**
```bash
docker push localhost:5000/secure-app:signed   # ⬆️ signed push
```

**Verify the signature:**
```bash
docker trust inspect localhost:5000/secure-app:signed   # 🔍 signature detail
```

### 🔹 Subtask 2.4: Test Content Trust Verification

**Try to pull an unsigned image (this should fail):**
```bash
docker pull hello-world   # ❌ blocked by content trust
```

**Disable content trust temporarily and pull:**
```bash
export DOCKER_CONTENT_TRUST=0
docker pull hello-world   # ✅ succeeds with trust disabled
export DOCKER_CONTENT_TRUST=1
```

> 📝 `# TODO:` Try pulling a second unsigned public image with trust re-enabled and confirm it's blocked the same way `hello-world` was.

---

## 🔍 Task 3: Security Scanning with Docker Scout

### 📚 Understanding Security Scanning

Security scanning identifies known vulnerabilities in your container images by checking against vulnerability databases. Docker Scout is Docker's built-in security scanning tool.

### 🔹 Subtask 3.1: Enable Docker Scout

**Check if Docker Scout is available:**
```bash
docker scout version   # 🔍 availability check
```

**If not available, update Docker to the latest version or install Docker Scout:**
```bash
curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s --   # ⬇️ install CLI
```

### 🔹 Subtask 3.2: Scan Images for Vulnerabilities

**Scan your secure application image:**
```bash
docker scout cves secure-app:v1   # 🔎 CVE scan
```

**Get a detailed vulnerability report:**
```bash
docker scout cves --format sarif --output secure-app-scan.json secure-app:v1   # 📄 SARIF report
```

**Scan a base image to compare:**
```bash
docker scout cves python:3.9-slim   # 🔎 base image scan
```

### 🔹 Subtask 3.3: Compare Image Security

**Compare your image with a different base image:**
```bash
docker scout compare secure-app:v1 --to python:3.9-alpine   # ⚖️ comparison
```

**Get recommendations for improving security:**
```bash
docker scout recommendations secure-app:v1   # 💡 suggestions
```

### 🔹 Subtask 3.4: Create a More Secure Dockerfile

**Based on scanning results, create an improved Dockerfile:**
```dockerfile
cat > Dockerfile.secure << 'EOF'
# 🏔️ Use a more secure base image
FROM python:3.9-alpine

# 🔐 Install security updates
RUN apk update && apk upgrade && apk add --no-cache \
    && rm -rf /var/cache/apk/*

# 👤 Create non-root user
RUN addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser

# 📁 Set working directory
WORKDIR /app

# 📦 Copy and install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 📄 Copy application
COPY app.py .

# 🔐 Set ownership
RUN chown -R appuser:appuser /app

# 👤 Switch to non-root user
USER appuser

# 🔌 Use non-root port
EXPOSE 8080

# 💓 Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

CMD ["python", "app.py"]
EOF
```

**Build and scan the improved image:**
```bash
docker build -f Dockerfile.secure -t secure-app:v2 .
docker scout cves secure-app:v2   # 🔎 rescan improved image
```

> 📝 `# TODO:` Compare the CVE counts between `secure-app:v1` and `secure-app:v2` and note which vulnerabilities the Alpine switch eliminated.

---

## 🚫 Task 4: Limit Container Privileges

### 📚 Understanding Container Privileges

By default, containers run with many Linux capabilities that may not be necessary for your application. Limiting these privileges reduces the attack surface.

### 🔹 Subtask 4.1: Drop Unnecessary Capabilities

**First, let's see what capabilities a container normally has:**
```bash
docker run --rm alpine:latest sh -c "apk add --no-cache libcap && capsh --print"   # 🔍 default capabilities
```

**Run a container with dropped capabilities:**
```bash
docker run -d --name limited-container \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  -p 8081:8080 \
  secure-app:v2   # 🚫 minimal capability set
```

**Verify the container is running with limited capabilities:**
```bash
docker exec limited-container sh -c "apk add --no-cache libcap && capsh --print"   # ✅ confirm dropped caps
```

### 🔹 Subtask 4.2: Use Security Options

**Run a container with additional security options:**
```bash
docker run -d --name secure-container \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  --security-opt=no-new-privileges:true \
  --security-opt=apparmor:docker-default \
  -p 8082:8080 \
  secure-app:v2   # 🛡️ hardened run
```

**Verify the security options are applied:**
```bash
docker inspect secure-container | grep -A 10 "SecurityOpt"   # 🔍 confirm options
```

### 🔹 Subtask 4.3: Test Privilege Limitations

**Try to perform privileged operations in the limited container:**
```bash
# ❌ This should fail
docker exec limited-container mount -t tmpfs tmpfs /tmp/test
```

**Compare with a regular container:**
```bash
docker run --rm --privileged alpine:latest mount -t tmpfs tmpfs /tmp/test   # ⚠️ privileged succeeds
```

**Clean up containers:**
```bash
docker stop limited-container secure-container
docker rm limited-container secure-container
```

> 📝 `# TODO:` Add just one more capability (e.g. `CHOWN`) to `--cap-add` and re-test which operations become possible.

---

## 📁 Task 5: Use Read-Only File Systems

### 📚 Understanding Read-Only File Systems

Read-only file systems prevent malicious code from writing to the container's file system, significantly improving security by limiting the impact of potential compromises.

### 🔹 Subtask 5.1: Create Application with Temporary Storage

**Create an improved application that uses temporary storage:**
```python
cat > app_readonly.py << 'EOF'
from flask import Flask, request, jsonify
import os
import tempfile
import json

app = Flask(__name__)

@app.route('/')
def hello():
    return f"Hello from read-only container! Running as user: {os.getuid()}"

@app.route('/write-test', methods=['POST'])
def write_test():
    try:
        # ✅ This will work - writing to /tmp
        with tempfile.NamedTemporaryFile(mode='w', delete=False, dir='/tmp') as f:
            f.write("Temporary data")
            temp_file = f.name

        return jsonify({
            "status": "success",
            "message": f"Successfully wrote to {temp_file}",
            "writable_dirs": ["/tmp"]
        })
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        })

@app.route('/illegal-write', methods=['POST'])
def illegal_write():
    try:
        # ❌ This will fail in read-only mode
        with open('/app/illegal_file.txt', 'w') as f:
            f.write("This should not work")
        return jsonify({"status": "success", "message": "File written"})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
EOF
```

### 🔹 Subtask 5.2: Create Dockerfile for Read-Only Application

**Create a Dockerfile optimized for read-only operation:**
```dockerfile
cat > Dockerfile.readonly << 'EOF'
FROM python:3.9-alpine

# 🔐 Install dependencies and create user
RUN apk update && apk upgrade && \
    addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser

# 📁 Set working directory
WORKDIR /app

# 📦 Copy and install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 📄 Copy application
COPY app_readonly.py .

# 🗂️ Create necessary directories and set permissions
RUN mkdir -p /tmp/app-data && \
    chown -R appuser:appuser /app /tmp/app-data

# 👤 Switch to non-root user
USER appuser

EXPOSE 8080

CMD ["python", "app_readonly.py"]
EOF
```

**Build the read-only optimized image:**
```bash
docker build -f Dockerfile.readonly -t readonly-app:v1 .   # 🏗️ build
```

### 🔹 Subtask 5.3: Run Container with Read-Only File System

**Run the container with read-only file system:**
```bash
docker run -d --name readonly-container \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=100m \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  --security-opt=no-new-privileges:true \
  -p 8083:8080 \
  readonly-app:v1   # 📁 read-only run
```

### 🔹 Subtask 5.4: Test Read-Only Restrictions

**Test that the application works normally:**
```bash
curl http://localhost:8083/   # 🌐 basic test
```

**Test writing to allowed temporary directory:**
```bash
curl -X POST http://localhost:8083/write-test   # ✅ tmpfs write
```

**Test writing to read-only file system (should fail):**
```bash
curl -X POST http://localhost:8083/illegal-write   # ❌ blocked write
```

**Try to create files directly in the container:**
```bash
# ❌ This should fail
docker exec readonly-container touch /app/test-file.txt

# ✅ This should work
docker exec readonly-container touch /tmp/test-file.txt
```

### 🔹 Subtask 5.5: Monitor File System Access

**Check what directories are writable:**
```bash
docker exec readonly-container df -h   # 💾 filesystem overview
```

**Verify mount options:**
```bash
docker exec readonly-container mount | grep -E "(tmpfs|ro)"   # 🔍 mount flags
```

**Clean up:**
```bash
docker stop readonly-container
docker rm readonly-container
```

> 📝 `# TODO:` Add a second `tmpfs` mount (e.g. `/var/tmp`) and confirm your application can use it the same way it uses `/tmp`.

---

## 🛡️ Task 6: Comprehensive Security Implementation

### 🔹 Subtask 6.1: Create a Fully Secured Container

Combine all security practices into one comprehensive example:

```yaml
cat > docker-compose.secure.yml << 'EOF'
version: '3.8'

services:
  secure-web-app:
    build:
      context: .
      dockerfile: Dockerfile.readonly
    ports:
      - "8084:8080"
    read_only: true                         # 📁 read-only root filesystem
    tmpfs:
      - /tmp:rw,noexec,nosuid,size=100m
    cap_drop:
      - ALL                                  # 🚫 drop everything
    cap_add:
      - NET_BIND_SERVICE                     # ➕ only what's needed
    security_opt:
      - no-new-privileges:true
      - apparmor:docker-default
    user: "1001:1001"                        # 👤 explicit non-root UID/GID
    environment:
      - PYTHONUNBUFFERED=1
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:8080/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
EOF
```

### 🔹 Subtask 6.2: Deploy and Test Secure Application

**Deploy the secure application:**
```bash
docker-compose -f docker-compose.secure.yml up -d   # 🚀 deploy
```

**Verify the application is running securely:**
```bash
docker-compose -f docker-compose.secure.yml ps   # 📋 status
```

**Test the application functionality:**
```bash
curl http://localhost:8084/
curl -X POST http://localhost:8084/write-test
curl -X POST http://localhost:8084/illegal-write
```

**Check security settings:**
```bash
docker inspect $(docker-compose -f docker-compose.secure.yml ps -q) | grep -A 20 "SecurityOpt"   # 🔍 confirm hardening
```

### 🔹 Subtask 6.3: Security Audit

**Perform a final security scan:**
```bash
docker scout cves readonly-app:v1   # 🔎 final CVE check
```

**Check for running processes:**
```bash
docker exec $(docker-compose -f docker-compose.secure.yml ps -q) ps aux   # ⚙️ process audit
```

**Verify file system permissions:**
```bash
docker exec $(docker-compose -f docker-compose.secure.yml ps -q) ls -la /   # 🔐 permission audit
```

**Test privilege escalation (should fail):**
```bash
docker exec $(docker-compose -f docker-compose.secure.yml ps -q) su -   # ❌ blocked by no-new-privileges
```

> 📝 `# TODO:` Add your own least-privilege capability (only what your real app needs) to `docker-compose.secure.yml` and re-run the full audit sequence.

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>✍️ Issue 1: Docker Content Trust Errors</summary>

**Problem:** Content trust signing fails

**Solution:**
```bash
# Reset trust data
rm -rf ~/.docker/trust
# Reinitialize
docker trust key generate mykey
```
</details>

<details>
<summary>📁 Issue 2: Permission Denied in Read-Only Containers</summary>

**Problem:** Application fails to start due to write permissions

**Solution:**
```bash
# Ensure proper tmpfs mounts
--tmpfs /tmp:rw,noexec,nosuid,size=100m
--tmpfs /var/tmp:rw,noexec,nosuid,size=50m
```
</details>

<details>
<summary>🔍 Issue 3: Security Scanning Tool Not Found</summary>

**Problem:** Docker Scout not available

**Solution:**
```bash
# Install Docker Scout CLI
curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s --
# Or use alternative tools
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image secure-app:v1
```
</details>

<details>
<summary>🚫 Issue 4: Capability Issues</summary>

**Problem:** Application needs specific capabilities

**Solution:**
```bash
# Identify required capabilities
strace -e trace=capget,capset docker run --rm your-image
# Add only necessary capabilities
--cap-add=NET_ADMIN  # Only if needed
```
</details>

---

## 🧹 Lab Cleanup

Clean up all resources created during this lab:

```bash
# 🛑 Stop and remove containers
docker-compose -f docker-compose.secure.yml down
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true

# 🗑️ Remove images
docker rmi secure-app:v1 secure-app:v2 readonly-app:v1 2>/dev/null || true

# 🗑️ Remove local registry
docker stop registry && docker rm registry 2>/dev/null || true

# 🧽 Clean up files
rm -rf secure-app/
rm -f *.json *.pub mykey

# ↩️ Reset Docker Content Trust
unset DOCKER_CONTENT_TRUST
```

---

## 🏁 Conclusion

In this comprehensive lab, you have successfully implemented multiple layers of Docker container security:

### 🔑 Key Accomplishments

- 👤 **Non-Root User Implementation** — You learned to create and run containers with non-privileged users, significantly reducing the attack surface if a container is compromised
- ✍️ **Docker Content Trust** — You implemented cryptographic signing and verification of container images, ensuring image integrity and authenticity in your deployment pipeline
- 🔍 **Security Scanning** — You used Docker Scout to identify vulnerabilities in container images and learned to create more secure base images based on scan results
- 🚫 **Privilege Limitation** — You successfully dropped unnecessary Linux capabilities and applied security options to limit what containers can do on the host system
- 📁 **Read-Only File Systems** — You implemented read-only containers with proper temporary storage, preventing malicious code from persisting changes to the container file system

### 💡 Why This Matters

Container security is critical in production environments because:

| Principle | Why It Matters |
|---|---|
| 🧱 Defense in Depth | Multiple security layers provide better protection than relying on a single security measure |
| 📜 Compliance Requirements | Many industries require specific security controls for containerized applications |
| ⚠️ Risk Mitigation | Proper security practices significantly reduce the impact of potential security breaches |
| 🤝 Trust and Reliability | Signed and scanned images ensure you're running trusted, vulnerability-free code |

### 🌍 Real-World Applications

These security practices are essential for:

- ☁️ Production deployments in cloud environments
- 🔄 CI/CD pipelines requiring secure image handling
- 📋 Compliance with security frameworks like NIST, CIS, or SOC 2
- 🏢 Multi-tenant environments where container isolation is critical

> 🎉 By mastering these Docker security techniques, you're now equipped to deploy containers safely in production environments and contribute to your organization's security posture. These skills are highly valued in the industry and directly applicable to Docker Certified Associate (DCA) certification requirements.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E90FF?style=for-the-badge)

</div>
