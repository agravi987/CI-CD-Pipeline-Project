# 💡 Step 7: Troubleshooting, Rollback & DevOps Interview Cheat Sheet

Congratulations on building your automated CI/CD pipeline!
This document covers common real-world errors, how to fix them, rollback strategies, and the exact answers you can give in a **DevOps / Cloud Engineer interview**.

---

## 🛠️ Common Errors & Quick Fixes

### 1. Error: `ssh: connect to host ... port 22: Connection timed out`
- **Cause**: AWS EC2 Security Group is blocking incoming SSH connections.
- **Fix**: Go to AWS Console $\rightarrow$ EC2 $\rightarrow$ Instances $\rightarrow$ Select your instance $\rightarrow$ Click **Security** tab $\rightarrow$ Click Security Group $\rightarrow$ Edit Inbound Rules $\rightarrow$ Add **SSH (Port 22)** from `0.0.0.0/0`.

---

### 2. Error: `Permission denied (publickey)`
- **Cause**: The SSH private key in `EC2_SSH_KEY` is corrupted or missing headers.
- **Fix**:
  - Open `devops-ec2-key.pem` with Notepad.
  - Make sure you copied **every character**, including:
    ```text
    -----BEGIN RSA PRIVATE KEY-----
    ...
    -----END RSA PRIVATE KEY-----
    ```
  - Ensure the username secret `EC2_USER` is exactly `ubuntu` (for Ubuntu instances).

---

### 3. Error: `Cannot connect to the Docker daemon on EC2`
- **Cause**: The `ubuntu` user on EC2 doesn't have permission to execute Docker commands without `sudo`.
- **Fix**: Connect to your EC2 instance and run:
  ```bash
  sudo usermod -aG docker ubuntu
  newgrp docker
  ```

---

### 4. Error: Health check fails with `Connection refused`
- **Cause**: The Nginx container hasn't started yet, or AWS Security Group is blocking Port 80.
- **Fix**:
  1. Verify Security Group Inbound Rule allows **HTTP (Port 80)** from `0.0.0.0/0`.
  2. Check container logs on EC2:
     ```bash
     cd ~/devops-app
     docker compose -f docker-compose.prod.yml logs
     ```

---

## 🔄 Rollback Strategy: What If a Bad Deployment Goes Live?

In professional DevOps environments, bad releases happen. Having an instant **Rollback Strategy** is critical.

### How Rollback Works in This Project:
Because every commit builds and tags images with their unique Git commit hash (`${{ github.sha }}`):
1. Find the last stable Git commit SHA (e.g. `c74b1e9`).
2. Run the deployment on EC2 pointing to that exact tag:
   ```bash
   export IMAGE_TAG="c74b1e9"
   docker compose -f docker-compose.prod.yml up -d
   ```
3. Or in GitHub Actions: Click the **Actions** tab $\rightarrow$ Select the last successful workflow run $\rightarrow$ Click **Re-run all jobs**.

---

## 🎯 DevOps Interview Cheat Sheet

When an interviewer asks: *"Can you tell me about a CI/CD pipeline you built?"*
Use this structured response:

### 1. The Elevator Pitch
> *"I designed and implemented an automated end-to-end CI/CD pipeline for a 3-tier web application (React, Express.js, and PostgreSQL). Whenever code is pushed to GitHub, GitHub Actions triggers automated unit and integration tests using Jest and Vitest. If tests pass, Aqua Security Trivy performs container vulnerability scanning. The pipeline then builds multi-stage Docker images, pushes them to Docker Hub, and automatically deploys the containers to an AWS EC2 instance over SSH, followed by an automated HTTP health check verification."*

### 2. Common Interview Questions & Answers

#### Q1: What is the difference between Continuous Delivery and Continuous Deployment?
- **Continuous Delivery**: Code automatically builds, tests, and prepares artifacts, but the final deployment to production requires a **manual approval** click.
- **Continuous Deployment**: Every change that passes all tests and scans is deployed directly to production **with zero human intervention**.

#### Q2: Why did you use Multi-Stage Docker builds for the React frontend?
- *"A standard Node.js image contains development tools, npm cache, and dependencies, making it over 500MB. With a multi-stage Docker build, Stage 1 uses Node to compile the assets, and Stage 2 copies only the minified static files into an ultra-lightweight Nginx Alpine image (~25MB). This drastically reduces image size, speeds up download times on EC2, and reduces security attack surfaces."*

#### Q3: How do you protect sensitive credentials in the pipeline?
- *"I store Docker Hub access tokens and EC2 SSH private keys in encrypted GitHub Repository Secrets. These secrets are injected dynamically into runners at runtime and masked in execution logs to prevent credential leakage."*

#### Q4: Why is an `/api/health` endpoint important?
- *"It serves as a liveness and readiness probe. Instead of assuming a deployment worked just because the container started, our CD pipeline curls `/api/health` to confirm the Express server is up and actively communicating with PostgreSQL before marking the pipeline as green."*

---

## 🏁 Summary Checklist

- [x] Application code created (`client/`, `server/`, `db/`)
- [x] Dockerfiles & Docker Compose created
- [x] Automated tests written (`npm test`)
- [x] GitHub Actions workflows configured (`ci.yml` & `cd.yml`)
- [x] Step-by-step documentation written (`docs/01` - `07`)

You are now ready to build and automate software delivery like a real DevOps engineer!
