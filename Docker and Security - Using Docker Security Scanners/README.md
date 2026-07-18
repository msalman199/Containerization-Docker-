<div align="center">

# 🛡️ Docker Image Security Scanning and Vulnerability Management 🔍

### Building a Multi-Tool Scanning Pipeline, Policy Gate, and CI/CD Security Workflow

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-1904DA?style=for-the-badge&logo=aquasecurity&logoColor=white)
![Grype](https://img.shields.io/badge/Grype-00A98F?style=for-the-badge&logo=anchore&logoColor=white)
![jq](https://img.shields.io/badge/jq-000000?style=for-the-badge&logo=json&logoColor=white)
![GitHubActions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)
![SARIF](https://img.shields.io/badge/SARIF-24292E?style=for-the-badge&logo=github&logoColor=white)
![AWS](https://img.shields.io/badge/AWS%20EC2-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

![Level](https://img.shields.io/badge/Level-Advanced-red?style=for-the-badge)
![Format](https://img.shields.io/badge/Format-Design%20Brief-9cf?style=for-the-badge)
![Track](https://img.shields.io/badge/Track-DevSecOps%20%2F%20Container%20Security-blueviolet?style=for-the-badge)

</div>

> 🧩 **Format note:** This lab is a **design brief**, not a copy-paste walkthrough. Interface contracts define exactly what each function or workflow step must do — you write the implementation. Confirmation checks tell you how to know it's working.

---

## 📚 Table of Contents

- [🎯 Objectives](#-objectives)
- [🧩 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment](#️-lab-environment)
- [1️⃣ Task 1: Environment Setup — Install and Verify the Toolchain](#1️⃣-task-1-environment-setup--install-and-verify-the-security-scanning-toolchain)
- [2️⃣ Task 2: Pull Target Images and Build a Structured Vulnerability Report Pipeline](#2️⃣-task-2-pull-target-images-and-build-a-structured-vulnerability-report-pipeline)
- [3️⃣ Task 3: Policy Enforcement and CI/CD Integration](#3️⃣-task-3-implement-policy-enforcement-and-cicd-integration)
- [🛡️ MITRE ATT&CK Mapping](#️-mitre-attck-mapping)
- [✅ Expected Outcomes](#-expected-outcomes)
- [🐛 Troubleshooting](#-troubleshooting)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

| # | Objective |
|---|-----------|
| 1 | Design and deploy a multi-tool vulnerability scanning pipeline that ingests Docker images and produces structured, machine-readable reports |
| 2 | Implement a policy enforcement layer that programmatically accepts or rejects images based on configurable severity thresholds |
| 3 | Construct a GitHub Actions CI/CD workflow that gates container image promotion on passing security scan results |

---

## 🧩 Prerequisites

| Requirement | Description |
|-------------|-------------|
| ⌨️ Linux CLI proficiency | File redirection, process management, and shell scripting |
| 🐳 Docker concepts | Images, layers, Dockerfiles, and the image build process |
| 🧮 JSON tooling | Working knowledge of JSON structures and at least one JSON-processing tool such as `jq` |

---

## 🖥️ Lab Environment

> ☁️ You will work on a dedicated **AWS EC2 Ubuntu instance** provided by Al Nafi. The instance has a base Ubuntu installation — you will install all required tools in Task 1.

---

## 1️⃣ Task 1: Environment Setup — Install and Verify the Security Scanning Toolchain

### 🔹 Step 1.1: Install System Dependencies, Trivy, and Grype

> 🧰 Three tools are needed: **Trivy** (inspects image layers against CVE databases), **Grype** (an independent Anchore scanner with its own database), and **jq** (parses scan output JSON).

```bash
# 📦 Install system dependencies first
sudo apt-get update -y
sudo apt-get install -y curl wget gnupg lsb-release apt-transport-https ca-certificates jq

# 🔑 Add Trivy signing key
sudo mkdir -p /etc/apt/keyrings
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/trivy.gpg > /dev/null
# 📖 Official guide: https://aquasecurity.github.io/trivy/latest/getting-started/installation/

# ➕ Add the Trivy APT repository — heredoc avoids line-continuation issues
sudo tee /etc/apt/sources.list.d/trivy.list <<EOF
deb [signed-by=/etc/apt/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main
EOF

sudo apt-get update -y
sudo apt-get install -y trivy
```

> ⚠️ **Troubleshoot this step:**
> - **Error:** `E: Malformed entry 1 in list file /etc/apt/sources.list.d/trivy.list` — the file contains a literal backslash or newline inside the `deb` line.
> - **Fix:** inspect with `cat /etc/apt/sources.list.d/trivy.list`; it must be a single unbroken line. Delete with `sudo rm /etc/apt/sources.list.d/trivy.list` and recreate using the heredoc above.
> - 📖 Official reference: https://aquasecurity.github.io/trivy/latest/getting-started/installation/

```bash
# 📥 Install Grype via its installer script
curl -fsSL https://raw.githubusercontent.com/anchore/grype/main/install.sh \
  | sudo sh -s -- -b /usr/local/bin
# 📖 Official guide: https://github.com/anchore/grype#installation
```

> ⚠️ **Troubleshoot this step:**
> - **Error:** `curl: (22) The requested URL returned error: 404` — the installer URL has changed upstream.
> - **Fix:** visit https://github.com/anchore/grype/releases, download the latest `grype_*_linux_amd64.tar.gz` asset manually, then move the binary to `/usr/local/bin/grype`.
> - 📖 Official reference: https://github.com/anchore/grype#installation

```bash
# ✅ Verify all three tools respond correctly before proceeding
trivy --version
grype version
jq --version
```

> ✅ **Expected output:** each command prints a version string with no errors. If any command returns `command not found`, the binary is not on `PATH` — confirm the install path with `which trivy` and `which grype`.

### 🔹 Step 1.2: Install Docker Engine

```bash
# 🐳 Install Docker Engine using the official convenience script
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
# 📖 Official guide: https://docs.docker.com/engine/install/ubuntu/
sudo sh /tmp/get-docker.sh

# 👤 Add your user to the docker group so commands don't require sudo
sudo usermod -aG docker "$USER"
newgrp docker
```

> ⚠️ **Troubleshoot this step:**
> - **Error:** `permission denied while trying to connect to the Docker daemon socket` after running `docker ps`.
> - **Fix:** confirm group membership with `groups`; if `docker` is absent, log out and back in, or run `exec su -l "$USER"` to reload the session.
> - 📖 Official reference: https://docs.docker.com/engine/install/linux-postinstall/

```bash
# ✅ Verify Docker is operational
docker version
docker run --rm hello-world
```

> ✅ **Expected output:** `docker version` prints both Client and Server sections; `hello-world` prints the "Hello from Docker!" message and exits cleanly.

---

## 2️⃣ Task 2: Pull Target Images and Build a Structured Vulnerability Report Pipeline

### 🔹 Step 2.1: Pull a Vulnerability Contrast Set and Scan with Both Tools

> 🔬 Pull four images that represent a deliberate security contrast: an end-of-life Ubuntu base, a current Ubuntu base, a full Node.js image, and its Alpine-based equivalent. Alpine ships far fewer packages, which reduces the number of potential vulnerable components.

> 🎯 **Your requirement:** pull all four images and produce one Trivy JSON report and one Grype JSON report for each image, storing all eight files under a `reports/` directory with filenames that encode the image name and scanner (e.g. `reports/ubuntu-18.04-trivy.json`).

```bash
# 📥 Pull the contrast set
docker pull ubuntu:18.04
docker pull ubuntu:22.04
docker pull node:18
docker pull node:18-alpine

# 📁 Prepare the reports directory
mkdir -p reports
```

The scanning contract your pipeline must satisfy — **you own the implementation**, the function bodies below are intentionally empty:

```bash
# 📐 Interface contract — implement each function body

# 🔎 scan_with_trivy IMAGE OUTPUT_FILE
# Produces a Trivy JSON vulnerability report at OUTPUT_FILE.
# Must exit non-zero if the scan itself fails (not if vulnerabilities are found).
scan_with_trivy() {
    local image="$1"
    local output_file="$2"
    # TODO: your implementation
}

# 🔎 scan_with_grype IMAGE OUTPUT_FILE
# Produces a Grype JSON vulnerability report at OUTPUT_FILE.
# Must exit non-zero if the scan itself fails.
scan_with_grype() {
    local image="$1"
    local output_file="$2"
    # TODO: your implementation
}

# 🔁 run_contrast_scan IMAGE_LIST_FILE REPORTS_DIR
# Iterates over newline-separated image names in IMAGE_LIST_FILE,
# calls both scanners for each, and writes all reports to REPORTS_DIR.
run_contrast_scan() {
    local image_list="$1"
    local reports_dir="$2"
    # TODO: your implementation
}
```

> ✅ **Confirmation:** after running your implementation, `ls reports/` must show **eight** `.json` files — two per image.

### 🔹 Step 2.2: Build a Severity Aggregation Script

> 🎯 **Your requirement:** implement a `summarize_reports.sh` script that reads every Trivy JSON file in `reports/`, extracts vulnerability counts grouped by severity (`CRITICAL`, `HIGH`, `MEDIUM`, `LOW`), and writes a Markdown summary table to `reports/summary.md`.

The aggregation logic must conform to this typed contract:

```bash
# 📐 Interface contract — implement each function body

# 📊 extract_severity_counts TRIVY_JSON_FILE
# Prints four lines to stdout in the format:
#   CRITICAL <count>
#   HIGH <count>
#   MEDIUM <count>
#   LOW <count>
# Count is 0 if no vulnerabilities of that severity exist.
extract_severity_counts() {
    local json_file="$1"
    # TODO: your implementation
    # 💡 hint: the relevant jq path is .Results[].Vulnerabilities[].Severity
}

# 📝 render_markdown_row IMAGE_NAME CRITICAL HIGH MEDIUM LOW
# Prints one Markdown table row: | image | critical | high | medium | low |
render_markdown_row() {
    local image_name="$1"
    local critical="$2"
    local high="$3"
    local medium="$4"
    local low="$5"
    # TODO: your implementation
}
```

> ✅ **Confirmation:** `cat reports/summary.md` must display a Markdown table with one row per scanned image and correct severity counts. Cross-check one row manually by running `trivy image --format table ubuntu:18.04` and comparing the totals.

---

## 3️⃣ Task 3: Implement Policy Enforcement and CI/CD Integration

### 🔹 Step 3.1: Build a Policy Enforcement Gate

> 🚦 A policy gate is a program that reads a scan report and exits with code `0` (pass) or `1` (fail) based on configurable thresholds — the mechanism that prevents a vulnerable image from being promoted to a registry or deployed to production.

> 🎯 **Your requirement:** implement `policy_gate.sh` that accepts a Trivy JSON report path and a policy YAML file path as arguments, evaluates the report against the policy, prints a human-readable verdict, and exits with the appropriate code.

The policy YAML schema your gate must support — **this is the contract, not an example to copy verbatim**; define your own threshold values when testing:

```yaml
# 📐 policy.yaml — schema definition
fail_on:
  critical_count_exceeds: <integer>   # ❌ fail if CRITICAL count is strictly greater than this value
  high_count_exceeds: <integer>       # ❌ fail if HIGH count is strictly greater than this value
warn_on:
  medium_count_exceeds: <integer>     # ⚠️ print warning but do not fail
report_label: <string>                # 🏷️ label printed in the verdict line
```

The gate function signature:

```bash
# 📐 Interface contract

# 🚦 run_policy_gate TRIVY_JSON POLICY_YAML
# Prints: "PASS: <report_label>" or "FAIL: <report_label> — <reason>"
# Exits 0 on pass, 1 on fail.
run_policy_gate() {
    local trivy_json="$1"
    local policy_yaml="$2"
    # TODO: your implementation
    # 💡 Note: bash does not natively parse YAML; use grep/awk or install 'yq'
    # 📖 yq installation: https://github.com/mikefarah/yq#install
}
```

> 🧪 Test your gate against at least two scenarios: one image that should **pass** (use `node:18-alpine` with a strict policy) and one that should **fail** (use `ubuntu:18.04` with a zero-tolerance CRITICAL policy). Confirm exit codes with `echo $?` after each run.

> ✅ **Confirmation:** `echo $?` returns `0` after the alpine scan and `1` after the `ubuntu:18.04` scan, assuming your policy thresholds are set appropriately for the actual vulnerability counts observed in Task 2.

### 🔹 Step 3.2: Construct a GitHub Actions Security Scanning Workflow

> ⚙️ A GitHub Actions workflow is a YAML file stored at `.github/workflows/<name>.yml` that GitHub executes automatically on specified triggers.

> 🎯 **Your requirement:** create a workflow that builds a Docker image from a Dockerfile in the repository root, runs Trivy against the built image, uploads the SARIF-format report (a standard JSON schema for static analysis results that GitHub's Security tab can render) to GitHub's code scanning dashboard, and fails the workflow if any CRITICAL vulnerabilities are found.

**🏗️ Architectural constraints the workflow must satisfy:**

| # | Constraint |
|---|------------|
| 1 | The build step must tag the image using the Git commit SHA so each run produces a uniquely identified artifact |
| 2 | The Trivy scan step must use the official `aquasecurity/trivy-action` rather than a raw shell command, with the action version pinned (not `@master`) |
| 3 | The policy enforcement step must reuse `policy_gate.sh` from Step 3.1 by checking it out from the repository and executing it — proving the gate is not CI-vendor-specific |

The workflow interface contract — fill in every `# IMPLEMENT` placeholder:

```yaml
# ⚙️ .github/workflows/docker-security-scan.yml

name: Docker Security Scan

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  scan:
    runs-on: ubuntu-latest
    permissions:
      security-events: write   # 🔐 required to upload SARIF to GitHub Security tab
      contents: read

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Build image
        # 🏗️ IMPLEMENT: build the image, tag it with github.sha
        run: # IMPLEMENT

      - name: Run Trivy and produce SARIF report
        uses: aquasecurity/trivy-action@0.18.0   # 📌 pin to a specific version
        with:
          image-ref: # IMPLEMENT — reference the image tagged with github.sha
          format: sarif
          output: trivy-results.sarif
          severity: CRITICAL,HIGH

      - name: Upload SARIF to GitHub Security tab
        uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: trivy-results.sarif

      - name: Run Trivy JSON scan for policy gate
        uses: aquasecurity/trivy-action@0.18.0
        with:
          image-ref: # IMPLEMENT
          format: json
          output: trivy-results.json
          severity: CRITICAL,HIGH

      - name: Enforce policy gate
        run: |
          # 🚦 IMPLEMENT: install yq if needed, then call policy_gate.sh
          # 📄 policy.yaml must also exist in the repository root
          bash policy_gate.sh trivy-results.json policy.yaml
```

> ✅ **Confirmation:** push a commit to your repository's `main` branch. The **Actions** tab must show the workflow run; the **Security** tab must show the uploaded scan findings; the "Enforce policy gate" step must exit with code `1` if your test image contains CRITICAL vulnerabilities, causing the overall job to fail with a red status.

---

## 🛡️ MITRE ATT&CK Mapping

> This pipeline is a *mitigation* control rather than a detection control — it reduces attack surface before deployment instead of catching an adversary mid-technique. Mapped against the techniques it most directly helps prevent:

| ATT&CK Technique | ID | How This Pipeline Helps |
|-------------------|-----|--------------------------|
| Supply Chain Compromise | T1195 | Scans third-party base images and dependencies for known CVEs before they enter the build pipeline |
| Exploit Public-Facing Application | T1190 | Blocks images carrying CRITICAL vulnerabilities from reaching production-facing services |
| Exploitation for Privilege Escalation | T1068 | Alpine-based images reduce the installed package surface, cutting the pool of exploitable local binaries |

---

## ✅ Expected Outcomes

- 📊 `reports/summary.md` contains a complete Markdown table showing vulnerability counts by severity for all four contrast images, with the Alpine-based image showing measurably fewer vulnerabilities than its full counterpart
- 🟢🔴 The GitHub Actions workflow run produces a visible SARIF report in the repository's Security tab, and the policy gate step correctly blocks or passes the build based on the thresholds defined in `policy.yaml`

---

## 🐛 Troubleshooting

<details>
<summary>🔴 Diagnostic 1: Empty Vulnerabilities Arrays</summary>

If your Trivy JSON reports contain empty `Vulnerabilities` arrays for **all** images, what does that indicate about the state of the Trivy vulnerability database on your instance, and how would you confirm whether the database was downloaded successfully before the scan ran?

</details>

<details>
<summary>🟠 Diagnostic 2: Policy Gate Passing When It Shouldn't</summary>

If the policy gate exits with code `0` for `ubuntu:18.04` even though the summary table shows dozens of CRITICAL vulnerabilities, what are the two most likely causes related to how the gate reads the policy thresholds and how it queries the JSON report, and what diagnostic output would you add to isolate which one is responsible?

</details>

---

## 🏁 Conclusion

This lab established a complete, tool-agnostic vulnerability management pipeline: raw scanner output was normalized into structured reports, a configurable policy gate translated those reports into binary deployment decisions, and the entire chain was embedded in a CI/CD workflow that enforces security checks on every code push. 🐧🆚🏔️ The contrast between `ubuntu:18.04` and `node:18-alpine` demonstrates that **base image selection is the single highest-leverage decision** in reducing a container's attack surface. Integrating policy gates directly into pull request checks ensures that vulnerability acceptance is an explicit, auditable decision — rather than an oversight. ✅

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-blueviolet?style=for-the-badge)

</div>
