<div align="center">

# 📦 Docker Registry — Creating a Private Docker Registry

### TLS, Authentication, Content Trust, and Registry Operations

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Registry](https://img.shields.io/badge/Docker_Registry-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![OpenSSL](https://img.shields.io/badge/OpenSSL-721412?style=for-the-badge&logo=openssl&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Alpine Linux](https://img.shields.io/badge/Alpine_Linux-0D597F?style=for-the-badge&logo=alpinelinux&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

</div>

---

## 📖 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [📦 Task 1: Setting Up a Private Docker Registry](#-task-1-setting-up-a-private-docker-registry)
- [🔐 Task 2: Implementing Authentication and Security](#-task-2-implementing-authentication-and-security)
- [🔓 Task 3: Testing Authenticated Registry Operations](#-task-3-testing-authenticated-registry-operations)
- [✍️ Task 4: Docker Content Trust and Image Signing](#️-task-4-docker-content-trust-and-image-signing)
- [🧹 Task 5: Registry Storage Management and Best Practices](#-task-5-registry-storage-management-and-best-practices)
- [🚀 Task 6: Advanced Registry Features and Troubleshooting](#-task-6-advanced-registry-features-and-troubleshooting)
- [✅ Verification and Testing](#-verification-and-testing)
- [🧽 Cleanup (Optional)](#-cleanup-optional)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

| # | Skill |
|---|-------|
| 1️⃣ | Set up and configure a private Docker registry on a local machine |
| 2️⃣ | Push and pull Docker images to/from a private registry |
| 3️⃣ | Implement authentication and secure access using TLS certificates |
| 4️⃣ | Configure Docker content trust and image signing policies |
| 5️⃣ | Apply best practices for registry storage management and cleanup |
| 6️⃣ | Understand the security implications of running a private Docker registry |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐳 Docker Basics | Understanding of Docker concepts (containers, images, Dockerfile) |
| 🐧 Linux CLI | Familiarity with Linux command line operations |
| 🌐 Networking | Knowledge of basic networking concepts (ports, IP addresses) |
| 🔒 TLS/SSL | Understanding of SSL/TLS certificates (basic level) |
| 💻 Docker CLI | Experience with Docker CLI commands |

---

## 🖥️ Lab Environment Setup

> ℹ️ **Ready-to-Use Cloud Machines:** Al Nafi provides pre-configured Linux-based cloud machines for this lab. Simply click **"Start Lab"** to access your environment — no need to build your own VM or install Docker manually.

Your lab environment includes:

- ✅ Ubuntu 20.04 LTS with Docker pre-installed
- ✅ All necessary tools and dependencies
- ✅ Root access for system configuration
- ✅ Network connectivity for registry operations

---

## 📦 Task 1: Setting Up a Private Docker Registry

### 🔹 Subtask 1.1: Verify Docker Installation and Start Registry Container

First, let's verify that Docker is properly installed and running on your system.

```bash
# 🐳 Check Docker version and status
docker --version
docker info

# ⬇️ Pull the official Docker registry image
docker pull registry:2

# 📁 Create a directory for registry data persistence
sudo mkdir -p /opt/docker-registry/data
sudo mkdir -p /opt/docker-registry/certs
sudo mkdir -p /opt/docker-registry/auth

# 🔐 Set proper permissions
sudo chown -R $USER:$USER /opt/docker-registry
```

### 🔹 Subtask 1.2: Run Basic Registry Container

Start a basic Docker registry without authentication first to understand the fundamentals.

```bash
# ▶️ Run a simple registry on port 5000
docker run -d \
  --name registry-basic \
  --restart=always \
  -p 5000:5000 \
  -v /opt/docker-registry/data:/var/lib/registry \
  registry:2

# ✅ Verify the registry is running
docker ps | grep registry-basic

# 💓 Check registry health
curl http://localhost:5000/v2/
```

> 💡 Expected output should show: `{}`

### 🔹 Subtask 1.3: Test Basic Registry Functionality

Let's test the basic registry by pushing and pulling a simple image.

```bash
# ⬇️ Pull a small test image
docker pull hello-world

# 🏷️ Tag the image for your private registry
docker tag hello-world localhost:5000/hello-world

# ⬆️ Push the image to your private registry
docker push localhost:5000/hello-world

# 🗑️ Remove local images to test pull functionality
docker rmi hello-world localhost:5000/hello-world

# ⬇️ Pull the image from your private registry
docker pull localhost:5000/hello-world

# 🧪 Verify the image works
docker run localhost:5000/hello-world
```

> 📝 `# TODO:` Push a second image of your own choosing to `registry-basic` and confirm `curl http://localhost:5000/v2/_catalog` lists both repositories.

---

## 🔐 Task 2: Implementing Authentication and Security

### 🔹 Subtask 2.1: Generate Self-Signed SSL Certificates

For production use, you would use certificates from a trusted CA. For this lab, we'll create self-signed certificates.

```bash
# 📁 Navigate to the certs directory
cd /opt/docker-registry/certs

# 🔑 Generate a private key
openssl genrsa -out domain.key 4096

# 📝 Generate a certificate signing request
openssl req -new -key domain.key -out domain.csr -subj "/C=US/ST=CA/L=San Francisco/O=MyOrg/CN=localhost"

# 📜 Generate the self-signed certificate
openssl x509 -req -days 365 -in domain.csr -signkey domain.key -out domain.crt

# ✅ Verify certificate creation
ls -la /opt/docker-registry/certs/
```

### 🔹 Subtask 2.2: Create Authentication Credentials

Set up basic HTTP authentication for the registry.

```bash
# 📦 Install htpasswd utility if not available
sudo apt-get update
sudo apt-get install -y apache2-utils

# 🔑 Create authentication file with username 'testuser' and password 'testpass'
htpasswd -Bbn testuser testpass > /opt/docker-registry/auth/htpasswd

# ✅ Verify the auth file
cat /opt/docker-registry/auth/htpasswd
```

### 🔹 Subtask 2.3: Stop Basic Registry and Start Secure Registry

```bash
# 🛑 Stop the basic registry
docker stop registry-basic
docker rm registry-basic

# 🔒 Start secure registry with authentication and TLS
docker run -d \
  --name registry-secure \
  --restart=always \
  -p 5000:5000 \
  -v /opt/docker-registry/data:/var/lib/registry \
  -v /opt/docker-registry/certs:/certs \
  -v /opt/docker-registry/auth:/auth \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_PRIVATE_KEY=/certs/domain.key \
  -e REGISTRY_AUTH=htpasswd \
  -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  registry:2

# ✅ Verify the secure registry is running
docker ps | grep registry-secure
```

### 🔹 Subtask 2.4: Configure Docker Client for Self-Signed Certificates

Since we're using self-signed certificates, we need to configure Docker to trust them.

```bash
# 📁 Create Docker daemon configuration directory
sudo mkdir -p /etc/docker/certs.d/localhost:5000

# 📄 Copy the certificate to Docker's certificate directory
sudo cp /opt/docker-registry/certs/domain.crt /etc/docker/certs.d/localhost:5000/ca.crt

# 🔄 Restart Docker daemon to pick up the new certificate
sudo systemctl restart docker

# ⏳ Wait for Docker to restart
sleep 5

# ✅ Verify Docker is running
docker info
```

> 📝 `# TODO:` Try connecting with `openssl s_client -connect localhost:5000` before and after trusting the certificate, and note the difference in the handshake output.

---

## 🔓 Task 3: Testing Authenticated Registry Operations

### 🔹 Subtask 3.1: Login to Private Registry

```bash
# 🔑 Login to the private registry
docker login localhost:5000

# When prompted, enter:
# Username: testuser
# Password: testpass

# ✅ Verify login was successful by checking Docker config
cat ~/.docker/config.json
```

### 🔹 Subtask 3.2: Push and Pull Images with Authentication

```bash
# ⬇️ Pull a sample application image
docker pull nginx:alpine

# 🏷️ Tag it for your private registry
docker tag nginx:alpine localhost:5000/my-nginx:v1.0

# ⬆️ Push to your private registry
docker push localhost:5000/my-nginx:v1.0
```

```dockerfile
# 🏗️ Create a custom image to push
cat > Dockerfile << EOF
FROM alpine:latest
RUN apk add --no-cache curl
COPY . /app
WORKDIR /app
CMD ["echo", "Hello from private registry!"]
EOF
```

```bash
# 🏗️ Build custom image
docker build -t localhost:5000/my-custom-app:latest .

# ⬆️ Push custom image
docker push localhost:5000/my-custom-app:latest

# 📋 List images in registry (using registry API)
curl -k -u testuser:testpass https://localhost:5000/v2/_catalog
```

### 🔹 Subtask 3.3: Test Pull Operations

```bash
# 🗑️ Remove local images
docker rmi localhost:5000/my-nginx:v1.0 localhost:5000/my-custom-app:latest

# ⬇️ Pull images from private registry
docker pull localhost:5000/my-nginx:v1.0
docker pull localhost:5000/my-custom-app:latest

# 🧪 Test the pulled images
docker run --rm localhost:5000/my-custom-app:latest
docker run --rm -p 8080:80 -d --name test-nginx localhost:5000/my-nginx:v1.0

# 🌐 Test nginx is working
curl http://localhost:8080

# 🧹 Clean up test container
docker stop test-nginx
```

> 📝 `# TODO:` Try `docker pull` from a second machine (or a fresh shell without the trusted CA cert) and confirm it fails until the certificate is trusted there too.

---

## ✍️ Task 4: Docker Content Trust and Image Signing

### 🔹 Subtask 4.1: Understanding Content Trust

Docker Content Trust provides cryptographic verification of image integrity and publisher identity.

```bash
# 🔍 Check current content trust setting
echo $DOCKER_CONTENT_TRUST

# ✍️ Enable content trust
export DOCKER_CONTENT_TRUST=1

# ❌ Try to pull an unsigned image (this should fail)
docker pull localhost:5000/my-nginx:v1.0 || echo "Pull failed due to content trust"

# ↩️ Disable content trust for this session
export DOCKER_CONTENT_TRUST=0

# ✅ Now the pull should work
docker pull localhost:5000/my-nginx:v1.0
```

### 🔹 Subtask 4.2: Working with Content Trust Policies

```bash
# 📝 Create a script to demonstrate content trust bypass
cat > test-content-trust.sh << 'EOF'
#!/bin/bash

echo "Testing with content trust enabled..."
export DOCKER_CONTENT_TRUST=1
docker pull localhost:5000/my-nginx:v1.0 2>&1 | head -5

echo -e "\nTesting with --disable-content-trust flag..."
docker pull --disable-content-trust localhost:5000/my-nginx:v1.0 2>&1 | head -5

echo -e "\nTesting with content trust disabled..."
export DOCKER_CONTENT_TRUST=0
docker pull localhost:5000/my-nginx:v1.0 2>&1 | head -5
EOF

# ✅ Make script executable and run it
chmod +x test-content-trust.sh
./test-content-trust.sh
```

### 🔹 Subtask 4.3: Registry Configuration for Content Trust

```yaml
# ⚙️ Create a registry configuration file for content trust
cat > /opt/docker-registry/config.yml << EOF
version: 0.1
log:
  fields:
    service: registry
storage:
  cache:
    blobdescriptor: inmemory
  filesystem:
    rootdirectory: /var/lib/registry
http:
  addr: :5000
  headers:
    X-Content-Type-Options: [nosniff]
  tls:
    certificate: /certs/domain.crt
    key: /certs/domain.key
auth:
  htpasswd:
    realm: basic-realm
    path: /auth/htpasswd
notifications:
  endpoints:
    - name: local-webhook
      disabled: true
EOF
```

```bash
# 🔄 Restart registry with custom configuration
docker stop registry-secure
docker rm registry-secure

docker run -d \
  --name registry-configured \
  --restart=always \
  -p 5000:5000 \
  -v /opt/docker-registry/data:/var/lib/registry \
  -v /opt/docker-registry/certs:/certs \
  -v /opt/docker-registry/auth:/auth \
  -v /opt/docker-registry/config.yml:/etc/docker/registry/config.yml \
  registry:2
```

> 📝 `# TODO:` Enable the `local-webhook` notification endpoint with a real URL and confirm the registry fires a push event to it.

---

## 🧹 Task 5: Registry Storage Management and Best Practices

### 🔹 Subtask 5.1: Monitoring Registry Storage

```bash
# 💾 Check registry storage usage
du -sh /opt/docker-registry/data

# 📋 List all repositories in the registry
curl -k -u testuser:testpass https://localhost:5000/v2/_catalog | jq '.'

# 🏷️ Get tags for a specific repository
curl -k -u testuser:testpass https://localhost:5000/v2/my-nginx/tags/list | jq '.'

# 🔍 Get detailed information about registry contents
find /opt/docker-registry/data -type f -name "*.json" | head -10
```

### 🔹 Subtask 5.2: Registry Cleanup and Garbage Collection

```bash
# 🧹 Create a cleanup script
cat > registry-cleanup.sh << 'EOF'
#!/bin/bash

echo "Registry cleanup starting..."

# Stop the registry
docker stop registry-configured

# Run garbage collection
docker run --rm \
  -v /opt/docker-registry/data:/var/lib/registry \
  registry:2 \
  garbage-collect /etc/docker/registry/config.yml

# Restart the registry
docker start registry-configured

echo "Registry cleanup completed."
EOF

# ✅ Make script executable
chmod +x registry-cleanup.sh

# 📊 Show storage before cleanup
echo "Storage before cleanup:"
du -sh /opt/docker-registry/data

# ▶️ Run cleanup (commented out to preserve lab data)
# ./registry-cleanup.sh

echo "Cleanup script created and ready to use."
```

### 🔹 Subtask 5.3: Implementing Storage Limits and Policies

```yaml
# ⚙️ Create an advanced registry configuration with storage policies
cat > /opt/docker-registry/config-advanced.yml << EOF
version: 0.1
log:
  level: info
  fields:
    service: registry
storage:
  cache:
    blobdescriptor: inmemory
  filesystem:
    rootdirectory: /var/lib/registry
    maxthreads: 100
  maintenance:
    uploadpurging:
      enabled: true
      age: 168h
      interval: 24h
      dryrun: false
    readonly:
      enabled: false
http:
  addr: :5000
  headers:
    X-Content-Type-Options: [nosniff]
  tls:
    certificate: /certs/domain.crt
    key: /certs/domain.key
auth:
  htpasswd:
    realm: basic-realm
    path: /auth/htpasswd
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
EOF
```

```bash
# 📊 Create a monitoring script
cat > monitor-registry.sh << 'EOF'
#!/bin/bash

echo "=== Registry Monitoring Report ==="
echo "Date: $(date)"
echo

echo "Registry Container Status:"
docker ps | grep registry

echo -e "\nRegistry Storage Usage:"
du -sh /opt/docker-registry/data

echo -e "\nRegistry Repositories:"
curl -s -k -u testuser:testpass https://localhost:5000/v2/_catalog | jq -r '.repositories[]' 2>/dev/null || echo "No repositories found"

echo -e "\nRegistry Health Check:"
curl -s -k https://localhost:5000/v2/ > /dev/null && echo "Registry is healthy" || echo "Registry health check failed"

echo -e "\nDocker System Information:"
docker system df

echo "=== End of Report ==="
EOF

chmod +x monitor-registry.sh
./monitor-registry.sh
```

### 🔹 Subtask 5.4: Backup and Recovery Procedures

```bash
# 💾 Create backup script
cat > backup-registry.sh << 'EOF'
#!/bin/bash

BACKUP_DIR="/opt/docker-registry/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="registry_backup_${TIMESTAMP}.tar.gz"

echo "Creating registry backup..."

# Create backup directory
mkdir -p $BACKUP_DIR

# Stop registry for consistent backup
docker stop registry-configured

# Create compressed backup
tar -czf "${BACKUP_DIR}/${BACKUP_FILE}" \
  -C /opt/docker-registry \
  data auth certs config.yml config-advanced.yml

# Restart registry
docker start registry-configured

echo "Backup created: ${BACKUP_DIR}/${BACKUP_FILE}"
echo "Backup size: $(du -sh ${BACKUP_DIR}/${BACKUP_FILE} | cut -f1)"
EOF

chmod +x backup-registry.sh
```

```bash
# ♻️ Create restore script
cat > restore-registry.sh << 'EOF'
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <backup_file>"
    echo "Available backups:"
    ls -la /opt/docker-registry/backups/
    exit 1
fi

BACKUP_FILE=$1

echo "Restoring registry from backup: $BACKUP_FILE"

# Stop registry
docker stop registry-configured

# Backup current state
mv /opt/docker-registry/data /opt/docker-registry/data.old.$(date +%Y%m%d_%H%M%S)

# Restore from backup
tar -xzf "$BACKUP_FILE" -C /opt/docker-registry

# Restart registry
docker start registry-configured

echo "Registry restored successfully"
EOF

chmod +x restore-registry.sh

# ▶️ Run backup
./backup-registry.sh
```

> 📝 `# TODO:` Practice a full disaster-recovery drill: push a new image, run `backup-registry.sh`, delete it, then use `restore-registry.sh` to bring it back.

---

## 🚀 Task 6: Advanced Registry Features and Troubleshooting

### 🔹 Subtask 6.1: Registry API Exploration

```bash
# 🔎 Create API testing script
cat > test-registry-api.sh << 'EOF'
#!/bin/bash

REGISTRY_URL="https://localhost:5000"
AUTH="testuser:testpass"

echo "=== Docker Registry API Testing ==="

echo -e "\n1. Check registry version:"
curl -s -k -u $AUTH $REGISTRY_URL/v2/ | jq '.' 2>/dev/null || echo "Registry API accessible"

echo -e "\n2. List all repositories:"
curl -s -k -u $AUTH $REGISTRY_URL/v2/_catalog | jq '.repositories[]' 2>/dev/null

echo -e "\n3. Get tags for my-nginx repository:"
curl -s -k -u $AUTH $REGISTRY_URL/v2/my-nginx/tags/list | jq '.' 2>/dev/null

echo -e "\n4. Get manifest for my-nginx:v1.0:"
curl -s -k -u $AUTH \
  -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
  $REGISTRY_URL/v2/my-nginx/manifests/v1.0 | jq '.schemaVersion' 2>/dev/null

echo -e "\n5. Registry statistics:"
echo "Total repositories: $(curl -s -k -u $AUTH $REGISTRY_URL/v2/_catalog | jq '.repositories | length' 2>/dev/null)"
EOF

chmod +x test-registry-api.sh
./test-registry-api.sh
```

### 🔹 Subtask 6.2: Common Troubleshooting Scenarios

```bash
# 🛠️ Create troubleshooting guide script
cat > troubleshoot-registry.sh << 'EOF'
#!/bin/bash

echo "=== Docker Registry Troubleshooting Guide ==="

echo -e "\n1. Check if registry container is running:"
docker ps | grep registry || echo "No registry container found!"

echo -e "\n2. Check registry logs:"
echo "Recent registry logs:"
docker logs --tail 10 registry-configured 2>/dev/null || echo "Cannot access registry logs"

echo -e "\n3. Test registry connectivity:"
curl -k https://localhost:5000/v2/ 2>/dev/null && echo "Registry is accessible" || echo "Registry connection failed"

echo -e "\n4. Check certificate validity:"
openssl x509 -in /opt/docker-registry/certs/domain.crt -text -noout | grep "Not After" || echo "Cannot read certificate"

echo -e "\n5. Verify authentication file:"
[ -f /opt/docker-registry/auth/htpasswd ] && echo "Auth file exists" || echo "Auth file missing"

echo -e "\n6. Check disk space:"
df -h /opt/docker-registry/

echo -e "\n7. Test Docker daemon configuration:"
[ -f /etc/docker/certs.d/localhost:5000/ca.crt ] && echo "Docker certificate configured" || echo "Docker certificate missing"

echo -e "\n8. Network connectivity test:"
netstat -tlnp | grep :5000 || echo "Registry port not listening"

echo "=== End Troubleshooting ==="
EOF

chmod +x troubleshoot-registry.sh
./troubleshoot-registry.sh
```

### 🔹 Subtask 6.3: Performance Optimization

```bash
# 📊 Create performance monitoring script
cat > performance-monitor.sh << 'EOF'
#!/bin/bash

echo "=== Registry Performance Monitoring ==="

echo -e "\n1. Container resource usage:"
docker stats --no-stream registry-configured 2>/dev/null || echo "Cannot get container stats"

echo -e "\n2. Registry response time test:"
time curl -s -k -u testuser:testpass https://localhost:5000/v2/_catalog > /dev/null

echo -e "\n3. Storage I/O statistics:"
iostat -x 1 1 2>/dev/null | tail -n +4 || echo "iostat not available"

echo -e "\n4. Memory usage:"
free -h

echo -e "\n5. Registry data directory size:"
du -sh /opt/docker-registry/data

echo "=== End Performance Report ==="
EOF

chmod +x performance-monitor.sh
./performance-monitor.sh
```

> 📝 `# TODO:` Run `performance-monitor.sh` before and after pushing a large image, and compare the response-time delta.

---

## ✅ Verification and Testing

### 🔹 Final Verification Steps

```bash
# 🧪 Create comprehensive test script
cat > final-verification.sh << 'EOF'
#!/bin/bash

echo "=== Final Registry Verification ==="

# Test 1: Registry accessibility
echo -e "\n✓ Testing registry accessibility..."
curl -k https://localhost:5000/v2/ > /dev/null 2>&1 && echo "PASS: Registry is accessible" || echo "FAIL: Registry not accessible"

# Test 2: Authentication
echo -e "\n✓ Testing authentication..."
curl -k -u testuser:testpass https://localhost:5000/v2/_catalog > /dev/null 2>&1 && echo "PASS: Authentication working" || echo "FAIL: Authentication failed"

# Test 3: Push/Pull functionality
echo -e "\n✓ Testing push/pull functionality..."
docker pull alpine:latest > /dev/null 2>&1
docker tag alpine:latest localhost:5000/test-alpine:latest > /dev/null 2>&1
docker push localhost:5000/test-alpine:latest > /dev/null 2>&1 && echo "PASS: Push working" || echo "FAIL: Push failed"

docker rmi localhost:5000/test-alpine:latest > /dev/null 2>&1
docker pull localhost:5000/test-alpine:latest > /dev/null 2>&1 && echo "PASS: Pull working" || echo "FAIL: Pull failed"

# Test 4: TLS/SSL
echo -e "\n✓ Testing TLS/SSL..."
openssl s_client -connect localhost:5000 -servername localhost < /dev/null 2>/dev/null | grep "Verify return code: 0" > /dev/null && echo "PASS: TLS working" || echo "INFO: Self-signed certificate in use"

# Test 5: Storage persistence
echo -e "\n✓ Testing storage persistence..."
[ -d /opt/docker-registry/data/docker ] && echo "PASS: Registry data persisted" || echo "FAIL: No registry data found"

echo -e "\n=== Verification Complete ==="
EOF

chmod +x final-verification.sh
./final-verification.sh
```

---

## 🧽 Cleanup (Optional)

If you want to clean up the lab environment:

```bash
# 🛑 Stop and remove registry container
docker stop registry-configured
docker rm registry-configured

# 🗑️ Remove test images
docker rmi localhost:5000/my-nginx:v1.0 localhost:5000/my-custom-app:latest localhost:5000/test-alpine:latest 2>/dev/null

# 🗑️ Remove registry data (optional - only if you want to start fresh)
# sudo rm -rf /opt/docker-registry

echo "Lab cleanup completed"
```

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>📜 Issue 1: Certificate Errors</summary>

**Problem:** `x509: certificate signed by unknown authority`

**Solution:**
```bash
# Ensure certificate is in the correct location
sudo cp /opt/docker-registry/certs/domain.crt /etc/docker/certs.d/localhost:5000/ca.crt
sudo systemctl restart docker
```
</details>

<details>
<summary>🔐 Issue 2: Authentication Failures</summary>

**Problem:** `unauthorized: authentication required`

**Solution:**
```bash
# Re-login to the registry
docker logout localhost:5000
docker login localhost:5000
```
</details>

<details>
<summary>🚫 Issue 3: Registry Not Starting</summary>

**Problem:** Registry container fails to start

**Solution:**
```bash
# Check logs for specific error
docker logs registry-configured
# Common fix: check file permissions
sudo chown -R $USER:$USER /opt/docker-registry
```
</details>

<details>
<summary>⏱️ Issue 4: Push/Pull Timeouts</summary>

**Problem:** Operations timeout or fail

**Solution:**
```bash
# Check registry health
curl -k https://localhost:5000/v2/
# Restart registry if needed
docker restart registry-configured
```
</details>

---

## 🏁 Conclusion

Congratulations! You have successfully completed **Lab 18: Docker Registry — Creating a Private Docker Registry**.

### 🔑 What You Accomplished

In this comprehensive lab, you have:

- 📦 **Set up a private Docker registry** from scratch, learning both basic and advanced configuration options
- 🔐 **Implemented security measures** including TLS encryption and HTTP basic authentication to protect your registry
- 🔓 **Mastered registry operations** by pushing and pulling images to/from your private registry
- ✍️ **Explored Docker Content Trust** and learned how to manage image signing policies for enhanced security
- 🧹 **Applied best practices** for registry storage management, cleanup, and maintenance procedures
- 🛠️ **Developed troubleshooting skills** for common registry issues and performance monitoring

### 💡 Why This Matters

Private Docker registries are essential in enterprise environments for several critical reasons:

| Reason | Description |
|---|---|
| 🔒 Security Control | Keep proprietary images within your organization's infrastructure |
| 📜 Compliance | Meet regulatory requirements for data sovereignty and access control |
| ⚡ Performance | Reduce image pull times by hosting registries closer to your deployment infrastructure |
| 💰 Cost Management | Avoid bandwidth charges and rate limits from public registries |
| 🔄 Workflow Integration | Integrate seamlessly with CI/CD pipelines and development workflows |

### 🌍 Real-World Applications

The skills you've developed in this lab directly apply to:

- ⚙️ **DevOps Engineering** — Setting up container infrastructure for development teams
- 🖥️ **System Administration** — Managing enterprise container registries and security policies
- ☁️ **Cloud Architecture** — Designing secure, scalable container deployment strategies
- 🔒 **Security Engineering** — Implementing container image security and compliance measures

### 🔮 Next Steps

To further develop your Docker registry expertise:

- 🌐 Explore Docker Registry clustering for high availability setups
- 🔁 Learn about registry replication and mirroring strategies
- 🔄 Investigate integration with CI/CD tools like Jenkins, GitLab CI, or GitHub Actions
- 🔑 Study advanced authentication methods including LDAP and OAuth integration
- 📊 Practice registry monitoring and alerting using tools like Prometheus and Grafana

> 🎉 This lab has provided you with a solid foundation in Docker registry management that will serve you well in your journey toward Docker certification and professional container orchestration roles.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E90FF?style=for-the-badge)

</div>
