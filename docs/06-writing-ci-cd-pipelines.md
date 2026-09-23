# ⚡ Step 6: Writing CI/CD Pipelines & GitHub Secrets

Welcome to Day 6! 🤖 Today is the day all the pieces come together into a fully automated pipeline. Once this step is complete, every time you type `git push`, your code will be tested, containerized, scanned, and deployed to AWS EC2 automatically! 🚀

---

## 🔒 Part 1: Setting Up Your 5 GitHub Secrets

Never put passwords, tokens, or SSH keys inside your code. If you do, hackers scanning GitHub will find them in minutes! ⚠️

GitHub provides a secure vault called **Repository Secrets**. Secrets are encrypted and passed into your workflow runners only when needed.

### 🧭 How to Add Secrets in GitHub:

1. Go to your repository page on GitHub.
2. Click **⚙️ Settings** (top tabs).
3. In the left menu, scroll down to **Secrets and variables** $\rightarrow$ Click **Actions**.
4. Click the green **New repository secret** button.

Add these **5 Secrets** one by one:

```
┌────────────────────────────────────────────────────────────────────────┐
│                        GITHUB SECRETS VAULT 🔐                         │
├───────────────────┬────────────────────────────────────────────────────┤
│ Secret Name       │ Value to Enter                                     │
├───────────────────┼────────────────────────────────────────────────────┤
│ DOCKER_USERNAME   │ Your Docker Hub username (e.g. johndoe)            │
│ DOCKER_PASSWORD   │ Your Docker Hub Personal Access Token (dckr_pat_..)│
│ EC2_HOST          │ Your EC2 Public IPv4 address (e.g. 54.210.120.45)  │
│ EC2_USER          │ ubuntu                                             │
│ EC2_SSH_KEY       │ Complete text from your devops-ec2-key.pem file    │
└───────────────────┴────────────────────────────────────────────────────┘
```

> [!IMPORTANT]
> When pasting `EC2_SSH_KEY`, make sure you paste the **ENTIRE** contents of the `.pem` file, starting with `-----BEGIN RSA PRIVATE KEY-----` and ending with `-----END RSA PRIVATE KEY-----`.

---

## 🧪 Part 2: Understanding `ci.yml` (Continuous Integration)

Location: `ci-cd-pipeline-app/.github/workflows/ci.yml`

This file defines the **Quality Gatekeeper**. It runs automatically on every **Pull Request** and push.

```yaml
name: CI Pipeline (Continuous Integration)

# 1. Trigger when code is pushed or a PR is opened
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  # -------------------------------------------------------------
  # Job 1: Test the Backend API with Jest & Supertest
  # -------------------------------------------------------------
  backend-test:
    runs-on: ubuntu-latest # Spawns a fresh Ubuntu virtual runner
    steps:
      - uses: actions/checkout@v4 # Step 1: Clone repo into runner
      - uses: actions/setup-node@v4 # Step 2: Install Node.js 20
        with:
          node-version: 20
      - run: npm install # Step 3: Install backend dependencies
        working-directory: ./server
      - run: npm test # Step 4: Run automated tests!
        working-directory: ./server

  # -------------------------------------------------------------
  # Job 2: Test the Frontend React UI with Vitest
  # -------------------------------------------------------------
  frontend-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm install
        working-directory: ./client
      - run: npm test
        working-directory: ./client

  # -------------------------------------------------------------
  # Job 3: Scan Docker Images for Security Vulnerabilities (Trivy)
  # -------------------------------------------------------------
  security-scan:
    runs-on: ubuntu-latest
    needs: [backend-test, frontend-test] # Only run if tests passed!
    steps:
      - uses: actions/checkout@v4
      - run: docker build -t test-backend:local ./server
      - uses: aquasecurity/trivy-action@master # Scans for CVEs
        with:
          image-ref: "test-backend:local"
          format: "table"
          severity: "CRITICAL,HIGH"
```

---

## 🚀 Part 3: Understanding `cd.yml` (Continuous Deployment)

Location: `ci-cd-pipeline-app/.github/workflows/cd.yml`

This file defines the **Automated Delivery System**. It triggers whenever code is merged into `main`.

### The 3 Stages of CD:

```
1. 🐳 Build & Push Images  ──► 2. ☁️ SSH & Restart on EC2  ──► 3. 🩺 Verify Health Check
   (Tagged latest & SHA)          (docker compose up -d)           (Pings /api/health)
```

### Let's Read the Key Parts:

#### A. Build and Push to Docker Hub

```yaml
- name: Log in to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}

- name: Build & Push Backend Image
  uses: docker/build-push-action@v5
  with:
    context: ./server
    push: true
    tags: |
      ${{ secrets.DOCKER_USERNAME }}/devops-server:latest
      ${{ secrets.DOCKER_USERNAME }}/devops-server:${{ github.sha }}
```

> 💡 Notice `${{ github.sha }}`? Every time you commit, Git creates a unique identifier (like `e9a31b4`). Tagging images with this SHA allows you to instantly rollback to any previous version!

#### B. Deploy to AWS EC2 over SSH

```yaml
- name: Copy Compose and Database files to EC2
  uses: appleboy/scp-action@v0.1.7
  with:
    host: ${{ secrets.EC2_HOST }}
    username: ${{ secrets.EC2_USER }}
    key: ${{ secrets.EC2_SSH_KEY }}
    source: "docker-compose.prod.yml,db/init.sql"
    target: "~/devops-app"

- name: Pull Images & Restart Containers on EC2
  uses: appleboy/ssh-action@v1.0.3
  with:
    host: ${{ secrets.EC2_HOST }}
    username: ${{ secrets.EC2_USER }}
    key: ${{ secrets.EC2_SSH_KEY }}
    script: |
      cd ~/devops-app
      export DOCKER_USERNAME="${{ secrets.DOCKER_USERNAME }}"
      docker pull ${DOCKER_USERNAME}/devops-server:latest
      docker pull ${DOCKER_USERNAME}/devops-client:latest
      docker compose -f docker-compose.prod.yml up -d
      docker image prune -f
```

#### C. Post-Deployment Automated Health Check

```yaml
- name: Verify Live API Health
  run: |
    sleep 20
    RESPONSE=$(curl --silent --fail http://${{ secrets.EC2_HOST }}/api/health || echo "FAILED")
    if [[ "$RESPONSE" == *"UP"* ]]; then
      echo "🎉 Deployment successfully verified!"
    else
      echo "❌ Deployment failed!"
      exit 1
    fi
```

---

## 🎯 Part 4: Push to GitHub and Trigger Your First Run!

Now open your terminal and push the code:

```bash
cd "d:\Current Projects\Cloud and DevOps Projects\ci-cd-pipeline-project\ci-cd-pipeline-app"

# 1. Initialize Git repository
git init

# 2. Add all files
git add .

# 3. Create your initial commit
git commit -m "feat: complete 3-tier CI/CD application"

# 4. Set main branch
git branch -M main

# 5. Link to your GitHub repository (replace with your repo URL!)
git remote add origin https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>.git

# 6. Push to trigger the pipeline!
git push -u origin main
```

---

## 🍿 Sit Back and Watch It Live!

1. Go to your repository on GitHub.
2. Click on the **Actions** tab at the top.
3. Click on the running workflow. You will see:
   - 🧪 `Test Backend API` ➔ Green checkmark! ✅
   - 🧪 `Test Frontend React` ➔ Green checkmark! ✅
   - 🛡️ `Security Vulnerability Scan` ➔ Green checkmark! ✅
   - 🐳 `Build & Push to Docker Hub` ➔ Green checkmark! ✅
   - ☁️ `Deploy to AWS EC2` ➔ Green checkmark! ✅
   - 🩺 `Post-Deployment Health Check` ➔ Green checkmark! ✅

4. Now open your web browser and navigate to:
   ```
   http://<YOUR-EC2-PUBLIC-IP>
   ```
   **Your full-stack application is live on the cloud, running on Docker, connected to PostgreSQL!** 🥳🎉

---

## 📸 Proof of Work: Screenshots

> [!TIP]
> **Capture your proof of work!** Save your screenshots into `docs/screenshots/` and link them here:

### 🖼️ Screenshot 1: GitHub Actions Secrets Configured

![GitHub Actions Secrets Configured](./screenshots/07-github-actions-secrets-configured.png)

### 🖼️ Screenshot 2: GitHub Actions CI/CD Pipeline Passing (All Green)

![GitHub Actions CI/CD Pipeline Passing](./screenshots/09-ci-cd-pipeline-passing.png)

### 🖼️ Screenshot 3: Application Live on AWS EC2

![Application Live on AWS EC2](./screenshots/10-application-live-on-ec2.png)

---

## ⏭️ Ready for the Final Step?

Now learn about Git branching strategies, monitoring, rollbacks, and interview mastery:  
👉 **[Go to Step 7: 07-git-and-branching-strategy.md](./07-git-and-branching-strategy.md)**
