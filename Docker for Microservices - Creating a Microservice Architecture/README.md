<div align="center">

# 🧩 Docker Microservices Architecture
### Multi-Service Design, Inter-Service Communication & API Gateway Routing

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-18-339933?style=for-the-badge&logo=node.js&logoColor=white)
![REST API](https://img.shields.io/badge/REST%20API-Microservices-informational?style=for-the-badge)
![AWS EC2](https://img.shields.io/badge/AWS%20EC2-Ubuntu-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Level](https://img.shields.io/badge/Level-Advanced-red?style=for-the-badge)

</div>

---

## 📚 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment](#️-lab-environment)
- [🧩 Technology Stack](#-technology-stack)
- [⚙️ Task 1: Install and Verify the Environment](#️-task-1-install-and-verify-the-environment)
- [🏗️ Task 2: Design and Build Three Independent Microservices](#️-task-2-design-and-build-three-independent-microservices)
- [🚪 Task 3: Orchestrate with Docker Compose and Route Through an API Gateway](#-task-3-orchestrate-with-docker-compose-and-route-through-an-api-gateway)
- [✅ Expected Outcomes](#-expected-outcomes)
- [🎓 Conclusion](#-conclusion)

---

## 🎯 Objectives

| # | Objective |
|---|-----------|
| 1 | 🏗️ Design and deploy a multi-service containerized application using Docker and Docker Compose, with each service independently buildable and runnable |
| 2 | 🔗 Implement inter-service HTTP communication across a custom Docker bridge network, where one service calls another by container name |
| 3 | 🚪 Expose all services through a single API Gateway container that routes requests, enforces rate limiting, and returns structured error responses when a backend is unreachable |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| ⌨️ Linux CLI | Comfortable navigating and editing files on a Linux/Ubuntu system using the command line |
| 🌐 REST API concepts | Familiar with HTTP methods, status codes, and JSON request/response bodies |

---

## 🖥️ Lab Environment

> **☁️ Dedicated Cloud Instance**
> You will work on a dedicated AWS EC2 Ubuntu instance provided by Al Nafi. The instance has a base Ubuntu installation — you will install all required tools in Task 1.

---

## 🧩 Technology Stack

<div align="center">

| Technology | Role in This Lab |
|---|---|
| ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white) | Containerizes each independent microservice |
| ![Docker Compose](https://img.shields.io/badge/Compose-2496ED?style=flat-square&logo=docker&logoColor=white) | Orchestrates all four services on one network |
| ![Node.js](https://img.shields.io/badge/Node.js%2018-339933?style=flat-square&logo=node.js&logoColor=white) | Runtime for the User, Product, Order, and Gateway services |
| ![Bridge Network](https://img.shields.io/badge/Docker%20Bridge%20Network-384d54?style=flat-square&logo=docker&logoColor=white) | Isolated network enabling service-name DNS resolution |
| ![API Gateway](https://img.shields.io/badge/API%20Gateway-Reverse%20Proxy-6f42c1?style=flat-square) | Single entry point: routing, rate limiting, error handling |

</div>

---

## ⚙️ Task 1: Install and Verify the Environment

### 🐳 Step 1.1: Install Docker Engine and Docker Compose

Run the following commands in order. Each block is safe to copy and paste as-is.

```bash
# 🔄 Update package index and install prerequisites
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings

# 🔑 Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

> 📖 Official guide if the URL above changes: https://docs.docker.com/engine/install/ubuntu/

```bash
# 📋 Add the Docker repository to APT sources
sudo tee /etc/apt/sources.list.d/docker.list <<'EOF'
deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable
EOF
```

<details>
<summary>🔴 Troubleshoot this step</summary>

You may see `E: Malformed entry 1 in list file /etc/apt/sources.list.d/docker.list` if the heredoc wrote extra whitespace or a backslash.

- 🔎 Inspect the file with `cat /etc/apt/sources.list.d/docker.list` — it must be a single unbroken line
- 🧹 Delete it with `sudo rm /etc/apt/sources.list.d/docker.list` and re-run the `tee` block if it is not
- 📖 Official reference: https://docs.docker.com/engine/install/ubuntu/
</details>

```bash
# 📥 Install Docker Engine, CLI, containerd, and the Compose plugin
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 👤 Add current user to the docker group
sudo usermod -aG docker $USER
newgrp docker

# ✅ Verify installation
docker version
docker compose version
```

> 📝 You should see a Client/Server version block for Docker and a version string for the Compose plugin. If either command returns "command not found", the installation did not complete — re-run the `apt-get install` line above.

### 🟢 Step 1.2: Install Node.js 18 via NodeSource

```bash
# 📦 Add the NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
```

> 📖 Official guide if the URL above changes: https://github.com/nodesource/distributions#debian-and-ubuntu-based-distributions

```bash
# 📥 Install Node.js
sudo apt-get install -y nodejs

# ✅ Verify installation
node --version
npm --version
```

<details>
<summary>🔴 Troubleshoot this step</summary>

You may see `E: Package 'nodejs' has no installation candidate` if the NodeSource repository was not added correctly.

- 🔎 Run `cat /etc/apt/sources.list.d/nodesource.list` — it must contain a line beginning with `deb`
- 🔄 If the file is missing or empty, re-run the `curl` setup script above
- 📖 Official reference: https://github.com/nodesource/distributions
</details>

> 📝 You should see `v18.x.x` for Node and `9.x.x` or higher for npm. Both commands must succeed before proceeding.

---

## 🏗️ Task 2: Design and Build Three Independent Microservices

> 📖 A **microservice** is a small, self-contained application that owns a single business domain and exposes its functionality over HTTP. You will design and implement three such services — **User**, **Product**, and **Order** — each running in its own Docker container, communicating over a shared Docker bridge network (an isolated virtual network that Docker manages, letting containers reach each other by service name).

### 👤 Step 2.1: Implement the User Service and Product Service

Design and implement two services from scratch. You decide the framework, file layout, and internal logic, subject to the constraints below.

#### 📦 User Service — Constraints

| # | Constraint |
|---|---|
| 1 | 🔌 Listens on port `3001` |
| 2 | 🛣️ Exposes at minimum: `GET /health`, `GET /users`, `GET /users/:id`, `POST /users` |
| 3 | 🚫 `POST /users` must reject requests missing a `name` or `email` field with HTTP `400` |
| 4 | 💾 In-memory storage is acceptable — no database is required |
| 5 | 🐳 Must include a Dockerfile that produces a working image using `node:18-alpine` as the base |

#### 🛍️ Product Service — Constraints

| # | Constraint |
|---|---|
| 1 | 🔌 Listens on port `3002` |
| 2 | 🛣️ Exposes at minimum: `GET /health`, `GET /products`, `GET /products/:id`, `POST /products`, `PATCH /products/:id/stock` |
| 3 | 🔍 `GET /products` must support optional query parameters for filtering by category and price range |
| 4 | 🐳 Must include a Dockerfile that produces a working image using `node:18-alpine` as the base |

#### ✅ Acceptance Criteria

```bash
# ❤️ Both services report healthy over the microservices-net bridge network
curl -s http://localhost:3001/health   # JSON: { service, status: "healthy" } — HTTP 200
curl -s http://localhost:3002/health   # JSON: { service, status: "healthy" } — HTTP 200

# 🚫 Missing fields are rejected
curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:3001/users \
  -H "Content-Type: application/json" -d '{"name":"","email":""}'   # → 400

# ✅ Valid creation succeeds
curl -s -X POST http://localhost:3001/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Ada Lovelace","email":"ada@example.com"}'
# → HTTP 201, JSON body includes submitted name + server-assigned numeric id
```

<!-- TODO: Choose your framework (Express, Fastify, or plain http) and scaffold each service under its own directory before writing the Dockerfile -->

### 📑 Step 2.2: Implement the Order Service with Live Inter-Service Calls

Design and implement an Order Service that depends on the User Service and Product Service at runtime. The Order Service must call the other two services over the Docker network to validate data before persisting an order.

#### 📦 Order Service — Constraints

| # | Constraint |
|---|---|
| 1 | 🔌 Listens on port `3003` |
| 2 | 🌐 Reads `USER_SERVICE_URL` and `PRODUCT_SERVICE_URL` from environment variables; defaults to `http://user-service:3001` and `http://product-service:3002` respectively (Docker Compose injects these via container-name DNS) |
| 3 | 🛣️ Exposes at minimum: `GET /health`, `GET /orders`, `GET /orders/:id`, `GET /orders/user/:userId`, `POST /orders`, `PATCH /orders/:id/status` |
| 4 | 🔗 `POST /orders` must verify the user exists and fetch live product prices from the respective services; if a service is unreachable, the endpoint must still respond (degrade gracefully) rather than crash |
| 5 | 🚦 Valid order statuses: `pending`, `processing`, `shipped`, `delivered`, `cancelled`; any other value must return HTTP `400` |
| 6 | 🐳 Must include a Dockerfile using `node:18-alpine` |

#### ✅ Acceptance Criteria

```bash
# 💰 A valid order returns a computed total sourced from live Product Service data
curl -s -X POST http://localhost:3003/orders \
  -H "Content-Type: application/json" \
  -d '{"userId": 1, "items": [{"productId": 1, "quantity": 2}]}'
# → HTTP 201, JSON body includes total = price × quantity

# 🛡️ Graceful degradation when User Service is down
docker stop user-service
curl -s -X POST http://localhost:3003/orders -H "Content-Type: application/json" -d '{...}'
# → non-500 response (HTTP 201 or a structured JSON error with a "message" field)

# ♻️ Restarting User Service restores full validation without restarting Order Service
docker start user-service
```

<!-- TODO: Decide how the Order Service handles a partially-degraded state — e.g. flag the order as "unverified" when User Service is unreachable -->

---

## 🚪 Task 3: Orchestrate with Docker Compose and Route Through an API Gateway

> 📖 **Docker Compose** defines and runs multi-container applications from a single YAML file. An **API Gateway** is a single entry-point container that receives all external requests and proxies them to the correct backend service, hiding internal ports from the outside world.

### 📝 Step 3.1: Write a Docker Compose File That Orchestrates All Four Services

Design a `docker-compose.yml` that brings up User, Product, Order, and API Gateway services together. You decide the structure, subject to the constraints below.

#### 🧱 Constraints

| # | Constraint |
|---|---|
| 1 | 🌉 All four services share a single user-defined bridge network; no service port except the API Gateway's port `3000` is exposed to the host (remove `ports` mappings from the three backend services so they're only reachable inside the network) |
| 2 | 🔗 The Order Service declares `depends_on` the User and Product services |
| 3 | 🩺 Every service includes a `healthcheck` block that calls its `/health` endpoint |
| 4 | 🚪 The API Gateway is the only service with a host port binding, on port `3000` |
| 5 | 🌐 The API Gateway reads backend URLs from environment variables injected by Compose, using Docker's internal DNS names (service names as hostnames) |
| 6 | 🛠️ The API Gateway implements: **request logging** (method, path, timestamp to stdout), **rate limiting** (max 100 requests / 15-minute window / IP), and **reverse proxying** for `/api/users`, `/api/products`, and `/api/orders` to the respective backends, stripping the `/api` prefix before forwarding |
| 7 | ⚠️ When a backend service is unreachable, the API Gateway returns HTTP `503` with a JSON body containing an `error` key — never a raw proxy error or HTML page |

<!-- TODO: Pick a reverse-proxy/rate-limiting library (e.g. http-proxy-middleware + express-rate-limit) for the API Gateway implementation -->

#### ✅ Acceptance Criteria

```bash
# 🚀 All four containers start cleanly
docker compose up -d
docker compose ps
# → all four services show "running" (or "healthy" once health checks pass)

# 🌐 End-to-end routing through the gateway
curl -s http://localhost:3000/api/users
# → same JSON body as a direct call to the User Service's /users endpoint

# 📈 Scaling a backend service is transparent to the gateway
# (first remove container_name from product-service to allow multiple instances)
docker compose up -d --scale product-service=2
curl -s http://localhost:3000/api/products
# → continues returning HTTP 200, confirming load distribution across instances
```

---

## ✅ Expected Outcomes

- 🧩 Four Docker containers (User, Product, Order, API Gateway) run simultaneously under Docker Compose, with all inter-service traffic flowing over an internal bridge network and all external traffic entering exclusively through port `3000` on the API Gateway
- 💰 The Order Service correctly computes order totals using live data fetched from the Product Service, and degrades gracefully when the User Service is stopped, demonstrating resilient inter-service communication

---

## 🎓 Conclusion

This lab required you to design a microservices system from first principles: each service owns its domain, communicates over a defined network boundary, and fails without cascading.

### 🏆 Key Takeaways

- 🚪 **API Gateway Pattern** — the standard approach for exposing multiple backend services through a single controlled entry point in production systems
- 📦 **Container Isolation** — each service is independently buildable, runnable, and replaceable
- 🌐 **Service Discovery via DNS** — Docker's internal DNS resolves containers by name, removing the need for hardcoded IPs
- 🛡️ **Graceful Degradation** — services stay responsive even when a dependency is unreachable
- 📝 **Declarative Orchestration** — Docker Compose defines the entire multi-service topology in one file

### 🌍 Real-World Applications

The skills applied here — container isolation, service discovery, graceful degradation, and declarative orchestration — are directly transferable to **Kubernetes** and cloud-native deployment workflows.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blue?style=for-the-badge)

</div>
