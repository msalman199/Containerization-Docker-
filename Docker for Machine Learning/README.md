<div align="center">

# 🤖 Containerized Machine Learning Pipelines with Docker

### Multi-Stage ML Images, Volume-Backed Training, and a Compose-Orchestrated Serving Stack

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![TensorFlow](https://img.shields.io/badge/TensorFlow-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white)
![AWS EC2](https://img.shields.io/badge/AWS_EC2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

</div>

---

## 📖 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment](#️-lab-environment)
- [⚙️ Task 1: Environment Setup and Verification](#️-task-1-environment-setup-and-verification)
- [🏗️ Task 2: Build a Reproducible ML Docker Image and Training Pipeline](#️-task-2-build-a-reproducible-ml-docker-image-and-training-pipeline)
- [🧩 Task 3: Orchestrate a Multi-Service ML Application with Docker Compose](#-task-3-orchestrate-a-multi-service-ml-application-with-docker-compose)
- [🏆 Expected Outcomes](#-expected-outcomes)
- [🛠️ Troubleshooting](#️-troubleshooting)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

| # | Skill |
|---|-------|
| 1️⃣ | Design and build a multi-stage Docker image optimized for TensorFlow-based ML workloads, applying layer caching and non-root user security constraints |
| 2️⃣ | Implement a containerized model training and serving pipeline with persistent volume-backed artifact storage and a REST prediction API |
| 3️⃣ | Orchestrate a multi-service ML application using Docker Compose, integrating a Jupyter development service, a model-serving API, and a PostgreSQL prediction-logging backend |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐧 Linux CLI | Comfort with file permissions, process management, and environment variables |
| 🐍 Python | Working knowledge including virtual environments, modules, and package management |
| 🤖 ML Fundamentals | Familiarity with training, evaluation, and model serialization |

---

## 🖥️ Lab Environment

> ℹ️ You will work on a dedicated **AWS EC2 Ubuntu instance** provided by Al Nafi. The instance has a base Ubuntu installation; you will install all required tools in Task 1.

---

## ⚙️ Task 1: Environment Setup and Verification

### 🔹 Step 1.1 — Install Docker Engine and Docker Compose Plugin

Your instance has no container runtime installed. Install Docker Engine from the official Docker apt repository, then verify the daemon is active and your user can issue Docker commands without `sudo`.

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg   # 📦 base packages

sudo install -m 0755 -d /etc/apt/keyrings

# 🔑 Import Docker's GPG signing key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```
> 🔗 If the `curl` command fails, consult the official guide at: https://docs.docker.com/engine/install/ubuntu/

```bash
sudo tee /etc/apt/sources.list.d/docker.list <<'EOF'
deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable
EOF
```

<details>
<summary>🛠️ Troubleshoot this step</summary>

You may see `E: Malformed entry 1 in list file /etc/apt/sources.list.d/docker.list` if the heredoc wrote extra whitespace or a literal backslash.

Run `cat /etc/apt/sources.list.d/docker.list` and confirm it is a single unbroken line; delete the file with `sudo rm /etc/apt/sources.list.d/docker.list` and recreate it if it is not.

🔗 Official reference: https://docs.docker.com/engine/install/ubuntu/
</details>

```bash
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin   # 🐳 Docker Engine + Compose plugin

sudo systemctl enable --now docker   # ▶️ enable + start daemon
sudo usermod -aG docker "$USER"      # 👤 allow non-root docker usage
newgrp docker
```

**Confirm the installation:**
```bash
docker version           # ✅ client + server info
docker compose version    # ✅ compose plugin version
```

> ⚠️ Both commands must return version strings without permission errors. If `docker version` shows a server connection error, run `sudo systemctl status docker` to inspect the daemon state.

### 🔹 Step 1.2 — Scaffold the Project Workspace

Create the directory tree that all subsequent tasks depend on. Every path used later in the lab must exist before any image build begins.

```bash
mkdir -p ~/ml-pipeline/{src,notebooks,models,data,postgres-init}   # 📁 project scaffold
cd ~/ml-pipeline
touch Dockerfile requirements.txt docker-compose.yml .dockerignore
touch src/train.py src/api.py src/db.py
touch postgres-init/01_schema.sql
```

**Confirm the structure:**
```bash
find ~/ml-pipeline -type f   # 📋 should list exactly 8 files
```

> ⚠️ You should see exactly eight files listed. No build step will succeed if any of these paths is missing.

> 📝 `# TODO:` Add a `.env` placeholder file now (even empty) so Task 3's Postgres credentials have somewhere to live before you need it.

---

## 🏗️ Task 2: Build a Reproducible ML Docker Image and Training Pipeline

### 🔹 Step 2.1 — Design a Multi-Stage Dockerfile with Security and Caching Constraints

Your Dockerfile must satisfy all of the following architectural constraints before you write a single line:

| Constraint | Requirement |
|---|---|
| 🏗️ Stage 1 (builder) | Install all build-time system dependencies and compile Python wheels. This stage must never appear in the final image |
| 🚀 Stage 2 (runtime) | Copy only the installed Python packages from the builder stage. The final image must not contain `build-essential`, `gcc`, or any compiler toolchain |
| 👤 Non-root execution | The runtime stage must create a system user named `mluser` (UID 1000) and switch to that user before the `CMD` instruction. The `/app/models` and `/app/data` directories must be owned by `mluser` |
| ⚡ Layer cache efficiency | The `requirements.txt` copy and `pip install` must occur before the application source copy so that source-code changes do not invalidate the dependency layer |
| 🔒 No secrets in layers | The image must not bake in any credentials, tokens, or passwords at any layer |

Your `requirements.txt` must pin exact versions for reproducibility. Include at minimum: `tensorflow`, `numpy`, `pandas`, `scikit-learn`, `flask`, `psycopg2-binary`, `jupyterlab`, and `requests`.

**The following interface defines the contract your training script must satisfy:**

```python
class TrainingPipeline:
    def load_data(self) -> tuple:
        """Return (X_train, X_test, y_train, y_test) as numpy arrays."""
        ...

    def build_model(self, input_dim: int, num_classes: int) -> object:
        """Return a compiled tf.keras.Model ready for fitting."""
        ...

    def train(self, model: object, X_train, y_train) -> dict:
        """Fit the model; return a history dict with 'accuracy' and 'val_accuracy' keys."""
        ...

    def save_artifacts(self, model: object, scaler: object, output_dir: str) -> None:
        """Persist model weights and scaler to output_dir; raise IOError on failure."""
        ...
```

**Build the image with a meaningful tag** (for example `ml-pipeline:v1`) and confirm it appears in `docker images`.

```bash
docker inspect ml-pipeline:v1   # 🔍 verify runtime user
```
> ✅ Verify that the `User` field is `mluser`, not `root`.

<details>
<summary>🛠️ Troubleshoot this step</summary>

You may see `ERROR [runtime 3/5] COPY --from=builder` failing with `failed to solve: failed to read dockerfile` if the stage name in `--from` does not exactly match the `AS` alias in the builder stage.

Open your Dockerfile and confirm the first `FROM` line reads `FROM python:3.11-slim AS builder` (or whichever alias you chose) and that the `COPY --from=` value is identical character-for-character.

🔗 Official multi-stage reference: https://docs.docker.com/build/building/multi-stage/
</details>

> 📝 `# TODO:` Run `docker history ml-pipeline:v1` and confirm the builder stage's compiler layers genuinely don't appear in the final image.

### 🔹 Step 2.2 — Run the Training Container with Volume-Backed Artifact Persistence

Execute the training script inside a container. The container must be ephemeral (removed after exit) and must write all artifacts to a host-mounted volume so they survive container termination.

**Constraints:**
- 📂 Mount `~/ml-pipeline/models` into the container at `/app/models` using a bind mount
- 📂 Mount `~/ml-pipeline/data` into the container at `/app/data`
- 🔧 Pass the dataset path and output directory as environment variables, not as hardcoded paths inside the script
- ✅ The container must exit with code `0` on successful training; any non-zero exit code indicates a failure that must be diagnosed before proceeding

**After the container exits, confirm artifacts were written:**
```bash
ls -lh ~/ml-pipeline/models/   # 📏 confirm non-zero file sizes
```

> ⚠️ You should see at minimum a saved model file and a serialized scaler object. A zero-byte artifact file means the save step silently failed inside the container.

> 📝 `# TODO:` Deliberately point the dataset env var at a nonexistent path and confirm the container exits non-zero instead of silently producing empty artifacts.

---

## 🧩 Task 3: Orchestrate a Multi-Service ML Application with Docker Compose

### 🔹 Step 3.1 — Define the Compose Service Architecture

Your `docker-compose.yml` must declare exactly three services with the dependency and networking constraints described below.

#### 📓 Service: `jupyter`
- Built from your project Dockerfile; override the default `CMD` to launch JupyterLab on port `8888` with token authentication disabled **only for this lab environment**
- Bind-mount `notebooks/`, `models/`, and `data/` so that notebooks can read trained artifacts and write new ones without rebuilding the image
- Must not start until the `api` service passes its health check

#### 🔌 Service: `api`
- Built from the same Dockerfile; override `CMD` to launch the Flask prediction API on port `5000`
- Must load the model and scaler from the `/app/models` volume **at startup**, not at request time. If the model file is absent at startup, the process must exit with a non-zero code rather than serving a broken endpoint
- Expose port `5000` to the host. Define a Docker health check that polls `GET /health` every 10 seconds with a 5-second timeout and 3 retries before marking the container unhealthy

#### 🗄️ Service: `postgres`
- Use the official `postgres:15` image
- Pass all credentials exclusively through environment variables; never hardcode them in the Compose file. Use a `.env` file that is listed in `.dockerignore` so it is never baked into an image layer
- Mount `postgres-init/01_schema.sql` into `/docker-entrypoint-initdb.d/` so the schema is applied automatically on first start
- Attach a named volume (`pgdata`) for data persistence across `docker compose down` and `docker compose up` cycles

**The following interfaces define the contracts your API and database modules must satisfy:**

```python
# src/api.py — Flask application contract
class PredictionAPI:
    def health(self) -> dict:
        """GET /health — return {'status': str, 'model_loaded': bool}; HTTP 200 always."""
        ...

    def predict(self, payload: dict) -> dict:
        """POST /predict — accept {'features': list[float]}; return {'prediction': int, 'confidence': float, 'logged_id': int}."""
        ...

    def model_info(self) -> dict:
        """GET /model/info — return model input shape, output shape, and artifact metadata."""
        ...
```

```python
# src/db.py — database logging contract
class PredictionLogger:
    def connect(self, dsn: str) -> None:
        """Open a connection using the DSN string; raise ConnectionError if unreachable after 30 seconds."""
        ...

    def log_prediction(self, features: list, prediction: int, confidence: float) -> int:
        """Insert one prediction record; return the auto-generated row ID."""
        ...

    def fetch_recent(self, limit: int) -> list[dict]:
        """Return the most recent `limit` prediction records ordered by timestamp descending."""
        ...
```

```sql
-- postgres-init/01_schema.sql — minimum required schema
CREATE TABLE IF NOT EXISTS predictions (
    id          SERIAL PRIMARY KEY,
    features    JSONB        NOT NULL,
    prediction  INTEGER      NOT NULL,
    confidence  NUMERIC(6,4) NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
```

> 📝 `# TODO:` Add an index on `created_at` to the schema above before load-testing `fetch_recent`.

### 🔹 Step 3.2 — Deploy, Validate, and Stress the Stack

Bring the full stack up in detached mode and validate each service independently before testing the integrated flow.

**Validation sequence (perform in this order):**

1. 🟢 **Confirm all three containers reach a running state:** `docker compose ps` must show `running` (not `restarting` or `exited`) for every service
2. 💓 **Confirm the api health check passes:** `docker compose ps` must show `(healthy)` next to the `api` service before you proceed. If it shows `(unhealthy)`, retrieve logs with `docker compose logs api` and identify whether the failure is a missing model file, a port conflict, or a Python import error
3. 🌐 **Send a prediction request** to the API from the host machine using `curl` or any HTTP client. The response body must contain `prediction`, `confidence`, and `logged_id` fields
4. 🗄️ **Connect to the postgres container** and query the `predictions` table to confirm the row was inserted:
   ```bash
   docker compose exec postgres psql -U <your_user> -d <your_db> -c "SELECT * FROM predictions ORDER BY created_at DESC LIMIT 5;"
   ```
5. 📓 **Open JupyterLab** in a browser at `http://<your-ec2-public-ip>:8888`. Load the trained model artifact from `/app/models` inside a notebook cell and run at least one inference to confirm the volume mount is live

<details>
<summary>🛠️ Troubleshoot this step</summary>

You may see `connection refused` when curling the API even though the container shows `running`, because the Flask process inside the container crashed after the health check window closed.

Run `docker compose logs --tail=50 api` and look for a Python traceback; the most common cause is the model file not existing at `/app/models/` because the bind mount path on the host is wrong or the training step in Task 2 did not complete successfully.

🔗 Docker Compose networking reference: https://docs.docker.com/compose/networking/
</details>

> 📝 `# TODO:` Restart just the `api` service with `docker compose restart api` and confirm it still reloads the model from the volume correctly without a full stack rebuild.

---

## 🏆 Expected Outcomes

- 🏗️ A tagged Docker image built from a multi-stage Dockerfile that runs all processes as a non-root user, with trained model artifacts persisting on the host across container restarts
- 🧩 A three-service Docker Compose stack where every prediction request is served by the Flask API, logged to PostgreSQL, and accessible for analysis inside JupyterLab — all communicating over an isolated Docker network

---

## 🛠️ Troubleshooting

<details>
<summary>🔄 If the api container repeatedly cycles between starting and unhealthy...</summary>

What does the sequence of events in `docker compose logs api` tell you about whether the model loading step is failing *before* or *after* the Flask server binds to port 5000?
</details>

<details>
<summary>🗄️ If predictions aren't appearing in the predictions table despite the API returning a logged_id...</summary>

How would you determine whether the failure is in the database connection string, the SQL insert statement, or the transaction commit — and which Docker Compose command lets you inspect the `postgres` container's own logs to cross-reference?
</details>

---

## 🏁 Conclusion

This lab demonstrates that containerizing an ML pipeline is not simply a packaging exercise — it requires deliberate decisions about image layering, secret management, service dependency ordering, and artifact lifecycle.

The multi-stage build pattern keeps production images lean and auditable, while named volumes and bind mounts enforce a clean boundary between ephemeral compute and persistent state.

> 🎉 Mastering these patterns is a prerequisite for deploying ML systems that are reproducible, observable, and safe to operate in shared infrastructure.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E90FF?style=for-the-badge)

</div>
