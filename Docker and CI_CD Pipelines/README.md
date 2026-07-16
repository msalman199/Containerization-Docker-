<div align="center">

# 🔄 Docker and CI/CD Pipelines

### GitLab CI/CD, Multi-Service Orchestration, and Secret-Safe Automated Delivery

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![GitLab CI/CD](https://img.shields.io/badge/GitLab_CI%2FCD-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-1904DA?style=for-the-badge&logo=aquasecurity&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![AWS EC2](https://img.shields.io/badge/AWS_EC2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

</div>

---

## 📖 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment](#️-lab-environment)
- [🧰 Task 1: Install and Verify the Required Toolchain](#-task-1-install-and-verify-the-required-toolchain)
- [🏗️ Task 2: Build a Containerized Application and Automate Its Delivery with a GitLab CI/CD Pipeline](#️-task-2-build-a-containerized-application-and-automate-its-delivery-with-a-gitlab-cicd-pipeline)
- [🔐 Task 3: Orchestrate a Multi-Service Stack and Inject Secrets Through GitLab CI/CD Variables](#-task-3-orchestrate-a-multi-service-stack-and-inject-secrets-through-gitlab-cicd-variables)
- [🏆 Expected Outcomes](#-expected-outcomes)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

| # | Skill |
|---|-------|
| 1️⃣ | Design and implement a GitLab CI/CD pipeline that automatically builds, tags, and pushes a Dockerized application to a container registry on every commit to the `main` branch |
| 2️⃣ | Orchestrate a multi-service application using Docker Compose and integrate that orchestration into the pipeline's test and deploy stages |
| 3️⃣ | Embed automated container vulnerability scanning and secret injection into the pipeline so that no plaintext credentials appear in any committed file |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐧 Linux CLI | Comfort navigating the filesystem, editing files with a terminal editor, and reading command output to diagnose errors |
| 🌿 Git Fundamentals | Initializing a repository, staging and committing files, and pushing to a remote |
| 🦊 GitLab Account | A free GitLab.com account created before the lab begins, with a personal access token that has the `read_registry`, `write_registry`, and `api` scopes enabled |

---

## 🖥️ Lab Environment

> ℹ️ You will work on a dedicated **AWS EC2 Ubuntu instance** provided by Al Nafi. The instance has a base Ubuntu installation; you will install all required tools in Task 1.

---

## 🧰 Task 1: Install and Verify the Required Toolchain

### 📚 Problem Statement

Your EC2 instance has no tooling beyond a base Ubuntu system. Design and execute an installation plan that produces a verified, working environment containing Docker Engine, Docker Compose (the standalone `docker-compose` binary, not the plugin), Git, and the Trivy container-scanning CLI. Every tool must be confirmed operational before you proceed.

### 🔹 Step 1 — Install Docker Engine, Docker Compose, and Git

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg git   # 📦 base packages

sudo install -m 0755 -d /etc/apt/keyrings

# 🔑 Import Docker's GPG signing key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```
> 🔗 Official reference if the URL above changes: https://docs.docker.com/engine/install/ubuntu/

```bash
sudo tee /etc/apt/sources.list.d/docker.list <<'EOF'
deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable
EOF

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io   # 🐳 Docker Engine

sudo usermod -aG docker $USER   # 👤 allow non-root docker usage
newgrp docker

COMPOSE_VERSION="v2.27.0"
sudo curl -fsSL \
  "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64" \
  -o /usr/local/bin/docker-compose   # ⬇️ standalone Compose binary
sudo chmod +x /usr/local/bin/docker-compose
```
> 🔗 Official reference if the Compose URL changes: https://docs.docker.com/compose/install/standalone/

<details>
<summary>🛠️ Troubleshoot this step</summary>

You may see `E: Malformed entry 1 in list file /etc/apt/sources.list.d/docker.list` if the heredoc wrote a backslash or blank line into the file.

Inspect the file with `cat /etc/apt/sources.list.d/docker.list` — it must be a single unbroken line; delete it with `sudo rm /etc/apt/sources.list.d/docker.list` and recreate it using the heredoc above.

🔗 Official guide: https://docs.docker.com/engine/install/ubuntu/
</details>

### 🔹 Step 2 — Install Trivy and Verify All Tools

```bash
# 🔑 Import the Trivy GPG signing key
curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/trivy.gpg
sudo chmod a+r /etc/apt/keyrings/trivy.gpg
```
> 🔗 Official reference if the Trivy key URL changes: https://aquasecurity.github.io/trivy/latest/getting-started/installation/

```bash
sudo tee /etc/apt/sources.list.d/trivy.list <<'EOF'
deb [signed-by=/etc/apt/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main
EOF

sudo apt-get update
sudo apt-get install -y trivy   # 🔍 vulnerability scanner CLI
```

<details>
<summary>🛠️ Troubleshoot this step</summary>

You may see `E: Malformed entry 1 in list file /etc/apt/sources.list.d/trivy.list` if the heredoc produced a broken line.

Run `cat /etc/apt/sources.list.d/trivy.list` — the file must contain exactly one unbroken line; remove it with `sudo rm /etc/apt/sources.list.d/trivy.list` and recreate it using the heredoc above.

🔗 Official guide: https://aquasecurity.github.io/trivy/latest/getting-started/installation/
</details>

**Verify every tool is operational:**
```bash
docker --version           # 🐳 confirm Docker
docker-compose --version   # 📦 confirm Compose
git --version               # 🌿 confirm Git
trivy --version             # 🔍 confirm Trivy
docker run --rm hello-world # 🧪 end-to-end sanity check
```

> ✅ **Confirmation:** every command prints a version string without error, and `docker run --rm hello-world` prints `Hello from Docker!` before exiting cleanly.

> 📝 `# TODO:` Pin `COMPOSE_VERSION` to the latest stable release at the time you run this lab and confirm the download URL still resolves.

---

## 🏗️ Task 2: Build a Containerized Application and Automate Its Delivery with a GitLab CI/CD Pipeline

### 📚 Problem Statement

Design and implement a complete delivery pipeline for a containerized web application of your own construction. The application must expose at least two HTTP endpoints — a root endpoint that returns application metadata (name, version, environment) and a `/health` endpoint that returns an HTTP 200 status.

You must:
- 🐳 Containerize it with a production-quality Dockerfile (non-root user, minimal base image, embedded health check)
- 📤 Push the repository to GitLab
- 📝 Author a `.gitlab-ci.yml` that executes four sequential stages — **build, test, scan, and deploy** — automatically on every push to the `main` branch

**Stage-by-stage requirements:**

| Stage | Requirement |
|---|---|
| 🏗️ Build | Push the image to the GitLab Container Registry using two tags: the short commit SHA and a semantic version read from a `VERSION` file tracked in the repository |
| 🧪 Test | Start the container and assert that both HTTP endpoints respond correctly before the stage is marked successful |
| 🔍 Scan | Invoke Trivy against the pushed image and export a JSON report as a pipeline artifact |
| 🚀 Deploy | Gated behind a manual approval click in the GitLab UI; must print the resolved image tag and semantic version to the job log |

### ✅ Acceptance Criteria

- A pipeline triggered by a `git push` to `main` completes the **build**, **test**, and **scan** stages automatically with green status; the **deploy** stage appears in the pipeline graph and waits for manual approval without failing; the GitLab Container Registry for the project shows two tags for the pushed image — one matching the short commit SHA and one matching the contents of the `VERSION` file.
- The Trivy JSON artifact is downloadable from the completed pipeline's artifact browser, contains a `Results` key with at least one scanned target, and the scan stage job log shows the image name and tag that were scanned; the pipeline job log for the test stage shows explicit HTTP 200 confirmation from both the root and `/health` endpoints.

> 📝 `# TODO:` Decide how your app reads its semantic version from `VERSION` at build time — bake it into the image as a build arg, or read it at runtime — and be consistent across the build and deploy stages.

---

## 🔐 Task 3: Orchestrate a Multi-Service Stack and Inject Secrets Through GitLab CI/CD Variables

### 📚 Problem Statement

Extend your delivery system so that the application runs as part of a multi-service stack defined in a `docker-compose.yml` file. The stack must include:

- 🖥️ Your application container
- 🗄️ A **Redis** instance (used by the application to store a request counter that the root endpoint returns)
- 🌐 An **Nginx** reverse proxy that forwards port 80 to the application

> 🔒 **No hardcoded passwords or connection strings may appear in any file committed to the repository.** Every secret — including the Redis password and any internal connection URL — must be injected exclusively through GitLab CI/CD masked variables and consumed by Docker Compose via environment variable substitution at pipeline runtime.

Update the **test** stage of your pipeline to bring up the full Compose stack, assert that a request through Nginx on port 80 reaches the application and returns the request counter, and tear the stack down cleanly. Update the **deploy** stage to bring up the stack using the production-scoped masked variables.

### ✅ Acceptance Criteria

- A reviewer inspecting every file in the Git repository — including `docker-compose.yml`, all override files, `.gitlab-ci.yml`, and any shell scripts — finds **zero plaintext passwords or connection strings**; all secrets resolve only at pipeline runtime from GitLab CI/CD masked variables, confirmed by the fact that the variable values are redacted as `[MASKED]` in the pipeline job log.
- The test stage job log shows a successful HTTP response received **through Nginx on port 80** (not directly on the application port), the response body contains a non-zero request counter value proving Redis connectivity, and `docker-compose down -v` executes without error at the end of the stage, leaving no dangling volumes as confirmed by `docker volume ls` showing no project-prefixed volumes in the log output.

> 📝 `# TODO:` Confirm your masked variables are also scoped correctly (protected branch / environment) so production secrets can't leak into a feature-branch pipeline run.

---

## 🏆 Expected Outcomes

- 🦊 A GitLab project containing a fully automated four-stage CI/CD pipeline that builds, tests, scans, and conditionally deploys a Dockerized multi-service application without any secrets stored in version control
- 📄 A downloadable Trivy vulnerability report artifact and a pipeline history demonstrating that every push to `main` triggers the first three stages automatically while the deploy stage requires explicit human approval

---

## 🏁 Conclusion

This lab required you to design a production-representative delivery pipeline from first principles, making deliberate decisions about image tagging strategy, secret handling, service orchestration, and security scanning integration.

The constraints — no hardcoded secrets, non-root containers, gated deployments, and artifact-backed scan reports — reflect the non-negotiable requirements of real-world containerized delivery systems.

> 🔎 Revisit the Trivy JSON output and the GitLab security dashboard to understand how vulnerability data flows from a scanner into an auditable record that a security team can act on.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E90FF?style=for-the-badge)

</div>
